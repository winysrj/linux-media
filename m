Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:34653 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955Ab0DOOij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 10:38:39 -0400
Message-ID: <4BC7249C.9010201@arcor.de>
Date: Thu, 15 Apr 2010 16:37:16 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: tm6000: firmware
References: <4BC5ECB8.2060208@arcor.de> <4BC5FF15.10605@redhat.com> <4BC60C72.6020901@arcor.de> <4BC62E69.60600@redhat.com>
In-Reply-To: <4BC62E69.60600@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070901080906030306070004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070901080906030306070004
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 14.04.2010 23:06, schrieb Mauro Carvalho Chehab:
> Em 14-04-2010 11:41, Stefan Ringel escreveu:
>   
>> Am 14.04.2010 19:44, schrieb Mauro Carvalho Chehab:
>>     
>>> Hi Stefan,
>>>
>>> Em 14-04-2010 09:26, Stefan Ringel escreveu:
>>>   
>>>       
>>>> Hi Mauro,
>>>>
>>>> Can you added these three firmwares? The third is into archive file,
>>>> because I'm extracted for an user (Bee Hock Goh).
>>>>     
>>>>         
>>> Sorry, but for us to put the firmwares at the server and/or add them at linux-firmware 
>>> git tree, we need to get the distribution rights from the manufacturer,
>>> as described on:
>>> 	http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches#Firmware_submission
>>>
>>> So, we need Xceive's ack, in order to add the firmware files somewhere. That's why
>>> currently we're using the procedure described on the comments at the extraction
>>> tool:
>>> 	Documentation/video4linux/extract_xc3028.pl  
>>>
>>> Cheers,
>>> Mauro
>>>   
>>>       
>> OK. In the archive is the modified extract_xc3028 tool for
>> tm6000-xc3028.fw . Is that useful?
>>     
> Yes, but:
>
> 1) Please, send it as a patch, with the proper SOB;
>
> 2) From a diff I did here:
>
> -       my $sourcefile = "UDXTTM6000.sys";
> -       my $hash = "cb9deb5508a5e150af2880f5b0066d78";
> -       my $outfile = "tm6000-xc3028.fw";
> +       my $sourcefile = "hcw85bda.sys";
> +       my $hash = "0e44dbf63bb0169d57446aec21881ff2";
> +       my $outfile = "xc3028-v27.fw";
>
> This version works with another *.sys file. The proper way is to
> check for the hash, and use the proper logic, based on the provided
> sys file;
>
> 3) Please document where to get the UDXTTTM6000.sys file at the 
> comments;
>
> 4) tm6000-xc3028.fw is a really bad name. It made sense only during
> the development of tuner-xc2028.c, since, on that time, it seemed that
> tm6000 had a different firmware version. In fact, the first devices
> appeared with v 1.e firmware. So, a proper name for that version
> would be xc3028-v1e.fw. We should rename it to be consistent.
>
>   
The firmware name is was you write in tm6000-card.c file and yes it can
renamed. This firmware work in tm5600 and tm6000 sticks where the
firmware v2.7 or v3.6 not works. The version isn't v1.e , it is v2.4 see
log file from Bee Hock Goh (
http://www.mail-archive.com/linux-media@vger.kernel.org/msg17378.html ).
> It is not clear what version is provided with this version. Is it
> v3.6? On a few cases, we've seen some modified versions of XC3028 firmwares
> shipped with some specific board. Is it the case?
>
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------070901080906030306070004
Content-Type: text/x-patch;
 name="extract_xc3028.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="extract_xc3028.diff"

--- usr/src/src/tm6010/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl	2010-03-27 13:14:22.215564668 +0100
+++ home/stefan/Downloads/tm6000-xc3028/extract_xc3028.pl	2010-04-15 16:21:19.664488407 +0200
@@ -5,13 +5,14 @@
 #
 # In order to use, you need to:
 #	1) Download the windows driver with something like:
-#		wget http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
-#	2) Extract the file hcw85bda.sys from the zip into the current dir:
-#		unzip -j HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
+#		wget http://www.twinhan.com/files/AW/BDA T/20080303_V1.0.6.7.zip
+#		or wget http://www.stefanringel.de/pub/20080303_V1.0.6.7.zip
+#	2) Extract the file UDXTTM6000.sys from the zip into the current dir:
+#		unzip -j 20080303_V1.0.6.7.zip 20080303_v1.0.6.7/UDXTTM6000.sys
 #	3) run the script:
 #		./extract_xc3028.pl
 #	4) copy the generated file:
-#		cp xc3028-v27.fw /lib/firmware
+#		cp tm6000-xc3028.fw /lib/firmware
 
 #use strict;
 use IO::Handle;
@@ -154,58 +155,58 @@
 	write_le16($nr_desc);
 
 	#
-	# Firmware 0, type: BASE FW   F8MHZ (0x00000003), id: (0000000000000000), size: 8718
+	# Firmware 0, type: BASE FW   F8MHZ (0x00000003), id: (0000000000000000), size: 6635
 	#
 
 	write_le32(0x00000003);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
-	write_le32(8718);			# Size
-	write_hunk_fix_endian(813432, 8718);
+	write_le32(6635);			# Size
+	write_hunk_fix_endian(257752, 6635);
 
 	#
-	# Firmware 1, type: BASE FW   F8MHZ MTS (0x00000007), id: (0000000000000000), size: 8712
+	# Firmware 1, type: BASE FW   F8MHZ MTS (0x00000007), id: (0000000000000000), size: 6635
 	#
 
 	write_le32(0x00000007);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
-	write_le32(8712);			# Size
-	write_hunk_fix_endian(822152, 8712);
+	write_le32(6635);			# Size
+	write_hunk_fix_endian(264392, 6635);
 
 	#
-	# Firmware 2, type: BASE FW   FM (0x00000401), id: (0000000000000000), size: 8562
+	# Firmware 2, type: BASE FW   FM (0x00000401), id: (0000000000000000), size: 6525
 	#
 
 	write_le32(0x00000401);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
-	write_le32(8562);			# Size
-	write_hunk_fix_endian(830872, 8562);
+	write_le32(6525);			# Size
+	write_hunk_fix_endian(271040, 6525);
 
 	#
-	# Firmware 3, type: BASE FW   FM INPUT1 (0x00000c01), id: (0000000000000000), size: 8576
+	# Firmware 3, type: BASE FW   FM INPUT1 (0x00000c01), id: (0000000000000000), size: 6539
 	#
 
 	write_le32(0x00000c01);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
-	write_le32(8576);			# Size
-	write_hunk_fix_endian(839440, 8576);
+	write_le32(6539);			# Size
+	write_hunk_fix_endian(277568, 6539);
 
 	#
-	# Firmware 4, type: BASE FW   (0x00000001), id: (0000000000000000), size: 8706
+	# Firmware 4, type: BASE FW   (0x00000001), id: (0000000000000000), size: 6633
 	#
 
 	write_le32(0x00000001);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
-	write_le32(8706);			# Size
-	write_hunk_fix_endian(848024, 8706);
+	write_le32(6633);			# Size
+	write_hunk_fix_endian(284120, 6633);
 
 	#
-	# Firmware 5, type: BASE FW   MTS (0x00000005), id: (0000000000000000), size: 8682
+	# Firmware 5, type: BASE FW   MTS (0x00000005), id: (0000000000000000), size: 6617
 	#
 
 	write_le32(0x00000005);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
-	write_le32(8682);			# Size
-	write_hunk_fix_endian(856736, 8682);
+	write_le32(6617);			# Size
+	write_hunk_fix_endian(290760, 6617);
 
 	#
 	# Firmware 6, type: STD FW    (0x00000000), id: PAL/BG A2/A (0000000100000007), size: 161
@@ -214,7 +215,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000001, 0x00000007);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(865424, 161);
+	write_hunk_fix_endian(297384, 161);
 
 	#
 	# Firmware 7, type: STD FW    MTS (0x00000004), id: PAL/BG A2/A (0000000100000007), size: 169
