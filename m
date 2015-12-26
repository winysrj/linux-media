Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56080 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbLZXr4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2015 18:47:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>
Subject: Re: per-frame camera metadata (again)
Date: Sun, 27 Dec 2015 01:47:54 +0200
Message-ID: <5520197.vJSVcNd1Sr@avalon>
In-Reply-To: <Pine.LNX.4.64.1512241123060.12474@axis700.grange>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange> <2560629.CtpjHgJUC1@avalon> <Pine.LNX.4.64.1512241123060.12474@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 24 December 2015 11:42:49 Guennadi Liakhovetski wrote:
> Hi Laurent,
> 
> Let me put this at the top: So far it looks like we converge on two
> possibilities:
> 
> (1) a separate video-device node with a separate queue. No user-space
> visible changes are required apart from new FOURCC codes. In the kernel
> we'd have to add some subdev API between the bridge and the sensor drivers
> to let the sensor driver instruct the bridge driver to use some of the
> data, arriving over the camera interface, as metadata.

The interface should be more generic and allow describing how multiple 
channels (in terms of virtual channels and data types for CSI-2 for instance) 
are multiplexed over a single physical link. I'm not sure how to represent 
that at the media controller level, that's also one topic that needs to be 
researched.

> (2) parsing metadata by the sensor subdevice driver to make it available
> as controls. This would only (properly) work with the request API, which
> is still a work in progress. Apart from that request API no additional
> user-space visible changes would be required. The kernel subdevice API
> would have to be extended as above, to specify metadata location.
> Additionally, the bridge driver would have to pass the metadata buffer
> back to the subdevice driver for parsing.
> 
> Since the request API isn't available yet and even the latest version
> doesn't support per-request controls, looks like immediately only the
> former approach can be used.

Both approaches require development, I'm certainly open to collaborating on 
the request API to finalize it sooner :-)

> On Wed, 23 Dec 2015, Laurent Pinchart wrote:
> 
> [snip]
> 
> >>> My other use case (Android camera HAL v3 for Project Ara) mainly deals
> >>> with controls and meta-data, but I'll then likely pass the meta-data
> >>> blob to userspace as-is, as its format isn't always known to the
> >>> driver. I'm also concerned about efficiency but haven't had time to
> >>> perform measurements yet.
> >> 
> >> Hm, why is it not known to the subdevice driver? Does the buffer layout
> >> depend on some external conditions? Maybe loaded firmware? But it should
> >> be possible to tell the driver, say, that the current metadata buffer
> >> layout has version N?
> > 
> > My devices are class-compliant but can use a device-specific meta-data
> > format. The kernel driver knows about the device class only, knowledge
> > about any device-specific format is only available in userspace.
> 
> So, unless you want to add camera-specific code to your class-driver
> (UVC?),

Not UVC, project Ara camera class.

> that's another argument against approach (2) above.

In my case that's correct, although I could still use the request API with a 
single binary blob control.

> >> Those metadata buffers can well contain some parameters, that can also
> >> be obtained via controls. So, if we just send metadata buffers to the
> >> user as is, we create duplication, which isn't nice.
> > 
> > In my case there won't be any duplication as there will likely be no
> > control at all, but I agree with you in the general case.
> > 
> >> Besides, the end user will anyway want broken down control values. E.g.
> >> in the Android case, the app is getting single controls, not opaque
> >> metadata buffers. Of course, one could create a vendor metadata tag
> >> "metadata blob," but that's not how Android does it so far.
> >> 
> >> OTOH passing those buffers to the subdevice driver for parsing and
> >> returning them as an (extended) control also seems a bit ugly.
> >> 
> >> What about performance cost? If we pass all those parameters as a single
> >> extended control (as long as they are of the same class), the cost won't
> >> be higher, than dequeuing a buffer? Let's not take the parsing cost and
> >> the control struct memory overhead into account for now.
> > 
> > If you take nothing into account then the cost won't be higher ;-) It's
> > the parsing cost I was referring to, including the cost of updating the
> > control value from within the kernel.
> 
> I meant mostly context switching costs, switching between the kernel- and
> the user-space. If we had to extract all controls one by one that wouldn't
> be a negligible overhead, I guess.

Agreed.

> [snip]
> 
> >>>> Right, our use-cases so far don't send a lot of data as per-frame
> >>>> metadata, no idea what others do.
> >>> 
> >>> What kind of hardware do you deal with that sends meta-data ? And over
> >>> what kind of channel does it send it ?
> >> 
> >> A CSI-2 connected camera sensor.
> > 
> > Is meta-data sent as embedded data lines with a different CSI-2 DT ?
> 
> A different data type, yes.
> 
> So, all in all it looks that the only immediately available option and,
> possibly, the only feasible option at all is a separate buffer queue. Do
> we agree, that a subdev API is needed to inform the bridge driver about
> the availability and location of the metadata?

As explained above I agree we need to extend the subdev API.

-- 
Regards,

Laurent Pinchart

