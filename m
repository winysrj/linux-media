Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43184 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750994Ab3IJVqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 17:46:33 -0400
Date: Wed, 11 Sep 2013 00:46:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: videobuf2: V4L2_BUF_TYPE_VIDEO_CAPTURE and
 V4L2_BUF_TYPE_VIDEO_OUTPUT at the same time?
Message-ID: <20130910214628.GE2057@valkosipuli.retiisi.org.uk>
References: <CAPybu_2dq6FkWebNw8ySD=4wJu++3z7K6oNDjXEJvcKVvRTVsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_2dq6FkWebNw8ySD=4wJu++3z7K6oNDjXEJvcKVvRTVsQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Tue, Sep 10, 2013 at 04:10:37PM +0200, Ricardo Ribalda Delgado wrote:
> Hello!
> 
> I am writing the driver for a device that can work as an input and as
> output at the same time. It is used for debugging of the video
> pipeline.
> 
> Is it possible to have a vb2 queue that supports capture and out at
> the same time?
> 
> After a fast look on the code it seems that the code flow is different
> depending of the type. if (V4L2_TYPE_IS_OUTPUT()....)  :(
> 
> Also it seems that struct video device has only space for one
> vb2_queue, so I cant create a video device with two vbuf2 queues.
> 
> So is there any way to have a video device with videobuf2 that
> supports caputer and output?

I think mem-to-mem devices do this. I think there should be plenty of
examples there. However your use case is slightly different but I guess it
wouldn't matter here. I think you'll need two buffer queues...

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
