Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZIXLpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 07:45:23 -0400
Date: Thu, 24 Sep 2009 08:44:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Yu, Jinlu" <jinlu.yu@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging
Message-ID: <20090924084448.76bf8ff1@pedra.chehab.org>
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01ED6EEE10@pdsmsx502.ccr.corp.intel.com>
References: <037F493892196B458CD3E193E8EBAD4F01ED6EEE10@pdsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 24 Sep 2009 19:21:40 +0800
"Yu, Jinlu" <jinlu.yu@intel.com> escreveu:

> Hi, Hans/Guennadi
> 
> I am modifying these drivers to comply with v4l2 framework. I have finished replacing our buffer managing code with utility function from videobuf-core.c and videobuf-dma-contig.c. Now I am working on the subdev. One thing I am sure is that each sensor should be registered as a v4l2_subdev and ISP (Image Signal Processor) is registered as a v4l2_device acting as the bridge device. 
> 
> But we have two ways to deal with the relationship of sensor and ISP, and we don't know which one is better. Could you help me on this?
> 
> No.1. Register the ISP as a video_device (/dev/video0) and treat each of the sensor (SOC and RAW) as an input of the ISP. If I want to change the sensor, use the VIDIOC_S_INPUT to change input from sensor A to sensor B. But I have a concern about this ioctl. Since I didn't find any code related HW pipeline status checking and HW register setting in the implement of this ioctl (e.g. vino_s_input in /drivers/media/video/vino.c). So don't I have to stream-off the HW pipeline and change the HW register setting for the new input? Or is it application's responsibility to stream-off the pipeline and renegotiate the parameters for the new input?
> 
> No.2. Combine the SOC sensor together with the ISP as Channel One and register it as /dev/video0, and combine the RAW sensor together with the ISP as Channel Two and register it as /dev/video1. Surely, only one channel works at a certain time due to HW restriction. When I want to change the sensor (e.g. from SOC sensor to RAW sensor), just close /dev/video0 and open /dev/video1.

The better seems to be No. 1. As you need to re-negotiate parameters for
switching from one sensor to another, if some app tries to change from one
input to another while streaming, you should just return -EBUSY, if it is not
possible to switch (for example, if the selected format/resolution/frame rate
is incompatible).



Cheers,
Mauro