@@ -223,7 +224,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000001, 0x00000007);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(865592, 169);
+	write_hunk_fix_endian(297552, 169);
 
 	#
 	# Firmware 8, type: STD FW    (0x00000000), id: PAL/BG A2/B (0000000200000007), size: 161
@@ -232,7 +233,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000002, 0x00000007);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(865424, 161);
+	write_hunk_fix_endian(297728, 161);
 
 	#
 	# Firmware 9, type: STD FW    MTS (0x00000004), id: PAL/BG A2/B (0000000200000007), size: 169
@@ -241,7 +242,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000002, 0x00000007);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(865592, 169);
+	write_hunk_fix_endian(297896, 169);
 
 	#
 	# Firmware 10, type: STD FW    (0x00000000), id: PAL/BG NICAM/A (0000000400000007), size: 161
@@ -250,7 +251,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000004, 0x00000007);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(866112, 161);
+	write_hunk_fix_endian(298072, 161);
 
 	#
 	# Firmware 11, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/A (0000000400000007), size: 169
@@ -259,7 +260,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000004, 0x00000007);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(866280, 169);
+	write_hunk_fix_endian(298240, 169);
 
 	#
 	# Firmware 12, type: STD FW    (0x00000000), id: PAL/BG NICAM/B (0000000800000007), size: 161
