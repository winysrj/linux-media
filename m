Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57843 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1BXVrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 16:47:42 -0500
Received: by vxi39 with SMTP id 39so860221vxi.19
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 13:47:42 -0800 (PST)
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 24 Feb 2011 22:47:21 +0100
Message-ID: <AANLkTimN9Acw2hE3p8T6U6RxgXi1HRcypKB2Uqg8V7oa@mail.gmail.com>
Subject: V4L2_CAP_VIDEO_OUTPUT and videobuf[1/2] & adv7175 mediabus
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I jumped into the cold water and I am trying to convert the
dxr3/em8300 driver to the v4l2 api. I got some parts already working,
but I think
that the hardest parts are still missing. As you might think... yes I
have some questions :)

1) The dxr3 has a hardware fifo, which is used to play content. Can I
reuse videbuf1 or videbuf2 to manage the fifo? Are these
the frameworks designed to support output devices - write operation to
the device?

Here you can find the current fifo impl.
https://github.com/austriancoder/v4l2-em8300/blob/master/modules/em8300_fifo.c

2) The adv7175 chip support to different input data types:

Video Input Data Port Supports:
CCIR-656 4:2:2 8-Bit Parallel Input Format
4:2:2 16-Bit Parallel Input Format

See http://dxr3.sourceforge.net/download/hardware/ADV7175A_6A.pdf for
more details about the chip.

Now I thought that I should use the v4l2-mediabus api for that, but I
am not sure what pixel codes (V4L2_MBUS_FMT...)
should be used for CCIR-656 4:2:2 8-Bit and CCIR-656 4:2:2 16-Bit.


thanks
--
Christian Gmeiner, MSc
