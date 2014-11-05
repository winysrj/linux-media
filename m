Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46373 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKEW3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 17:29:50 -0500
Received: by mail-ie0-f171.google.com with SMTP id x19so1751630ier.2
        for <linux-media@vger.kernel.org>; Wed, 05 Nov 2014 14:29:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1786601.8VQNyC75Ox@avalon>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
 <54596226.8040403@iki.fi> <CAPueXH5kQG7zm3W-ghcVoq-rrqyE3rcYnfmGO+bPR=S91L3qpw@mail.gmail.com>
 <1786601.8VQNyC75Ox@avalon>
From: Paulo Assis <pj.assis@gmail.com>
Date: Wed, 5 Nov 2014 22:29:29 +0000
Message-ID: <CAPueXH7Z=6QdPyfzT0J_5CkEpw5F9unjv0pW=PkGtPmf=Jm1OQ@mail.gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	=?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,
see below yavta output and matching syslog

./yavta -c -s 800x600 -t 1/30 -f mjpeg /dev/video0
Device /dev/video0 opened.
Device `Logitech Webcam C930e' on `usb-0000:00:1a.7-1' is a video
output (without mplanes) device.
Video format set: MJPEG (47504a4d) 800x600 (stride 0) field none
buffer size 960000
Video format: MJPEG (47504a4d) 800x600 (stride 0) field none buffer size 960000
Current frame rate: 1/30
Setting frame rate to: 1/30
Frame rate set: 1/30
8 buffers requested.
length: 960000 offset: 0 timestamp type/source: mono/SoE
Buffer 0/0 mapped at address 0x7fa53d2a9000.
length: 960000 offset: 962560 timestamp type/source: mono/SoE
Buffer 1/0 mapped at address 0x7fa53c8d6000.
length: 960000 offset: 1925120 timestamp type/source: mono/SoE
Buffer 2/0 mapped at address 0x7fa53c7eb000.
length: 960000 offset: 2887680 timestamp type/source: mono/SoE
Buffer 3/0 mapped at address 0x7fa53c700000.
length: 960000 offset: 3850240 timestamp type/source: mono/SoE
Buffer 4/0 mapped at address 0x7fa53c615000.
length: 960000 offset: 4812800 timestamp type/source: mono/SoE
Buffer 5/0 mapped at address 0x7fa53c52a000.
length: 960000 offset: 5775360 timestamp type/source: mono/SoE
Buffer 6/0 mapped at address 0x7fa53c43f000.
length: 960000 offset: 6737920 timestamp type/source: mono/SoE
Buffer 7/0 mapped at address 0x7fa53c354000.
0 (0) [-] any 0 78126 B 1967.041984 1967.046007 199.243 fps ts mono/SoE
1 (1) [-] any 1 83867 B 1967.065982 1967.074017 41.670 fps ts mono/SoE
2 (2) [-] any 2 83019 B 1967.157974 1967.166002 10.871 fps ts mono/SoE
3 (3) [-] any 3 83772 B 1967.249978 1967.258003 10.869 fps ts mono/SoE
4 (4) [-] any 4 83973 B 1967.341976 1967.350002 10.870 fps ts mono/SoE
5 (5) [-] any 5 81903 B 1967.433974 1967.441996 10.870 fps ts mono/SoE
6 (6) [-] any 6 83112 B 1967.497976 1967.506003 15.625 fps ts mono/SoE
7 (7) [-] any 7 80714 B 1967.565975 1967.573998 14.706 fps ts mono/SoE
8 (0) [-] any 8 81568 B 1967.633973 1967.641990 14.706 fps ts mono/SoE
9 (1) [-] any 9 80797 B 1967.697971 1967.705999 15.625 fps ts mono/SoE
10 (2) [-] any 10 81242 B 1967.765972 1967.773996 14.706 fps ts mono/SoE
11 (3) [-] any 11 79881 B 1967.833971 1967.841984 14.706 fps ts mono/SoE
12 (4) [-] any 12 77947 B 1967.897969 1967.905998 15.625 fps ts mono/SoE
13 (5) [-] any 13 75779 B 1967.965969 1967.973987 14.706 fps ts mono/SoE
14 (6) [-] any 14 73720 B 1968.029969 1968.038008 15.625 fps ts mono/SoE
15 (7) [-] any 15 73671 B 1968.097969 1968.105995 14.706 fps ts mono/SoE
16 (0) [-] any 16 80507 B 1968.165969 1968.173989 14.706 fps ts mono/SoE
17 (1) [-] any 17 82505 B 1968.229969 1968.237999 15.625 fps ts mono/SoE
18 (2) [-] any 18 82640 B 1968.297966 1968.305990 14.707 fps ts mono/SoE
19 (3) [-] any 19 82676 B 1968.365969 1968.373987 14.705 fps ts mono/SoE
20 (4) [-] any 20 82802 B 1968.429967 1968.437996 15.625 fps ts mono/SoE
21 (5) [-] any 21 83523 B 1968.497967 1968.505992 14.706 fps ts mono/SoE
22 (6) [-] any 22 83774 B 1968.565964 1968.573980 14.707 fps ts mono/SoE
23 (7) [-] any 23 83678 B 1968.629966 1968.637992 15.625 fps ts mono/SoE
24 (0) [-] any 24 83627 B 1968.697964 1968.705985 14.706 fps ts mono/SoE
25 (1) [-] any 25 83675 B 1968.761965 1968.773978 15.625 fps ts mono/SoE
26 (2) [-] any 26 84022 B 1968.829965 1968.837991 14.706 fps ts mono/SoE
27 (3) [-] any 27 83861 B 1968.897963 1968.905984 14.706 fps ts mono/SoE
28 (4) [-] any 28 83859 B 1968.961962 1968.969995 15.625 fps ts mono/SoE
29 (5) [-] any 29 84127 B 1969.029964 1969.037988 14.705 fps ts mono/SoE
30 (6) [-] any 30 83975 B 1969.097963 1969.105980 14.706 fps ts mono/SoE
31 (7) [-] any 31 83942 B 1968.705930 1969.170007 -2.551 fps ts mono/SoE
32 (0) [-] any 32 84151 B 1966.942496 1969.238004 -0.567 fps ts mono/SoE
33 (1) [-] any 33 84063 B 1966.407386 1969.305995 -1.869 fps ts mono/SoE
34 (2) [-] any 34 83821 B 6363.417588 1969.370002 0.000 fps ts mono/SoE
35 (3) [-] any 35 83856 B 8999.957765 1969.437996 0.000 fps ts mono/SoE
36 (4) [-] any 36 83654 B 25405.275813 1969.505986 0.000 fps ts mono/SoE
37 (5) [-] any 37 83619 B 19546.239569 1969.570001 -0.000 fps ts mono/SoE
38 (6) [-] any 38 83257 B 19546.049575 1969.637995 -5.263 fps ts mono/SoE
39 (7) [-] any 39 83211 B 25405.475806 1969.702002 0.000 fps ts mono/SoE
40 (0) [-] any 40 83231 B 19546.310550 1969.769993 -0.000 fps ts mono/SoE
41 (1) [-] any 41 83172 B 19546.249539 1969.837989 -16.390 fps ts mono/SoE
42 (2) [-] any 42 83177 B 25405.504127 1969.901997 0.000 fps ts mono/SoE
43 (3) [-] any 43 83055 B 19546.510529 1969.969995 -0.000 fps ts mono/SoE
44 (4) [-] any 44 82520 B 19546.320540 1970.037985 -5.263 fps ts mono/SoE
45 (5) [-] any 45 80593 B 19546.771538 1970.101999 2.217 fps ts mono/SoE
46 (6) [-] any 46 77431 B 19546.710555 1970.169986 -16.398 fps ts mono/SoE
47 (7) [-] any 47 75963 B 25406.007835 1970.233994 0.000 fps ts mono/SoE
48 (0) [-] any 48 74591 B 19546.971544 1970.301993 -0.000 fps ts mono/SoE
49 (1) [-] any 49 74606 B 19546.781526 1970.369988 -5.263 fps ts mono/SoE
50 (2) [-] any 50 73896 B 25406.207845 1970.433995 0.000 fps ts mono/SoE
51 (3) [-] any 51 74192 B 19547.042536 1970.501990 -0.000 fps ts mono/SoE
52 (4) [-] any 52 75659 B 19546.981566 1970.569978 -16.402 fps ts mono/SoE
53 (5) [-] any 53 76690 B 25406.236134 1970.633989 0.000 fps ts mono/SoE
54 (6) [-] any 54 77414 B 19547.242545 1970.701984 -0.000 fps ts mono/SoE
55 (7) [-] any 55 78730 B 19547.181540 1970.769977 -16.392 fps ts mono/SoE
56 (0) [-] any 56 78034 B 19547.503556 1970.833988 3.105 fps ts mono/SoE
57 (1) [-] any 57 79526 B 19547.442546 1970.901984 -16.391 fps ts mono/SoE
58 (2) [-] any 58 79702 B 25406.739800 1970.965992 0.000 fps ts mono/SoE
59 (3) [-] any 59 79123 B 19547.703559 1971.033986 -0.000 fps ts mono/SoE
60 (4) [-] any 60 79122 B 19547.513551 1971.101980 -5.263 fps ts mono/SoE
61 (5) [-] any 61 80463 B 25406.939786 1971.165993 0.000 fps ts mono/SoE
62 (6) [-] any 62 81427 B 19547.774542 1971.233983 -0.000 fps ts mono/SoE