@@ -268,7 +269,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000008, 0x00000007);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(866112, 161);
+	write_hunk_fix_endian(298416, 161);
 
 	#
 	# Firmware 13, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/B (0000000800000007), size: 169
@@ -277,7 +278,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000008, 0x00000007);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(866280, 169);
+	write_hunk_fix_endian(298584, 169);
 
 	#
 	# Firmware 14, type: STD FW    (0x00000000), id: PAL/DK A2 (00000003000000e0), size: 161
@@ -286,7 +287,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000003, 0x000000e0);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(866800, 161);
+	write_hunk_fix_endian(298760, 161);
 
 	#
 	# Firmware 15, type: STD FW    MTS (0x00000004), id: PAL/DK A2 (00000003000000e0), size: 169
@@ -295,7 +296,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000003, 0x000000e0);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(866968, 169);
+	write_hunk_fix_endian(298928, 169);
 
 	#
 	# Firmware 16, type: STD FW    (0x00000000), id: PAL/DK NICAM (0000000c000000e0), size: 161
@@ -304,7 +305,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x0000000c, 0x000000e0);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(867144, 161);
+	write_hunk_fix_endian(299104, 161);
 
 	#
 	# Firmware 17, type: STD FW    MTS (0x00000004), id: PAL/DK NICAM (0000000c000000e0), size: 169
@@ -313,7 +314,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x0000000c, 0x000000e0);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(867312, 169);
+	write_hunk_fix_endian(299272, 169);
 
 	#
 	# Firmware 18, type: STD FW    (0x00000000), id: SECAM/K1 (0000000000200000), size: 161
@@ -322,7 +323,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000000, 0x00200000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(867488, 161);
+	write_hunk_fix_endian(299448, 161);
 
 	#
 	# Firmware 19, type: STD FW    MTS (0x00000004), id: SECAM/K1 (0000000000200000), size: 169
@@ -331,7 +332,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000000, 0x00200000);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(867656, 169);
+	write_hunk_fix_endian(299616, 169);
 
 	#
 	# Firmware 20, type: STD FW    (0x00000000), id: SECAM/K3 (0000000004000000), size: 161
@@ -340,7 +341,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000000, 0x04000000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(867832, 161);
+	write_hunk_fix_endian(299792, 161);
 
 	#
 	# Firmware 21, type: STD FW    MTS (0x00000004), id: SECAM/K3 (0000000004000000), size: 169
@@ -349,7 +350,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000000, 0x04000000);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(868000, 169);
+	write_hunk_fix_endian(299960, 169);
 
 	#
 	# Firmware 22, type: STD FW    D2633 DTV6 ATSC (0x00010030), id: (0000000000000000), size: 149
@@ -358,7 +359,7 @@
 	write_le32(0x00010030);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868176, 149);
+	write_hunk_fix_endian(300136, 149);
 
 	#
 	# Firmware 23, type: STD FW    D2620 DTV6 QAM (0x00000068), id: (0000000000000000), size: 149
@@ -367,7 +368,7 @@
 	write_le32(0x00000068);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868336, 149);
