Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44406 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0IPWRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 18:17:06 -0400
Received: by qwh6 with SMTP id 6so1312973qwh.19
        for <linux-media@vger.kernel.org>; Thu, 16 Sep 2010 15:17:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C9289FD.8030004@redhat.com>
References: <AANLkTi=7fPmqkkhGpPEXP9b6od+QRMTF_Xwh-i=BjEku@mail.gmail.com>
	<AANLkTi=C5vbVqcDe1JDcz7WxRRO3YeL-RKwQh5Bpv79G@mail.gmail.com>
	<AANLkTi=otOpFHMGKg9=wkMZKgY_KHOkBDAUq93-18fzb@mail.gmail.com>
	<4C9289FD.8030004@redhat.com>
Date: Thu, 16 Sep 2010 19:17:05 -0300
Message-ID: <AANLkTim5_cHNF6Z1SJXESZiWDge8RZzuHvRROXyo6U3u@mail.gmail.com>
Subject: Re: Hello and question about firmwares
From: =?UTF-8?B?4pyOxqZhZmFlbCBWaWVpcmHimaY=?= <rafastv@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Mauro,

Thanks for your help.
Found your patch:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/22814

You're right, a more careful research returned
--------------------------
   - Product: PixelView PlayTV USB Hybrid

   - Part Number: PV-B308U(FRTN)-F

   - TDA18271 (NXP Hybrid Tuner), 86A20S (Fujitsu ISDB-T demodulator),
   CX23102 (CNXT AV Decoder - 10bit), USB Bridge
--------------------------
   - Product: PixelView PlayTV USB SBTVD Full-Seg

   - Part Number: PV-D231U(RN)-F

   - Chipset: DIB8076
--------------------------
Even if they share the same ID(from lsusb), chipsets are different.
This is really troublesome :(
But, the driver for CX23102 does exist in kernel.....So, I was
thinking....Is there a way to force kernel to recognize the device
PixelView PlayTV USB Hybrid as anyother who uses the same chipset,
like Conexant Hybrid TV - RDE250?

http://lxr.free-electrons.com/source/drivers/media/video/cx231xx/cx231xx-cards.c
http://www.datasheetarchive.com/Indexer/Datasheet-064/DSA00206835.html

Shouldn't it work? At least as a regular tv(analog)....this way the
money I spent wouldn't be for nothing.

I don't know if this helps but I found this too(for fujitsu chipset,
his full name seems to be MB86A20S):

http://www.fujitsu.com/downloads/MICRO/fme/documentation/M17_MB86A20S_OFDM_Demodulator.pdf

Do you think it's possible?
Thank you again for your help and patch :)

Rafael Vieira

2010/9/16 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Hi Rafael,
>
> Em 16-09-2010 13:56, ✎Ʀafael Vieira♦ escreveu:
>> I realize now that I was kind of fast foward :) So nice to meet you all.
>> I hope someday, I'm able to help you guys.
>> Let me give you some more data from the device, although is not
>> directly related to my questions.
>>
>> The two devices:
>>
>> http://www.pixelview.com.br/play_tv_usb_sbtvd_fullseg.asp (works already)
>>
>> http://www.pixelview.com.br/playtv_usb_hybrid.asp (I'm trying to get it to work)
>
> They are completely independent devices. One uses dib0700, while the other uses cx23102,
> plus a Fujitsu frontend. The second one is not supported. I wrote a patch to fix the
> auto-detection issues between them a few days ago on my -git tree. Eventually, analog
> support for s-video/composite will work, but analog or digital TV won't work. I need
> to get one of those in order to fix the analog TV. For digital, it is more complicated,
> as we don't have any info about the Fujitsu chip yet.
>
> Abraços,
> Mauro.
>



-- 
Rafael Siqueira Telles Vieira
------------------------------------------------------------------
"Effective leadership is not about making speeches or being liked;
leadership is defined by results not attributes" - Peter F. Drucker
