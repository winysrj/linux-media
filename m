Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39619 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab0ANHf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 02:35:29 -0500
Received: by yxe17 with SMTP id 17so23198715yxe.33
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 23:35:27 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Jan 2010 15:35:27 +0800
Message-ID: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
Subject: About driver architecture
From: Michael Qiu <fallwind@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,
  I'm going to write drivers for a new soc which designed for dvb-s set top box.
It will support these features:
1. Multi-layer display with alpha blending feature, including
video(YUV), OSDs(2 same RGB layers), background(with fixed YUV color)
and still picture(YUV color for still image)
2. DVB-S tuner and demod
3. HW MPEG2/4 decoder
4. HW accelerated JPEG decoder engine.

My targets are:
1. Fit all the drivers in proper framework so they can be easily used
by applications in open source community.
2. As flexible as I can to add new software features in the future.

My questions are:
How many drivers should I implement, and how should I divide all the features?
As far as I know:
A) a frame buffer driver for 2 OSDs, maybe also the control point for
whole display module?
B) video output device for video layer, which will output video program.
C) drivers for tuner and demo (or just a driver which will export 2
devices files for each?)
D) driver for jpeg accelerate interface, or should it be a part of
MPEG2/4 decoder driver?
E) driver for MPEG2/4 decoder which will control the behave of H/W decoder.

Actually I think all the display functions are relative, some
functions i listed upper are operating one HW module, for instance:
OSD and video layer are implemented by display module in H/W level.
What's the right way to implement these functions in driver level,
united or separated?
And, I've read some documents for V4L2, but I still cannot figure out
where should I implement my driver in the framework.

In a word, I'm totally confused. Can you guys show me the right way or
just kick me to a existing example with similar features?


Best regards
Michael Qiu
