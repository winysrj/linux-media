Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:37857 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbABKGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 05:06:54 -0500
Received: by mail-qc0-f177.google.com with SMTP id x3so12662468qcv.8
        for <linux-media@vger.kernel.org>; Fri, 02 Jan 2015 02:06:53 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 2 Jan 2015 10:06:53 +0000
Message-ID: <CAA6s63trmCBJC3GMyuJvXpVHgy=oT2XvWozG7+C0iwLgR-PNzw@mail.gmail.com>
Subject: Looking for a suitable framework for my driver
From: Sadegh Abbasi <4abbasi@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

I need to write a driver for a video-in device and need
to choose the best framework for it. I think V4L2 can be used but would like to
know if any more suitable framework exists. Also if there is an existing similar
driver under linux that you are aware of please let me know. The idea is not to
waste people's time with the wrong approach or wrong subsystem.
Here is a brief description of the hardware capabilities:
1. It captures digital video input and writes it to memory after
optional colour space conversion (CSC) and scaling.
2. It supports DVI/HDMI inputs, providing 20/24/30/48-bit RGB/YCbCr,
and running at up to 1600x1280x75Hz.
3. It supports  frame sizes up to UHD 4096x2304, interlaced and
progressive video, and range of RGB and YCbCr formats
for input and output.
4. Both packed and planar formats are supported. The supported output
formats are as follows.

444 YUV101010; 422 UYVY10101010; PL12Y10/422PL12UV10;
PL12Y10/420PL12UV10; PL12Y8/422PL12UV8; PL12Y8/420PL12UV8;
RGB121212.5. The CSC is applied to the RGB input performing a 3x3
Matrix multiply with
programmable coefficients and programmable input and output offsets.
It can also adjust brightness, contrast,
saturation and hue.
6. It has its own MMU and DMA.

Any suggestions is highly appreciated.

Sadegh Abbasi
4abbasi@gmail.com