+	write_hunk_fix_endian(300296, 149);
 
 	#
 	# Firmware 24, type: STD FW    D2633 DTV6 QAM (0x00000070), id: (0000000000000000), size: 149
@@ -376,7 +377,7 @@
 	write_le32(0x00000070);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868488, 149);
+	write_hunk_fix_endian(300448, 149);
 
 	#
 	# Firmware 25, type: STD FW    D2620 DTV7 (0x00000088), id: (0000000000000000), size: 149
@@ -385,7 +386,7 @@
 	write_le32(0x00000088);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868648, 149);
+	write_hunk_fix_endian(300608, 149);
 
 	#
 	# Firmware 26, type: STD FW    D2633 DTV7 (0x00000090), id: (0000000000000000), size: 149
@@ -394,7 +395,7 @@
 	write_le32(0x00000090);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868800, 149);
+	write_hunk_fix_endian(300760, 149);
 
 	#
 	# Firmware 27, type: STD FW    D2620 DTV78 (0x00000108), id: (0000000000000000), size: 149
@@ -403,7 +404,7 @@
 	write_le32(0x00000108);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868960, 149);
+	write_hunk_fix_endian(300920, 149);
 
 	#
 	# Firmware 28, type: STD FW    D2633 DTV78 (0x00000110), id: (0000000000000000), size: 149
@@ -412,7 +413,7 @@
 	write_le32(0x00000110);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(869112, 149);
+	write_hunk_fix_endian(301072, 149);
 
 	#
 	# Firmware 29, type: STD FW    D2620 DTV8 (0x00000208), id: (0000000000000000), size: 149
@@ -421,7 +422,7 @@
 	write_le32(0x00000208);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868648, 149);
+	write_hunk_fix_endian(301232, 149);
 
 	#
 	# Firmware 30, type: STD FW    D2633 DTV8 (0x00000210), id: (0000000000000000), size: 149
@@ -430,7 +431,7 @@
 	write_le32(0x00000210);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(149);			# Size
-	write_hunk_fix_endian(868800, 149);
+	write_hunk_fix_endian(301384, 149);
 
 	#
 	# Firmware 31, type: STD FW    FM (0x00000400), id: (0000000000000000), size: 135
@@ -439,7 +440,7 @@
 	write_le32(0x00000400);			# Type
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le32(135);			# Size
-	write_hunk_fix_endian(869584, 135);
+	write_hunk_fix_endian(301554, 135);
 
 	#
 	# Firmware 32, type: STD FW    (0x00000000), id: PAL/I (0000000000000010), size: 161
@@ -448,7 +449,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000000, 0x00000010);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(869728, 161);
+	write_hunk_fix_endian(301688, 161);
 
 	#
 	# Firmware 33, type: STD FW    MTS (0x00000004), id: PAL/I (0000000000000010), size: 169
@@ -457,17 +458,12 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000000, 0x00000010);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(869896, 169);
+	write_hunk_fix_endian(301856, 169);
 
 	#
 	# Firmware 34, type: STD FW    (0x00000000), id: SECAM/L AM (0000001000400000), size: 169
 	#
 
-	write_le32(0x00000000);			# Type
-	write_le64(0x00000010, 0x00400000);	# ID
-	write_le32(169);			# Size
-	write_hunk_fix_endian(870072, 169);
-
 	#
 	# Firmware 35, type: STD FW    (0x00000000), id: SECAM/L NICAM (0000000c00400000), size: 161
 	#
@@ -475,7 +471,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x0000000c, 0x00400000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(870248, 161);
+	write_hunk_fix_endian(302032, 161);
 
 	#
 	# Firmware 36, type: STD FW    (0x00000000), id: SECAM/Lc (0000000000800000), size: 161
@@ -484,7 +480,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000000, 0x00800000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(870416, 161);
+	write_hunk_fix_endian(302200, 161);
 
 	#
 	# Firmware 37, type: STD FW    (0x00000000), id: NTSC/M Kr (0000000000008000), size: 161
@@ -493,7 +489,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000000, 0x00008000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(870584, 161);
+	write_hunk_fix_endian(302368, 161);
 
 	#
 	# Firmware 38, type: STD FW    LCD (0x00001000), id: NTSC/M Kr (0000000000008000), size: 161
