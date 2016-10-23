Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbcJWLUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 07:20:12 -0400
Date: Sun, 23 Oct 2016 09:20:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161023092000.632aa934@vento.lan>
In-Reply-To: <20161022085629.6ebbc4f6@vento.lan>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <87oa2xrhqx.fsf@intel.com>
        <20161006103132.3a56802a@vento.lan>
        <87lgy15zin.fsf@intel.com>
        <20161006135028.2880f5a5@vento.lan>
        <8737k8ya6f.fsf@intel.com>
        <8E74FF11-208D-4C76-8A8C-2B2102E5CB20@darmarit.de>
        <20161021160543.264b8cf2@lwn.net>
        <20161022085629.6ebbc4f6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Oct 2016 08:56:29 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> How many special-case commands are we going to need to run?  Does it
> > really need to go beyond what parse-headers is doing now?  
> 
> Right now, we have actually 2 such cases: kernel-doc and parse-headers.
> 
> I also use a set of perl scripts that I manually run, on each Kernel
> version, to update the cards list of several drivers. It is a total of
> 9 such scripts.

I ended by adding a few more scripts, as ivtv, tm6000 and gspca
cardlists were missing. As result, all three had some documentation
gaps.

As an example of such scripts, I added a PoC patch at my development
tree, at the lkml-books-v2 branch:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=lkml-books-v2

Patch follows.

As I mentioned before, usually at -rc6 or -rc7, when I remember that a driver
with a cardlist was touched, I run those scripts to make sure that the
driver documentation will reflect the board additions. The scripts
run quick, so, It doesn't hurt much from my side to keep using the same
procedure. There are just a few drawbacks with this:

1) from time to time, third-party patches touch those cardlist tables,
usually not doing exactly the same thing as the script. So, when I run
the script manually, it will replace by the one at the cards definition,
producing an extra patch;

2) sometimes, I just forget running it;

3) as those cardlists are auto-generated, they need to be on a separate
rst file. If we use the kernel-cmd directive, I could write some text
before the cardlist database, and update it independently from the
scripts.

So, I prefer if we could generate it dynamically while building the
documentation.

Thanks,
Mauro

[RFC] [media] cardlists: dynamically generate cardlists from source
    
