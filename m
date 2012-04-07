Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43152 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261Ab2DGRhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Apr 2012 13:37:01 -0400
Received: by qcsp15 with SMTP id p15so2945202qcs.16
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 10:36:59 -0700 (PDT)
MIME-Version: 1.0
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sat, 7 Apr 2012 12:36:39 -0500
Message-ID: <CAKnK67QZ78iTxYWvfpUJ_v_KD7XLUT=o=pkrC2EZ8CJ2r00pCQ@mail.gmail.com>
Subject: [Query] About NV12 pixel format support in a subdevice
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I'll like to request for your advice on adding NV12 support for my omap4iss
camera driver, which is done after the resizer block in the OMAP4 ISS ISP
(Imaging SubSystem Image Signal Processor).

So, the problem with that, is that I don't see a match for V4L2_PIX_FMT_NV12
pixel format in "enum v4l2_mbus_pixelcode".

Now, I wonder what's the best way to describe the format... Is this correct?

V4L2_MBUS_FMT_NV12_1X12

Because every pixel is comprised of a 8-bit Y element, and it's UV components
are grouped in pairs with the next horizontal pixel, whcih in combination
are represented in 8 bits... So it's like that UV component per-pixel is 4-bits.
Not exactly, but it's the best representation I could think of to
simplify things.

I mean, the HW itself writes in memory to 2 contiguous buffers, so there's 2
separate DMA writes. I have to program 2 starting addresses, which, in an
internal non-v4l2-subdev implementation, I have been programming like this:

paddr = start of 32-byte aligned physical address to store buffer
x = width
y = height

Ysize = (x * y)
UVsize = (x / 2) * y
Total size = Ysize + UVsize

Ystart = paddr
UVstart = (paddr + Ysize)

But, in the media controller framework, i have a single DMA output pad, that
creates a v4l2 capture device node, and i'll be queueing a single buffer.

Any advice on how to address this properly? Does anyone has/had a similar need?

Regards,
Sergio
