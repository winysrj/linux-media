Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32801 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1LJSBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 13:01:46 -0500
Received: by eekc4 with SMTP id c4so885691eek.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 10:01:45 -0800 (PST)
Message-ID: <4EE39E86.2000404@gmail.com>
Date: Sat, 10 Dec 2011 19:01:42 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/1] xc3028: fix center frequency calculation for DTV78
 firmware
References: <4EE0B419.3070604@gmail.com> <4EE37207.4010100@redhat.com>
In-Reply-To: <4EE37207.4010100@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 10/12/2011 15:51, Mauro Carvalho Chehab ha scritto:
> On 08-12-2011 10:56, Gianluca Gennari wrote:
>> Hi all,
>> this patch replaces the previous one proposed in the thread "xc3028:
>> force reload of DTV7 firmware in VHF band with Zarlink demodulator".
>> The problem is that the firmware DTV78 works fine in UHF band (8 MHz
>> bandwidth) but is not working at all in VHF band (7 MHz bandwidth).
>> Reading the comments inside the code, I figured out that the real
>> problem could be connected to the formula used to calculate the center
>> frequency offset in VHF band.
>>
>> In fact, removing this adjustment fixed the problem:
>>
>>         if ((priv->cur_fw.type&  DTV78)&&  freq<  470000000)
>>             offset -= 500000;
>>
>> This is coherent to what was implemented for the DTV7 firmware by an
>> Australian user:
>>
>>         if (priv->cur_fw.type&  DTV7)
>>             offset += 500000;
>>
>> In the end, the center frequency is the same for all firmwares (DTV7,
>> DTV8, DTV78) and for both 7 and 8 MHz bandwidth.
>> Probably, a further offset is hardcoded directly into the firmwares, to
>> compensate the difference between 7 and 8 MHz bandwidth.
>>
>> The final code looks clean and simple, and there is no need for any
>> "magic" adjustment:
>>
>>         if (priv->cur_fw.type&  DTV6)
>>             offset = 1750000;
>>         else    /* DTV7 or DTV8 or DTV78 */
>>             offset = 2750000;
> 
> 
> The above comment is better than the one inside the patch. Just add it
> there
> when submitting the final review.
> 
> Yet, I don't think this is right, at least for firmware 2.7 and bellow.
> 
> What happens with xc3028 devices is that the frequency of the DLL is set
> to a
> "reference" frequency, and not to the center frequency. The reference
> frequency
> is 1.25 MHz after the lower frequency.
> 
> The standard-specific firmwares could also have an extra offset, as well
> as the
> S-CODE tables. In general, the offset for them are 200 kHz, but it seems
> that
> 
> Not sure if you're aware, but you can look on each firmware with an
> userspace tool
> that is part of v4l-utils:
> 
> ~/v4l-utils/utils/xc3028-firmware $ ./firmware-tool --list
> /lib/firmware/xc3028-v27.fw
> list action
> 
> firmware file name: /lib/firmware/xc3028-v27.fw
> firmware name:    xc2028 firmware
> version:    2.7 (519)
> standards:    80
> Firmware  0, type: BASE FW   F8MHZ (0x00000003), id: (0000000000000000),
> size: 8718
> Firmware  1, type: BASE FW   F8MHZ MTS (0x00000007), id:
> (0000000000000000), size: 8712
> Firmware  2, type: BASE FW   FM (0x00000401), id: (0000000000000000),
> size: 8562
> Firmware  3, type: BASE FW   FM INPUT1 (0x00000c01), id:
> (0000000000000000), size: 8576
> Firmware  4, type: BASE FW   (0x00000001), id: (0000000000000000), size:
> 8706
> Firmware  5, type: BASE FW   MTS (0x00000005), id: (0000000000000000),
> size: 8682
> Firmware  6, type: STD FW    (0x00000000), id: PAL/BG A2/A
> (0000000100000007), size: 161
> Firmware  7, type: STD FW    MTS (0x00000004), id: PAL/BG A2/A
> (0000000100000007), size: 169
> Firmware  8, type: STD FW    (0x00000000), id: PAL/BG A2/B
> (0000000200000007), size: 161
> Firmware  9, type: STD FW    MTS (0x00000004), id: PAL/BG A2/B
> (0000000200000007), size: 169
> Firmware 10, type: STD FW    (0x00000000), id: PAL/BG NICAM/A
> (0000000400000007), size: 161
> Firmware 11, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/A
> (0000000400000007), size: 169
> Firmware 12, type: STD FW    (0x00000000), id: PAL/BG NICAM/B
> (0000000800000007), size: 161
> Firmware 13, type: STD FW    MTS (0x00000004), id: PAL/BG NICAM/B
> (0000000800000007), size: 169
> Firmware 14, type: STD FW    (0x00000000), id: PAL/DK A2
> (00000003000000e0), size: 161
> Firmware 15, type: STD FW    MTS (0x00000004), id: PAL/DK A2
> (00000003000000e0), size: 169
> Firmware 16, type: STD FW    (0x00000000), id: PAL/DK NICAM
> (0000000c000000e0), size: 161
> Firmware 17, type: STD FW    MTS (0x00000004), id: PAL/DK NICAM
> (0000000c000000e0), size: 169
> Firmware 18, type: STD FW    (0x00000000), id: SECAM/K1
> (0000000000200000), size: 161
> Firmware 19, type: STD FW    MTS (0x00000004), id: SECAM/K1
> (0000000000200000), size: 169
> Firmware 20, type: STD FW    (0x00000000), id: SECAM/K3
> (0000000004000000), size: 161
> Firmware 21, type: STD FW    MTS (0x00000004), id: SECAM/K3
> (0000000004000000), size: 169
> Firmware 22, type: STD FW    D2633 DTV6 ATSC (0x00010030), id:
> (0000000000000000), size: 149
> Firmware 23, type: STD FW    D2620 DTV6 QAM (0x00000068), id:
> (0000000000000000), size: 149
> Firmware 24, type: STD FW    D2633 DTV6 QAM (0x00000070), id:
> (0000000000000000), size: 149
> Firmware 25, type: STD FW    D2620 DTV7 (0x00000088), id:
> (0000000000000000), size: 149
> Firmware 26, type: STD FW    D2633 DTV7 (0x00000090), id:
> (0000000000000000), size: 149
> Firmware 27, type: STD FW    D2620 DTV78 (0x00000108), id:
> (0000000000000000), size: 149
> Firmware 28, type: STD FW    D2633 DTV78 (0x00000110), id:
> (0000000000000000), size: 149
> Firmware 29, type: STD FW    D2620 DTV8 (0x00000208), id:
> (0000000000000000), size: 149
> Firmware 30, type: STD FW    D2633 DTV8 (0x00000210), id:
> (0000000000000000), size: 149
> Firmware 31, type: STD FW    FM (0x00000400), id: (0000000000000000),
> size: 135
> Firmware 32, type: STD FW    (0x00000000), id: PAL/I (0000000000000010),
> size: 161
> Firmware 33, type: STD FW    MTS (0x00000004), id: PAL/I
> (0000000000000010), size: 169
> Firmware 34, type: STD FW    (0x00000000), id: SECAM/L AM
> (0000001000400000), size: 169
> Firmware 35, type: STD FW    (0x00000000), id: SECAM/L NICAM
> (0000000c00400000), size: 161
> Firmware 36, type: STD FW    (0x00000000), id: SECAM/Lc
> (0000000000800000), size: 161
> Firmware 37, type: STD FW    (0x00000000), id: NTSC/M Kr
> (0000000000008000), size: 161
> Firmware 38, type: STD FW    LCD (0x00001000), id: NTSC/M Kr
> (0000000000008000), size: 161
> Firmware 39, type: STD FW    LCD NOGD (0x00003000), id: NTSC/M Kr
> (0000000000008000), size: 161
> Firmware 40, type: STD FW    MTS (0x00000004), id: NTSC/M Kr
> (0000000000008000), size: 169
> Firmware 41, type: STD FW    (0x00000000), id: NTSC PAL/M PAL/N
> (000000000000b700), size: 161
> Firmware 42, type: STD FW    LCD (0x00001000), id: NTSC PAL/M PAL/N
> (000000000000b700), size: 161
> Firmware 43, type: STD FW    LCD NOGD (0x00003000), id: NTSC PAL/M PAL/N
> (000000000000b700), size: 161
> Firmware 44, type: STD FW    (0x00000000), id: NTSC/M Jp
> (0000000000002000), size: 161
> Firmware 45, type: STD FW    MTS (0x00000004), id: NTSC PAL/M PAL/N
> (000000000000b700), size: 169
> Firmware 46, type: STD FW    MTS LCD (0x00001004), id: NTSC PAL/M PAL/N
> (000000000000b700), size: 169
> Firmware 47, type: STD FW    MTS LCD NOGD (0x00003004), id: NTSC PAL/M
> PAL/N (000000000000b700), size: 169
> Firmware 48, type: SCODE FW  HAS IF (0x60000000), IF = 3.28 MHz id:
> (0000000000000000), size: 192
> Firmware 49, type: SCODE FW  HAS IF (0x60000000), IF = 3.30 MHz id:
> (0000000000000000), size: 192
> Firmware 50, type: SCODE FW  HAS IF (0x60000000), IF = 3.44 MHz id:
> (0000000000000000), size: 192
> Firmware 51, type: SCODE FW  HAS IF (0x60000000), IF = 3.46 MHz id:
> (0000000000000000), size: 192
> Firmware 52, type: SCODE FW  DTV6 ATSC OREN36 HAS IF (0x60210020), IF =
> 3.80 MHz id: (0000000000000000), size: 192
> Firmware 53, type: SCODE FW  HAS IF (0x60000000), IF = 4.00 MHz id:
> (0000000000000000), size: 192
> Firmware 54, type: SCODE FW  DTV6 ATSC TOYOTA388 HAS IF (0x60410020), IF
> = 4.08 MHz id: (0000000000000000), size: 192
> Firmware 55, type: SCODE FW  HAS IF (0x60000000), IF = 4.20 MHz id:
> (0000000000000000), size: 192
> Firmware 56, type: SCODE FW  MONO HAS IF (0x60008000), IF = 4.32 MHz id:
> NTSC/M Kr (0000000000008000), size: 192
> Firmware 57, type: SCODE FW  HAS IF (0x60000000), IF = 4.45 MHz id:
> (0000000000000000), size: 192
> Firmware 58, type: SCODE FW  MTS LCD NOGD MONO IF HAS IF (0x6002b004),
> IF = 4.50 MHz id: NTSC PAL/M PAL/N (000000000000b700), size: 192
> Firmware 59, type: SCODE FW  LCD NOGD IF HAS IF (0x60023000), IF = 4.60
> MHz id: NTSC/M Kr (0000000000008000), size: 192
> Firmware 60, type: SCODE FW  DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 HAS IF
> (0x620003e0), IF = 4.76 MHz id: (0000000000000000), size: 192
> Firmware 61, type: SCODE FW  HAS IF (0x60000000), IF = 4.94 MHz id:
> (0000000000000000), size: 192
> Firmware 62, type: SCODE FW  HAS IF (0x60000000), IF = 5.26 MHz id:
> (0000000000000000), size: 192
> Firmware 63, type: SCODE FW  MONO HAS IF (0x60008000), IF = 5.32 MHz id:
> PAL/BG A2 NICAM (0000000f00000007), size: 192
> Firmware 64, type: SCODE FW  DTV7 DTV78 DTV8 DIBCOM52 CHINA HAS IF
> (0x65000380), IF = 5.40 MHz id: (0000000000000000), size: 192
> Firmware 65, type: SCODE FW  DTV6 ATSC OREN538 HAS IF (0x60110020), IF =
> 5.58 MHz id: (0000000000000000), size: 192
> Firmware 66, type: SCODE FW  HAS IF (0x60000000), IF = 5.64 MHz id:
> PAL/BG A2 (0000000300000007), size: 192
> Firmware 67, type: SCODE FW  HAS IF (0x60000000), IF = 5.74 MHz id:
> PAL/BG NICAM (0000000c00000007), size: 192
> Firmware 68, type: SCODE FW  HAS IF (0x60000000), IF = 5.90 MHz id:
> (0000000000000000), size: 192
> Firmware 69, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.00 MHz id:
> PAL/DK PAL/I SECAM/K3 SECAM/L SECAM/Lc NICAM (0000000c04c000f0), size: 192
> Firmware 70, type: SCODE FW  DTV6 QAM ATSC LG60 F6MHZ HAS IF
> (0x68050060), IF = 6.20 MHz id: (0000000000000000), size: 192
> Firmware 71, type: SCODE FW  HAS IF (0x60000000), IF = 6.24 MHz id:
> PAL/I (0000000000000010), size: 192
> Firmware 72, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.32 MHz id:
> SECAM/K1 (0000000000200000), size: 192
> Firmware 73, type: SCODE FW  HAS IF (0x60000000), IF = 6.34 MHz id:
> SECAM/K1 (0000000000200000), size: 192
> Firmware 74, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.50 MHz id:
> PAL/DK SECAM/K3 SECAM/L NICAM (0000000c044000e0), size: 192
> Firmware 75, type: SCODE FW  DTV6 ATSC ATI638 HAS IF (0x60090020), IF =
> 6.58 MHz id: (0000000000000000), size: 192
> Firmware 76, type: SCODE FW  HAS IF (0x60000000), IF = 6.60 MHz id:
> PAL/DK A2 (00000003000000e0), size: 192
> Firmware 77, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.68 MHz id:
> PAL/DK A2 (00000003000000e0), size: 192
> Firmware 78, type: SCODE FW  DTV6 ATSC TOYOTA794 HAS IF (0x60810020), IF
> = 8.14 MHz id: (0000000000000000), size: 192
> Firmware 79, type: SCODE FW  HAS IF (0x60000000), IF = 8.20 MHz id:
> (0000000000000000), size: 192
> 
> I did a quick check here with firmware v2.7. The standard firmwares for
> DTV7 and DTV8 are equal.
> The firmware for DTV78 has one byte with a different value. So, it seems
> that the offset for
> DVB7 should be different than the one for DVB8.
> 
> Regards,
> Mauro
> 
> 

Hi Mauro,
thanks for the review and the info about the firmware tool.
The interesting thing is that DTV7 and DTV8 are identical: this means
there is no info about bandwidth coded inside them.
Also, the SCODE table (firmware 60) is the same for all 3 firmware
types: in fact, this is what is loaded when selecting a VHF frequency,
just after a replug of my Terratec stick:

[ 8701.753768] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[ 8702.804153] xc2028 0-0061: Loading firmware for type=D2633 DTV7 (90),
id 0000000000000000.
[ 8702.819274] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.

and the, after selecting a UHF frequency:

[ 8758.361730] xc2028 0-0061: Loading firmware for type=D2633 DTV78
(110), id 0000000000000000.
[ 8758.376951] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.

So, if the center frequency is indeed the same in all cases, the
variable part could be the so called "reference frequency"; this
frequency could be 1.25 MHz for 8 MHz channels and 1.75 MHz for 7 MHz
channels.

But those are just conjectures; maybe in the comment I should just
specify what I did and why I did it, removing the sentence with
"probably...".

Best regards,
Gianluca