@@ -502,7 +498,7 @@
 	write_le32(0x00001000);			# Type
 	write_le64(0x00000000, 0x00008000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(870752, 161);
+	write_hunk_fix_endian(302536, 161);
 
 	#
 	# Firmware 39, type: STD FW    LCD NOGD (0x00003000), id: NTSC/M Kr (0000000000008000), size: 161
@@ -511,7 +507,7 @@
 	write_le32(0x00003000);			# Type
 	write_le64(0x00000000, 0x00008000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(870920, 161);
+	write_hunk_fix_endian(302704, 161);
 
 	#
 	# Firmware 40, type: STD FW    MTS (0x00000004), id: NTSC/M Kr (0000000000008000), size: 169
@@ -520,7 +516,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000000, 0x00008000);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(871088, 169);
+	write_hunk_fix_endian(302872, 169);
 
 	#
 	# Firmware 41, type: STD FW    (0x00000000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
@@ -529,7 +525,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000000, 0x0000b700);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(871264, 161);
+	write_hunk_fix_endian(303048, 161);
 
 	#
 	# Firmware 42, type: STD FW    LCD (0x00001000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
@@ -538,7 +534,7 @@
 	write_le32(0x00001000);			# Type
 	write_le64(0x00000000, 0x0000b700);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(871432, 161);
+	write_hunk_fix_endian(303216, 161);
 
 	#
 	# Firmware 43, type: STD FW    LCD NOGD (0x00003000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
@@ -547,7 +543,7 @@
 	write_le32(0x00003000);			# Type
 	write_le64(0x00000000, 0x0000b700);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(871600, 161);
+	write_hunk_fix_endian(303384, 161);
 
 	#
 	# Firmware 44, type: STD FW    (0x00000000), id: NTSC/M Jp (0000000000002000), size: 161
@@ -556,7 +552,7 @@
 	write_le32(0x00000000);			# Type
 	write_le64(0x00000000, 0x00002000);	# ID
 	write_le32(161);			# Size
-	write_hunk_fix_endian(871264, 161);
+	write_hunk_fix_endian(303552, 161);
 
 	#
 	# Firmware 45, type: STD FW    MTS (0x00000004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
@@ -565,7 +561,7 @@
 	write_le32(0x00000004);			# Type
 	write_le64(0x00000000, 0x0000b700);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(871936, 169);
+	write_hunk_fix_endian(303720, 169);
 
 	#
 	# Firmware 46, type: STD FW    MTS LCD (0x00001004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
@@ -574,7 +570,7 @@
 	write_le32(0x00001004);			# Type
 	write_le64(0x00000000, 0x0000b700);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(872112, 169);
+	write_hunk_fix_endian(303896, 169);
 
 	#
 	# Firmware 47, type: STD FW    MTS LCD NOGD (0x00003004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
@@ -583,7 +579,7 @@
 	write_le32(0x00003004);			# Type
 	write_le64(0x00000000, 0x0000b700);	# ID
 	write_le32(169);			# Size
-	write_hunk_fix_endian(872288, 169);
+	write_hunk_fix_endian(304072, 169);
 
 	#
 	# Firmware 48, type: SCODE FW  HAS IF (0x60000000), IF = 3.28 MHz id: (0000000000000000), size: 192
@@ -593,17 +589,17 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(3280);			# IF
 	write_le32(192);			# Size
-	write_hunk(811896, 192);
+	write_hunk(309048, 192);
 
 	#
 	# Firmware 49, type: SCODE FW  HAS IF (0x60000000), IF = 3.30 MHz id: (0000000000000000), size: 192
 	#
 
-	write_le32(0x60000000);			# Type
-	write_le64(0x00000000, 0x00000000);	# ID
-	write_le16(3300);			# IF
-	write_le32(192);			# Size
-	write_hunk(813048, 192);
+#	write_le32(0x60000000);			# Type
+#	write_le64(0x00000000, 0x00000000);	# ID
+#	write_le16(3300);			# IF
+#	write_le32(192);			# Size
+#	write_hunk(304440, 192);
 
 	#
 	# Firmware 50, type: SCODE FW  HAS IF (0x60000000), IF = 3.44 MHz id: (0000000000000000), size: 192
