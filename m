Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:46356 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843Ab0DUPRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 11:17:22 -0400
Message-ID: <4BCF16AB.3020201@arcor.de>
Date: Wed, 21 Apr 2010 17:15:55 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: tm6000: firmware
References: <4BC5ECB8.2060208@arcor.de>	<4BC5FF15.10605@redhat.com>	<4BC60C72.6020901@arcor.de>	<4BC62E69.60600@redhat.com>	<4BC7249C.9010201@arcor.de>	<4BC7496A.6090105@redhat.com>	<4BC768E7.8070204@arcor.de> <20100421014538.59c690ad@pedra>
In-Reply-To: <20100421014538.59c690ad@pedra>
Content-Type: multipart/mixed;
 boundary="------------030000050301020100010005"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030000050301020100010005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 21.04.2010 06:45, schrieb Mauro Carvalho Chehab:
> Em Thu, 15 Apr 2010 21:28:39 +0200
> Stefan Ringel <stefan.ringel@arcor.de> escreveu:
>
>   
>> Am 15.04.2010 19:14, schrieb Mauro Carvalho Chehab:
>>     
>>> Em 15-04-2010 07:37, Stefan Ringel escreveu:
>>>   
>>>       
>>>> Am 14.04.2010 23:06, schrieb Mauro Carvalho Chehab:
>>>>     
>>>>         
>>>>> Em 14-04-2010 11:41, Stefan Ringel escreveu:
>>>>>   
>>>>>       
>>>>>           
>>>>>> Am 14.04.2010 19:44, schrieb Mauro Carvalho Chehab:
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> Hi Stefan,
>>>>>>>
>>>>>>> Em 14-04-2010 09:26, Stefan Ringel escreveu:
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>>>> Hi Mauro,
>>>>>>>>
>>>>>>>> Can you added these three firmwares? The third is into archive file,
>>>>>>>> because I'm extracted for an user (Bee Hock Goh).
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>> Sorry, but for us to put the firmwares at the server and/or add them at linux-firmware 
>>>>>>> git tree, we need to get the distribution rights from the manufacturer,
>>>>>>> as described on:
>>>>>>> 	http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches#Firmware_submission
>>>>>>>
>>>>>>> So, we need Xceive's ack, in order to add the firmware files somewhere. That's why
>>>>>>> currently we're using the procedure described on the comments at the extraction
>>>>>>> tool:
>>>>>>> 	Documentation/video4linux/extract_xc3028.pl  
>>>>>>>
>>>>>>> Cheers,
>>>>>>> Mauro
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> OK. In the archive is the modified extract_xc3028 tool for
>>>>>> tm6000-xc3028.fw . Is that useful?
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> Yes, but:
>>>>>
>>>>> 1) Please, send it as a patch, with the proper SOB;
>>>>>
>>>>> 2) From a diff I did here:
>>>>>
>>>>> -       my $sourcefile = "UDXTTM6000.sys";
>>>>> -       my $hash = "cb9deb5508a5e150af2880f5b0066d78";
>>>>> -       my $outfile = "tm6000-xc3028.fw";
>>>>> +       my $sourcefile = "hcw85bda.sys";
>>>>> +       my $hash = "0e44dbf63bb0169d57446aec21881ff2";
>>>>> +       my $outfile = "xc3028-v27.fw";
>>>>>
>>>>> This version works with another *.sys file. The proper way is to
>>>>> check for the hash, and use the proper logic, based on the provided
>>>>> sys file;
>>>>>
>>>>> 3) Please document where to get the UDXTTTM6000.sys file at the 
>>>>> comments;
>>>>>
>>>>> 4) tm6000-xc3028.fw is a really bad name. It made sense only during
>>>>> the development of tuner-xc2028.c, since, on that time, it seemed that
>>>>> tm6000 had a different firmware version. In fact, the first devices
>>>>> appeared with v 1.e firmware. So, a proper name for that version
>>>>> would be xc3028-v1e.fw. We should rename it to be consistent.
>>>>>
>>>>>   
>>>>>       
>>>>>           
>>>> The firmware name is was you write in tm6000-card.c file and yes it can
>>>> renamed. This firmware work in tm5600 and tm6000 sticks where the
>>>> firmware v2.7 or v3.6 not works. The version isn't v1.e , it is v2.4 see
>>>> log file from Bee Hock Goh (
>>>>     
>>>>         
>>> Ok. then, please send me a patch renaming the firmware used by this card as
>>> xc3028-v24.fw.
>>>
>>> I won't be able to apply any patch until next week (I'm currently abroad for
>>> the Collaboration Summit).
>>>
>>>   
>>>       
>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg17378.html ).
>>>>     
>>>>         
>>>>> It is not clear what version is provided with this version. Is it
>>>>> v3.6? On a few cases, we've seen some modified versions of XC3028 firmwares
>>>>> shipped with some specific board. Is it the case?
>>>>>       
>>>>>           
>>> With respect to your patch, you need to add some logic to decide to generate
>>> either v2.4 or v2.7, based on the *.sys checksum code. So, instead of just
>>> renaming things, the proper solution is to create two sub-routines: one for
>>> v2.7 and another for v2.4, and decide to use either one, based on the checksum
>>> of the *.sys file.
>>>
>>>   
>>>       
>> I have generated new the patch.
>>     
> Much better! Yet:
>
> 	+verify($sourcefile_24, $hash_24);
> 	+	verify($sourcefile_27, $hash_27);
> 	+
> 	+	open INFILE, "<$sourcefile_24";
> 	+	main_firmware_24($outfile_24, $name_24, $version_24, $nr_desc_24);
> 	+	close INFILE;
> 	+
> 	+	open INFILE, "<$sourcefile_27";
> 	+	main_firmware_27($outfile_27, $name_27, $version_27, $nr_desc_27);
> 	 	close INFILE;
> 	 }
>
> Users shouldn't be forced to download both files, as just one file is needed for a given device. 
> So, instead, the tool should test if the file exists, and handle only the found file(s).
>
>   
OK.

