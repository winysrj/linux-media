Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:55842 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab1IBJIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 05:08:47 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Using atmel-isi for direct output on framebuffer ?
Date: Fri, 2 Sep 2011 17:08:32 +0800
Message-ID: <4C79549CB6F772498162A641D92D532802A09156@penmb01.corp.atmel.com>
In-Reply-To: <20110901170555.568af6ea@skate>
References: <20110901170555.568af6ea@skate>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>
Cc: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Thomas

On Thu, 1 Sep 2011, Thomas Petazzoni wrote:

> Hello Josh,

> I am currently looking at V4L2 and your atmel-isi driver for an AT91
> based platform on which I would like the ISI interface to capture the
> image from a camera and have this image directly output in RGB format
> at a specific location on the screen (so that it can be nicely
> integrated into a Qt application for example).

> At the moment, I grab frames from the V4L2 device to userspace, do the
> YUV -> RGB conversion manually in my application, and then displays the
> converted frame on the framebuffer thanks to normal Qt painting
> mechanisms. This works, but obviously consumes a lot of CPU.

> From the AT91 datasheet, I understand that the ISI interface is capable
> of doing the YUV -> RGB conversion and is also capable of outputting
> the frame at some location in the framebuffer, but I don't see how to
> use this capability with the Linux V4L2 and framebuffer infrastructures.

> Is this possible ? If so, could you provide some pointers or starting
> points to get me started ? If not, what is missing in the driver ?

My understanding is that you want to use Atmel ISI to output RGB data then work with framebuffer. So yes, it is possible.

Since current atmel_isi.c only uses its codec path to output YUV data. So first need add RGB format support in isi_camera_get_formats().
Then you have two choices to enable RGB output of ISI:
  1. Enable isi's preview path(DMA, interrupts) to convert YUV to RGB.
  2. Or still use codec path but don't need add much ISI code, just set camera sensor(if it support RGB565 output) to output RGB565 data for ISI, then what the data ISI output now should be RGB565 format. But in this way you cannot do any scale.

For V4L2_CAP_VIDEO_OVERLAY type driver, I don't know much about that.

Best Regards,
Josh Wu

> Thanks a lot,

> Thomas
> -- 
> Thomas Petazzoni, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
