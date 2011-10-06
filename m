Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47827 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965205Ab1JFVgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 17:36:47 -0400
Date: Fri, 7 Oct 2011 00:36:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
Message-ID: <20111006213641.GA8908@valkosipuli.localdomain>
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com>
 <1316627107-18709-3-git-send-email-s.nawrocki@samsung.com>
 <20110922220259.GS1845@valkosipuli.localdomain>
 <4E7C5BAA.9090900@samsung.com>
 <20110925100804.GU1845@valkosipuli.localdomain>
 <4E7F5DEC.8020808@gmail.com>
 <20110927205532.GA6180@valkosipuli.localdomain>
 <4E86DAA7.4@gmail.com>
 <20111002072011.GJ6180@valkosipuli.localdomain>
 <4E8E08F2.10904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8E08F2.10904@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 06, 2011 at 10:00:50PM +0200, Sylwester Nawrocki wrote:
> Moikka Sakari,

Hi, Sylwester!

> On 10/02/2011 09:20 AM, Sakari Ailus wrote:
> > On Sat, Oct 01, 2011 at 11:17:27AM +0200, Sylwester Nawrocki wrote:

[clip]

> > That's fine because it's implemented by the sensor already. My point is that
> > we should only show this fact in V4L2 API as little as possible.
> > 
> > I remember Guennadi had sensors which provide something called "snapshot
> > mode". A single boolean control to turn this on or off would suffice ---
> > snapshot mode is something that's going to be discussed in the Multimedia
> > summit if my memory serves me right.
> 
> Perhaps, although I don't expect huge outcome from one or two days meeting. 
> Hopefully it gets us closer into the right direction. 
> I'll try to prepare a brief summary of the m-5mols sensor requirements. 
> 
> > 
> > This could be one option for this sensor as well but the implementation
> > might not be quite optimal since you'd still need to switch the
> > configuration.
> 
> I believe the final result would be acceptable as well.
> 
> However I recall going through a datasheet of a camera device which was capable
> of generating simultaneously low resolution YUV and a higher resolution capture 
> JPEG data stream. Either on same MIPI-CSI channel or on separate ones. This was
> to achieve so called "zero shutter lag".
> For this kind of device you may need two separate resolutions, at least
> an application and the driver must keep track of them.   

This kind of device requires two source pads.

The same goes for the CSI-2 reciever: the CSI-2 channels are freely
configurable even if the current drivers typically only use one.

Two video nodes are required, too, since the images are independent of each
other.

In other words, this is already supported by the V4L2 interface. :-)

[clip]

> >>>> If the hardware (or it's firmware) supports something natively why should
> >>>> we go for a less efficient SW emulated replacement? After all, preview and
> >>>> capture mode seem pretty basic features that applications will want to
> >>>> use.
> >>>
> >>> I think it depends on an application. If your application only knows it
> >>> wants to do "viewfinder" or "capture" then it might be V4L2 could be a too
> >>> low level interface for that job.
> >>
> >> Sorry, this is all not about the applications capabilities. Only about the V4L2 API
> >> limitations in using the existing devices.
> >>
> >>>
> >>> I might suggest GSTphotography instead.
> >>
> >> GstPhotography is not really impressive in its current state:
> >> http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-bad-plugins/html/GstPhotography.html
> > 
> > I'm probably not the best person to comment on this, but do you think
> > something is e.g. either missing or should be implemented differently?
> 
> I'm not a big expert either. The GstPhotography interface seems not well documented,
> I just tried to imagine how it could be used with above mentioned camera chip
> supporting interlaced viewfinder/capture data stream.  

The lack of documentation aspect might be a valid complaint. :)

I'm not a Gstreamer expert so take this with a grain of salt:

This interface is used to control the capture process, and setting the
resolutions is not part of that interface. The GSTphotography interface is
provided by the camera source. A source used with Camerabin2 has three
output pads: one of the pads provides viewfinder stream while another one
provides captured images. The third putput pad is for video.

<URL:http://gstreamer.freedesktop.org/wiki/CameraBin>

I your case the source provides the viewfinder and captures images through
the two pads.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
