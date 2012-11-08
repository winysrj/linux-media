Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53447 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2KHJZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 04:25:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andreas Nagel <andreasnagel@gmx.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
Date: Thu, 08 Nov 2012 10:26:11 +0100
Message-ID: <4541060.0oGRVnU8K8@avalon>
In-Reply-To: <509A4473.3080506@gmx.net>
References: <5097DF9F.6080603@gmx.net> <20121106215153.GE25623@valkosipuli.retiisi.org.uk> <509A4473.3080506@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 07 November 2012 12:22:27 Andreas Nagel wrote:
> 
> > My code sets up the ISP pipeline, configures the format on all the
> > subdevices pads and the actual video device. Works fine so far.
> > Then I passed user pointers (aquired with malloc) to the device
> > driver for the capture buffers. Before issuing VIDIOC_STREAMON, I
> > enqueue my buffers with VIDIOC_QBUF, which fails with errno = EIO. I
> > don't know, why this is happening or where to got from here.
> > 
> >> One possibility could be that mapping the buffer to ISP MMU fails for
> >> a reason or another. Do you set the length field in the buffer?
> 
> Yes, the length was set when using userptr.
> 
> >> And am I missing something else?
> > 
> > The formats on the pads at different ends of the links in the pipeline
> > must match. In most cases, they have to be exactly the same.
> > 
> > Have you used the media-ctl test program here?
> > 
> > <URL:http://git.ideasonboard.org/media-ctl.git>
> > 
> > media-ctl -p gives you (and us) lots of information that helps figuring
> > out what could go wrong here.
> 
> All pads do indeed have the same format.
> I ran media-ctl, as you suggested. You can see the topology in the
> attached textfile.

media-ctl doesn't show pad formats, that's a bit weird. Are you using a recent 
version ?

Does the TVP5146 generate interlaced frames ?

-- 
Regards,

Laurent Pinchart