Instead of manually patch the cardlists by hand, on every Kernel
version, use scripts to auto-generate them when building the
documentation.
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/Documentation/media/v4l-drivers/au0828-cardlist.rst b/Documentation/media/v4l-drivers/au0828-cardlist.rst
index 82d2567bc7c1..afaef88969b6 100644
--- a/Documentation/media/v4l-drivers/au0828-cardlist.rst
+++ b/Documentation/media/v4l-drivers/au0828-cardlist.rst
@@ -1,13 +1 @@
-AU0828 cards list
-=================
-
-=========== ========================== =======================================================================================================================
-Card number Card name                  USB IDs
-=========== ========================== =======================================================================================================================
-0           Unknown board
-1           Hauppauge HVR950Q          2040:7200, 2040:7210, 2040:7217, 2040:721b, 2040:721e, 2040:721f, 2040:7280, 0fd9:0008, 2040:7260, 2040:7213, 2040:7270
-2           Hauppauge HVR850           2040:7240
-3           DViCO FusionHDTV USB       0fe9:d620
-4           Hauppauge HVR950Q rev xxF8 2040:7201, 2040:7211, 2040:7281
-5           Hauppauge Woodbury         05e1:0480, 2040:8200
-=========== ========================== =======================================================================================================================
+.. kernel-cmd:: au0828-cardlist.pl $srctree/drivers/media/usb/au0828/au0828-cards.h $srctree/drivers/media/usb/au0828/au0828-cards.c
diff --git a/Documentation/media/v4l-drivers/bttv-cardlist.rst b/Documentation/media/v4l-drivers/bttv-cardlist.rst
index 28a01cd6cf2e..3ae5099ffdd3 100644
--- a/Documentation/media/v4l-drivers/bttv-cardlist.rst
+++ b/Documentation/media/v4l-drivers/bttv-cardlist.rst
@@ -1,174 +1 @@
-BTTV cards list
-===============
-
-=========== ================================================================================= ==============================================================================================================================================================================
-Card number Card name                                                                         PCI IDs
-=========== ================================================================================= ==============================================================================================================================================================================
-0            *** UNKNOWN/GENERIC ***
-1           MIRO PCTV
-2           Hauppauge (bt848)
-3           STB, Gateway P/N 6000699 (bt848)
-4           Intel Create and Share PCI/ Smart Video Recorder III
-5           Diamond DTV2000
-6           AVerMedia TVPhone
-7           MATRIX-Vision MV-Delta
-8           Lifeview FlyVideo II (Bt848) LR26 / MAXI TV Video PCI2 LR26
-9           IMS/IXmicro TurboTV
-10          Hauppauge (bt878)                                                                 0070:13eb, 0070:3900, 2636:10b4
-11          MIRO PCTV pro
-12          ADS Technologies Channel Surfer TV (bt848)
-13          AVerMedia TVCapture 98                                                            1461:0002, 1461:0004, 1461:0300
-14          Aimslab Video Highway Xtreme (VHX)
-15          Zoltrix TV-Max                                                                    a1a0:a0fc
-16          Prolink Pixelview PlayTV (bt878)
-17          Leadtek WinView 601
-18          AVEC Intercapture
-19          Lifeview FlyVideo II EZ /FlyKit LR38 Bt848 (capture only)
-20          CEI Raffles Card
-21          Lifeview FlyVideo 98/ Lucky Star Image World ConferenceTV LR50
-22          Askey CPH050/ Phoebe Tv Master + FM                                               14ff:3002
-23          Modular Technology MM201/MM202/MM205/MM210/MM215 PCTV, bt878                      14c7:0101
-24          Askey CPH05X/06X (bt878) [many vendors]                                           144f:3002, 144f:3005, 144f:5000, 14ff:3000
-25          Terratec TerraTV+ Version 1.0 (Bt848)/ Terra TValue Version 1.0/ Vobis TV-Boostar
-26          Hauppauge WinCam newer (bt878)
-27          Lifeview FlyVideo 98/ MAXI TV Video PCI2 LR50
-28          Terratec TerraTV+ Version 1.1 (bt878)                                             153b:1127, 1852:1852
-29          Imagenation PXC200                                                                1295:200a
-30          Lifeview FlyVideo 98 LR50                                                         1f7f:1850
-31          Formac iProTV, Formac ProTV I (bt848)
-32          Intel Create and Share PCI/ Smart Video Recorder III
-33          Terratec TerraTValue Version Bt878                                                153b:1117, 153b:1118, 153b:1119, 153b:111a, 153b:1134, 153b:5018
-34          Leadtek WinFast 2000/ WinFast 2000 XP                                             107d:6606, 107d:6609, 6606:217d, f6ff:fff6
-35          Lifeview FlyVideo 98 LR50 / Chronos Video Shuttle II                              1851:1850, 1851:a050
-36          Lifeview FlyVideo 98FM LR50 / Typhoon TView TV/FM Tuner                           1852:1852
-37          Prolink PixelView PlayTV pro
-38          Askey CPH06X TView99                                                              144f:3000, 144f:a005, a04f:a0fc
-39          Pinnacle PCTV Studio/Rave                                                         11bd:0012, bd11:1200, bd11:ff00, 11bd:ff12
-40          STB TV PCI FM, Gateway P/N 6000704 (bt878), 3Dfx VoodooTV 100                     10b4:2636, 10b4:2645, 121a:3060
-41          AVerMedia TVPhone 98                                                              1461:0001, 1461:0003
-42          ProVideo PV951                                                                    aa0c:146c
-43          Little OnAir TV
-44          Sigma TVII-FM
-45          MATRIX-Vision MV-Delta 2
-46          Zoltrix Genie TV/FM                                                               15b0:4000, 15b0:400a, 15b0:400d, 15b0:4010, 15b0:4016
-47          Terratec TV/Radio+                                                                153b:1123
-48          Askey CPH03x/ Dynalink Magic TView
-49          IODATA GV-BCTV3/PCI                                                               10fc:4020
-50          Prolink PV-BT878P+4E / PixelView PlayTV PAK / Lenco MXTV-9578 CP
-51          Eagle Wireless Capricorn2 (bt878A)
-52          Pinnacle PCTV Studio Pro
-53          Typhoon TView RDS + FM Stereo / KNC1 TV Station RDS
-54          Lifeview FlyVideo 2000 /FlyVideo A2/ Lifetec LT 9415 TV [LR90]
-55          Askey CPH031/ BESTBUY Easy TV
-56          Lifeview FlyVideo 98FM LR50                                                       a051:41a0
-57          GrandTec 'Grand Video Capture' (Bt848)                                            4344:4142
-58          Askey CPH060/ Phoebe TV Master Only (No FM)
-59          Askey CPH03x TV Capturer
-60          Modular Technology MM100PCTV
-61          AG Electronics GMV1                                                               15cb:0101
-62          Askey CPH061/ BESTBUY Easy TV (bt878)
-63          ATI TV-Wonder                                                                     1002:0001
-64          ATI TV-Wonder VE                                                                  1002:0003
-65          Lifeview FlyVideo 2000S LR90
-66          Terratec TValueRadio                                                              153b:1135, 153b:ff3b
-67          IODATA GV-BCTV4/PCI                                                               10fc:4050
-68          3Dfx VoodooTV FM (Euro)                                                           10b4:2637
-69          Active Imaging AIMMS
-70          Prolink Pixelview PV-BT878P+ (Rev.4C,8E)
-71          Lifeview FlyVideo 98EZ (capture only) LR51                                        1851:1851
-72          Prolink Pixelview PV-BT878P+9B (PlayTV Pro rev.9B FM+NICAM)                       1554:4011
-73          Sensoray 311/611                                                                  6000:0311, 6000:0611
-74          RemoteVision MX (RV605)
-75          Powercolor MTV878/ MTV878R/ MTV878F
-76          Canopus WinDVR PCI (COMPAQ Presario 3524JP, 5112JP)                               0e11:0079
-77          GrandTec Multi Capture Card (Bt878)
-78          Jetway TV/Capture JW-TV878-FBK, Kworld KW-TV878RF                                 0a01:17de
-79          DSP Design TCVIDEO
-80          Hauppauge WinTV PVR                                                               0070:4500
-81          IODATA GV-BCTV5/PCI                                                               10fc:4070, 10fc:d018
-82          Osprey 100/150 (878)                                                              0070:ff00
-83          Osprey 100/150 (848)
-84          Osprey 101 (848)
-85          Osprey 101/151
-86          Osprey 101/151 w/ svid
-87          Osprey 200/201/250/251
-88          Osprey 200/250                                                                    0070:ff01
-89          Osprey 210/220/230
-90          Osprey 500                                                                        0070:ff02
-91          Osprey 540                                                                        0070:ff04
-92          Osprey 2000                                                                       0070:ff03
-93          IDS Eagle
-94          Pinnacle PCTV Sat                                                                 11bd:001c
-95          Formac ProTV II (bt878)
-96          MachTV
-97          Euresys Picolo
-98          ProVideo PV150                                                                    aa00:1460, aa01:1461, aa02:1462, aa03:1463, aa04:1464, aa05:1465, aa06:1466, aa07:1467
-99          AD-TVK503
-100         Hercules Smart TV Stereo
-101         Pace TV & Radio Card
-102         IVC-200                                                                           0000:a155, 0001:a155, 0002:a155, 0003:a155, 0100:a155, 0101:a155, 0102:a155, 0103:a155, 0800:a155, 0801:a155, 0802:a155, 0803:a155
-103         Grand X-Guard / Trust 814PCI                                                      0304:0102
-104         Nebula Electronics DigiTV                                                         0071:0101
-105         ProVideo PV143                                                                    aa00:1430, aa00:1431, aa00:1432, aa00:1433, aa03:1433
-106         PHYTEC VD-009-X1 VD-011 MiniDIN (bt878)
-107         PHYTEC VD-009-X1 VD-011 Combi (bt878)
-108         PHYTEC VD-009 MiniDIN (bt878)
-109         PHYTEC VD-009 Combi (bt878)
-110         IVC-100                                                                           ff00:a132
-111         IVC-120G                                                                          ff00:a182, ff01:a182, ff02:a182, ff03:a182, ff04:a182, ff05:a182, ff06:a182, ff07:a182, ff08:a182, ff09:a182, ff0a:a182, ff0b:a182, ff0c:a182, ff0d:a182, ff0e:a182, ff0f:a182
-112         pcHDTV HD-2000 TV                                                                 7063:2000
-113         Twinhan DST + clones                                                              11bd:0026, 1822:0001, 270f:fc00, 1822:0026
-114         Winfast VC100                                                                     107d:6607
-115         Teppro TEV-560/InterVision IV-560
-116         SIMUS GVC1100                                                                     aa6a:82b2
-117         NGS NGSTV+
-118         LMLBT4
-119         Tekram M205 PRO
-120         Conceptronic CONTVFMi
-121         Euresys Picolo Tetra                                                              1805:0105, 1805:0106, 1805:0107, 1805:0108
-122         Spirit TV Tuner
-123         AVerMedia AVerTV DVB-T 771                                                        1461:0771
-124         AverMedia AverTV DVB-T 761                                                        1461:0761
-125         MATRIX Vision Sigma-SQ
-126         MATRIX Vision Sigma-SLC
-127         APAC Viewcomp 878(AMAX)
-128         DViCO FusionHDTV DVB-T Lite                                                       18ac:db10, 18ac:db11
-129         V-Gear MyVCD
-130         Super TV Tuner
-131         Tibet Systems 'Progress DVR' CS16
-132         Kodicom 4400R (master)
-133         Kodicom 4400R (slave)
-134         Adlink RTV24
-135         DViCO FusionHDTV 5 Lite                                                           18ac:d500
-136         Acorp Y878F                                                                       9511:1540
-137         Conceptronic CTVFMi v2                                                            036e:109e
-138         Prolink Pixelview PV-BT878P+ (Rev.2E)
-139         Prolink PixelView PlayTV MPEG2 PV-M4900
-140         Osprey 440                                                                        0070:ff07
-141         Asound Skyeye PCTV
-142         Sabrent TV-FM (bttv version)
-143         Hauppauge ImpactVCB (bt878)                                                       0070:13eb
-144         MagicTV
-145         SSAI Security Video Interface                                                     4149:5353
-146         SSAI Ultrasound Video Interface                                                   414a:5353
-147         VoodooTV 200 (USA)                                                                121a:3000
-148         DViCO FusionHDTV 2                                                                dbc0:d200
-149         Typhoon TV-Tuner PCI (50684)
-150         Geovision GV-600                                                                  008a:763c
-151         Kozumi KTV-01C
-152         Encore ENL TV-FM-2                                                                1000:1801
-153         PHYTEC VD-012 (bt878)
-154         PHYTEC VD-012-X1 (bt878)
-155         PHYTEC VD-012-X2 (bt878)
-156         IVCE-8784                                                                         0000:f050, 0001:f050, 0002:f050, 0003:f050
-157         Geovision GV-800(S) (master)                                                      800a:763d
-158         Geovision GV-800(S) (slave)                                                       800b:763d, 800c:763d, 800d:763d
-159         ProVideo PV183                                                                    1830:1540, 1831:1540, 1832:1540, 1833:1540, 1834:1540, 1835:1540, 1836:1540, 1837:1540
-160         Tongwei Video Technology TD-3116                                                  f200:3116
-161         Aposonic W-DVR                                                                    0279:0228
-162         Adlink MPG24
-163         Bt848 Capture 14MHz
-164         CyberVision CV06 (SV)
-165         Kworld V-Stream Xpert TV PVR878
-166         PCI-8604PW
-=========== ================================================================================= ==============================================================================================================================================================================
+.. kernel-cmd:: bttv-cardlist.pl $srctree/drivers/media/pci/bt8xx/bttv.h $srctree/drivers/media/pci/bt8xx/bttv-cards.c
diff --git a/Documentation/media/v4l-drivers/cx23885-cardlist.rst b/Documentation/media/v4l-drivers/cx23885-cardlist.rst
index fd20b50d2c1d..2a76b5a0c147 100644
--- a/Documentation/media/v4l-drivers/cx23885-cardlist.rst
+++ b/Documentation/media/v4l-drivers/cx23885-cardlist.rst
@@ -1,65 +1 @@
-cx23885 cards list
-==================
-
-=========== ==================================== ======================================================================================
-Card number Card name                            PCI IDs
-=========== ==================================== ======================================================================================
-0           UNKNOWN/GENERIC                      0070:3400
-1           Hauppauge WinTV-HVR1800lp            0070:7600
-2           Hauppauge WinTV-HVR1800              0070:7800, 0070:7801, 0070:7809
-3           Hauppauge WinTV-HVR1250              0070:7911
-4           DViCO FusionHDTV5 Express            18ac:d500
-5           Hauppauge WinTV-HVR1500Q             0070:7790, 0070:7797
-6           Hauppauge WinTV-HVR1500              0070:7710, 0070:7717
-7           Hauppauge WinTV-HVR1200              0070:71d1, 0070:71d3
-8           Hauppauge WinTV-HVR1700              0070:8101
-9           Hauppauge WinTV-HVR1400              0070:8010
-10          DViCO FusionHDTV7 Dual Express       18ac:d618
-11          DViCO FusionHDTV DVB-T Dual Express  18ac:db78
-12          Leadtek Winfast PxDVR3200 H          107d:6681
-13          Compro VideoMate E650F               185b:e800
-14          TurboSight TBS 6920                  6920:8888
-15          TeVii S470                           d470:9022
-16          DVBWorld DVB-S2 2005                 0001:2005
-17          NetUP Dual DVB-S2 CI                 1b55:2a2c
-18          Hauppauge WinTV-HVR1270              0070:2211
-19          Hauppauge WinTV-HVR1275              0070:2215, 0070:221d, 0070:22f2
-20          Hauppauge WinTV-HVR1255              0070:2251, 0070:22f1
-21          Hauppauge WinTV-HVR1210              0070:2291, 0070:2295, 0070:2299, 0070:229d, 0070:22f0, 0070:22f3, 0070:22f4, 0070:22f5
-22          Mygica X8506 DMB-TH                  14f1:8651
-23          Magic-Pro ProHDTV Extreme 2          14f1:8657
-24          Hauppauge WinTV-HVR1850              0070:8541
-25          Compro VideoMate E800                1858:e800
-26          Hauppauge WinTV-HVR1290              0070:8551
-27          Mygica X8558 PRO DMB-TH              14f1:8578
-28          LEADTEK WinFast PxTV1200             107d:6f22
-29          GoTView X5 3D Hybrid                 5654:2390
-30          NetUP Dual DVB-T/C-CI RF             1b55:e2e4
-31          Leadtek Winfast PxDVR3200 H XC4000   107d:6f39
-32          MPX-885
-33          Mygica X8502/X8507 ISDB-T            14f1:8502
-34          TerraTec Cinergy T PCIe Dual         153b:117e
-35          TeVii S471                           d471:9022
-36          Hauppauge WinTV-HVR1255              0070:2259
-37          Prof Revolution DVB-S2 8000          8000:3034
-38          Hauppauge WinTV-HVR4400/HVR5500      0070:c108, 0070:c138, 0070:c1f8
-39          AVerTV Hybrid Express Slim HC81R     1461:d939
-40          TurboSight TBS 6981                  6981:8888
-41          TurboSight TBS 6980                  6980:8888
-42          Leadtek Winfast PxPVR2200            107d:6f21
-43          Hauppauge ImpactVCB-e                0070:7133
-44          DViCO FusionHDTV DVB-T Dual Express2 18ac:db98
-45          DVBSky T9580                         4254:9580
-46          DVBSky T980C                         4254:980c
-47          DVBSky S950C                         4254:950c
-48          Technotrend TT-budget CT2-4500 CI    13c2:3013
-49          DVBSky S950                          4254:0950
-50          DVBSky S952                          4254:0952
-51          DVBSky T982                          4254:0982
-52          Hauppauge WinTV-HVR5525              0070:f038
-53          Hauppauge WinTV Starburst            0070:c12a
-54          ViewCast 260e                        1576:0260
-55          ViewCast 460e                        1576:0460
-56          Hauppauge WinTV-QuadHD-DVB           0070:6a28, 0070:6b28
-57          Hauppauge WinTV-QuadHD-ATSC          0070:6a18, 0070:6b18
-=========== ==================================== ======================================================================================
+.. kernel-cmd:: cx23885-cardlist.pl $srctree/drivers/media/pci/cx23885/cx23885.h $srctree/drivers/media/pci/cx23885/cx23885-cards.c
diff --git a/Documentation/media/v4l-drivers/cx88-cardlist.rst b/Documentation/media/v4l-drivers/cx88-cardlist.rst
index 8cc1cea17035..85a71537b98e 100644
--- a/Documentation/media/v4l-drivers/cx88-cardlist.rst
+++ b/Documentation/media/v4l-drivers/cx88-cardlist.rst
@@ -1,98 +1 @@
-CX88 cards list
-===============
-
-=========== =================================================== ======================================================================================
-Card number Card name                                           PCI IDs
-=========== =================================================== ======================================================================================
-0           UNKNOWN/GENERIC
-1           Hauppauge WinTV 34xxx models                        0070:3400, 0070:3401
-2           GDI Black Gold                                      14c7:0106, 14c7:0107
-3           PixelView                                           1554:4811
-4           ATI TV Wonder Pro                                   1002:00f8, 1002:00f9
-5           Leadtek Winfast 2000XP Expert                       107d:6611, 107d:6613
-6           AverTV Studio 303 (M126)                            1461:000b
-7           MSI TV-@nywhere Master                              1462:8606
-8           Leadtek Winfast DV2000                              107d:6620, 107d:6621
-9           Leadtek PVR 2000                                    107d:663b, 107d:663c, 107d:6632, 107d:6630, 107d:6638, 107d:6631, 107d:6637, 107d:663d
-10          IODATA GV-VCP3/PCI                                  10fc:d003
-11          Prolink PlayTV PVR
-12          ASUS PVR-416                                        1043:4823, 1461:c111
-13          MSI TV-@nywhere
-14          KWorld/VStream XPert DVB-T                          17de:08a6
-15          DViCO FusionHDTV DVB-T1                             18ac:db00
-16          KWorld LTV883RF
-17          DViCO FusionHDTV 3 Gold-Q                           18ac:d810, 18ac:d800
-18          Hauppauge Nova-T DVB-T                              0070:9002, 0070:9001, 0070:9000
-19          Conexant DVB-T reference design                     14f1:0187
-20          Provideo PV259                                      1540:2580
-21          DViCO FusionHDTV DVB-T Plus                         18ac:db10, 18ac:db11
-22          pcHDTV HD3000 HDTV                                  7063:3000
-23          digitalnow DNTV Live! DVB-T                         17de:a8a6
-24          Hauppauge WinTV 28xxx (Roslyn) models               0070:2801
-25          Digital-Logic MICROSPACE Entertainment Center (MEC) 14f1:0342
-26          IODATA GV/BCTV7E                                    10fc:d035
-27          PixelView PlayTV Ultra Pro (Stereo)
-28          DViCO FusionHDTV 3 Gold-T                           18ac:d820
-29          ADS Tech Instant TV DVB-T PCI                       1421:0334
-30          TerraTec Cinergy 1400 DVB-T                         153b:1166
-31          DViCO FusionHDTV 5 Gold                             18ac:d500
-32          AverMedia UltraTV Media Center PCI 550              1461:8011
-33          Kworld V-Stream Xpert DVD
-34          ATI HDTV Wonder                                     1002:a101
-35          WinFast DTV1000-T                                   107d:665f
-36          AVerTV 303 (M126)                                   1461:000a
-37          Hauppauge Nova-S-Plus DVB-S                         0070:9201, 0070:9202
-38          Hauppauge Nova-SE2 DVB-S                            0070:9200
-39          KWorld DVB-S 100                                    17de:08b2, 1421:0341
-40          Hauppauge WinTV-HVR1100 DVB-T/Hybrid                0070:9400, 0070:9402
-41          Hauppauge WinTV-HVR1100 DVB-T/Hybrid (Low Profile)  0070:9800, 0070:9802
-42          digitalnow DNTV Live! DVB-T Pro                     1822:0025, 1822:0019
-43          KWorld/VStream XPert DVB-T with cx22702             17de:08a1, 12ab:2300
-44          DViCO FusionHDTV DVB-T Dual Digital                 18ac:db50, 18ac:db54
-45          KWorld HardwareMpegTV XPert                         17de:0840, 1421:0305
-46          DViCO FusionHDTV DVB-T Hybrid                       18ac:db40, 18ac:db44
-47          pcHDTV HD5500 HDTV                                  7063:5500
-48          Kworld MCE 200 Deluxe                               17de:0841
-49          PixelView PlayTV P7000                              1554:4813
-50          NPG Tech Real TV FM Top 10                          14f1:0842
-51          WinFast DTV2000 H                                   107d:665e
-52          Geniatech DVB-S                                     14f1:0084
-53          Hauppauge WinTV-HVR3000 TriMode Analog/DVB-S/DVB-T  0070:1404, 0070:1400, 0070:1401, 0070:1402
-54          Norwood Micro TV Tuner
-55          Shenzhen Tungsten Ages Tech TE-DTV-250 / Swann OEM  c180:c980
-56          Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder   0070:9600, 0070:9601, 0070:9602
-57          ADS Tech Instant Video PCI                          1421:0390
-58          Pinnacle PCTV HD 800i                               11bd:0051
-59          DViCO FusionHDTV 5 PCI nano                         18ac:d530
-60          Pinnacle Hybrid PCTV                                12ab:1788
-61          Leadtek TV2000 XP Global                            107d:6f18, 107d:6618, 107d:6619
-62          PowerColor RA330                                    14f1:ea3d
-63          Geniatech X8000-MT DVBT                             14f1:8852
-64          DViCO FusionHDTV DVB-T PRO                          18ac:db30
-65          DViCO FusionHDTV 7 Gold                             18ac:d610
-66          Prolink Pixelview MPEG 8000GT                       1554:4935
-67          Kworld PlusTV HD PCI 120 (ATSC 120)                 17de:08c1
-68          Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid           0070:6900, 0070:6904, 0070:6902
-69          Hauppauge WinTV-HVR4000(Lite) DVB-S/S2              0070:6905, 0070:6906
-70          TeVii S460 DVB-S/S2                                 d460:9022
-71          Omicom SS4 DVB-S/S2 PCI                             A044:2011
-72          TBS 8920 DVB-S/S2                                   8920:8888
-73          TeVii S420 DVB-S                                    d420:9022
-74          Prolink Pixelview Global Extreme                    1554:4976
-75          PROF 7300 DVB-S/S2                                  B033:3033
-76          SATTRADE ST4200 DVB-S/S2                            b200:4200
-77          TBS 8910 DVB-S                                      8910:8888
-78          Prof 6200 DVB-S                                     b022:3022
-79          Terratec Cinergy HT PCI MKII                        153b:1177
-80          Hauppauge WinTV-IR Only                             0070:9290
-81          Leadtek WinFast DTV1800 Hybrid                      107d:6654
-82          WinFast DTV2000 H rev. J                            107d:6f2b
-83          Prof 7301 DVB-S/S2                                  b034:3034
-84          Samsung SMT 7020 DVB-S                              18ac:dc00, 18ac:dccd
-85          Twinhan VP-1027 DVB-S                               1822:0023
-86          TeVii S464 DVB-S/S2                                 d464:9022
-87          Leadtek WinFast DTV2000 H PLUS                      107d:6f42
-88          Leadtek WinFast DTV1800 H (XC4000)                  107d:6f38
-89          Leadtek TV2000 XP Global (SC4100)                   107d:6f36
-90          Leadtek TV2000 XP Global (XC4100)                   107d:6f43
-=========== =================================================== ======================================================================================
+.. kernel-cmd:: cx88-cardlist.pl $srctree/drivers/media/pci/cx88/cx88.h $srctree/drivers/media/pci/cx88/cx88-cards.c
diff --git a/Documentation/media/v4l-drivers/em28xx-cardlist.rst b/Documentation/media/v4l-drivers/em28xx-cardlist.rst
index 76b1d301754c..b08e6eddbb12 100644
--- a/Documentation/media/v4l-drivers/em28xx-cardlist.rst
+++ b/Documentation/media/v4l-drivers/em28xx-cardlist.rst
@@ -1,107 +1 @@
-EM28xx cards list
-=================
-
-=========== ==================================================================== ================ ==================================================================================================================================
-Card number Card name                                                            Empia Chip       USB IDs
-=========== ==================================================================== ================ ==================================================================================================================================
-0           Unknown EM2800 video grabber                                         em2800           eb1a:2800
-1           Unknown EM2750/28xx video grabber                                    em2820 or em2840 eb1a:2710, eb1a:2820, eb1a:2821, eb1a:2860, eb1a:2861, eb1a:2862, eb1a:2863, eb1a:2870, eb1a:2881, eb1a:2883, eb1a:2868, eb1a:2875
-2           Terratec Cinergy 250 USB                                             em2820 or em2840 0ccd:0036
-3           Pinnacle PCTV USB 2                                                  em2820 or em2840 2304:0208
-4           Hauppauge WinTV USB 2                                                em2820 or em2840 2040:4200, 2040:4201
-5           MSI VOX USB 2.0                                                      em2820 or em2840
-6           Terratec Cinergy 200 USB                                             em2800
-7           Leadtek Winfast USB II                                               em2800           0413:6023
-8           Kworld USB2800                                                       em2800
-9           Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker  em2820 or em2840 1b80:e302, 1b80:e304, 2304:0207, 2304:021a, 093b:a003
-10          Hauppauge WinTV HVR 900                                              em2880           2040:6500
-11          Terratec Hybrid XS                                                   em2880
-12          Kworld PVR TV 2800 RF                                                em2820 or em2840
-13          Terratec Prodigy XS                                                  em2880
-14          SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0                  em2820 or em2840
-15          V-Gear PocketTV                                                      em2800
-16          Hauppauge WinTV HVR 950                                              em2883           2040:6513, 2040:6517, 2040:651b
-17          Pinnacle PCTV HD Pro Stick                                           em2880           2304:0227
-18          Hauppauge WinTV HVR 900 (R2)                                         em2880           2040:6502
-19          EM2860/SAA711X Reference Design                                      em2860
-20          AMD ATI TV Wonder HD 600                                             em2880           0438:b002
-21          eMPIA Technology, Inc. GrabBeeX+ Video Encoder                       em2800           eb1a:2801
-22          EM2710/EM2750/EM2751 webcam grabber                                  em2750           eb1a:2750, eb1a:2751
-23          Huaqi DLCW-130                                                       em2750
-24          D-Link DUB-T210 TV Tuner                                             em2820 or em2840 2001:f112
-25          Gadmei UTV310                                                        em2820 or em2840
-26          Hercules Smart TV USB 2.0                                            em2820 or em2840
-27          Pinnacle PCTV USB 2 (Philips FM1216ME)                               em2820 or em2840
-28          Leadtek Winfast USB II Deluxe                                        em2820 or em2840
-29          EM2860/TVP5150 Reference Design                                      em2860
-30          Videology 20K14XUSB USB2.0                                           em2820 or em2840
-31          Usbgear VD204v9                                                      em2821
-32          Supercomp USB 2.0 TV                                                 em2821
-33          Elgato Video Capture                                                 em2860           0fd9:0033
-34          Terratec Cinergy A Hybrid XS                                         em2860           0ccd:004f
-35          Typhoon DVD Maker                                                    em2860
-36          NetGMBH Cam                                                          em2860
-37          Gadmei UTV330                                                        em2860           eb1a:50a6
-38          Yakumo MovieMixer                                                    em2861
-39          KWorld PVRTV 300U                                                    em2861           eb1a:e300
-40          Plextor ConvertX PX-TV100U                                           em2861           093b:a005
-41          Kworld 350 U DVB-T                                                   em2870           eb1a:e350
-42          Kworld 355 U DVB-T                                                   em2870           eb1a:e355, eb1a:e357, eb1a:e359
-43          Terratec Cinergy T XS                                                em2870
-44          Terratec Cinergy T XS (MT2060)                                       em2870           0ccd:0043
-45          Pinnacle PCTV DVB-T                                                  em2870
-46          Compro, VideoMate U3                                                 em2870           185b:2870
-47          KWorld DVB-T 305U                                                    em2880           eb1a:e305
-48          KWorld DVB-T 310U                                                    em2880
-49          MSI DigiVox A/D                                                      em2880           eb1a:e310
-50          MSI DigiVox A/D II                                                   em2880           eb1a:e320
-51          Terratec Hybrid XS Secam                                             em2880           0ccd:004c
-52          DNT DA2 Hybrid                                                       em2881
-53          Pinnacle Hybrid Pro                                                  em2881
-54          Kworld VS-DVB-T 323UR                                                em2882           eb1a:e323
-55          Terratec Cinnergy Hybrid T USB XS (em2882)                           em2882           0ccd:005e, 0ccd:0042
-56          Pinnacle Hybrid Pro (330e)                                           em2882           2304:0226
-57          Kworld PlusTV HD Hybrid 330                                          em2883           eb1a:a316
-58          Compro VideoMate ForYou/Stereo                                       em2820 or em2840 185b:2041
-59          Pinnacle PCTV HD Mini                                                em2874           2304:023f
-60          Hauppauge WinTV HVR 850                                              em2883           2040:651f
-61          Pixelview PlayTV Box 4 USB 2.0                                       em2820 or em2840
-62          Gadmei TVR200                                                        em2820 or em2840
-63          Kaiomy TVnPC U2                                                      em2860           eb1a:e303
-64          Easy Cap Capture DC-60                                               em2860           1b80:e309
-65          IO-DATA GV-MVP/SZ                                                    em2820 or em2840 04bb:0515
-66          Empire dual TV                                                       em2880
-67          Terratec Grabby                                                      em2860           0ccd:0096, 0ccd:10AF
-68          Terratec AV350                                                       em2860           0ccd:0084
-69          KWorld ATSC 315U HDTV TV Box                                         em2882           eb1a:a313
-70          Evga inDtube                                                         em2882
-71          Silvercrest Webcam 1.3mpix                                           em2820 or em2840
-72          Gadmei UTV330+                                                       em2861
-73          Reddo DVB-C USB TV Box                                               em2870
-74          Actionmaster/LinXcel/Digitus VC211A                                  em2800
-75          Dikom DK300                                                          em2882
-76          KWorld PlusTV 340U or UB435-Q (ATSC)                                 em2870           1b80:a340
-77          EM2874 Leadership ISDBT                                              em2874
-78          PCTV nanoStick T2 290e                                               em28174          2013:024f
-79          Terratec Cinergy H5                                                  em2884           eb1a:2885, 0ccd:10a2, 0ccd:10ad, 0ccd:10b6
-80          PCTV DVB-S2 Stick (460e)                                             em28174          2013:024c
-81          Hauppauge WinTV HVR 930C                                             em2884           2040:1605
-82          Terratec Cinergy HTC Stick                                           em2884           0ccd:00b2
-83          Honestech Vidbox NW03                                                em2860           eb1a:5006
-84          MaxMedia UB425-TC                                                    em2874           1b80:e425
-85          PCTV QuatroStick (510e)                                              em2884           2304:0242
-86          PCTV QuatroStick nano (520e)                                         em2884           2013:0251
-87          Terratec Cinergy HTC USB XS                                          em2884           0ccd:008e, 0ccd:00ac
-88          C3 Tech Digital Duo HDTV/SDTV USB                                    em2884           1b80:e755
-89          Delock 61959                                                         em2874           1b80:e1cc
-90          KWorld USB ATSC TV Stick UB435-Q V2                                  em2874           1b80:e346
-91          SpeedLink Vicious And Devine Laplace webcam                          em2765           1ae7:9003, 1ae7:9004
-92          PCTV DVB-S2 Stick (461e)                                             em28178          2013:0258
-93          KWorld USB ATSC TV Stick UB435-Q V3                                  em2874           1b80:e34c
-94          PCTV tripleStick (292e)                                              em28178          2013:025f, 2040:0264
-95          Leadtek VC100                                                        em2861           0413:6f07
-96          Terratec Cinergy T2 Stick HD                                         em28178          eb1a:8179
-97          Elgato EyeTV Hybrid 2008 INT                                         em2884           0fd9:0018
-98          PLEX PX-BCUD                                                         em28178          3275:0085
-99          Hauppauge WinTV-dualHD DVB                                           em28174          2040:0265
-=========== ==================================================================== ================ ==================================================================================================================================
+.. kernel-cmd:: em28xx-cardlist.pl $srctree/drivers/media/usb/em28xx/em28xx-cards.c   $srctree/drivers/media/usb/em28xx/em28xx.h
diff --git a/Documentation/media/v4l-drivers/ivtv-cardlist.rst b/Documentation/media/v4l-drivers/ivtv-cardlist.rst
index 754ffa820b4c..e9ab6849335f 100644
--- a/Documentation/media/v4l-drivers/ivtv-cardlist.rst
+++ b/Documentation/media/v4l-drivers/ivtv-cardlist.rst
@@ -1,38 +1 @@
-IVTV cards list
-===============
-
-=========== ============================================================= ====================================================
-Card number Card name                                                     PCI IDs
-=========== ============================================================= ====================================================
-0           Hauppauge WinTV PVR-250                                       IVTV16 104d:813d
-1           Hauppauge WinTV PVR-350                                       IVTV16 104d:813d
-2           Hauppauge WinTV PVR-150                                       IVTV16 104d:813d
-3           AVerMedia M179                                                IVTV15 1461:a3cf, IVTV15 1461:a3ce
-4           Yuan MPG600, Kuroutoshikou ITVC16-STVLP                       IVTV16 12ab:fff3, IVTV16 12ab:ffff
-5           YUAN MPG160, Kuroutoshikou ITVC15-STVLP, I/O Data GV-M2TV/PCI IVTV15 10fc:40a0
-6           Yuan PG600, Diamond PVR-550                                   IVTV16 ff92:0070, IVTV16 ffab:0600
-7           Adaptec VideOh! AVC-2410                                      IVTV16 9005:0093
-8           Adaptec VideOh! AVC-2010                                      IVTV16 9005:0092
-9           Nagase Transgear 5000TV                                       IVTV16 1461:bfff
-10          AOpen VA2000MAX-SNT6                                          IVTV16 0000:ff5f
-11          Yuan MPG600GR, Kuroutoshikou CX23416GYC-STVLP                 IVTV16 12ab:0600, IVTV16 fbab:0600, IVTV16 1154:0523
-12          I/O Data GV-MVP/RX, GV-MVP/RX2W (dual tuner)                  IVTV16 10fc:d01e, IVTV16 10fc:d038, IVTV16 10fc:d039
-13          I/O Data GV-MVP/RX2E                                          IVTV16 10fc:d025
-14          GotView PCI DVD                                               IVTV16 12ab:0600
-15          GotView PCI DVD2 Deluxe                                       IVTV16 ffac:0600
-16          Yuan MPC622                                                   IVTV16 ff01:d998
-17          Digital Cowboy DCT-MTVP1                                      IVTV16 1461:bfff
-18          Yuan PG600-2, GotView PCI DVD Lite                            IVTV16 ffab:0600, IVTV16 ffad:0600
-19          Club3D ZAP-TV1x01                                             IVTV16 ffab:0600
-20          AVerTV MCE 116 Plus                                           IVTV16 1461:c439
-21          ASUS Falcon2                                                  IVTV16 1043:4b66, IVTV16 1043:462e, IVTV16 1043:4b2e
-22          AVerMedia PVR-150 Plus / AVerTV M113 Partsnic (Daewoo) Tuner  IVTV16 1461:c034, IVTV16 1461:c035
-23          AVerMedia EZMaker PCI Deluxe                                  IVTV16 1461:c03f
-24          AVerMedia M104                                                IVTV16 1461:c136
-25          Buffalo PC-MV5L/PCI                                           IVTV16 1154:052b
-26          AVerMedia UltraTV 1500 MCE / AVerTV M113 Philips Tuner        IVTV16 1461:c019, IVTV16 1461:c01b
-27          Sony VAIO Giga Pocket (ENX Kikyou)                            IVTV16 104d:813d
-28          Hauppauge WinTV PVR-350 (V1)                                  IVTV16 104d:813d
-29          Yuan MPG600GR, Kuroutoshikou CX23416GYC-STVLP (no GR)         IVTV16 104d:813d
-30          Yuan MPG600GR, Kuroutoshikou CX23416GYC-STVLP (no GR/YCS)     IVTV16 104d:813d
-=========== ============================================================= ====================================================
+.. kernel-cmd:: ivtv-cardlist.pl $srctree/drivers/media/pci/ivtv/ivtv-cards.h $srctree/drivers/media/pci/ivtv/ivtv-cards.c
diff --git a/Documentation/media/v4l-drivers/saa7134-cardlist.rst b/Documentation/media/v4l-drivers/saa7134-cardlist.rst
index a5efa8f4b8e4..6164ba154abe 100644
--- a/Documentation/media/v4l-drivers/saa7134-cardlist.rst
+++ b/Documentation/media/v4l-drivers/saa7134-cardlist.rst
@@ -1,204 +1 @@
-SAA7134 cards list
-==================
-
-=========== ======================================================= ================================================================
-Card number Card name                                               PCI IDs
-=========== ======================================================= ================================================================
-0           UNKNOWN/GENERIC
-1           Proteus Pro [philips reference design]                  1131:2001, 1131:2001
-2           LifeView FlyVIDEO3000                                   5168:0138, 4e42:0138
-3           LifeView/Typhoon FlyVIDEO2000                           5168:0138, 4e42:0138
-4           EMPRESS                                                 1131:6752
-5           SKNet Monster TV                                        1131:4e85
-6           Tevion MD 9717
-7           KNC One TV-Station RDS / Typhoon TV Tuner RDS           1131:fe01, 1894:fe01
-8           Terratec Cinergy 400 TV                                 153b:1142
-9           Medion 5044
-10          Kworld/KuroutoShikou SAA7130-TVPCI
-11          Terratec Cinergy 600 TV                                 153b:1143
-12          Medion 7134                                             16be:0003, 16be:5000
-13          Typhoon TV+Radio 90031
-14          ELSA EX-VISION 300TV                                    1048:226b
-15          ELSA EX-VISION 500TV                                    1048:226a
-16          ASUS TV-FM 7134                                         1043:4842, 1043:4830, 1043:4840
-17          AOPEN VA1000 POWER                                      1131:7133
-18          BMK MPEX No Tuner
-19          Compro VideoMate TV                                     185b:c100
-20          Matrox CronosPlus                                       102B:48d0
-21          10MOONS PCI TV CAPTURE CARD                             1131:2001
-22          AverMedia M156 / Medion 2819                            1461:a70b
-23          BMK MPEX Tuner
-24          KNC One TV-Station DVR                                  1894:a006
-25          ASUS TV-FM 7133                                         1043:4843
-26          Pinnacle PCTV Stereo (saa7134)                          11bd:002b
-27          Manli MuchTV M-TV002
-28          Manli MuchTV M-TV001
-29          Nagase Sangyo TransGear 3000TV                          1461:050c
-30          Elitegroup ECS TVP3XP FM1216 Tuner Card(PAL-BG,FM)      1019:4cb4
-31          Elitegroup ECS TVP3XP FM1236 Tuner Card (NTSC,FM)       1019:4cb5
-32          AVACS SmartTV
-33          AVerMedia DVD EZMaker                                   1461:10ff
-34          Noval Prime TV 7133
-35          AverMedia AverTV Studio 305                             1461:2115
-36          UPMOST PURPLE TV                                        12ab:0800
-37          Items MuchTV Plus / IT-005
-38          Terratec Cinergy 200 TV                                 153b:1152
-39          LifeView FlyTV Platinum Mini                            5168:0212, 4e42:0212, 5169:1502
-40          Compro VideoMate TV PVR/FM                              185b:c100
-41          Compro VideoMate TV Gold+                               185b:c100
-42          Sabrent SBT-TVFM (saa7130)
-43          :Zolid Xpert TV7134
-44          Empire PCI TV-Radio LE
-45          Avermedia AVerTV Studio 307                             1461:9715
-46          AVerMedia Cardbus TV/Radio (E500)                       1461:d6ee
-47          Terratec Cinergy 400 mobile                             153b:1162
-48          Terratec Cinergy 600 TV MK3                             153b:1158
-49          Compro VideoMate Gold+ Pal                              185b:c200
-50          Pinnacle PCTV 300i DVB-T + PAL                          11bd:002d
-51          ProVideo PV952                                          1540:9524
-52          AverMedia AverTV/305                                    1461:2108
-53          ASUS TV-FM 7135                                         1043:4845
-54          LifeView FlyTV Platinum FM / Gold                       5168:0214, 5168:5214, 1489:0214, 5168:0304
-55          LifeView FlyDVB-T DUO / MSI TV@nywhere Duo              5168:0306, 4E42:0306
-56          Avermedia AVerTV 307                                    1461:a70a
-57          Avermedia AVerTV GO 007 FM                              1461:f31f
-58          ADS Tech Instant TV (saa7135)                           1421:0350, 1421:0351, 1421:0370, 1421:1370
-59          Kworld/Tevion V-Stream Xpert TV PVR7134
-60          LifeView/Typhoon/Genius FlyDVB-T Duo Cardbus            5168:0502, 4e42:0502, 1489:0502
-61          Philips TOUGH DVB-T reference design                    1131:2004
-62          Compro VideoMate TV Gold+II
-63          Kworld Xpert TV PVR7134
-64          FlyTV mini Asus Digimatrix                              1043:0210
-65          V-Stream Studio TV Terminator
-66          Yuan TUN-900 (saa7135)
-67          Beholder BeholdTV 409 FM                                0000:4091
-68          GoTView 7135 PCI                                        5456:7135
-69          Philips EUROPA V3 reference design                      1131:2004
-70          Compro Videomate DVB-T300                               185b:c900
-71          Compro Videomate DVB-T200                               185b:c901
-72          RTD Embedded Technologies VFG7350                       1435:7350
-73          RTD Embedded Technologies VFG7330                       1435:7330
-74          LifeView FlyTV Platinum Mini2                           14c0:1212
-75          AVerMedia AVerTVHD MCE A180                             1461:1044
-76          SKNet MonsterTV Mobile                                  1131:4ee9
-77          Pinnacle PCTV 40i/50i/110i (saa7133)                    11bd:002e
-78          ASUSTeK P7131 Dual                                      1043:4862
-79          Sedna/MuchTV PC TV Cardbus TV/Radio (ITO25 Rev:2B)
-80          ASUS Digimatrix TV                                      1043:0210
-81          Philips Tiger reference design                          1131:2018
-82          MSI TV@Anywhere plus                                    1462:6231, 1462:8624
-83          Terratec Cinergy 250 PCI TV                             153b:1160
-84          LifeView FlyDVB Trio                                    5168:0319
-85          AverTV DVB-T 777                                        1461:2c05, 1461:2c05
-86          LifeView FlyDVB-T / Genius VideoWonder DVB-T            5168:0301, 1489:0301
-87          ADS Instant TV Duo Cardbus PTV331                       0331:1421
-88          Tevion/KWorld DVB-T 220RF                               17de:7201
-89          ELSA EX-VISION 700TV                                    1048:226c
-90          Kworld ATSC110/115                                      17de:7350, 17de:7352
-91          AVerMedia A169 B                                        1461:7360
-92          AVerMedia A169 B1                                       1461:6360
-93          Medion 7134 Bridge #2                                   16be:0005
-94          LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB 5168:3306, 5168:3502, 5168:3307, 4e42:3502
-95          LifeView FlyVIDEO3000 (NTSC)                            5169:0138
-96          Medion Md8800 Quadro                                    16be:0007, 16be:0008, 16be:000d
-97          LifeView FlyDVB-S /Acorp TV134DS                        5168:0300, 4e42:0300
-98          Proteus Pro 2309                                        0919:2003
-99          AVerMedia TV Hybrid A16AR                               1461:2c00
-100         Asus Europa2 OEM                                        1043:4860
-101         Pinnacle PCTV 310i                                      11bd:002f
-102         Avermedia AVerTV Studio 507                             1461:9715
-103         Compro Videomate DVB-T200A
-104         Hauppauge WinTV-HVR1110 DVB-T/Hybrid                    0070:6700, 0070:6701, 0070:6702, 0070:6703, 0070:6704, 0070:6705
-105         Terratec Cinergy HT PCMCIA                              153b:1172
-106         Encore ENLTV                                            1131:2342, 1131:2341, 3016:2344
-107         Encore ENLTV-FM                                         1131:230f
-108         Terratec Cinergy HT PCI                                 153b:1175
-109         Philips Tiger - S Reference design
-110         Avermedia M102                                          1461:f31e
-111         ASUS P7131 4871                                         1043:4871
-112         ASUSTeK P7131 Hybrid                                    1043:4876
-113         Elitegroup ECS TVP3XP FM1246 Tuner Card (PAL,FM)        1019:4cb6
-114         KWorld DVB-T 210                                        17de:7250
-115         Sabrent PCMCIA TV-PCB05                                 0919:2003
-116         10MOONS TM300 TV Card                                   1131:2304
-117         Avermedia Super 007                                     1461:f01d
-118         Beholder BeholdTV 401                                   0000:4016
-119         Beholder BeholdTV 403                                   0000:4036
-120         Beholder BeholdTV 403 FM                                0000:4037
-121         Beholder BeholdTV 405                                   0000:4050
-122         Beholder BeholdTV 405 FM                                0000:4051
-123         Beholder BeholdTV 407                                   0000:4070
-124         Beholder BeholdTV 407 FM                                0000:4071
-125         Beholder BeholdTV 409                                   0000:4090
-126         Beholder BeholdTV 505 FM                                5ace:5050
-127         Beholder BeholdTV 507 FM / BeholdTV 509 FM              5ace:5070, 5ace:5090
-128         Beholder BeholdTV Columbus TV/FM                        0000:5201
-129         Beholder BeholdTV 607 FM                                5ace:6070
-130         Beholder BeholdTV M6                                    5ace:6190
-131         Twinhan Hybrid DTV-DVB 3056 PCI                         1822:0022
-132         Genius TVGO AM11MCE
-133         NXP Snake DVB-S reference design
-134         Medion/Creatix CTX953 Hybrid                            16be:0010
-135         MSI TV@nywhere A/D v1.1                                 1462:8625
-136         AVerMedia Cardbus TV/Radio (E506R)                      1461:f436
-137         AVerMedia Hybrid TV/Radio (A16D)                        1461:f936
-138         Avermedia M115                                          1461:a836
-139         Compro VideoMate T750                                   185b:c900
-140         Avermedia DVB-S Pro A700                                1461:a7a1
-141         Avermedia DVB-S Hybrid+FM A700                          1461:a7a2
-142         Beholder BeholdTV H6                                    5ace:6290
-143         Beholder BeholdTV M63                                   5ace:6191
-144         Beholder BeholdTV M6 Extra                              5ace:6193
-145         AVerMedia MiniPCI DVB-T Hybrid M103                     1461:f636, 1461:f736
-146         ASUSTeK P7131 Analog
-147         Asus Tiger 3in1                                         1043:4878
-148         Encore ENLTV-FM v5.3                                    1a7f:2008
-149         Avermedia PCI pure analog (M135A)                       1461:f11d
-150         Zogis Real Angel 220
-151         ADS Tech Instant HDTV                                   1421:0380
-152         Asus Tiger Rev:1.00                                     1043:4857
-153         Kworld Plus TV Analog Lite PCI                          17de:7128
-154         Avermedia AVerTV GO 007 FM Plus                         1461:f31d
-155         Hauppauge WinTV-HVR1150 ATSC/QAM-Hybrid                 0070:6706, 0070:6708
-156         Hauppauge WinTV-HVR1120 DVB-T/Hybrid                    0070:6707, 0070:6709, 0070:670a
-157         Avermedia AVerTV Studio 507UA                           1461:a11b
-158         AVerMedia Cardbus TV/Radio (E501R)                      1461:b7e9
-159         Beholder BeholdTV 505 RDS                               0000:505B
-160         Beholder BeholdTV 507 RDS                               0000:5071
-161         Beholder BeholdTV 507 RDS                               0000:507B
-162         Beholder BeholdTV 607 FM                                5ace:6071
-163         Beholder BeholdTV 609 FM                                5ace:6090
-164         Beholder BeholdTV 609 FM                                5ace:6091
-165         Beholder BeholdTV 607 RDS                               5ace:6072
-166         Beholder BeholdTV 607 RDS                               5ace:6073
-167         Beholder BeholdTV 609 RDS                               5ace:6092
-168         Beholder BeholdTV 609 RDS                               5ace:6093
-169         Compro VideoMate S350/S300                              185b:c900
-170         AverMedia AverTV Studio 505                             1461:a115
-171         Beholder BeholdTV X7                                    5ace:7595
-172         RoverMedia TV Link Pro FM                               19d1:0138
-173         Zolid Hybrid TV Tuner PCI                               1131:2004
-174         Asus Europa Hybrid OEM                                  1043:4847
-175         Leadtek Winfast DTV1000S                                107d:6655
-176         Beholder BeholdTV 505 RDS                               0000:5051
-177         Hawell HW-404M7
-178         Beholder BeholdTV H7                                    5ace:7190
-179         Beholder BeholdTV A7                                    5ace:7090
-180         Avermedia PCI M733A                                     1461:4155, 1461:4255
-181         TechoTrend TT-budget T-3000                             13c2:2804
-182         Kworld PCI SBTVD/ISDB-T Full-Seg Hybrid                 17de:b136
-183         Compro VideoMate Vista M1F                              185b:c900
-184         Encore ENLTV-FM 3                                       1a7f:2108
-185         MagicPro ProHDTV Pro2 DMB-TH/Hybrid                     17de:d136
-186         Beholder BeholdTV 501                                   5ace:5010
-187         Beholder BeholdTV 503 FM                                5ace:5030
-188         Sensoray 811/911                                        6000:0811, 6000:0911
-189         Kworld PC150-U                                          17de:a134
-190         Asus My Cinema PS3-100                                  1043:48cd
-191         Hawell HW-9004V1
-192         AverMedia AverTV Satellite Hybrid+FM A706               1461:2055
-193         WIS Voyager or compatible                               1905:7007
-194         AverMedia AverTV/505                                    1461:a10a
-195         Leadtek Winfast TV2100 FM                               107d:6f3a
-196         SnaZio* TVPVR PRO                                       1779:13cf
-=========== ======================================================= ================================================================
+.. kernel-cmd:: saa7134-cardlist.pl $srctree/drivers/media/pci/saa7134/saa7134.h $srctree/drivers/media/pci/saa7134/saa7134-cards.c
diff --git a/Documentation/media/v4l-drivers/saa7164-cardlist.rst b/Documentation/media/v4l-drivers/saa7164-cardlist.rst
index 7d17d38df3bc..012c60358e91 100644
--- a/Documentation/media/v4l-drivers/saa7164-cardlist.rst
+++ b/Documentation/media/v4l-drivers/saa7164-cardlist.rst
@@ -1,21 +1 @@
-SAA7164 cards list
-==================
-
-=========== ==================================== ====================
-Card number Card name                            PCI IDs
-=========== ==================================== ====================
-0           Unknown
-1           Generic Rev2
-2           Generic Rev3
-3           Hauppauge WinTV-HVR2250              0070:8880, 0070:8810
-4           Hauppauge WinTV-HVR2200              0070:8980
-5           Hauppauge WinTV-HVR2200              0070:8900
-6           Hauppauge WinTV-HVR2200              0070:8901
-7           Hauppauge WinTV-HVR2250              0070:8891, 0070:8851
-8           Hauppauge WinTV-HVR2250              0070:88A1
-9           Hauppauge WinTV-HVR2200              0070:8940
-10          Hauppauge WinTV-HVR2200              0070:8953
-11          Hauppauge WinTV-HVR2255(proto)       0070:f111
-12          Hauppauge WinTV-HVR2255              0070:f111
-13          Hauppauge WinTV-HVR2205              0070:f123, 0070:f120
-=========== ==================================== ====================
+.. kernel-cmd:: saa7164-cardlist.pl $srctree/drivers/media/pci/saa7164/saa7164.h    $srctree/drivers/media/pci/saa7164/saa7164-cards.c
diff --git a/Documentation/media/v4l-drivers/tm6000-cardlist.rst b/Documentation/media/v4l-drivers/tm6000-cardlist.rst
index ae2952683ccf..58af44eecc0d 100644
--- a/Documentation/media/v4l-drivers/tm6000-cardlist.rst
+++ b/Documentation/media/v4l-drivers/tm6000-cardlist.rst
@@ -1,24 +1 @@
-TM6000 cards list
-=================
-
-=========== ================================================= ==========================================
-Card number Card name                                         USB IDs
-=========== ================================================= ==========================================
-0           Unknown tm6000 video grabber
-1           Generic tm5600 board                              6000:0001
-2           Generic tm6000 board
-3           Generic tm6010 board                              6000:0002
-4           10Moons UT 821
-5           10Moons UT 330
-6           ADSTECH Dual TV USB                               06e1:f332
-7           Freecom Hybrid Stick / Moka DVB-T Receiver Dual   14aa:0620
-8           ADSTECH Mini Dual TV USB                          06e1:b339
-9           Hauppauge WinTV HVR-900H / WinTV USB2-Stick       2040:6600, 2040:6601, 2040:6610, 2040:6611
-10          Beholder Wander DVB-T/TV/FM USB2.0                6000:dec0
-11          Beholder Voyager TV/FM USB2.0                     6000:dec1
-12          Terratec Cinergy Hybrid XE / Cinergy Hybrid-Stick 0ccd:0086, 0ccd:00A5
-13          Twinhan TU501(704D1)                              13d3:3240, 13d3:3241, 13d3:3243, 13d3:3264
-14          Beholder Wander Lite DVB-T/TV/FM USB2.0           6000:dec2
-15          Beholder Voyager Lite TV/FM USB2.0                6000:dec3
-16          Terratec Grabster AV 150/250 MX                   0ccd:0079
-=========== ================================================= ==========================================
+.. kernel-cmd:: tm6000-cardlist.pl $srctree/drivers/media/usb/tm6000/tm6000-cards.c
diff --git a/Documentation/media/v4l-drivers/tuner-cardlist.rst b/Documentation/media/v4l-drivers/tuner-cardlist.rst
index 276dd90e0c59..b2a04dc396d5 100644
--- a/Documentation/media/v4l-drivers/tuner-cardlist.rst
+++ b/Documentation/media/v4l-drivers/tuner-cardlist.rst
@@ -1,98 +1 @@
-Tuner cards list
-================
-
-============ =====================================================
-Tuner number Card name
-============ =====================================================
-0            Temic PAL (4002 FH5)
-1            Philips PAL_I (FI1246 and compatibles)
-2            Philips NTSC (FI1236,FM1236 and compatibles)
-3            Philips (SECAM+PAL_BG) (FI1216MF, FM1216MF, FR1216MF)
-4            NoTuner
-5            Philips PAL_BG (FI1216 and compatibles)
-6            Temic NTSC (4032 FY5)
-7            Temic PAL_I (4062 FY5)
-8            Temic NTSC (4036 FY5)
-9            Alps HSBH1
-10           Alps TSBE1
-11           Alps TSBB5
-12           Alps TSBE5
-13           Alps TSBC5
-14           Temic PAL_BG (4006FH5)
-15           Alps TSCH6
-16           Temic PAL_DK (4016 FY5)
-17           Philips NTSC_M (MK2)
-18           Temic PAL_I (4066 FY5)
-19           Temic PAL* auto (4006 FN5)
-20           Temic PAL_BG (4009 FR5) or PAL_I (4069 FR5)
-21           Temic NTSC (4039 FR5)
-22           Temic PAL/SECAM multi (4046 FM5)
-23           Philips PAL_DK (FI1256 and compatibles)
-24           Philips PAL/SECAM multi (FQ1216ME)
-25           LG PAL_I+FM (TAPC-I001D)
-26           LG PAL_I (TAPC-I701D)
-27           LG NTSC+FM (TPI8NSR01F)
-28           LG PAL_BG+FM (TPI8PSB01D)
-29           LG PAL_BG (TPI8PSB11D)
-30           Temic PAL* auto + FM (4009 FN5)
-31           SHARP NTSC_JP (2U5JF5540)
-32           Samsung PAL TCPM9091PD27
-33           MT20xx universal
-34           Temic PAL_BG (4106 FH5)
-35           Temic PAL_DK/SECAM_L (4012 FY5)
-36           Temic NTSC (4136 FY5)
-37           LG PAL (newer TAPC series)
-38           Philips PAL/SECAM multi (FM1216ME MK3)
-39           LG NTSC (newer TAPC series)
-40           HITACHI V7-J180AT
-41           Philips PAL_MK (FI1216 MK)
-42           Philips FCV1236D ATSC/NTSC dual in
-43           Philips NTSC MK3 (FM1236MK3 or FM1236/F)
-44           Philips 4 in 1 (ATI TV Wonder Pro/Conexant)
-45           Microtune 4049 FM5
-46           Panasonic VP27s/ENGE4324D
-47           LG NTSC (TAPE series)
-48           Tenna TNF 8831 BGFF)
-49           Microtune 4042 FI5 ATSC/NTSC dual in
-50           TCL 2002N
-51           Philips PAL/SECAM_D (FM 1256 I-H3)
-52           Thomson DTT 7610 (ATSC/NTSC)
-53           Philips FQ1286
-54           Philips/NXP TDA 8290/8295 + 8275/8275A/18271
-55           TCL 2002MB
-56           Philips PAL/SECAM multi (FQ1216AME MK4)
-57           Philips FQ1236A MK4
-58           Ymec TVision TVF-8531MF/8831MF/8731MF
-59           Ymec TVision TVF-5533MF
-60           Thomson DTT 761X (ATSC/NTSC)
-61           Tena TNF9533-D/IF/TNF9533-B/DF
-62           Philips TEA5767HN FM Radio
-63           Philips FMD1216ME MK3 Hybrid Tuner
-64           LG TDVS-H06xF
-65           Ymec TVF66T5-B/DFF
-66           LG TALN series
-67           Philips TD1316 Hybrid Tuner
-68           Philips TUV1236D ATSC/NTSC dual in
-69           Tena TNF 5335 and similar models
-70           Samsung TCPN 2121P30A
-71           Xceive xc2028/xc3028 tuner
-72           Thomson FE6600
-73           Samsung TCPG 6121P30A
-75           Philips TEA5761 FM Radio
-76           Xceive 5000 tuner
-77           TCL tuner MF02GIP-5N-E
-78           Philips FMD1216MEX MK3 Hybrid Tuner
-79           Philips PAL/SECAM multi (FM1216 MK5)
-80           Philips FQ1216LME MK3 PAL/SECAM w/active loopthrough
-81           Partsnic (Daewoo) PTI-5NF05
-82           Philips CU1216L
-83           NXP TDA18271
-84           Sony BTF-Pxn01Z
-85           Philips FQ1236 MK5
-86           Tena TNF5337 MFD
-87           Xceive 4000 tuner
-88           Xceive 5000C tuner
-89           Sony BTF-PG472Z PAL/SECAM
-90           Sony BTF-PK467Z NTSC-M-JP
-91           Sony BTF-PB463Z NTSC-M
-============ =====================================================
+.. kernel-cmd:: tuner-cardlist.pl $srctree/include/media/tuner.h $srctree/drivers/media/tuners/tuner-types.c
diff --git a/Documentation/media/v4l-drivers/usbvision-cardlist.rst b/Documentation/media/v4l-drivers/usbvision-cardlist.rst
index 44d53dff0984..014496c6b435 100644
--- a/Documentation/media/v4l-drivers/usbvision-cardlist.rst
+++ b/Documentation/media/v4l-drivers/usbvision-cardlist.rst
@@ -1,74 +1 @@
-USBvision cards list
-====================
-
-=========== ======================================================== =========
-Card number Card name                                                USB IDs
-=========== ======================================================== =========
-0           Xanboo                                                   0a6f:0400
-1           Belkin USB VideoBus II Adapter                           050d:0106
-2           Belkin Components USB VideoBus                           050d:0207
-3           Belkin USB VideoBus II                                   050d:0208
-4           echoFX InterView Lite                                    0571:0002
-5           USBGear USBG-V1 resp. HAMA USB                           0573:0003
-6           D-Link V100                                              0573:0400
-7           X10 USB Camera                                           0573:2000
-8           Hauppauge WinTV USB Live (PAL B/G)                       0573:2d00
-9           Hauppauge WinTV USB Live Pro (NTSC M/N)                  0573:2d01
-10          Zoran Co. PMD (Nogatech) AV-grabber Manhattan            0573:2101
-11          Nogatech USB-TV (NTSC) FM                                0573:4100
-12          PNY USB-TV (NTSC) FM                                     0573:4110
-13          PixelView PlayTv-USB PRO (PAL) FM                        0573:4450
-14          ZTV ZT-721 2.4GHz USB A/V Receiver                       0573:4550
-15          Hauppauge WinTV USB (NTSC M/N)                           0573:4d00
-16          Hauppauge WinTV USB (PAL B/G)                            0573:4d01
-17          Hauppauge WinTV USB (PAL I)                              0573:4d02
-18          Hauppauge WinTV USB (PAL/SECAM L)                        0573:4d03
-19          Hauppauge WinTV USB (PAL D/K)                            0573:4d04
-20          Hauppauge WinTV USB (NTSC FM)                            0573:4d10
-21          Hauppauge WinTV USB (PAL B/G FM)                         0573:4d11
-22          Hauppauge WinTV USB (PAL I FM)                           0573:4d12
-23          Hauppauge WinTV USB (PAL D/K FM)                         0573:4d14
-24          Hauppauge WinTV USB Pro (NTSC M/N)                       0573:4d2a
-25          Hauppauge WinTV USB Pro (NTSC M/N) V2                    0573:4d2b
-26          Hauppauge WinTV USB Pro (PAL/SECAM B/G/I/D/K/L)          0573:4d2c
-27          Hauppauge WinTV USB Pro (NTSC M/N) V3                    0573:4d20
-28          Hauppauge WinTV USB Pro (PAL B/G)                        0573:4d21
-29          Hauppauge WinTV USB Pro (PAL I)                          0573:4d22
-30          Hauppauge WinTV USB Pro (PAL/SECAM L)                    0573:4d23
-31          Hauppauge WinTV USB Pro (PAL D/K)                        0573:4d24
-32          Hauppauge WinTV USB Pro (PAL/SECAM BGDK/I/L)             0573:4d25
-33          Hauppauge WinTV USB Pro (PAL/SECAM BGDK/I/L) V2          0573:4d26
-34          Hauppauge WinTV USB Pro (PAL B/G) V2                     0573:4d27
-35          Hauppauge WinTV USB Pro (PAL B/G,D/K)                    0573:4d28
-36          Hauppauge WinTV USB Pro (PAL I,D/K)                      0573:4d29
-37          Hauppauge WinTV USB Pro (NTSC M/N FM)                    0573:4d30
-38          Hauppauge WinTV USB Pro (PAL B/G FM)                     0573:4d31
-39          Hauppauge WinTV USB Pro (PAL I FM)                       0573:4d32
-40          Hauppauge WinTV USB Pro (PAL D/K FM)                     0573:4d34
-41          Hauppauge WinTV USB Pro (Temic PAL/SECAM B/G/I/D/K/L FM) 0573:4d35
-42          Hauppauge WinTV USB Pro (Temic PAL B/G FM)               0573:4d36
-43          Hauppauge WinTV USB Pro (PAL/SECAM B/G/I/D/K/L FM)       0573:4d37
-44          Hauppauge WinTV USB Pro (NTSC M/N FM) V2                 0573:4d38
-45          Camtel Technology USB TV Genie Pro FM Model TVB330       0768:0006
-46          Digital Video Creator I                                  07d0:0001
-47          Global Village GV-007 (NTSC)                             07d0:0002
-48          Dazzle Fusion Model DVC-50 Rev 1 (NTSC)                  07d0:0003
-49          Dazzle Fusion Model DVC-80 Rev 1 (PAL)                   07d0:0004
-50          Dazzle Fusion Model DVC-90 Rev 1 (SECAM)                 07d0:0005
-51          Eskape Labs MyTV2Go                                      07f8:9104
-52          Pinnacle Studio PCTV USB (PAL)                           2304:010d
-53          Pinnacle Studio PCTV USB (SECAM)                         2304:0109
-54          Pinnacle Studio PCTV USB (PAL) FM                        2304:0110
-55          Miro PCTV USB                                            2304:0111
-56          Pinnacle Studio PCTV USB (NTSC) FM                       2304:0112
-57          Pinnacle Studio PCTV USB (PAL) FM V2                     2304:0210
-58          Pinnacle Studio PCTV USB (NTSC) FM V2                    2304:0212
-59          Pinnacle Studio PCTV USB (PAL) FM V3                     2304:0214
-60          Pinnacle Studio Linx Video input cable (NTSC)            2304:0300
-61          Pinnacle Studio Linx Video input cable (PAL)             2304:0301
-62          Pinnacle PCTV Bungee USB (PAL) FM                        2304:0419
-63          Hauppauge WinTv-USB                                      2400:4200
-64          Pinnacle Studio PCTV USB (NTSC) FM V3                    2304:0113
-65          Nogatech USB MicroCam NTSC (NV3000N)                     0573:3000
-66          Nogatech USB MicroCam PAL (NV3001P)                      0573:3001
-=========== ======================================================== =========
+.. kernel-cmd:: usbvision-cardlist.pl $srctree/drivers/media/usb/usbvision/usbvision-cards.h $srctree/drivers/media/usb/usbvision/usbvision-cards.c
diff --git a/Documentation/sphinx/au0828-cardlist.pl b/Documentation/sphinx/au0828-cardlist.pl
new file mode 100755
index 000000000000..5425a7af3f5b
--- /dev/null
+++ b/Documentation/sphinx/au0828-cardlist.pl
@@ -0,0 +1,66 @@
+#!/usr/bin/perl -w
+use strict;
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(AU08[\d]._BOARD_\w+)\s+(\d+)/) {
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# au0828_boards
+	if (/\[(AU0828_BOARD_\w+)\]/) {
+		$id = $1;
+		$data{$id}->{id} = $id;
+		$data{$id}->{type} = "(au0828)";
+	};
+
+	next unless defined($id);
+
+	if (/USB_DEVICE.*0x([0-9a-fA-F]*).*0x([0-9a-fA-F]*)/ ) {
+		$subvendor=$1;
+		$subdevice=$2;
+	}
+
+	if (/.*driver_info.*(AU08[\d]._BOARD_\w+)/ ) {
+		my $name = "$subvendor:$subdevice";
+		if ($data{$1}->{subid}) {
+			$data{$1}->{subid} .= ", " . $name;
+		} else {
+			$data{$1}->{subid} = $name;
+		}
+		$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+	}
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		if (/\.name\s*=\s*\"([^\"]+)\"/) {
+			$data{$id}->{name} = $1;
+			$len = length($1) if (length($1) > $len);
+		}
+	}
+}
+
+print "AU0828 cards list\n";
+print "=================\n\n";
+
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "USB IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/bttv-cardlist.pl b/Documentation/sphinx/bttv-cardlist.pl
new file mode 100755
index 000000000000..fc6056042fe7
--- /dev/null
+++ b/Documentation/sphinx/bttv-cardlist.pl
@@ -0,0 +1,75 @@
+#!/usr/bin/perl -w
+use strict;
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+my $pciid = 0;
+
+while (<>) {
+	# defines in header file
+        if (/#define\s+(BTTV_BOARD_\w+)\s+0x([0-9a-fA-F]*).*/) {
+		$data{$1}->{nr} = hex $2;
+
+		next;
+	}
+	# cx88_boards
+	if (/\[(BTTV_BOARD_\w+)\]/) {
+		$id = $1;
+		$data{$id}->{id} = $id;
+#		$data{$id}->{nr} = $nr++;
+	};
+	if (/0x([0-9a-fA-F]...)([0-9a-fA-F]...)/) {
+		$subvendor = $2;
+		$subdevice = $1;
+		if (/(BTTV_BOARD_\w+)/) {
+			my $name = "$subvendor:$subdevice";
+			if ($data{$1}->{subid}) {
+				$data{$1}->{subid} .= ", " . $name;
+			} else {
+				$data{$1}->{subid} = $name;
+			}
+			$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+
+			undef $subvendor;
+			undef $subdevice;
+		}
+	}
+
+	next unless defined($id);
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		if (/\.name\s*=\s*\"([^\"]+)\"/) {
+			$data{$id}->{name} = $1;
+			$len = length($1) if (length($1) > $len);
+		}
+	}
+
+	if (/0x([0-9]...)([0-9]...)/) {
+		$subvendor = $1;
+		$subdevice = $2;
+	}
+
+}
+
+print "BTTV cards list\n";
+print "===============\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "PCI IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/cx23885-cardlist.pl b/Documentation/sphinx/cx23885-cardlist.pl
new file mode 100755
index 000000000000..7de92cdb4643
--- /dev/null
+++ b/Documentation/sphinx/cx23885-cardlist.pl
@@ -0,0 +1,79 @@
+#!/usr/bin/perl -w
+use strict;
+
+my %map = (
+	   "PCI_ANY_ID"            => "0",
+);
+
+sub fix_id($) {
+	my $id = shift;
+	$id = $map{$id} if defined($map{$id});
+	$id =~ s/^0x//;
+	return $id;
+}
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(CX23885_BOARD_\w+)\s+(\d+)/) {
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# cx88_boards
+	if (/\[(CX23885_BOARD_\w+)\]/) {
+		$id = $1;
+		$data{$id}->{id} = $id;
+#		$data{$id}->{nr} = $nr++;
+	};
+	next unless defined($id);
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		if (/\.name\s*=\s*\"([^\"]+)\"/) {
+			$data{$id}->{name} = $1;
+			$len = length($1) if (length($1) > $len);
+		}
+	}
+
+	# cx88_pci_tbl
+	$subvendor = fix_id($1) if (/\.subvendor\s*=\s*(\w+),/);
+	$subdevice = fix_id($1) if (/\.subdevice\s*=\s*(\w+),/);
+	if (/.card\s*=\s*(\w+),/) {
+		if (defined($data{$1})  &&
+		    defined($subvendor) && $subvendor ne "0" &&
+		    defined($subdevice) && $subdevice ne "0") {
+			my $name = "$subvendor:$subdevice";
+			if ($data{$1}->{subid}) {
+				$data{$1}->{subid} .= ", " . $name;
+			} else {
+				$data{$1}->{subid} = $name;
+			}
+			$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+			undef $subvendor;
+			undef $subdevice;
+		}
+	}
+}
+
+print "cx23885 cards list\n";
+print "==================\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "PCI IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/cx88-cardlist.pl b/Documentation/sphinx/cx88-cardlist.pl
new file mode 100755
index 000000000000..e66a71840777
--- /dev/null
+++ b/Documentation/sphinx/cx88-cardlist.pl
@@ -0,0 +1,78 @@
+#!/usr/bin/perl -w
+use strict;
+
+my %map = (
+	   "PCI_ANY_ID"            => "0",
+	   "PCI_VENDOR_ID_PHILIPS" => "1131",
+	   "PCI_VENDOR_ID_ASUSTEK" => "1043",
+	   "PCI_VENDOR_ID_MATROX"  => "102B",
+	   "PCI_VENDOR_ID_ATI"     => "1002",
+);
+
+sub fix_id($) {
+	my $id = shift;
+	$id = $map{$id} if defined($map{$id});
+	$id =~ s/^0x//;
+	return $id;
+}
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(CX88_BOARD_\w+)\s+(\d+)/) {
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# cx88_boards
+	if (/\[(CX88_BOARD_\w+)\]/) {
+		$id = $1;
+		$data{$id}->{id} = $id;
+	};
+	next unless defined($id);
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		$data{$id}->{name} = $1 if (/\.name\s*=\s*\"([^\"]+)\"/);
+		$len = length($1) if (length($1) > $len);
+	}
+
+	# cx88_pci_tbl
+	$subvendor = fix_id($1) if (/\.subvendor\s*=\s*(\w+),/);
+	$subdevice = fix_id($1) if (/\.subdevice\s*=\s*(\w+),/);
+	if (/.card\s*=\s*(\w+),/) {
+		if (defined($data{$1})  &&
+		    defined($subvendor) && $subvendor ne "0" &&
+		    defined($subdevice) && $subdevice ne "0") {
+			my $name = "$subvendor:$subdevice";
+			if ($data{$1}->{subid}) {
+				$data{$1}->{subid} .= ", " . $name;
+			} else {
+				$data{$1}->{subid} = $name;
+			}
+			$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+		}
+	}
+}
+
+print "CX88 cards list\n";
+print "===============\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "PCI IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/em28xx-cardlist.pl b/Documentation/sphinx/em28xx-cardlist.pl
new file mode 100755
index 000000000000..d8ebacc443ab
--- /dev/null
+++ b/Documentation/sphinx/em28xx-cardlist.pl
@@ -0,0 +1,84 @@
+#!/usr/bin/perl -w
+use strict;
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+my $debug = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(EM2[\d]+_BOARD_[\w\d_]+)\s+(\d+)/) {
+		printf("$1 = $2\n") if ($debug);
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# em2820_boards
+	if (/\[(EM2820_BOARD_[\w\d_]+)\]/) {
+		$id = $1;
+		printf("ID = $id\n") if $debug;
+		$data{$id}->{id} = $id;
+		$data{$id}->{type} = "em2820 or em2840";
+		$data{$id}->{qtd}++;
+	} elsif (/\[(EM)(2[\d]+)(_BOARD_[\w\d_]+)\]/) {
+		$id = "$1$2$3";
+		printf("ID = $id\n") if $debug;
+		$data{$id}->{id} = $id;
+		$data{$id}->{type} = "em$2";
+		$data{$id}->{qtd}++;
+	};
+
+	next unless defined($id);
+
+	if (/USB_DEVICE.*0x([0-9a-fA-F]+)\s*\,\s*0x([0-9a-fA-F]+)/ ) {
+		$subvendor=$1;
+		$subdevice=$2;
+	}
+
+	if (/.*driver_info.*(EM2[\d]+_BOARD_[\w\d_]+)/ ) {
+		my $name = "$subvendor:$subdevice";
+		if ($data{$1}->{subid}) {
+			$data{$1}->{subid} .= ", " . $name;
+		} else {
+			$data{$1}->{subid} = $name;
+		}
+		$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+	}
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		if (/\.name\s*=\s*\"([^\"]+)\"/) {
+			$data{$id}->{name} = $1;
+			printf("name[$id] = %s\n", $data{$id}->{name}) if ($debug);
+			$len = length($1) if (length($1) > $len);
+		}
+	}
+}
+
+print "EM28xx cards list\n";
+print "=================\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x 16 . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %-16s %s\n",
+		"Card number", "Card name", "Empia Chip", "USB IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x 16 . " " . "=" x $idlen . "\n";
+
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %-16s %s\n",
+			$data{$item}->{nr}, $data{$item}->{name},
+			$data{$item}->{type}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	print $s;
+
+	printf "(%d entries)", $data{$item}->{qtd} if ($debug);
+}
+
+print "=========== " . "=" x $len . " " . "=" x 16 . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/ivtv-cardlist.pl b/Documentation/sphinx/ivtv-cardlist.pl
new file mode 100755
index 000000000000..a26284683466
--- /dev/null
+++ b/Documentation/sphinx/ivtv-cardlist.pl
@@ -0,0 +1,133 @@
+#!/usr/bin/perl -w
+use strict;
+
+my $debug = 0;
+
+my %map = (
+	"PCI_DEVICE_ID_IVTV15"	=> "0803",
+	"PCI_DEVICE_ID_IVTV16"	=> "0016",
+	"PCI_ANY_ID"            => "0",
+);
+
+sub fix_id($) {
+	my $id = shift;
+	if (defined($map{$id})) {
+		$id = $map{$id};
+	} else {
+		$id = sprintf "%04x", hex($id);
+	}
+	return $id;
+}
+
+my $new_entry = -1;
+my $nr = -1;
+my ($id,$pci);
+my %data;
+my %number;
+my %pci_map;
+my $len = 0;
+my $idlen = 0;
+
+my $last;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(IVTV_CARD_[\w\d\_]+)\s+(\d+)/) {
+		my $c = $1;
+		my $n = $2;
+		if (/IVTV_CARD_LAST/) {
+			printf("$c = $n\n") if ($debug);
+			$last = $n;
+			next;
+		};
+		next if (/IVTV_CARD_INPUT_/);
+		next if (/IVTV_CARD_MAX_/);
+		$number{$c} = $n;
+		printf("$c = $n\n") if ($debug);
+		next;
+	}
+
+	if (/#define\s+(IVTV_CARD_[\w\d\_]+)\s+.*IVTV_CARD_LAST\s*\+\s*(\d+)/) {
+		$number{$1} = $2 + $last;
+		printf("$1 = %d\n", $number{$1}) if ($debug);
+		next;
+	}
+	if (/#define\s+(IVTV_PCI_ID_\w+)\s+0x([\w\d]+)/) {
+		$map{$1} = $2;
+		printf("$1 = $2\n") if ($debug);
+		next;
+	}
+	#  ivtv-cards
+	if (m/static const struct ivtv_card\s+([\w\d_]+)/) {
+		$id = $1;
+	}
+
+	if (m/static const struct ivtv_card_pci_info\s+([\w\d_]+)/) {
+		$pci = $1;
+	}
+
+	if (defined($id)) {
+		if (m/^\};$/) {
+			undef $id;
+			next;
+		}
+
+		if (/.type\s*=\s*(IVTV_CARD_\w+)/) {
+			$nr = $number{$1};
+			printf("ID#$nr: $id\n") if ($debug);
+			$data{$id}->{nr} = $nr;
+		};
+
+		if (/\.name\s*=\s*\"([^\"]+)\"/) {
+			printf("ID#$nr: $id, name $1\n") if ($debug);
+			$data{$id}->{id} = $id;
+			$data{$id}->{name} = $1;
+			$len = length($1) if (length($1) > $len);
+		}
+
+		if (/\.pci_list\s*=\s*([\w\d_]+)/) {
+			$data{$id}->{pci} = $1;
+			printf("pci map for $id: $1\n") if ($debug);
+		}
+	}
+
+	if (defined ($pci)) {
+		if (m/PCI_DEVICE_ID_(\S+)\s*\,\s*(\S+)\s*\,\s*0x(\S+)/) {
+			my $ivtv = $1;
+			my $vend = fix_id($2);
+			my $sub = fix_id($3);
+			my $name = "$ivtv $vend:$sub";
+			printf "pci map: $pci, PCI ID %name\n", if ($debug);
+			if (defined($pci_map{$pci})) {
+				$pci_map{$pci} .= ", " . $name;
+			} else {
+				$pci_map{$pci} = $name;
+			}
+			$idlen = length($pci_map{$pci}) if (length($pci_map{$pci}) > $idlen);
+		}
+	}
+}
+
+print "IVTV cards list\n";
+print "===============\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "PCI IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	printf "ITEM: $item\n" if ($debug);
+	printf "PCI map: $pci\n" if ($debug && $pci);
+
+	$pci = $data{$item}->{pci} if defined $data{$item}->{pci};
+
+	$pci_map{$pci} = "" if (!$pci_map{$pci});
+
+	my $s = sprintf "%-11s %-${len}s %s\n",
+		$data{$item}->{nr}, $data{$item}->{name}, $pci_map{$pci};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/saa7134-cardlist.pl b/Documentation/sphinx/saa7134-cardlist.pl
new file mode 100755
index 000000000000..73d3f18dd856
--- /dev/null
+++ b/Documentation/sphinx/saa7134-cardlist.pl
@@ -0,0 +1,80 @@
+#!/usr/bin/perl -w
+use strict;
+
+my %map = (
+	   "PCI_ANY_ID"            => "0",
+	   "PCI_VENDOR_ID_PHILIPS" => "1131",
+	   "PCI_VENDOR_ID_ASUSTEK" => "1043",
+	   "PCI_VENDOR_ID_MATROX"  => "102B",
+);
+
+sub fix_id($) {
+	my $id = shift;
+	$id = $map{$id} if defined($map{$id});
+	$id =~ s/^0x//;
+	return $id;
+}
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(SAA7134_BOARD_\w+)\s+(\d+)/) {
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# saa7134_boards
+	if (/\[(SAA7134_BOARD_\w+)\]/) {
+		$id = $1;
+		$data{$id}->{id} = $id;
+#		$data{$id}->{nr} = $nr++;
+	};
+	next unless defined($id);
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		if (/\.name\s*=\s*\"([^\"]+)\"/) {
+			$data{$id}->{name} = $1;
+			$len = length($1) if (length($1) > $len);
+		}
+	}
+
+	# saa7134_pci_tbl
+	$subvendor = fix_id($1) if (/\.subvendor\s*=\s*(\w+)\s*,*/);
+	$subdevice = fix_id($1) if (/\.subdevice\s*=\s*(\w+)\s*,*/);
+	if (/.driver_data\s*=\s*(\w+)\s*,*/) {
+		if (defined($data{$1})  &&
+		    defined($subvendor) && $subvendor ne "0" &&
+		    defined($subdevice) && $subdevice ne "0") {
+			my $name = "$subvendor:$subdevice";
+			if ($data{$1}->{subid}) {
+				$data{$1}->{subid} .= ", " . $name;
+			} else {
+				$data{$1}->{subid} = $name;
+			}
+			$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+		}
+	}
+}
+
+print "SAA7134 cards list\n";
+print "==================\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "PCI IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/saa7164-cardlist.pl b/Documentation/sphinx/saa7164-cardlist.pl
new file mode 100755
index 000000000000..b7c1ea080540
--- /dev/null
+++ b/Documentation/sphinx/saa7164-cardlist.pl
@@ -0,0 +1,74 @@
+#!/usr/bin/perl -w
+use strict;
+
+my %map = (
+	   "PCI_ANY_ID"            => "0",
+);
+
+sub fix_id($) {
+	my $id = shift;
+	$id = $map{$id} if defined($map{$id});
+	$id =~ s/^0x//;
+	return $id;
+}
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(SAA7164_BOARD_\w+)\s+(\d+)/) {
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# saa7164_boards
+	if (/\[(SAA7164_BOARD_\w+)\]/) {
+		$id = $1;
+		$data{$id}->{id} = $id;
+	};
+	next unless defined($id);
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		$data{$id}->{name} = $1 if (/\.name\s*=\s*\"([^\"]+)\"/);
+		$len = length($1) if (length($1) > $len);
+	}
+
+	# saa7164_pci_tbl
+	$subvendor = fix_id($1) if (/\.subvendor\s*=\s*(\w+),/);
+	$subdevice = fix_id($1) if (/\.subdevice\s*=\s*(\w+),/);
+	if (/.card\s*=\s*(\w+),/) {
+		if (defined($data{$1})  &&
+		    defined($subvendor) && $subvendor ne "0" &&
+		    defined($subdevice) && $subdevice ne "0") {
+			my $name = "$subvendor:$subdevice";
+			if ($data{$1}->{subid}) {
+				$data{$1}->{subid} .= ", " . $name;
+			} else {
+				$data{$1}->{subid} = $name;
+			}
+			$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+		}
+	}
+}
+
+print "SAA7164 cards list\n";
+print "==================\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "PCI IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/tm6000-cardlist.pl b/Documentation/sphinx/tm6000-cardlist.pl
new file mode 100755
index 000000000000..07fc5e7557e5
--- /dev/null
+++ b/Documentation/sphinx/tm6000-cardlist.pl
@@ -0,0 +1,73 @@
+#!/usr/bin/perl -w
+use strict;
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+my $debug = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s+(TM[\d]+_BOARD_[\w\d_]+)\s+(\d+)/) {
+		printf("$1 = $2\n") if ($debug);
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# em2820_boards
+	if (/\[(TM)([\d]+)(_BOARD_[\w\d_]+)\]/) {
+		$id = "$1$2$3";
+		printf("ID = $id\n") if $debug;
+		$data{$id}->{id} = $id;
+		$data{$id}->{type} = "tm$2";
+		$data{$id}->{qtd}++;
+	};
+
+	next unless defined($id);
+
+	if (/USB_DEVICE.*0x([0-9a-fA-F]+)\s*\,\s*0x([0-9a-fA-F]+)/ ) {
+		$subvendor=$1;
+		$subdevice=$2;
+	}
+
+	if (/.*driver_info.*(TM[\d]+_BOARD_[\w\d_]+)/ ) {
+		my $name = "$subvendor:$subdevice";
+		if ($data{$1}->{subid}) {
+			$data{$1}->{subid} .= ", " . $name;
+		} else {
+			$data{$1}->{subid} = $name;
+		}
+		$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+	}
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		if (/\.name\s*=\s*\"([^\"]+)\"/) {
+			$data{$id}->{name} = $1;
+			$len = length($1) if (length($1) > $len);
+			printf("name[$id] = %s\n", $data{$id}->{name}) if ($debug);
+		}
+	}
+}
+
+print "TM6000 cards list\n";
+print "=================\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "USB IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+
+	printf "(%d entires)", $data{$item}->{qtd} if ($debug);
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
diff --git a/Documentation/sphinx/tuner-cardlist.pl b/Documentation/sphinx/tuner-cardlist.pl
new file mode 100755
index 000000000000..ff9163643dcb
--- /dev/null
+++ b/Documentation/sphinx/tuner-cardlist.pl
@@ -0,0 +1,63 @@
+#!/usr/bin/perl -w
+use strict;
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+
+my $H = shift;
+my $C = shift;
+my %blacklist;
+
+open IN, "<$H";
+while (<IN>) {
+	# defines in header file
+	if (/#define\s+(TUNER_\w+)\s+(\d+)/) {
+		my $num=$2;
+		$data{$1}->{nr} = $num;
+		if (/#define\s+TUNER_TDA9887/) {
+			$blacklist{$num}=1;
+		}
+		next;
+	}
+}
+close IN;
+
+open IN, "<$C";
+while (<IN>) {
+	# tuners
+	if (/\[(TUNER_\w+)\]/) {
+		$id = $1;
+		if ($id =~ m/TUNER_MAX/) {
+			next;
+		}
+		$data{$id}->{id} = $id;
+	};
+	next unless defined($id);
+
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		$data{$id}->{name} = $1 if (/\.name\s*=\s*\"([^\"]+)\"/);
+		$len = length($1) if (length($1) > $len);
+	}
+}
+
+print "Tuner cards list\n";
+print "================\n\n";
+
+print "============ " . "=" x $len . "\n";
+my $s = sprintf "%-12s %-${len}s\n", "Tuner number", "Card name";
+$s =~ s/[ \t]+$//;
+print $s;
+print "============ " . "=" x $len . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	if ($blacklist{$data{$item}->{nr}}) {
+		next;
+	}
+	my $s = sprintf "%-12s %-${len}s\n", $data{$item}->{nr}, $data{$item}->{name};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "============ " . "=" x $len . "\n";
diff --git a/Documentation/sphinx/usbvision-cardlist.pl b/Documentation/sphinx/usbvision-cardlist.pl
new file mode 100755
index 000000000000..c0191dc5606c
--- /dev/null
+++ b/Documentation/sphinx/usbvision-cardlist.pl
@@ -0,0 +1,65 @@
+#!/usr/bin/perl -w
+use strict;
+
+my $new_entry = -1;
+my $nr = 0;
+my ($id,$subvendor,$subdevice);
+my %data;
+my $len = 0;
+my $idlen = 0;
+
+while (<>) {
+	# defines in header file
+	if (/#define\s*(\w+)\s*(\d+)/) {
+		$data{$1}->{nr} = $2;
+		next;
+	}
+	# boards
+	if (/^\s*\[([\w\d_]+)\]\s*=\s*{/) {
+		$id = $1;
+		$data{$id}->{id} = $id;
+	};
+
+	next unless defined($id);
+
+	if (/USB_DEVICE.*0x([0-9a-fA-F]*).*0x([0-9a-fA-F]*).*/)
+	{
+		$subvendor=$1;
+		$subdevice=$2;
+	}
+	if(/driver_info\s*=\s*([\w\d_]+)/)
+	{
+		my $name = "$subvendor:$subdevice";
+		if ($data{$1}->{subid}) {
+			$data{$1}->{subid} .= ", " . $name;
+		} else {
+			$data{$1}->{subid} = $name;
+		}
+		$idlen = length($data{$1}->{subid}) if (length($data{$1}->{subid}) > $idlen);
+	}
+	if (!defined($data{$id}) || !defined($data{$id}->{name})) {
+		if (/\.model_string\s*=\s*\"([^\"]+)\"/) {
+			$data{$id}->{name} = $1;
+
+			$len = length($1) if (length($1) > $len);
+		}
+	}
+}
+
+print "USBvision cards list\n";
+print "====================\n\n";
+
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+my $s = sprintf "%-11s %-${len}s %s\n", "Card number", "Card name", "USB IDs";
+$s =~ s/[ \t]+$//;
+print $s;
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";
+
+foreach my $item (sort { $data{$a}->{nr} <=> $data{$b}->{nr} } keys %data) {
+	$data{$item}->{subid} = "" if (!defined $data{$item}->{subid});
+
+	my $s = sprintf "%-11s %-${len}s %s\n", $data{$item}->{nr}, $data{$item}->{name}, $data{$item}->{subid};
+	$s =~ s/[ \t]+$//;
+	printf $s;
+}
+print "=========== " . "=" x $len . " " . "=" x $idlen . "\n";

