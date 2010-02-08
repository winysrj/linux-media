Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:35273 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948Ab0BHRLV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 12:11:21 -0500
Message-ID: <4B704593.6040201@arcor.de>
Date: Mon, 08 Feb 2010 18:10:43 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 11/12] tm6000: bugfix firmware xc3028L-v36.fw used with
 Zarlink and DTV78 or DTV8 no shift
References: <1265411214-12231-10-git-send-email-stefan.ringel@arcor.de> <1265411214-12231-11-git-send-email-stefan.ringel@arcor.de> <4B6FF51F.9080507@redhat.com>
In-Reply-To: <4B6FF51F.9080507@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000409060009030107040102"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000409060009030107040102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 08.02.2010 12:27, schrieb Mauro Carvalho Chehab:
> stefan.ringel@arcor.de wrote:
>   
>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>> ---
>>  drivers/media/common/tuners/tuner-xc2028.c |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
>> index ed50168..fcf19cc 100644
>> --- a/drivers/media/common/tuners/tuner-xc2028.c
>> +++ b/drivers/media/common/tuners/tuner-xc2028.c
>> @@ -1114,7 +1114,12 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>>  
>>  	/* All S-code tables need a 200kHz shift */
>>  	if (priv->ctrl.demod) {
>> -		demod = priv->ctrl.demod + 200;
>> +		if ((strcmp (priv->ctrl.fname, "xc3028L-v36.fw") == 0) && 
>> +			(priv->ctrl.demod == XC3028_FE_ZARLINK456) &&
>> +				((type & DTV78) || (type & DTV8)))
>> +			demod = priv->ctrl.demod;
>> +		else
>> +			demod = priv->ctrl.demod + 200;
>>  		/*
>>  		 * The DTV7 S-code table needs a 700 kHz shift.
>>  		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
>>     
> The idea behind this patch is right, but you should be testing it against
> priv->firm_version, instead comparing with a file name.
>
> Also, this will likely cause regressions on other drivers, since the offsets for
> v3.6 firmwares were handled on a different way on other drivers. I prefer to postpone
> this patch and the discussion behind it after having tm6000 driver ready, since
> it makes no sense to cause regressions or request changes on existing drivers due
> to a driver that is not ready yet.
>
> So, please hold your patch on your queue for now.
>
> My suggestion is that you should use git and have this patch on a separate branch where you
> do your tests, having a branch without this patch for upstream submission.
>
>   
In this firmware is for ZARLINK two parts, first for QAM, DTV6 and DTV7
with shift 200 kHz, and second for DTV78 and DTV8. I check the firmware
2.7 this use for ZARLINK for all this mode a 200 kHz shift. For the next
source part it says that DTV7 have 700 kHz shift.
That not for all firmware correct.

-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------000409060009030107040102
Content-Type: text/plain;
 name="firmware-v27.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="firmware-v27.txt"

list action

firmware file name: xc3028-v27.fw
firmware name:	xc2028 firmware
version:	2.7 (519)
standards:	80
Firmware  0, type: BASE FW   F8MHZ (0x00000003), id: (0000000000000000), size: 8718
Firmware  1, type: BASE FW   F8MHZ MTS (0x00000007), id: (0000000000000000), size: 8712
Firmware  2, type: BASE FW   FM (0x00000401), id: (0000000000000000), size: 8562
Firmware  3, type: BASE FW   FM INPUT1 (0x00000c01), id: (0000000000000000), size: 8576
Firmware  4, type: BASE FW   (0x00000001), id: (0000000000000000), size: 8706
Firmware  5, type: BASE FW   MTS (0x00000005), id: (0000000000000000), size: 8682
Firmware  6, type: STD FW    (0x00000000), id: PAL/BG A2/A (0000000100000007), size: 161
Firmware  7, type: STD FW    MTS (0x00000004), id: PAL/BG A2/A (0000000100000007), size: 169
Firmware  8, type: STD FW    (0x00000000), id: PAL/BG A2/B (0000000200000007), size: 161
Firmware  9, type: STD FW    MTS (0x00000004), id: PAL/BG A2/B (0000000200000007), size: 169
Firmware 10, type: STD FW    (0x00000000), id: PAL/BG NICAM/A (0000000400000007), size: 161
Firmware 11, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/A (0000000400000007), size: 169
Firmware 12, type: STD FW    (0x00000000), id: PAL/BG NICAM/B (0000000800000007), size: 161
Firmware 13, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/B (0000000800000007), size: 169
Firmware 14, type: STD FW    (0x00000000), id: PAL/DK A2 (00000003000000e0), size: 161
Firmware 15, type: STD FW    MTS (0x00000004), id: PAL/DK A2 (00000003000000e0), size: 169
Firmware 16, type: STD FW    (0x00000000), id: PAL/DK NICAM (0000000c000000e0), size: 161
Firmware 17, type: STD FW    MTS (0x00000004), id: PAL/DK NICAM (0000000c000000e0), size: 169
Firmware 18, type: STD FW    (0x00000000), id: SECAM/K1 (0000000000200000), size: 161
Firmware 19, type: STD FW    MTS (0x00000004), id: SECAM/K1 (0000000000200000), size: 169
Firmware 20, type: STD FW    (0x00000000), id: SECAM/K3 (0000000004000000), size: 161
Firmware 21, type: STD FW    MTS (0x00000004), id: SECAM/K3 (0000000004000000), size: 169
Firmware 22, type: STD FW    D2633 DTV6 ATSC (0x00010030), id: (0000000000000000), size: 149
Firmware 23, type: STD FW    D2620 DTV6 QAM (0x00000068), id: (0000000000000000), size: 149
Firmware 24, type: STD FW    D2633 DTV6 QAM (0x00000070), id: (0000000000000000), size: 149
Firmware 25, type: STD FW    D2620 DTV7 (0x00000088), id: (0000000000000000), size: 149
Firmware 26, type: STD FW    D2633 DTV7 (0x00000090), id: (0000000000000000), size: 149
Firmware 27, type: STD FW    D2620 DTV78 (0x00000108), id: (0000000000000000), size: 149
Firmware 28, type: STD FW    D2633 DTV78 (0x00000110), id: (0000000000000000), size: 149
Firmware 29, type: STD FW    D2620 DTV8 (0x00000208), id: (0000000000000000), size: 149
Firmware 30, type: STD FW    D2633 DTV8 (0x00000210), id: (0000000000000000), size: 149
Firmware 31, type: STD FW    FM (0x00000400), id: (0000000000000000), size: 135
Firmware 32, type: STD FW    (0x00000000), id: PAL/I (0000000000000010), size: 161
Firmware 33, type: STD FW    MTS (0x00000004), id: PAL/I (0000000000000010), size: 169
Firmware 34, type: STD FW    (0x00000000), id: SECAM/L AM (0000001000400000), size: 169
Firmware 35, type: STD FW    (0x00000000), id: SECAM/L NICAM (0000000c00400000), size: 161
Firmware 36, type: STD FW    (0x00000000), id: SECAM/Lc (0000000000800000), size: 161
Firmware 37, type: STD FW    (0x00000000), id: NTSC/M Kr (0000000000008000), size: 161
Firmware 38, type: STD FW    LCD (0x00001000), id: NTSC/M Kr (0000000000008000), size: 161
Firmware 39, type: STD FW    LCD NOGD (0x00003000), id: NTSC/M Kr (0000000000008000), size: 161
Firmware 40, type: STD FW    MTS (0x00000004), id: NTSC/M Kr (0000000000008000), size: 169
Firmware 41, type: STD FW    (0x00000000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
Firmware 42, type: STD FW    LCD (0x00001000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
Firmware 43, type: STD FW    LCD NOGD (0x00003000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
Firmware 44, type: STD FW    (0x00000000), id: NTSC/M Jp (0000000000002000), size: 161
Firmware 45, type: STD FW    MTS (0x00000004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
Firmware 46, type: STD FW    MTS LCD (0x00001004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
Firmware 47, type: STD FW    MTS LCD NOGD (0x00003004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
Firmware 48, type: SCODE FW  HAS IF (0x60000000), IF = 3.28 MHz id: (0000000000000000), size: 192
Firmware 49, type: SCODE FW  HAS IF (0x60000000), IF = 3.30 MHz id: (0000000000000000), size: 192
Firmware 50, type: SCODE FW  HAS IF (0x60000000), IF = 3.44 MHz id: (0000000000000000), size: 192
Firmware 51, type: SCODE FW  HAS IF (0x60000000), IF = 3.46 MHz id: (0000000000000000), size: 192
Firmware 52, type: SCODE FW  DTV6 ATSC OREN36 HAS IF (0x60210020), IF = 3.80 MHz id: (0000000000000000), size: 192
Firmware 53, type: SCODE FW  HAS IF (0x60000000), IF = 4.00 MHz id: (0000000000000000), size: 192
Firmware 54, type: SCODE FW  DTV6 ATSC TOYOTA388 HAS IF (0x60410020), IF = 4.08 MHz id: (0000000000000000), size: 192
Firmware 55, type: SCODE FW  HAS IF (0x60000000), IF = 4.20 MHz id: (0000000000000000), size: 192
Firmware 56, type: SCODE FW  MONO HAS IF (0x60008000), IF = 4.32 MHz id: NTSC/M Kr (0000000000008000), size: 192
Firmware 57, type: SCODE FW  HAS IF (0x60000000), IF = 4.45 MHz id: (0000000000000000), size: 192
Firmware 58, type: SCODE FW  MTS LCD NOGD MONO IF HAS IF (0x6002b004), IF = 4.50 MHz id: NTSC PAL/M PAL/N (000000000000b700), size: 192
Firmware 59, type: SCODE FW  LCD NOGD IF HAS IF (0x60023000), IF = 4.60 MHz id: NTSC/M Kr (0000000000008000), size: 192
Firmware 60, type: SCODE FW  DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 HAS IF (0x620003e0), IF = 4.76 MHz id: (0000000000000000), size: 192
Firmware 61, type: SCODE FW  HAS IF (0x60000000), IF = 4.94 MHz id: (0000000000000000), size: 192
Firmware 62, type: SCODE FW  HAS IF (0x60000000), IF = 5.26 MHz id: (0000000000000000), size: 192
Firmware 63, type: SCODE FW  MONO HAS IF (0x60008000), IF = 5.32 MHz id: PAL/BG A2 NICAM (0000000f00000007), size: 192
Firmware 64, type: SCODE FW  DTV7 DTV78 DTV8 DIBCOM52 CHINA HAS IF (0x65000380), IF = 5.40 MHz id: (0000000000000000), size: 192
Firmware 65, type: SCODE FW  DTV6 ATSC OREN538 HAS IF (0x60110020), IF = 5.58 MHz id: (0000000000000000), size: 192
Firmware 66, type: SCODE FW  HAS IF (0x60000000), IF = 5.64 MHz id: PAL/BG A2 (0000000300000007), size: 192
Firmware 67, type: SCODE FW  HAS IF (0x60000000), IF = 5.74 MHz id: PAL/BG NICAM (0000000c00000007), size: 192
Firmware 68, type: SCODE FW  HAS IF (0x60000000), IF = 5.90 MHz id: (0000000000000000), size: 192
Firmware 69, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.00 MHz id: PAL/DK PAL/I SECAM/K3 SECAM/L SECAM/Lc NICAM (0000000c04c000f0), size: 192
Firmware 70, type: SCODE FW  DTV6 QAM ATSC LG60 F6MHZ HAS IF (0x68050060), IF = 6.20 MHz id: (0000000000000000), size: 192
Firmware 71, type: SCODE FW  HAS IF (0x60000000), IF = 6.24 MHz id: PAL/I (0000000000000010), size: 192
Firmware 72, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.32 MHz id: SECAM/K1 (0000000000200000), size: 192
Firmware 73, type: SCODE FW  HAS IF (0x60000000), IF = 6.34 MHz id: SECAM/K1 (0000000000200000), size: 192
Firmware 74, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.50 MHz id: PAL/DK SECAM/K3 SECAM/L NICAM (0000000c044000e0), size: 192
Firmware 75, type: SCODE FW  DTV6 ATSC ATI638 HAS IF (0x60090020), IF = 6.58 MHz id: (0000000000000000), size: 192
Firmware 76, type: SCODE FW  HAS IF (0x60000000), IF = 6.60 MHz id: PAL/DK A2 (00000003000000e0), size: 192
Firmware 77, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.68 MHz id: PAL/DK A2 (00000003000000e0), size: 192
Firmware 78, type: SCODE FW  DTV6 ATSC TOYOTA794 HAS IF (0x60810020), IF = 8.14 MHz id: (0000000000000000), size: 192
Firmware 79, type: SCODE FW  HAS IF (0x60000000), IF = 8.20 MHz id: (0000000000000000), size: 192

--------------000409060009030107040102
Content-Type: text/plain;
 name="firmware-v36.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="firmware-v36.txt"

list action

firmware file name: xc3028L-v36.fw
firmware name:	xc2028 firmware
version:	3.6 (774)
standards:	81
Firmware  0, type: BASE FW   F8MHZ (0x00000003), id: (0000000000000000), size: 9144
Firmware  1, type: BASE FW   F8MHZ MTS (0x00000007), id: (0000000000000000), size: 9030
Firmware  2, type: BASE FW   FM (0x00000401), id: (0000000000000000), size: 9054
Firmware  3, type: BASE FW   FM INPUT1 (0x00000c01), id: (0000000000000000), size: 9068
Firmware  4, type: BASE FW   (0x00000001), id: (0000000000000000), size: 9132
Firmware  5, type: BASE FW   MTS (0x00000005), id: (0000000000000000), size: 9006
Firmware  6, type: STD FW    (0x00000000), id: PAL/BG (0000000000000007), size: 161
Firmware  7, type: STD FW    MTS (0x00000004), id: PAL/BG (0000000000000007), size: 169
Firmware  8, type: STD FW    (0x00000000), id: PAL/BG (0000000000000007), size: 161
Firmware  9, type: STD FW    MTS (0x00000004), id: PAL/BG (0000000000000007), size: 169
Firmware 10, type: STD FW    (0x00000000), id: PAL/BG (0000000000000007), size: 161
Firmware 11, type: STD FW    MTS (0x00000004), id: PAL/BG (0000000000000007), size: 169
Firmware 12, type: STD FW    (0x00000000), id: PAL/BG (0000000000000007), size: 161
Firmware 13, type: STD FW    MTS (0x00000004), id: PAL/BG (0000000000000007), size: 169
Firmware 14, type: STD FW    (0x00000000), id: PAL/DK (00000000000000e0), size: 161
Firmware 15, type: STD FW    MTS (0x00000004), id: PAL/DK (00000000000000e0), size: 169
Firmware 16, type: STD FW    (0x00000000), id: PAL/DK (00000000000000e0), size: 161
Firmware 17, type: STD FW    MTS (0x00000004), id: PAL/DK (00000000000000e0), size: 169
Firmware 18, type: STD FW    (0x00000000), id: SECAM/K1 (0000000000200000), size: 161
Firmware 19, type: STD FW    MTS (0x00000004), id: SECAM/K1 (0000000000200000), size: 169
Firmware 20, type: STD FW    (0x00000000), id: SECAM/K3 (0000000004000000), size: 161
Firmware 21, type: STD FW    MTS (0x00000004), id: SECAM/K3 (0000000004000000), size: 169
Firmware 22, type: STD FW    D2633 DTV6 ATSC (0x00010030), id: (0000000000000000), size: 149
Firmware 23, type: STD FW    D2620 DTV6 QAM (0x00000068), id: (0000000000000000), size: 149
Firmware 24, type: STD FW    D2633 DTV6 QAM (0x00000070), id: (0000000000000000), size: 149
Firmware 25, type: STD FW    D2620 DTV7 (0x00000088), id: (0000000000000000), size: 149
Firmware 26, type: STD FW    D2633 DTV7 (0x00000090), id: (0000000000000000), size: 149
Firmware 27, type: STD FW    D2620 DTV78 (0x00000108), id: (0000000000000000), size: 149
Firmware 28, type: STD FW    D2633 DTV78 (0x00000110), id: (0000000000000000), size: 149
Firmware 29, type: STD FW    D2620 DTV8 (0x00000208), id: (0000000000000000), size: 149
Firmware 30, type: STD FW    D2633 DTV8 (0x00000210), id: (0000000000000000), size: 149
Firmware 31, type: STD FW    FM (0x00000400), id: (0000000000000000), size: 135
Firmware 32, type: STD FW    (0x00000000), id: PAL/I (0000000000000010), size: 161
Firmware 33, type: STD FW    MTS (0x00000004), id: PAL/I (0000000000000010), size: 169
Firmware 34, type: STD FW    (0x00000000), id: SECAM/L (0000000000400000), size: 161
Firmware 35, type: STD FW    (0x00000000), id: SECAM/Lc (0000000000800000), size: 161
Firmware 36, type: STD FW    (0x00000000), id: NTSC/M Kr (0000000000008000), size: 161
Firmware 37, type: STD FW    LCD (0x00001000), id: NTSC/M Kr (0000000000008000), size: 161
Firmware 38, type: STD FW    LCD NOGD (0x00003000), id: NTSC/M Kr (0000000000008000), size: 161
Firmware 39, type: STD FW    MTS (0x00000004), id: NTSC/M Kr (0000000000008000), size: 169
Firmware 40, type: STD FW    (0x00000000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
Firmware 41, type: STD FW    LCD (0x00001000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
Firmware 42, type: STD FW    LCD NOGD (0x00003000), id: NTSC PAL/M PAL/N (000000000000b700), size: 161
Firmware 43, type: STD FW    (0x00000000), id: NTSC/M Jp (0000000000002000), size: 161
Firmware 44, type: STD FW    MTS (0x00000004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
Firmware 45, type: STD FW    MTS LCD (0x00001004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
Firmware 46, type: STD FW    MTS LCD NOGD (0x00003004), id: NTSC PAL/M PAL/N (000000000000b700), size: 169
Firmware 47, type: SCODE FW  HAS IF (0x60000000), IF = 3.28 MHz id: (0000000000000000), size: 192
Firmware 48, type: SCODE FW  HAS IF (0x60000000), IF = 3.30 MHz id: (0000000000000000), size: 192
Firmware 49, type: SCODE FW  HAS IF (0x60000000), IF = 3.44 MHz id: (0000000000000000), size: 192
Firmware 50, type: SCODE FW  HAS IF (0x60000000), IF = 3.46 MHz id: (0000000000000000), size: 192
Firmware 51, type: SCODE FW  DTV6 ATSC OREN36 HAS IF (0x60210020), IF = 3.80 MHz id: (0000000000000000), size: 192
Firmware 52, type: SCODE FW  HAS IF (0x60000000), IF = 4.00 MHz id: (0000000000000000), size: 192
Firmware 53, type: SCODE FW  DTV6 ATSC TOYOTA388 HAS IF (0x60410020), IF = 4.08 MHz id: (0000000000000000), size: 192
Firmware 54, type: SCODE FW  HAS IF (0x60000000), IF = 4.20 MHz id: (0000000000000000), size: 192
Firmware 55, type: SCODE FW  MONO HAS IF (0x60008000), IF = 4.32 MHz id: NTSC/M Kr (0000000000008000), size: 192
Firmware 56, type: SCODE FW  HAS IF (0x60000000), IF = 4.45 MHz id: (0000000000000000), size: 192
Firmware 57, type: SCODE FW  MTS LCD NOGD MONO IF HAS IF (0x6002b004), IF = 4.50 MHz id: NTSC PAL/M PAL/N (000000000000b700), size: 192
Firmware 58, type: SCODE FW  DTV78 DTV8 ZARLINK456 HAS IF (0x62000300), IF = 4.56 MHz id: (0000000000000000), size: 192
Firmware 59, type: SCODE FW  LCD NOGD IF HAS IF (0x60023000), IF = 4.60 MHz id: NTSC/M Kr (0000000000008000), size: 192
Firmware 60, type: SCODE FW  DTV6 QAM DTV7 ZARLINK456 HAS IF (0x620000e0), IF = 4.76 MHz id: (0000000000000000), size: 192
Firmware 61, type: SCODE FW  HAS IF (0x60000000), IF = 4.94 MHz id: (0000000000000000), size: 192
Firmware 62, type: SCODE FW  DTV78 DTV8 DIBCOM52 HAS IF (0x61000300), IF = 5.20 MHz id: (0000000000000000), size: 192
Firmware 63, type: SCODE FW  HAS IF (0x60000000), IF = 5.26 MHz id: (0000000000000000), size: 192
Firmware 64, type: SCODE FW  MONO HAS IF (0x60008000), IF = 5.32 MHz id: PAL/BG (0000000000000007), size: 192
Firmware 65, type: SCODE FW  DTV7 DTV8 DIBCOM52 CHINA HAS IF (0x65000280), IF = 5.40 MHz id: (0000000000000000), size: 192
Firmware 66, type: SCODE FW  DTV6 ATSC OREN538 HAS IF (0x60110020), IF = 5.58 MHz id: (0000000000000000), size: 192
Firmware 67, type: SCODE FW  HAS IF (0x60000000), IF = 5.64 MHz id: PAL/BG (0000000000000007), size: 192
Firmware 68, type: SCODE FW  HAS IF (0x60000000), IF = 5.74 MHz id: PAL/BG (0000000000000007), size: 192
Firmware 69, type: SCODE FW  HAS IF (0x60000000), IF = 5.90 MHz id: (0000000000000000), size: 192
Firmware 70, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.00 MHz id: PAL/DK PAL/I SECAM/K3 SECAM/L SECAM/Lc (0000000004c000f0), size: 192
Firmware 71, type: SCODE FW  DTV6 QAM ATSC LG60 F6MHZ HAS IF (0x68050060), IF = 6.20 MHz id: (0000000000000000), size: 192
Firmware 72, type: SCODE FW  HAS IF (0x60000000), IF = 6.24 MHz id: PAL/I (0000000000000010), size: 192
Firmware 73, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.32 MHz id: SECAM/K1 (0000000000200000), size: 192
Firmware 74, type: SCODE FW  HAS IF (0x60000000), IF = 6.34 MHz id: SECAM/K1 (0000000000200000), size: 192
Firmware 75, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.50 MHz id: PAL/DK SECAM/K3 (00000000040000e0), size: 192
Firmware 76, type: SCODE FW  DTV6 ATSC ATI638 HAS IF (0x60090020), IF = 6.58 MHz id: (0000000000000000), size: 192
Firmware 77, type: SCODE FW  HAS IF (0x60000000), IF = 6.60 MHz id: PAL/DK (00000000000000e0), size: 192
Firmware 78, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.68 MHz id: PAL/DK (00000000000000e0), size: 192
Firmware 79, type: SCODE FW  DTV6 ATSC TOYOTA794 HAS IF (0x60810020), IF = 8.14 MHz id: (0000000000000000), size: 192
Firmware 80, type: SCODE FW  HAS IF (0x60000000), IF = 8.20 MHz id: (0000000000000000), size: 192

--------------000409060009030107040102--