@@ -613,7 +609,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(3440);			# IF
 	write_le32(192);			# Size
-	write_hunk(812280, 192);
+	write_hunk(309432, 192);
 
 	#
 	# Firmware 51, type: SCODE FW  HAS IF (0x60000000), IF = 3.46 MHz id: (0000000000000000), size: 192
@@ -623,7 +619,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(3460);			# IF
 	write_le32(192);			# Size
-	write_hunk(812472, 192);
+	write_hunk(309624, 192);
 
 	#
 	# Firmware 52, type: SCODE FW  DTV6 ATSC OREN36 HAS IF (0x60210020), IF = 3.80 MHz id: (0000000000000000), size: 192
@@ -633,7 +629,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(3800);			# IF
 	write_le32(192);			# Size
-	write_hunk(809784, 192);
+	write_hunk(306936, 192);
 
 	#
 	# Firmware 53, type: SCODE FW  HAS IF (0x60000000), IF = 4.00 MHz id: (0000000000000000), size: 192
@@ -643,7 +639,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(4000);			# IF
 	write_le32(192);			# Size
-	write_hunk(812088, 192);
+	write_hunk(309240, 192);
 
 	#
 	# Firmware 54, type: SCODE FW  DTV6 ATSC TOYOTA388 HAS IF (0x60410020), IF = 4.08 MHz id: (0000000000000000), size: 192
@@ -653,7 +649,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(4080);			# IF
 	write_le32(192);			# Size
-	write_hunk(809976, 192);
+	write_hunk(307128, 192);
 
 	#
 	# Firmware 55, type: SCODE FW  HAS IF (0x60000000), IF = 4.20 MHz id: (0000000000000000), size: 192
@@ -663,7 +659,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(4200);			# IF
 	write_le32(192);			# Size
-	write_hunk(811704, 192);
+	write_hunk(308856, 192);
 
 	#
 	# Firmware 56, type: SCODE FW  MONO HAS IF (0x60008000), IF = 4.32 MHz id: NTSC/M Kr (0000000000008000), size: 192
@@ -673,7 +669,7 @@
 	write_le64(0x00000000, 0x00008000);	# ID
 	write_le16(4320);			# IF
 	write_le32(192);			# Size
-	write_hunk(808056, 192);
+	write_hunk(305208, 192);
 
 	#
 	# Firmware 57, type: SCODE FW  HAS IF (0x60000000), IF = 4.45 MHz id: (0000000000000000), size: 192
@@ -683,7 +679,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(4450);			# IF
 	write_le32(192);			# Size
-	write_hunk(812664, 192);
+	write_hunk(309816, 192);
 
 	#
 	# Firmware 58, type: SCODE FW  MTS LCD NOGD MONO IF HAS IF (0x6002b004), IF = 4.50 MHz id: NTSC PAL/M PAL/N (000000000000b700), size: 192
@@ -693,7 +689,7 @@
 	write_le64(0x00000000, 0x0000b700);	# ID
 	write_le16(4500);			# IF
 	write_le32(192);			# Size
-	write_hunk(807672, 192);
+	write_hunk(304824, 192);
 
 	#
 	# Firmware 59, type: SCODE FW  LCD NOGD IF HAS IF (0x60023000), IF = 4.60 MHz id: NTSC/M Kr (0000000000008000), size: 192
@@ -703,7 +699,7 @@
 	write_le64(0x00000000, 0x00008000);	# ID
 	write_le16(4600);			# IF
 	write_le32(192);			# Size
-	write_hunk(807864, 192);
+	write_hunk(305016, 192);
 
 	#
 	# Firmware 60, type: SCODE FW  DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 HAS IF (0x620003e0), IF = 4.76 MHz id: (0000000000000000), size: 192
@@ -713,7 +709,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(4760);			# IF
 	write_le32(192);			# Size
-	write_hunk(807288, 192);
+	write_hunk(304440, 192);
 
 	#
 	# Firmware 61, type: SCODE FW  HAS IF (0x60000000), IF = 4.94 MHz id: (0000000000000000), size: 192
