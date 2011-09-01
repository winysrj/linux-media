Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:36908 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1IAPGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:06:03 -0400
Date: Thu, 1 Sep 2011 17:05:55 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: josh.wu@atmel.com
Cc: linux-media@vger.kernel.org
Subject: Using atmel-isi for direct output on framebuffer ?
Message-ID: <20110901170555.568af6ea@skate>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Josh,

I am currently looking at V4L2 and your atmel-isi driver for an AT91
based platform on which I would like the ISI interface to capture the
image from a camera and have this image directly output in RGB format
at a specific location on the screen (so that it can be nicely
integrated into a Qt application for example).

At the moment, I grab frames from the V4L2 device to userspace, do the
YUV -> RGB conversion manually in my application, and then displays the
converted frame on the framebuffer thanks to normal Qt painting
mechanisms. This works, but obviously consumes a lot of CPU.

>From the AT91 datasheet, I understand that the ISI interface is capable
of doing the YUV -> RGB conversion and is also capable of outputting
the frame at some location in the framebuffer, but I don't see how to
use this capability with the Linux V4L2 and framebuffer infrastructures.

Is this possible ? If so, could you provide some pointers or starting
points to get me started ? If not, what is missing in the driver ?

Thanks a lot,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