-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------030000050301020100010005
Content-Type: text/x-patch;
 name="extract_xc3028.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="extract_xc3028.diff"

--- usr/src/src/tm6010/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl	2010-03-27 13:14:22.215564668 +0100
+++ home/stefan/Downloads/tm6000-xc3028/extract_xc3028.pl	2010-04-21 17:09:22.591574944 +0200
@@ -5,12 +5,18 @@
 #
 # In order to use, you need to:
 #	1) Download the windows driver with something like:
+#	Version 2.4
+#		wget http://www.twinhan.com/files/AW/BDA T/20080303_V1.0.6.7.zip
+#		or wget http://www.stefanringel.de/pub/20080303_V1.0.6.7.zip
+#	Version 2.7
 #		wget http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
-#	2) Extract the file hcw85bda.sys from the zip into the current dir:
+#	2) Extract the files from the zip into the current dir:
+#		unzip -j 20080303_V1.0.6.7.zip 20080303_v1.0.6.7/UDXTTM6000.sys
 #		unzip -j HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
 #	3) run the script:
 #		./extract_xc3028.pl
-#	4) copy the generated file:
+#	4) copy the generated files:
+#		cp xc3028-v24.fw /lib/firmware
 #		cp xc3028-v27.fw /lib/firmware
 
 #use strict;
@@ -135,7 +141,7 @@
 	}
 }
 