---//----
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.169995] uvcvideo:
Logitech Webcam C930e: PTS 2762404994 y 4519.375137 SOF 4519.375137
(x1 2073036234 x2 2148397214 y1 266141696 y2 296550400 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.170002] uvcvideo:
Logitech Webcam C930e: SOF 4519.375137 y 2663946718 ts 1968.705930 buf
ts 1969.161961 (x1 266141696/221/2013 x2 304414720/293/429 y1
1000000000 y2 3119977295)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.237992] uvcvideo:
Logitech Webcam C930e: PTS 2764401500 y 2542.380523 SOF 2542.380523
(x1 2083514520 x2 2148397346 y1 159186944 y2 166723584 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.237998] uvcvideo:
Logitech Webcam C930e: SOF 2542.380523 y 876513667 ts 1966.942496 buf
ts 1969.229962 (x1 167051264/245/381 x2 174653440/361/496 y1
1000000000 y2 3163980033)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.305981] uvcvideo:
Logitech Webcam C930e: PTS 2766398050 y 2608.731536 SOF 2608.731536
(x1 2084261310 x2 2148397740 y1 165216256 y2 171048960 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.305987] uvcvideo:
Logitech Webcam C930e: SOF 2608.731536 y 249412201 ts 1966.407386 buf
ts 1969.297961 (x1 173080576/337/473 x2 179109888/429/562 y1
1000000000 y2 3139986562)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.369989] uvcvideo:
Logitech Webcam C930e: PTS 2768394588 y 2676.063140 SOF 2676.063140
(x1 2085009256 x2 2148397262 y1 171180032 y2 175439872 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.369995] uvcvideo:
Logitech Webcam C930e: SOF 2676.063140 y 4397167610356 ts 6363.417588
buf ts 1969.361960 (x1 179109888/429/564 x2 183304192/493/629 y1
1000000000 y2 3111982460)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.437982] uvcvideo:
Logitech Webcam C930e: PTS 2770391078 y 2743.416503 SOF 2743.416503
(x1 2085757052 x2 2148397390 y1 177209344 y2 179830784 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.437989] uvcvideo:
Logitech Webcam C930e: SOF 2743.416503 y 7033615790108 ts 8999.957765
buf ts 1969.429961 (x1 185139200/521/656 x2 187760640/561/696 y1
1000000000 y2 3087984880)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.505973] uvcvideo:
Logitech Webcam C930e: PTS 2772387614 y 2809.778488 SOF 2809.778488
(x1 2086504990 x2 2148397582 y1 183173120 y2 184156160 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.505979] uvcvideo:
Logitech Webcam C930e: SOF 2809.778488 y 23438841839398 ts
25405.275813 buf ts 1969.493958 (x1 191168512/613/747 x2
191954944/625/762 y1 1000000000 y2 3059984364)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.569988] uvcvideo:
Logitech Webcam C930e: PTS 2774384164 y 2876.778503 SOF 2876.778503
(x1 2086505172 x2 2148397550 y1 187564032 y2 188547072 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.569994] uvcvideo:
Logitech Webcam C930e: SOF 2876.778503 y 17579741593849 ts
19546.239569 buf ts 1969.561957 (x1 195362816/677/814 x2
196411392/693/829 y1 1000000000 y2 3063981195)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.637982] uvcvideo:
Logitech Webcam C930e: PTS 2776380650 y 2942.778549 SOF 2942.778549
(x1 2086504900 x2 2148397350 y1 191889408 y2 192872448 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.637988] uvcvideo:
Logitech Webcam C930e: SOF 2942.778549 y 17579483600299 ts
19546.049575 buf ts 1969.629957 (x1 199819264/745/880 x2
200867840/761/895 y1 1000000000 y2 3063981467)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.701989] uvcvideo:
Logitech Webcam C930e: PTS 2778377196 y 3009.778503 SOF 3009.778503
(x1 2086504892 x2 2148397554 y1 196280320 y2 197263360 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.701995] uvcvideo:
Logitech Webcam C930e: SOF 3009.778503 y 23438841832859 ts
25405.475806 buf ts 1969.693958 (x1 204275712/813/947 x2
205062144/825/962 y1 1000000000 y2 3059985389)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.769980] uvcvideo:
Logitech Webcam C930e: PTS 2780373752 y 3075.778549 SOF 3075.778549
(x1 2086505152 x2 2148397324 y1 200605696 y2 201588736 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.769986] uvcvideo:
Logitech Webcam C930e: SOF 3075.778549 y 17579612579208 ts
19546.310550 buf ts 1969.761955 (x1 208470016/877/1013 x2
209518592/893/1028 y1 1000000000 y2 3063984498)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.837976] uvcvideo:
Logitech Webcam C930e: PTS 2782370262 y 3142.778564 SOF 3142.778564
(x1 2086504996 x2 2148397304 y1 204996608 y2 205979648 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.837982] uvcvideo:
Logitech Webcam C930e: SOF 3142.778564 y 17579483566644 ts
19546.249539 buf ts 1969.829959 (x1 212926464/945/1080 x2
213975040/961/1095 y1 1000000000 y2 3063986833)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.901984] uvcvideo:
Logitech Webcam C930e: PTS 2784366776 y 3208.778396 SOF 3208.778396
(x1 2086505046 x2 2148397978 y1 209321984 y2 210305024 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.901990] uvcvideo:
Logitech Webcam C930e: SOF 3208.778396 y 23438670155531 ts
25405.504127 buf ts 1969.893956 (x1 217382912/1013/1146 x2
218169344/1/1161 y1 1000000000 y2 3059984673)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.969981] uvcvideo:
Logitech Webcam C930e: PTS 2786363306 y 3275.778518 SOF 3275.778518
(x1 2086505170 x2 2148397476 y1 213712896 y2 214695936 SOF offset 138)
Nov  5 22:07:38 Cobra-desktop kernel: [ 1969.969987] uvcvideo:
Logitech Webcam C930e: SOF 3275.778518 y 17579612560054 ts
19546.510529 buf ts 1969.961956 (x1 221577216/53/1213 x2
222625792/69/1228 y1 1000000000 y2 3063986812)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.037972] uvcvideo:
Logitech Webcam C930e: PTS 2788359850 y 3341.778533 SOF 3341.778533
(x1 2086505350 x2 2148397414 y1 218038272 y2 219021312 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.037979] uvcvideo:
Logitech Webcam C930e: SOF 3341.778533 y 17579354571096 ts
19546.320540 buf ts 1970.029955 (x1 226033664/121/1279 x2
227082240/137/1294 y1 1000000000 y2 3063985704)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.101986] uvcvideo:
Logitech Webcam C930e: PTS 2790356358 y 3408.778518 SOF 3408.778518
(x1 2086504950 x2 2148397496 y1 222429184 y2 223412224 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.101992] uvcvideo:
Logitech Webcam C930e: SOF 3408.778518 y 17579741569189 ts
19546.771538 buf ts 1970.093954 (x1 230227968/185/1346 x2
231276544/201/1361 y1 1000000000 y2 3063985283)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.169973] uvcvideo:
Logitech Webcam C930e: PTS 2792352904 y 3475.778533 SOF 3475.778533
(x1 2086505102 x2 2148397408 y1 226820096 y2 227803136 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.169980] uvcvideo:
Logitech Webcam C930e: SOF 3475.778533 y 17579612586322 ts
19546.710555 buf ts 1970.161952 (x1 234684416/253/1413 x2
235732992/269/1428 y1 1000000000 y2 3063983117)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.233981] uvcvideo:
Logitech Webcam C930e: PTS 2794349426 y 3541.778564 SOF 3541.778564
(x1 2086505038 x2 2148397280 y1 231145472 y2 232128512 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.233987] uvcvideo:
Logitech Webcam C930e: SOF 3541.778564 y 23438841865772 ts
25406.007835 buf ts 1970.225952 (x1 239140864/321/1479 x2
239927296/333/1494 y1 1000000000 y2 3059982878)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.301979] uvcvideo:
Logitech Webcam C930e: PTS 2796345944 y 3608.778533 SOF 3608.778533
(x1 2086504980 x2 2148397402 y1 235536384 y2 236519424 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.301986] uvcvideo:
Logitech Webcam C930e: SOF 3608.778533 y 17579741575092 ts
19546.971544 buf ts 1970.293954 (x1 243335168/385/1546 x2
244383744/401/1561 y1 1000000000 y2 3063984679)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.369975] uvcvideo:
Logitech Webcam C930e: PTS 2798342492 y 3674.778518 SOF 3674.778518
(x1 2086505052 x2 2148397480 y1 239861760 y2 240844800 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.369981] uvcvideo:
Logitech Webcam C930e: SOF 3674.778518 y 17579483560493 ts
19546.781526 buf ts 1970.361953 (x1 247791616/453/1612 x2
248840192/469/1627 y1 1000000000 y2 3063986870)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.433983] uvcvideo:
Logitech Webcam C930e: PTS 2800339000 y 3741.778564 SOF 3741.778564
(x1 2086505020 x2 2148397320 y1 244252672 y2 245235712 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.433989] uvcvideo:
Logitech Webcam C930e: SOF 3741.778564 y 23438841876629 ts
25406.207845 buf ts 1970.425951 (x1 252248064/521/1679 x2
253034496/533/1694 y1 1000000000 y2 3059981663)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.501978] uvcvideo:
Logitech Webcam C930e: PTS 2802335514 y 3807.778503 SOF 3807.778503
(x1 2086504998 x2 2148397556 y1 248578048 y2 249561088 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.501984] uvcvideo:
Logitech Webcam C930e: SOF 3807.778503 y 17579612569758 ts
19547.042536 buf ts 1970.493952 (x1 256442368/585/1745 x2
257490944/601/1760 y1 1000000000 y2 3063985037)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.569965] uvcvideo:
Logitech Webcam C930e: PTS 2804332058 y 3874.778533 SOF 3874.778533
(x1 2086505178 x2 2148397390 y1 252968960 y2 253952000 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.569972] uvcvideo:
Logitech Webcam C930e: SOF 3874.778533 y 17579483599493 ts
19546.981566 buf ts 1970.561949 (x1 260898816/653/1812 x2
261947392/669/1827 y1 1000000000 y2 3063981292)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.633976] uvcvideo:
Logitech Webcam C930e: PTS 2806328600 y 3940.778472 SOF 3940.778472
(x1 2086505510 x2 2148397640 y1 257294336 y2 258277376 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.633983] uvcvideo:
Logitech Webcam C930e: SOF 3940.778472 y 23438670170143 ts
25406.236134 buf ts 1970.625949 (x1 265355264/721/1878 x2
266141696/733/1893 y1 1000000000 y2 3059984505)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.701972] uvcvideo:
Logitech Webcam C930e: PTS 2808325118 y 4007.778503 SOF 4007.778503
(x1 2086504962 x2 2148397538 y1 261685248 y2 262668288 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.701979] uvcvideo:
Logitech Webcam C930e: SOF 1959.778503 y 17579612579235 ts
19547.242545 buf ts 1970.693950 (x1 135331840/785/1945 x2
136380416/801/1960 y1 1000000000 y2 3063983596)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.769964] uvcvideo:
Logitech Webcam C930e: PTS 2810321650 y 4074.778533 SOF 4074.778533
(x1 2086505356 x2 2148397434 y1 266076160 y2 267059200 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.769970] uvcvideo:
Logitech Webcam C930e: SOF 2026.778533 y 17579483577113 ts
19547.181540 buf ts 1970.761948 (x1 139788288/853/2012 x2
140836864/869/2027 y1 1000000000 y2 3063984663)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.833975] uvcvideo:
Logitech Webcam C930e: PTS 2812318162 y 2092.778579 SOF 2092.778579
(x1 2086504992 x2 2148397224 y1 136183808 y2 137166848 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.833981] uvcvideo:
Logitech Webcam C930e: SOF 2092.778579 y 17579741591308 ts
19547.503556 buf ts 1970.825948 (x1 143982592/917/30 x2
145031168/933/45 y1 1000000000 y2 3063983096)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.901972] uvcvideo:
Logitech Webcam C930e: PTS 2814314688 y 2159.778503 SOF 2159.778503
(x1 2086504946 x2 2148397560 y1 140574720 y2 141557760 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.901978] uvcvideo:
Logitech Webcam C930e: SOF 2159.778503 y 17579612581944 ts
19547.442546 buf ts 1970.893948 (x1 148439040/985/97 x2
149487616/1001/112 y1 1000000000 y2 3063983184)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.965979] uvcvideo:
Logitech Webcam C930e: PTS 2816311230 y 2225.778564 SOF 2225.778564
(x1 2086505120 x2 2148397300 y1 144900096 y2 145883136 SOF offset 138)
Nov  5 22:07:39 Cobra-desktop kernel: [ 1970.965986] uvcvideo:
Logitech Webcam C930e: SOF 2225.778564 y 23438841837341 ts
25406.739800 buf ts 1970.957949 (x1 152895488/29/163 x2
153681920/41/178 y1 1000000000 y2 3059986060)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.033973] uvcvideo:
Logitech Webcam C930e: PTS 2818307742 y 2292.778579 SOF 2292.778579
(x1 2086505052 x2 2148397240 y1 149291008 y2 150274048 SOF offset 138)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.033980] uvcvideo:
Logitech Webcam C930e: SOF 2292.778579 y 17579741596923 ts
19547.703559 buf ts 1971.025944 (x1 157089792/93/230 x2
158138368/109/245 y1 1000000000 y2 3063982234)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.101967] uvcvideo:
Logitech Webcam C930e: PTS 2820304272 y 2358.778503 SOF 2358.778503
(x1 2086505024 x2 2148397552 y1 153616384 y2 154599424 SOF offset 138)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.101973] uvcvideo:
Logitech Webcam C930e: SOF 2358.778503 y 17579483587576 ts
19547.513551 buf ts 1971.093946 (x1 161546240/161/296 x2
162594816/177/311 y1 1000000000 y2 3063982494)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.165980] uvcvideo:
Logitech Webcam C930e: PTS 2822300816 y 2425.778549 SOF 2425.778549
(x1 2086505156 x2 2148397368 y1 158007296 y2 158990336 SOF offset 138)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.165986] uvcvideo:
Logitech Webcam C930e: SOF 2425.778549 y 23438841823651 ts
25406.939786 buf ts 1971.157950 (x1 166002688/229/363 x2
166789120/241/378 y1 1000000000 y2 3059987299)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.233970] uvcvideo:
Logitech Webcam C930e: PTS 2824297352 y 2491.778472 SOF 2491.778472
(x1 2086504856 x2 2148397660 y1 162332672 y2 163315712 SOF offset 138)
Nov  5 22:07:40 Cobra-desktop kernel: [ 1971.233976] uvcvideo:
Logitech Webcam C930e: SOF 2491.778472 y 17579612581033 ts
19547.774542 buf ts 1971.225944 (x1 170196992/293/429 x2
171245568/309/444 y1 1000000000 y2 3063982724)

