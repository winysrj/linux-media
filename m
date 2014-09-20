Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53684 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaITG6o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 02:58:44 -0400
Date: Sat, 20 Sep 2014 08:58:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian.molton@codethink.co.uk>
cc: linux-media@vger.kernel.org, source@mvista.com,
	source@cogentembedded.com, vbarinov@embeddedalley.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: rcar_vin: rcar_vin_get_formats()
In-Reply-To: <20140812182156.60bf2513ae5de5557bbdfa05@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1409200845520.21175@axis700.grange>
References: <20140812182156.60bf2513ae5de5557bbdfa05@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ian,

On Tue, 12 Aug 2014, Ian Molton wrote:

> rcar_vin_get_formats()
> 
> Can anyone explain to me what on earth this function is trying to 
> achieve? I'm finding it rather impenetrable, and it works for me on one 
> driver (adv7180) but not with another (modified 7612 driver).
> 
> It appears that its doing some sort of magic with the builtin array of 
> formats, to allow the 7180 driver to select a YUV mode?? but I cant for 
> the life of me understand what. I'm fairly new to v4l2, so I dont really 
> know whats legit and what isnt. particularly, the code appears to abuse 
> one "code" to provide several (incompatible?) formats.

That function is adding support for VIN own format conversions. V4L2 
drivers get requests from the user space to provide data to the 
application in one of V4L2_PIX_FMT_* formats. Those formats define how 
data is organised in memory buffers. Camera sensors however send data to 
camera host adapters, like VIN, over a bus, using one of V4L2_MBUS_FMT_* 
formats. The camera host then uses DMA to transfer the data into a memory 
buffer. In the most trivial case the camera interface consists of 8 or 16 
data lines and the host simply stores bytes or 16-bit words directly into 
memory. This is called in the soc-camera framework a pass-through mode. 
However, many hosts additionally provide several ways to convert the data 
in real time and store them into memore in one of several formats. In 
soc-camera this is implemented, using translation tables. This is exactly 
what this function does. Specifically it specifies, that if the sensor 
supports one of

	case V4L2_MBUS_FMT_YUYV8_1X16:
	case V4L2_MBUS_FMT_YUYV8_2X8:
	case V4L2_MBUS_FMT_YUYV10_2X10:

formats, the VIN can convert them to any of the formats, specified in the 
rcar_vin_formats[] array. And since it can happen, that the sensor 
supports several of the above V4L2_MBUS_FMT_* formats, care is taken to 
attach the additional table of generated formats only once.

Thanks
Guennadi

> Help?
> 
> -- 
> Ian Molton <ian.molton@codethink.co.uk>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
