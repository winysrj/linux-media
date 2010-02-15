Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:51496 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103Ab0BOTUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 14:20:41 -0500
Message-ID: <4B799E5B.8090208@arcor.de>
Date: Mon, 15 Feb 2010 20:19:55 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 01/11] xc2028: tm6000: bugfix firmware xc3028L-v36.fw
 used 	with Zarlink and DTV78 or DTV8 no shift
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de> <829197381002151036w2cbfa8f7t59fc097f9c692631@mail.gmail.com>
In-Reply-To: <829197381002151036w2cbfa8f7t59fc097f9c692631@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000200050303000605040603"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000200050303000605040603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 15.02.2010 19:36, schrieb Devin Heitmueller:
> On Mon, Feb 15, 2010 at 12:37 PM,  <stefan.ringel@arcor.de> wrote:
>   
>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
>> index ed50168..e051caa 100644
>> --- a/drivers/media/common/tuners/tuner-xc2028.c
>> +++ b/drivers/media/common/tuners/tuner-xc2028.c
>> @@ -1114,7 +1114,12 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>>
>>        /* All S-code tables need a 200kHz shift */
>>        if (priv->ctrl.demod) {
>> -               demod = priv->ctrl.demod + 200;
>> +               if ((priv->firm_version == 0x0306) &&
>> +                       (priv->ctrl.demod == XC3028_FE_ZARLINK456) &&
>> +                               ((type & DTV78) || (type & DTV8)))
>> +                       demod = priv->ctrl.demod;
>> +               else
>> +                       demod = priv->ctrl.demod + 200;
>>                /*
>>                 * The DTV7 S-code table needs a 700 kHz shift.
>>                 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
>>     
> I would still like to better understand the origin of this change.
> Was the tm6000 board not locking without it?  Was this change based on
> any documented source?  What basis are you using when deciding this
> issue is specific only to the zl10353 and not all boards using the
> xc3028L?
>
> We've got a number of boards already supported which use the xc3028L,
> so we need to ensure there is no regression introduced in those boards
> just to get yours working.
>
> Devin
>
>   
Devin here in attachment the firmware table. You see, that it is has two
entries  for ZARLINK456, one for QAM, DTV6 and DTV7, and one for DTV78
and DTV8. The first have a shift from +200, the second doesn't. I can
test for you without this patch to see what for demodulator status is has.

Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------000200050303000605040603
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

--------------000200050303000605040603--
