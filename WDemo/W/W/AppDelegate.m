//
//  AppDelegate.m
//  W
//
//  Created by WangQiang on 2017/12/5.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self sort];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)sort {
    NSArray *categories = [aaa componentsSeparatedByString:@"\n"];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"#*? "];
    NSComparisonResult (^comparitor)(NSString *, NSString *) = ^NSComparisonResult(NSString *obj1, NSString *obj2) {
        obj1 = [obj1 stringByTrimmingCharactersInSet:characterSet];
        obj2 = [obj2 stringByTrimmingCharactersInSet:characterSet];
        return obj1.integerValue > obj2.integerValue;
    };
    NSMutableString *result = [NSMutableString string];
    for(NSString *category in categories) {
        NSArray *keyValues = [category componentsSeparatedByString:@"-"];
        NSString *categoryName = keyValues[0];
        if(!categoryName.length) continue;
        
        NSString *codes = keyValues[1];
        
        NSArray *codeArray = [codes componentsSeparatedByString:@"@@@"];
        
        NSString *handledString = codeArray[0];
        NSArray *handledArray = [handledString componentsSeparatedByString:@"???"];
        NSString *downloadedString = handledArray.firstObject;
        NSString *downloadingString = handledArray.count>1 ? handledArray.lastObject : @"";
        NSMutableArray *mDownloaded = [NSMutableArray arrayWithArray:[downloadedString componentsSeparatedByString:@" "]];
        NSMutableArray *mDownloading = [NSMutableArray arrayWithArray:[downloadingString componentsSeparatedByString:@" "]];
        
        NSString *unhandledString = codeArray.count>1 ? codeArray[1] : nil;
        NSMutableArray *mUnhandled = [NSMutableArray arrayWithArray:[unhandledString componentsSeparatedByString:@" "]];
        
        [mDownloaded sortUsingComparator:comparitor];
        [mDownloading sortUsingComparator:comparitor];
        [mUnhandled sortUsingComparator:comparitor];
        
        [result appendFormat:@"%@-%@ ??? %@ @@@ %@\n\n",
         categoryName,
         [mDownloaded componentsJoinedByString:@" "],
         [mDownloading componentsJoinedByString:@" "],
         [mUnhandled componentsJoinedByString:@" "]];
    }
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[-?@]+ + " options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:result options:0 range:NSMakeRange(0, result.length)];
    __block NSMutableString *matchingText = [NSMutableString string];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL * _Nonnull stop) {
        [matchingText appendString:[result substringWithRange:match.range]];
        [matchingText replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, matchingText.length)];
        NSString *tail = [matchingText rangeOfString:@"-"].length ? @"" : @" ";
        [matchingText appendString:tail];
        [result replaceCharactersInRange:match.range withString:matchingText];
        
        [matchingText deleteCharactersInRange:NSMakeRange(0, matchingText.length)];
    }];
    
    NSLog(@"aaa-->%@", result);
}

static NSString *const aaa = @"259L-**164 320 748 791 #851 ??? *034 117 184 248 257 275 *495 *503 566 801 829 831 @@@\n"

"200G-#360 659 *894 #970 **1246 *1257 ***1317 1340 1346 1386 1388 *1434 **1460 *1471 1472 #1511 ??? 010 **018 ***018 038 *040 *048 064 072 094 107 121 130 *164 *167 **203 227 239 *262 269 307 310 311 *313 325 326 333 *350 *357 358 362 374 377 *378 **389 **395 407 412 *430 435 437 439 *443 443 *446 450 451 *453 **463 **463 499 *500 533 *571 *572 595 602 603 615 628 630 711 712 724 741 *748 794 *802 *807 810 *816 819 833 **874 *881 886 906 907 951 987 *1029 1031 *1044 1045 **1059 **1063 **1073 *1073 *1095 1096 1120 1121 *1132 *1141 *1143 **1153 **1158 1180 1193 **1202 *1219 *1223 **1235 1239 1245 *1250 1251 *1254 ***1263 1264 **1269 *1271 *1275 *1277 **1278 *1278 *1289 1294 1295 1300 1304 *1305 1307 **1323 **1331 1344 **1346 *1352 **1356 *1368 **1375 *1379 **1387 1389 *1394 1407 1417 *1418 **1424 1428 **1431 *1435 **1437 1441 *1441 1443 *1444 **1449 *1450 *1452 1453 **1457 1458 1459 1461 **1463 *1465 1467 *1468 1483 1485 1502 1503 *1512 ***1513 1520 *1528 ***1530 1533 **1546 1556 2443 2482 @@@ 057 *065 080 *120 *122 *175 186 188 206 258 268 **273 306 337 *339 363 *365 **375 *380 401 413 417 484 *545 761 *827 881 *919 980 981 ***987 *993 **998 *1019 1041 1062 1064 1070 1082 1111 1154 1165 *1212 1213 1220 1221 1230 1262 1286 1302 *1440 1446 *1478 *1481 *1484 1485 *1493 *1494 1517 1519 1522 *1552 1556 1563 1564 1567 **1572\n"

"261A-*053 *183 191 193 **195 196 ***197 205 **219 ??? 005 *006 008 *011 013 027 028 033 *034 040 042 043 050 052 054 056 058 061 065 *101 105 106 119 125 138 141 145 148 *154 155 161 165 *191 *205 208 226 @@@ 214 **215 221 224 225 *226 236 237 241 *245\n"

"240TK-317 320 327 ??? @@@\n"

"241GAREA-**351 ??? @@@\n"

