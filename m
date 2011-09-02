Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:51413 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab1IBJTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 05:19:03 -0400
Date: Fri, 2 Sep 2011 11:18:53 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "Wu, Josh" <Josh.wu@atmel.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Using atmel-isi for direct output on framebuffer ?
Message-ID: <20110902111853.292d7f26@skate>
In-Reply-To: <4C79549CB6F772498162A641D92D532802A09156@penmb01.corp.atmel.com>
References: <20110901170555.568af6ea@skate>
	<4C79549CB6F772498162A641D92D532802A09156@penmb01.corp.atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Josh,

Le Fri, 2 Sep 2011 17:08:32 +0800,
"Wu, Josh" <Josh.wu@atmel.com> a écrit :

> My understanding is that you want to use Atmel ISI to output RGB data
> then work with framebuffer. So yes, it is possible.

Good.

> Since current atmel_isi.c only uses its codec path to output YUV
> data. So first need add RGB format support in
> isi_camera_get_formats(). Then you have two choices to enable RGB
> output of ISI: 1. Enable isi's preview path(DMA, interrupts) to
> convert YUV to RGB. 2. Or still use codec path but don't need add
> much ISI code, just set camera sensor(if it support RGB565 output) to
> output RGB565 data for ISI, then what the data ISI output now should
> be RGB565 format. But in this way you cannot do any scale.

Doing the YUV -> RGB within the V4L2 driver is something I understand
quite well. The part I miss is how the V4L2 driver interacts with the
framebuffer driver to output the camera image into the framebuffer.

> For V4L2_CAP_VIDEO_OVERLAY type driver, I don't know much about that.

Hum, ok, found http://v4l2spec.bytesex.org/spec/x6570.htm which seems
to explain a bit the userspace interface for this.

Thanks for your feedback!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