-sub main_firmware($$$$)
+sub main_firmware_24($$$$)
 {
 	my $out;
 	my $j=0;
@@ -146,8 +152,774 @@
 
 	for ($j = length($name); $j <32; $j++) {
 		$name = $name.chr(0);
+	}
+
+	open OUTFILE, ">$outfile";
+	syswrite(OUTFILE, $name);
+	write_le16($version);
+	write_le16($nr_desc);
+
+	#
+	# Firmware 0, type: BASE FW   F8MHZ (0x00000003), id: (0000000000000000), size: 6635
+	#
+
+	write_le32(0x00000003);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(6635);			# Size
+	write_hunk_fix_endian(257752, 6635);
+
+	#
+	# Firmware 1, type: BASE FW   F8MHZ MTS (0x00000007), id: (0000000000000000), size: 6635
+	#
+
+	write_le32(0x00000007);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(6635);			# Size
+	write_hunk_fix_endian(264392, 6635);
+
+	#
+	# Firmware 2, type: BASE FW   FM (0x00000401), id: (0000000000000000), size: 6525
+	#
+
+	write_le32(0x00000401);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(6525);			# Size
+	write_hunk_fix_endian(271040, 6525);
+
+	#
+	# Firmware 3, type: BASE FW   FM INPUT1 (0x00000c01), id: (0000000000000000), size: 6539
+	#
+
+	write_le32(0x00000c01);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(6539);			# Size
+	write_hunk_fix_endian(277568, 6539);
+
+	#
+	# Firmware 4, type: BASE FW   (0x00000001), id: (0000000000000000), size: 6633
+	#
+
+	write_le32(0x00000001);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(6633);			# Size
+	write_hunk_fix_endian(284120, 6633);
+
+	#
+	# Firmware 5, type: BASE FW   MTS (0x00000005), id: (0000000000000000), size: 6617
+	#
+
+	write_le32(0x00000005);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(6617);			# Size
+	write_hunk_fix_endian(290760, 6617);
+
+	#
+	# Firmware 6, type: STD FW    (0x00000000), id: PAL/BG A2/A (0000000100000007), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000001, 0x00000007);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(297384, 161);
+
+	#
+	# Firmware 7, type: STD FW    MTS (0x00000004), id: PAL/BG A2/A (0000000100000007), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000001, 0x00000007);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(297552, 169);
+
+	#
+	# Firmware 8, type: STD FW    (0x00000000), id: PAL/BG A2/B (0000000200000007), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000002, 0x00000007);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(297728, 161);
+
+	#
+	# Firmware 9, type: STD FW    MTS (0x00000004), id: PAL/BG A2/B (0000000200000007), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000002, 0x00000007);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(297896, 169);
+
+	#
+	# Firmware 10, type: STD FW    (0x00000000), id: PAL/BG NICAM/A (0000000400000007), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000004, 0x00000007);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(298072, 161);
+
+	#
+	# Firmware 11, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/A (0000000400000007), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000004, 0x00000007);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(298240, 169);
+
+	#
+	# Firmware 12, type: STD FW    (0x00000000), id: PAL/BG NICAM/B (0000000800000007), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000008, 0x00000007);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(298416, 161);
+
+	#
+	# Firmware 13, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/B (0000000800000007), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000008, 0x00000007);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(298584, 169);
+
+	#
+	# Firmware 14, type: STD FW    (0x00000000), id: PAL/DK A2 (00000003000000e0), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000003, 0x000000e0);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(298760, 161);
+
+	#
+	# Firmware 15, type: STD FW    MTS (0x00000004), id: PAL/DK A2 (00000003000000e0), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000003, 0x000000e0);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(298928, 169);
+
+	#
+	# Firmware 16, type: STD FW    (0x00000000), id: PAL/DK NICAM (0000000c000000e0), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x0000000c, 0x000000e0);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(299104, 161);
+
+	#
+	# Firmware 17, type: STD FW    MTS (0x00000004), id: PAL/DK NICAM (0000000c000000e0), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x0000000c, 0x000000e0);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(299272, 169);
+
+	#
+	# Firmware 18, type: STD FW    (0x00000000), id: SECAM/K1 (0000000000200000), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000000, 0x00200000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(299448, 161);
+
+	#
+	# Firmware 19, type: STD FW    MTS (0x00000004), id: SECAM/K1 (0000000000200000), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000000, 0x00200000);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(299616, 169);
+
+	#
+	# Firmware 20, type: STD FW    (0x00000000), id: SECAM/K3 (0000000004000000), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000000, 0x04000000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(299792, 161);
+
+	#
+	# Firmware 21, type: STD FW    MTS (0x00000004), id: SECAM/K3 (0000000004000000), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000000, 0x04000000);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(299960, 169);
+
+	#
+	# Firmware 22, type: STD FW    D2633 DTV6 ATSC (0x00010030), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00010030);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(300136, 149);
+
+	#
+	# Firmware 23, type: STD FW    D2620 DTV6 QAM (0x00000068), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000068);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(300296, 149);
+
+	#
+	# Firmware 24, type: STD FW    D2633 DTV6 QAM (0x00000070), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000070);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(300448, 149);
+
+	#
+	# Firmware 25, type: STD FW    D2620 DTV7 (0x00000088), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000088);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(300608, 149);
+
+	#
+	# Firmware 26, type: STD FW    D2633 DTV7 (0x00000090), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000090);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(300760, 149);
+
+	#
+	# Firmware 27, type: STD FW    D2620 DTV78 (0x00000108), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000108);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(300920, 149);
+
+	#
+	# Firmware 28, type: STD FW    D2633 DTV78 (0x00000110), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000110);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(301072, 149);
+
+	#
+	# Firmware 29, type: STD FW    D2620 DTV8 (0x00000208), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000208);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(301232, 149);
+
+	#
+	# Firmware 30, type: STD FW    D2633 DTV8 (0x00000210), id: (0000000000000000), size: 149
+	#
+
+	write_le32(0x00000210);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(149);			# Size
+	write_hunk_fix_endian(301384, 149);
+
+	#
+	# Firmware 31, type: STD FW    FM (0x00000400), id: (0000000000000000), size: 135
+	#
+
+	write_le32(0x00000400);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le32(135);			# Size
+	write_hunk_fix_endian(301554, 135);
+
+	#
+	# Firmware 32, type: STD FW    (0x00000000), id: PAL/I (0000000000000010), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000000, 0x00000010);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(301688, 161);
+
+	#
+	# Firmware 33, type: STD FW    MTS (0x00000004), id: PAL/I (0000000000000010), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000000, 0x00000010);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(301856, 169);
+
+	#
+	# Firmware 34, type: STD FW    (0x00000000), id: SECAM/L AM (0000001000400000), size: 169
+	#
+
+	#
+	# Firmware 35, type: STD FW    (0x00000000), id: SECAM/L NICAM (0000000c00400000), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x0000000c, 0x00400000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(302032, 161);
+
+	#
+	# Firmware 36, type: STD FW    (0x00000000), id: SECAM/Lc (0000000000800000), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000000, 0x00800000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(302200, 161);
+
+	#
+	# Firmware 37, type: STD FW    (0x00000000), id: NTSC/M Kr (0000000000008000), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000000, 0x00008000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(302368, 161);
+
+	#
+	# Firmware 38, type: STD FW    LCD (0x00001000), id: NTSC/M Kr (0000000000008000), size: 161
+	#
+
+	write_le32(0x00001000);			# Type
+	write_le64(0x00000000, 0x00008000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(302536, 161);
+
+	#
+	# Firmware 39, type: STD FW    LCD NOGD (0x00003000), id: NTSC/M Kr (0000000000008000), size: 161
+	#
+
+	write_le32(0x00003000);			# Type
+	write_le64(0x00000000, 0x00008000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(302704, 161);
+
+	#
+	# Firmware 40, type: STD FW    MTS (0x00000004), id: NTSC/M Kr (0000000000008000), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000000, 0x00008000);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(302872, 169);
+
+	#
+	# Firmware 41, type: STD FW    (0x00000000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000000, 0x0000b700);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(303048, 161);
+
+	#
+	# Firmware 42, type: STD FW    LCD (0x00001000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
+	#
+
+	write_le32(0x00001000);			# Type
+	write_le64(0x00000000, 0x0000b700);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(303216, 161);
+
+	#
+	# Firmware 43, type: STD FW    LCD NOGD (0x00003000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
+	#
+
+	write_le32(0x00003000);			# Type
+	write_le64(0x00000000, 0x0000b700);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(303384, 161);
+
+	#
+	# Firmware 44, type: STD FW    (0x00000000), id: NTSC/M Jp (0000000000002000), size: 161
+	#
+
+	write_le32(0x00000000);			# Type
+	write_le64(0x00000000, 0x00002000);	# ID
+	write_le32(161);			# Size
+	write_hunk_fix_endian(303552, 161);
+
+	#
+	# Firmware 45, type: STD FW    MTS (0x00000004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
+	#
+
+	write_le32(0x00000004);			# Type
+	write_le64(0x00000000, 0x0000b700);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(303720, 169);
+
+	#
+	# Firmware 46, type: STD FW    MTS LCD (0x00001004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
+	#
+
+	write_le32(0x00001004);			# Type
+	write_le64(0x00000000, 0x0000b700);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(303896, 169);
+
+	#
+	# Firmware 47, type: STD FW    MTS LCD NOGD (0x00003004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
+	#
+
+	write_le32(0x00003004);			# Type
+	write_le64(0x00000000, 0x0000b700);	# ID
+	write_le32(169);			# Size
+	write_hunk_fix_endian(304072, 169);
+
+	#
+	# Firmware 48, type: SCODE FW  HAS IF (0x60000000), IF = 3.28 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(3280);			# IF
+	write_le32(192);			# Size
+	write_hunk(309048, 192);
+
+	#
+	# Firmware 49, type: SCODE FW  HAS IF (0x60000000), IF = 3.30 MHz id: (0000000000000000), size: 192
+	#
+
+#	write_le32(0x60000000);			# Type
+#	write_le64(0x00000000, 0x00000000);	# ID
+#	write_le16(3300);			# IF
+#	write_le32(192);			# Size
+#	write_hunk(304440, 192);
+
+	#
+	# Firmware 50, type: SCODE FW  HAS IF (0x60000000), IF = 3.44 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(3440);			# IF
+	write_le32(192);			# Size
+	write_hunk(309432, 192);
+
+	#
+	# Firmware 51, type: SCODE FW  HAS IF (0x60000000), IF = 3.46 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(3460);			# IF
+	write_le32(192);			# Size
+	write_hunk(309624, 192);
+
+	#
+	# Firmware 52, type: SCODE FW  DTV6 ATSC OREN36 HAS IF (0x60210020), IF = 3.80 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60210020);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(3800);			# IF
+	write_le32(192);			# Size
+	write_hunk(306936, 192);
+
+	#
+	# Firmware 53, type: SCODE FW  HAS IF (0x60000000), IF = 4.00 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(4000);			# IF
+	write_le32(192);			# Size
+	write_hunk(309240, 192);
+
+	#
+	# Firmware 54, type: SCODE FW  DTV6 ATSC TOYOTA388 HAS IF (0x60410020), IF = 4.08 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60410020);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(4080);			# IF
+	write_le32(192);			# Size
+	write_hunk(307128, 192);
+
+	#
+	# Firmware 55, type: SCODE FW  HAS IF (0x60000000), IF = 4.20 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(4200);			# IF
+	write_le32(192);			# Size
+	write_hunk(308856, 192);
+
+	#
+	# Firmware 56, type: SCODE FW  MONO HAS IF (0x60008000), IF = 4.32 MHz id: NTSC/M Kr (0000000000008000), size: 192
+	#
+
+	write_le32(0x60008000);			# Type
+	write_le64(0x00000000, 0x00008000);	# ID
+	write_le16(4320);			# IF
+	write_le32(192);			# Size
+	write_hunk(305208, 192);
+
+	#
+	# Firmware 57, type: SCODE FW  HAS IF (0x60000000), IF = 4.45 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(4450);			# IF
+	write_le32(192);			# Size
+	write_hunk(309816, 192);
+
+	#
+	# Firmware 58, type: SCODE FW  MTS LCD NOGD MONO IF HAS IF (0x6002b004), IF = 4.50 MHz id: NTSC PAL/M PAL/N (000000000000b700), size: 192
+	#
+
+	write_le32(0x6002b004);			# Type
+	write_le64(0x00000000, 0x0000b700);	# ID
+	write_le16(4500);			# IF
+	write_le32(192);			# Size
+	write_hunk(304824, 192);
+
+	#
+	# Firmware 59, type: SCODE FW  LCD NOGD IF HAS IF (0x60023000), IF = 4.60 MHz id: NTSC/M Kr (0000000000008000), size: 192
+	#
+
+	write_le32(0x60023000);			# Type
+	write_le64(0x00000000, 0x00008000);	# ID
+	write_le16(4600);			# IF
+	write_le32(192);			# Size
+	write_hunk(305016, 192);
+
+	#
+	# Firmware 60, type: SCODE FW  DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 HAS IF (0x620003e0), IF = 4.76 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x620003e0);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(4760);			# IF
+	write_le32(192);			# Size
+	write_hunk(304440, 192);
+
+	#
+	# Firmware 61, type: SCODE FW  HAS IF (0x60000000), IF = 4.94 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(4940);			# IF
+	write_le32(192);			# Size
+	write_hunk(308664, 192);
+
+	#
+	# Firmware 62, type: SCODE FW  HAS IF (0x60000000), IF = 5.26 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(5260);			# IF
+	write_le32(192);			# Size
+	write_hunk(307704, 192);
+
+	#
+	# Firmware 63, type: SCODE FW  MONO HAS IF (0x60008000), IF = 5.32 MHz id: PAL/BG A2 NICAM (0000000f00000007), size: 192
+	#
+
+	write_le32(0x60008000);			# Type
+	write_le64(0x0000000f, 0x00000007);	# ID
+	write_le16(5320);			# IF
+	write_le32(192);			# Size
+	write_hunk(307896, 192);
+
+	#
+	# Firmware 64, type: SCODE FW  DTV7 DTV78 DTV8 DIBCOM52 CHINA HAS IF (0x65000380), IF = 5.40 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x65000380);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(5400);			# IF
+	write_le32(192);			# Size
+	write_hunk(304248, 192);
+
+	#
+	# Firmware 65, type: SCODE FW  DTV6 ATSC OREN538 HAS IF (0x60110020), IF = 5.58 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60110020);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(5580);			# IF
+	write_le32(192);			# Size
+	write_hunk(306744, 192);
+
+	#
+	# Firmware 66, type: SCODE FW  HAS IF (0x60000000), IF = 5.64 MHz id: PAL/BG A2 (0000000300000007), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000003, 0x00000007);	# ID
+	write_le16(5640);			# IF
+	write_le32(192);			# Size
+	write_hunk(305592, 192);
+
+	#
+	# Firmware 67, type: SCODE FW  HAS IF (0x60000000), IF = 5.74 MHz id: PAL/BG NICAM (0000000c00000007), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x0000000c, 0x00000007);	# ID
+	write_le16(5740);			# IF
+	write_le32(192);			# Size
+	write_hunk(305784, 192);
+
+	#
+	# Firmware 68, type: SCODE FW  HAS IF (0x60000000), IF = 5.90 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(5900);			# IF
+	write_le32(192);			# Size
+	write_hunk(307512, 192);
+
+	#
+	# Firmware 69, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.00 MHz id: PAL/DK PAL/I SECAM/K3 SECAM/L SECAM/Lc NICAM (0000000c04c000f0), size: 192
+	#
+
+	write_le32(0x60008000);			# Type
+	write_le64(0x0000000c, 0x04c000f0);	# ID
+	write_le16(6000);			# IF
+	write_le32(192);			# Size
+	write_hunk(305576, 192);
+
+	#
+	# Firmware 70, type: SCODE FW  DTV6 QAM ATSC LG60 F6MHZ HAS IF (0x68050060), IF = 6.20 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x68050060);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(6200);			# IF
+	write_le32(192);			# Size
+	write_hunk(306552, 192);
+
+	#
+	# Firmware 71, type: SCODE FW  HAS IF (0x60000000), IF = 6.24 MHz id: PAL/I (0000000000000010), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00000010);	# ID
+	write_le16(6240);			# IF
+	write_le32(192);			# Size
+	write_hunk(305400, 192);
+
+	#
+	# Firmware 72, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.32 MHz id: SECAM/K1 (0000000000200000), size: 192
+	#
+
+	write_le32(0x60008000);			# Type
+	write_le64(0x00000000, 0x00200000);	# ID
+	write_le16(6320);			# IF
+	write_le32(192);			# Size
+	write_hunk(308472, 192);
+
+	#
+	# Firmware 73, type: SCODE FW  HAS IF (0x60000000), IF = 6.34 MHz id: SECAM/K1 (0000000000200000), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000000, 0x00200000);	# ID
+	write_le16(6340);			# IF
+	write_le32(192);			# Size
+	write_hunk(306360, 192);
+
+	#
+	# Firmware 74, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.50 MHz id: PAL/DK SECAM/K3 SECAM/L NICAM (0000000c044000e0), size: 192
+	#
+
+	write_le32(0x60008000);			# Type
+	write_le64(0x0000000c, 0x044000e0);	# ID
+	write_le16(6500);			# IF
+	write_le32(192);			# Size
+	write_hunk(308280, 192);
+
+	#
+	# Firmware 75, type: SCODE FW  DTV6 ATSC ATI638 HAS IF (0x60090020), IF = 6.58 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60090020);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(6580);			# IF
+	write_le32(192);			# Size
+	write_hunk(304632, 192);
+
+	#
+	# Firmware 76, type: SCODE FW  HAS IF (0x60000000), IF = 6.60 MHz id: PAL/DK A2 (00000003000000e0), size: 192
+	#
+
+	write_le32(0x60000000);			# Type
+	write_le64(0x00000003, 0x000000e0);	# ID
+	write_le16(6600);			# IF
+	write_le32(192);			# Size
+	write_hunk(306168, 192);
+
+	#
+	# Firmware 77, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.68 MHz id: PAL/DK A2 (00000003000000e0), size: 192
+	#
+
+	write_le32(0x60008000);			# Type
+	write_le64(0x00000003, 0x000000e0);	# ID
+	write_le16(6680);			# IF
+	write_le32(192);			# Size
+	write_hunk(308088, 192);
+
+	#
+	# Firmware 78, type: SCODE FW  DTV6 ATSC TOYOTA794 HAS IF (0x60810020), IF = 8.14 MHz id: (0000000000000000), size: 192
+	#
+
+	write_le32(0x60810020);			# Type
+	write_le64(0x00000000, 0x00000000);	# ID
+	write_le16(8140);			# IF
+	write_le32(192);			# Size
+	write_hunk(307320, 192);
+
+	#
+	# Firmware 79, type: SCODE FW  HAS IF (0x60000000), IF = 8.20 MHz id: (0000000000000000), size: 192
+	#
+
+#	write_le32(0x60000000);			# Type
+#	write_le64(0x00000000, 0x00000000);	# ID
+#	write_le16(8200);			# IF
+#	write_le32(192);			# Size
+#	write_hunk(308088, 192);
 }
 
+sub main_firmware_27($$$$)
+{
+	my $out;
+	my $j=0;
+	my $outfile = shift;
+	my $name    = shift;
+	my $version = shift;
+	my $nr_desc = shift;
+
+	for ($j = length($name); $j <32; $j++) {
+		$name = $name.chr(0);
+	}
+
 	open OUTFILE, ">$outfile";
 	syswrite(OUTFILE, $name);
 	write_le16($version);
@@ -906,20 +1678,39 @@
 	write_hunk(812856, 192);
 }
 
+
 sub extract_firmware {
-	my $sourcefile = "hcw85bda.sys";
-	my $hash = "0e44dbf63bb0169d57446aec21881ff2";
-	my $outfile = "xc3028-v27.fw";
-	my $name = "xc2028 firmware";
-	my $version = 519;
-	my $nr_desc = 80;
+	my $sourcefile_24 = "UDXTTM6000.sys";
+	my $hash_24 = "cb9deb5508a5e150af2880f5b0066d78";
+	my $outfile_24 = "xc3028-v24.fw";
+	my $name_24 = "xc2028 firmware";
+	my $version_24 = 516;
+	my $nr_desc_24 = 77;
 	my $out;
 
-	verify($sourcefile, $hash);
+	my $sourcefile_27 = "hcw85bda.sys";
+	my $hash_27 = "0e44dbf63bb0169d57446aec21881ff2";
+	my $outfile_27 = "xc3028-v27.fw";
+	my $name_27 = "xc2028 firmware";
+	my $version_27 = 519;
+	my $nr_desc_27 = 80;
+	my $out;
 
-	open INFILE, "<$sourcefile";
-	main_firmware($outfile, $name, $version, $nr_desc);
-	close INFILE;
+	if (-e $sourcefile_24) {
+		verify($sourcefile_24, $hash_24);
+
+		open INFILE, "<$sourcefile_24";
+		main_firmware_24($outfile_24, $name_24, $version_24, $nr_desc_24);
+		close INFILE;
+	}
+
+	if (-e $sourcefile_27) {
+		verify($sourcefile_27, $hash_27);
+
+		open INFILE, "<$sourcefile_27";
+		main_firmware_27($outfile_27, $name_27, $version_27, $nr_desc_27);
+		close INFILE;
+	}
 }
 
 extract_firmware;

--------------030000050301020100010005--