@@ -723,7 +719,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(4940);			# IF
 	write_le32(192);			# Size
-	write_hunk(811512, 192);
+	write_hunk(308664, 192);
 
 	#
 	# Firmware 62, type: SCODE FW  HAS IF (0x60000000), IF = 5.26 MHz id: (0000000000000000), size: 192
@@ -733,7 +729,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(5260);			# IF
 	write_le32(192);			# Size
-	write_hunk(810552, 192);
+	write_hunk(307704, 192);
 
 	#
 	# Firmware 63, type: SCODE FW  MONO HAS IF (0x60008000), IF = 5.32 MHz id: PAL/BG A2 NICAM (0000000f00000007), size: 192
@@ -743,7 +739,7 @@
 	write_le64(0x0000000f, 0x00000007);	# ID
 	write_le16(5320);			# IF
 	write_le32(192);			# Size
-	write_hunk(810744, 192);
+	write_hunk(307896, 192);
 
 	#
 	# Firmware 64, type: SCODE FW  DTV7 DTV78 DTV8 DIBCOM52 CHINA HAS IF (0x65000380), IF = 5.40 MHz id: (0000000000000000), size: 192
@@ -753,7 +749,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(5400);			# IF
 	write_le32(192);			# Size
-	write_hunk(807096, 192);
+	write_hunk(304248, 192);
 
 	#
 	# Firmware 65, type: SCODE FW  DTV6 ATSC OREN538 HAS IF (0x60110020), IF = 5.58 MHz id: (0000000000000000), size: 192
@@ -763,7 +759,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(5580);			# IF
 	write_le32(192);			# Size
-	write_hunk(809592, 192);
+	write_hunk(306744, 192);
 
 	#
 	# Firmware 66, type: SCODE FW  HAS IF (0x60000000), IF = 5.64 MHz id: PAL/BG A2 (0000000300000007), size: 192
@@ -773,7 +769,7 @@
 	write_le64(0x00000003, 0x00000007);	# ID
 	write_le16(5640);			# IF
 	write_le32(192);			# Size
-	write_hunk(808440, 192);
+	write_hunk(305592, 192);
 
 	#
 	# Firmware 67, type: SCODE FW  HAS IF (0x60000000), IF = 5.74 MHz id: PAL/BG NICAM (0000000c00000007), size: 192
@@ -783,7 +779,7 @@
 	write_le64(0x0000000c, 0x00000007);	# ID
 	write_le16(5740);			# IF
 	write_le32(192);			# Size
-	write_hunk(808632, 192);
+	write_hunk(305784, 192);
 
 	#
 	# Firmware 68, type: SCODE FW  HAS IF (0x60000000), IF = 5.90 MHz id: (0000000000000000), size: 192
@@ -793,7 +789,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(5900);			# IF
 	write_le32(192);			# Size
-	write_hunk(810360, 192);
+	write_hunk(307512, 192);
 
 	#
 	# Firmware 69, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.00 MHz id: PAL/DK PAL/I SECAM/K3 SECAM/L SECAM/Lc NICAM (0000000c04c000f0), size: 192
@@ -803,7 +799,7 @@
 	write_le64(0x0000000c, 0x04c000f0);	# ID
 	write_le16(6000);			# IF
 	write_le32(192);			# Size
-	write_hunk(808824, 192);
+	write_hunk(305576, 192);
 
 	#
 	# Firmware 70, type: SCODE FW  DTV6 QAM ATSC LG60 F6MHZ HAS IF (0x68050060), IF = 6.20 MHz id: (0000000000000000), size: 192
@@ -813,7 +809,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(6200);			# IF
 	write_le32(192);			# Size
-	write_hunk(809400, 192);
+	write_hunk(306552, 192);
 
 	#
 	# Firmware 71, type: SCODE FW  HAS IF (0x60000000), IF = 6.24 MHz id: PAL/I (0000000000000010), size: 192
@@ -823,7 +819,7 @@
 	write_le64(0x00000000, 0x00000010);	# ID
 	write_le16(6240);			# IF
 	write_le32(192);			# Size