"254HON-128 ??? @@@\n"

"SR-*1160 *1303 1347 *1404 1440 1506 1531 **1627 *1663 *1664 **1671 1695 *1710 ****1747 1866 *1873 1906 1964 2008 *2042 *2067 ****2114 2163 ***2170 *2179 *2182 2211 *2221 *2250 ****2266 2269 **2281 **2333 2334 2336 2370 2395 **2418 *2421 **2429 *2444 *2489 *2699 *2742 **2880 ??? *769 *903 *942 984 1013 **1100 1101 *1110 *1130 *1135 **1138 *1139 **1146 1158 ***1171 ***1183 *1183 1206 *1207 *1250 1254 *1272 **1277 1287 ***1292 1293 **1320 *1334 **1339 *1346 1385 *1390 1398 ***1418 1447 **1457 *1467 ****1479 ***1499 **1503 ***1517 **1519 ***1521 *1523 *1533 ***1539 1552 ***1564 **1577 1592 1597 1607 *1625 1638 1651 **1652 **1654 *1667 *1673 1678 *1681 **1684 **1704 *1705 1707 1708 *1713 1716 **1734 1735 **1743 **1763 1786 *1798 *1801 *1804 *1804 1805 1814 *1832 *1837 1847 ***1872 ***1878 *1893 2014 *2032 2044 ***2058 *2066 **2072 *2086 *2087 **2088 **2103 *2116 2146 *2154 ***2157 *2161 *2168 *2184 2199 2204 2207 **2219 **2228 2277 *2299 *2303 2305 2313 2327 2336 *2368 2371 2381 2382 2384 2386 2462 2465 2495 2519 **2526 *2550 *2593 *2659 2704 2706 2726 2733 2769 *2779 2780 2781 2807 *2807 2808 *2811 2816 2817 2818 *2821 2839 *2840 2841 2843 2848 2851 *2857 *2860 2866 *2868 *2868 **2871 *2875 2875 2884 **2897 **2909 **2910 *2928 *2935 *2944 *2948 2951 *2957 2964 *2966 *2972 2973 *2974 *2979 *2981 2982 *2987 2989 2991 2994 *2999 *3001 3004 3007 *3010 3012 *3018 3020 *3021 3025 *3026 3027 3031 3032 3045 *3050 **3052 **3054 3062 *3084 3091 *3095 3096 *3105 *3110 *3118 3123 *3126 3128 *3130 *3134 3138 3144 *3146 3147 3148 **3158 **3160 3165 3166 **3171 *3181 *3183 3198 3204 3209 3211 3212 *3214 *3222 **3223 3229 3237 *3238 3239 3247 **3251 *3261 3458 @@@ ***  221 338 413 783 **816 870 **893 **900 *901 **903 930 *940 *945 *961 ***968 *969 ***972 977 **979 *982 *986 989 *993 *994 **996 *1001 1012 **1015 ***1032 1047 1051 1059 **1070 *1074 *1076 **1077 **1084 **1088 1089 *1124 1132 1161 *1192 **1271 ***1377 1393 *1395 *1401 ***1405 1406 *1413 *1415 1416 1420 *1422 1425 1429 **1441 *1442 1444 **1446 *1452 1453 1454 **1472 **1484 ***1485 *1486 *1488 1489 1492 ***1493 **1494 *1495 *1498 *1504 *1516 **1520 **1522 **1524 ***1525 **1527 *1529 *1532 **1534 *1536 **1538 1545 ****1546 *1547 **1549 ***1550 **1551 **1553 **1556 **1557 ****1558 **1560 ***1566 ***1567 ***1570 ***1572 **1576 **1576 ***1579 **1585 ***1587 1591 *1598 ***1598 *1599 ***1605 **1616 **1617 1619 **1621 **1622 1634 1635 **1640 *1647 ***1650 *1656 **1657 **1666 *1669 *1670 1676 **1685 1686 **1687 ***1688 ***1691 ***1693 *1696 **1701 *1702 **1703 *1706 **1707 1711 *1712 1714 *1717 *1720 *1723 **1724 *1737 ***1740 1744 **1748 1751 *1767 **1770 1775 *1787 1793 *1799 *1800 *1812 *1813 1819 **1838 1842 1846 *1850 1860 1864 1867 **1879 1888 1898 *1899 *1903 1913 *1918 *1920 *1924 *1960 *1965 *1980 1993 2020 2021 2027 *2029 2030 2041 2045 *2049 2056 *2057 2063 **2065 **2068 ***2070 ***2072 **2078 *2082 2091 2092 2101 **2102 **2108 *2110 *2115 **2128 *2136 2144 **2151 *2162 **2167 2202 **2209 **2217 *2291 2383 2402 2406 2441 *2462 **2493 2494 ***2526 *2528 2530 **2540 2556 *2561 *2562 *2566 *2581 *2587 2593 2594 *2601 **2608 *2612 2613 ***2618 *2619 ***2622 *2626 *2636 **2641 2642 2649 **2665 2666 *2671 *2672 2683 *2688 2695 2697 2722 2729 *2747 **2750 *2754 *2787 2801 2813 2855 2862 2863 *2866 *2867 2870 2891 *2892 2895 2896 2899 2914 *2917 *2925 *2937 2940 2951 2967 2971 2977 **2998 **2999 3011 3013 3048 3061 3067 3088 *3113 3119 3127 **3130 3132 3141 **3141 *3144 *3146 **3147 3153 3159 *3170 *3207 3232 3237 *3238 **3251 *3255 *3262 3271\n";

@end
