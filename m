Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57611 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab2BUJli convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 04:41:38 -0500
Received: by lagu2 with SMTP id u2so7400341lag.19
        for <linux-media@vger.kernel.org>; Tue, 21 Feb 2012 01:41:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202211020040.18412@axis700.grange>
References: <1329219332-27620-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1202201413300.2836@axis700.grange>
	<CACKLOr1KT2A1Zd_xsVXPGW8X6e57v6xTZTm46wdfNfwwf9-MYQ@mail.gmail.com>
	<Pine.LNX.4.64.1202210936420.18412@axis700.grange>
	<CACKLOr2uOab=yS6iE2A871=dEfWH5jFDcoL7FQ2=nKOyJkHN-A@mail.gmail.com>
	<Pine.LNX.4.64.1202211020040.18412@axis700.grange>
Date: Tue, 21 Feb 2012 10:41:37 +0100
Message-ID: <CACKLOr27AsuZVJWrOhSBUgRMT=idtYH1YPXCAbxw_fcqmF4Z0w@mail.gmail.com>
Subject: Re: [PATCH] media: i.MX27 camera: Add resizing support.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 February 2012 10:24, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Tue, 21 Feb 2012, javier Martin wrote:
>
>> On 21 February 2012 09:39, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> > Hi Javier
>> >
>> > One more thing occurred to me: I don't see anywhere in your patch checking
>> > for supported pixel (fourcc) formats. I don't think the PRP can resize
>> > arbitrary formats? Most likely these would be limited to some YUV, and,
>> > possibly, some RGB formats?
>>
>> The PrP can resize every format which is supported as input by the eMMa.
>>
>> Currently, the driver supports 2 input formats: RGB565 and YUV422
>> (YUYV)  (see mx27_emma_prp_table[]).
>
> That's not how I understand it. The mx27_emma_prp_table[] array has 2
> entries: the first one is indeed configured for RGB565, and the second one
> is converting input YUV422 to output YUV420. But the former one is not
> really that specific format, rather it is a generic configuration used as
> a pass-through mode for generic 16-bit formats.
>
> BTW, does that mean, that on i.MX27 the driver currently doesn't support
> 8-bit formats like Bayer?

According to the datasheet, the eMMa-PrP only accepts the following
input formats when capturing data form the CSI:

RGB 16 bpp
RGB 32 bpp (unpacked RGB888)
YUV 4:2:2 Pixel interleaved
YUV 4:4:4

But the driver only supports:
- RGB 16bpp which, as you say is used as pass-through mode for generic
16-bit formats.
- YUV 422 which is converted to YUV420.

I'm sorry, you are right. Since I only use the latter, I hadn't
noticed that the resizing engine could in fact have problems with
16bit pass-through mode depending on what 16bit format is really being
transfered.

What I can do is restricting the use of resizing only to the YUV422
case so that someone who is using the old pass-through mode can add
support for resizing later for this format.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
