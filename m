Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:37215 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3HDCcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 22:32:10 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk14so600186bkc.1
        for <linux-media@vger.kernel.org>; Sat, 03 Aug 2013 19:32:09 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 4 Aug 2013 10:32:09 +0800
Message-ID: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>
Subject: How to express planar formats with mediabus format code?
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I know the title looks crazy, but here is our problem:

In our SoC based ISP, the hardware can be divide to several blocks.
Some blocks can do color space conversion(raw to YUV
interleave/planar), others can do the pixel
re-order(interleave/planar/semi-planar conversion, UV planar switch).
We use one subdev to describe each of them, then came the problem: How
can we express the planar formats with mediabus format code?

I understand at beginning, media-bus was designed to describe the data
link between camera sensor and camera controller, where sensor is
described in subdev. So interleave formats looks good enough at that
time. But now as Media-controller is introduced, subdev can describe a
much wider range of hardware, which is not limited to camera sensor.
So now planar formats are possible to be passed between subdevs.

I think the problem we meet can be very common for SoC based ISP
solutions, what do you think about it?

there are many possible solution for it:

1> change the definition of v4l2_subdev_format::format, use v4l2_format;

2> extend the mediabus format code, add planar format code;

3> use a extra bit to tell the meaning of v4l2_mbus_framefmt::code, is
it in mediabus-format or in fourcc

 Do you have any suggestions?

 Thanks a lot!