--/--

As you can see from the yavta output timestamps are completly messed up.
I hope these logs are enough, I don't think I'll have time to test
anything else for the next coule of days.

Regards,
Paulo

2014-11-05 14:05 GMT+00:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Paulo,
>
> On Wednesday 05 November 2014 10:13:45 Paulo Assis wrote:
>> 2014-11-04 23:32 GMT+00:00 Sakari Ailus <sakari.ailus@iki.fi>:
>> > Sakari Ailus wrote:
>> >> yavta does, for example, print both the monotonic timestamp from the
>> >> buffer and the time when the buffer has been dequeued:
>> >>
>> >> <URL:http://git.ideasonboard.org/yavta.git>
>> >>
>> >>       $ yavta -c /dev/video0
>> >>
>> >> should do it. The first timestamp is the buffer timestamp, and the latter
>> >> is the one is taken when the buffer is dequeued (by yavta).
>>
>> I've done exaclty this with guvcview, and uvcvideo timestamps are completly
>> unreliable, in some devices they may have just a bit of jitter, but in
>> others, values go back and forth in time, making them totally unusable.
>>
>> Honestly I wouldn't trust device firmware to provide correct timestamps, or
>> at least I would have the driver perform a couple of tests to make sure
>> these are at least reasonable: within an expected interval (maybe comparing
>> it to a reference monotonic clock) or at the very least making sure the
>> current frame timestamp is not lower than the previous one.
>
> I can add that to the uvcvideo driver, but I'd first like to find out whether
> the device timestamps are really unreliable, or if the problem comes from a
> bug in the driver's timestamp conversion code. Could you capture images using
> yavta with an unreliable device, with the uvcvideo trace parameter set to
> 4096, and send me both the yavta log and the kernel log ? Let's start with a
> capture sequence of 50 to 100 images.
>
>> > Removing the uvcvideo module and loading it again with trace=4096 before
>> > capturing, and then kernel log would provide more useful information.
>
> --
> Regards,
>
> Laurent Pinchart
