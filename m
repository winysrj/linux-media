Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59861 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980AbbFWTTu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 15:19:50 -0400
Date: Tue, 23 Jun 2015 14:19:42 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [Patch 0/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture
 driver
Message-ID: <20150623191941.GF31636@ti.com>
References: <1434475763-20294-1-git-send-email-bparrot@ti.com>
 <5587B9C9.70803@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5587B9C9.70803@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> wrote on Mon [2015-Jun-22 09:31:21 +0200]:
> On 06/16/2015 07:29 PM, Benoit Parrot wrote:
> > The Camera Adaptation Layer (CAL) is a block which consists of a dual
> > port CSI2/MIPI camera capture engine.
> > This camera engine is currently found on DRA72xx family of devices.
> > 
> > Port #0 can handle CSI2 camera connected to up to 4 data lanes.
> > Port #1 can handle CSI2 camera connected to up to 2 data lanes.
> > 
> > The driver implements the required API/ioctls to be V4L2 compliant.
> > Driver supports the following:
> >     - V4L2 API using DMABUF/MMAP buffer access based on videobuf2 api
> >     - Asynchronous sensor sub device registration
> >     - DT support
> > 
> > Currently each port is designed to connect to a single sub-device.
> > In other words port aggregation is not currently supported.
> > 
> > Here is a sample output of the v4l2-compliance tool:
> > 
> > # ./v4l2-compliance -s -v -d /dev/video0
> 
> Can you show the output of './v4l2-compliance -f' as well?

I can but you won't see much as my test sensor (the only one I have)
only support V4L2_PIX_FMT_SGRBG8.

> 
> Thanks!
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