-	write_hunk(808248, 192);
+	write_hunk(305400, 192);
 
 	#
 	# Firmware 72, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.32 MHz id: SECAM/K1 (0000000000200000), size: 192
@@ -833,7 +829,7 @@
 	write_le64(0x00000000, 0x00200000);	# ID
 	write_le16(6320);			# IF
 	write_le32(192);			# Size
-	write_hunk(811320, 192);
+	write_hunk(308472, 192);
 
 	#
 	# Firmware 73, type: SCODE FW  HAS IF (0x60000000), IF = 6.34 MHz id: SECAM/K1 (0000000000200000), size: 192
@@ -843,7 +839,7 @@
 	write_le64(0x00000000, 0x00200000);	# ID
 	write_le16(6340);			# IF
 	write_le32(192);			# Size
-	write_hunk(809208, 192);
+	write_hunk(306360, 192);
 
 	#
 	# Firmware 74, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.50 MHz id: PAL/DK SECAM/K3 SECAM/L NICAM (0000000c044000e0), size: 192
@@ -853,7 +849,7 @@
 	write_le64(0x0000000c, 0x044000e0);	# ID
 	write_le16(6500);			# IF
 	write_le32(192);			# Size
-	write_hunk(811128, 192);
+	write_hunk(308280, 192);
 
 	#
 	# Firmware 75, type: SCODE FW  DTV6 ATSC ATI638 HAS IF (0x60090020), IF = 6.58 MHz id: (0000000000000000), size: 192
@@ -863,7 +859,7 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(6580);			# IF
 	write_le32(192);			# Size
-	write_hunk(807480, 192);
+	write_hunk(304632, 192);
 
 	#
 	# Firmware 76, type: SCODE FW  HAS IF (0x60000000), IF = 6.60 MHz id: PAL/DK A2 (00000003000000e0), size: 192
@@ -873,7 +869,7 @@
 	write_le64(0x00000003, 0x000000e0);	# ID
 	write_le16(6600);			# IF
 	write_le32(192);			# Size
-	write_hunk(809016, 192);
+	write_hunk(306168, 192);
 
 	#
 	# Firmware 77, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.68 MHz id: PAL/DK A2 (00000003000000e0), size: 192
@@ -883,7 +879,7 @@
 	write_le64(0x00000003, 0x000000e0);	# ID
 	write_le16(6680);			# IF
 	write_le32(192);			# Size
-	write_hunk(810936, 192);
+	write_hunk(308088, 192);
 
 	#
 	# Firmware 78, type: SCODE FW  DTV6 ATSC TOYOTA794 HAS IF (0x60810020), IF = 8.14 MHz id: (0000000000000000), size: 192
@@ -893,26 +889,26 @@
 	write_le64(0x00000000, 0x00000000);	# ID
 	write_le16(8140);			# IF
 	write_le32(192);			# Size
-	write_hunk(810168, 192);
+	write_hunk(307320, 192);
 
 	#
 	# Firmware 79, type: SCODE FW  HAS IF (0x60000000), IF = 8.20 MHz id: (0000000000000000), size: 192
 	#
 
-	write_le32(0x60000000);			# Type
-	write_le64(0x00000000, 0x00000000);	# ID
-	write_le16(8200);			# IF
-	write_le32(192);			# Size
-	write_hunk(812856, 192);
+#	write_le32(0x60000000);			# Type
+#	write_le64(0x00000000, 0x00000000);	# ID
+#	write_le16(8200);			# IF
+#	write_le32(192);			# Size
+#	write_hunk(308088, 192);
 }
 
 sub extract_firmware {
-	my $sourcefile = "hcw85bda.sys";
-	my $hash = "0e44dbf63bb0169d57446aec21881ff2";
-	my $outfile = "xc3028-v27.fw";
+	my $sourcefile = "UDXTTM6000.sys";
+	my $hash = "cb9deb5508a5e150af2880f5b0066d78";
+	my $outfile = "tm6000-xc3028.fw";
 	my $name = "xc2028 firmware";
-	my $version = 519;
-	my $nr_desc = 80;
+	my $version = 516;
+	my $nr_desc = 77;
 	my $out;
 
 	verify($sourcefile, $hash);

--------------070901080906030306070004--
