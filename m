Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58975 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2KLLRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 06:17:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Alain VOLMAT <alain.volmat@st.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Way to request a time discontinuity in a V4L2 encoder device
Date: Mon, 12 Nov 2012 12:18:10 +0100
Message-ID: <2030523.VVFEJzW5uv@avalon>
In-Reply-To: <20121111085106.GK25623@valkosipuli.retiisi.org.uk>
References: <E27519AE45311C49887BE8C438E68FAA01012DC87FE3@SAFEX1MAIL1.st.com> <509825C4.9000604@gmail.com> <20121111085106.GK25623@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 11 November 2012 10:51:06 Sakari Ailus wrote:
> On Mon, Nov 05, 2012 at 09:47:00PM +0100, Sylwester Nawrocki wrote:
> > On 11/05/2012 11:45 AM, Alain VOLMAT wrote:
> > > Hi Laurent,
> > >
> > > Yes indeed, meta plane seems a good candidate. It was the other option.
> > >
> > > The pity with that is that the FMT can thus no longer be standard FMT
> > > but a specific format that include both plane 0 with real frame data and
> > > plane 1 with meta data.
> > > So, standard V4L2 application (that doesn't know about this time
> > > discontinuity stuff) wouldn't be able to push things into the encoder
> > > since they are not aware of this 2 plane format.
> > >
> > > Or maybe we should export 2 format, 1 standard one that doesn't have
> > > time discontinuity support, thus not best performance but still can do
> > > things and a second format that has 2 planes
> > 
> > Not sure what media guys think about it, I was considering making it
> > possible for applications (or libv4l or any other library) to request
> > additional meta data plane at a video capture driver, e.g. with
> > VIDIOC_S_FMT ioctl. With same fourcc for e.g. 1-planar buffers with image
> > data and 2-planar buffer with meta data in plane 1. However this would be
> > somehow device-specific, rather
> 
> How about this: add a special 4cc that tells only that the 4cc is defined
> per-plane, and define it in planes instead? We could also add a flags field
> to tell that a plane is actually a part of the same image in cases where
> true multi-plane formats are being used at the same time.
> 
> You could use this to pass frame metadata (when it's produced by the sensor
> itself) to the user space as well.

That sounds like a good idea to explore.

> What I haven't yet thought is how this can be told to the user using
> ENUMFMT.
> 
> > than a completely generic interface. Since frame-meta data is often device
> > specific. For camera it would depend on the image sensor whether the
> 
> Device-specific metadata should have their own 4ccs as device specific image
> formats.
> 
> > additional plane request on a /dev/video? would be fulfilled by a driver
> > or not.
> > 
> > I don't think duplicating 4CCs for the sake of additional meta-data plane
> > is a good idea.
> 
> No, that'd really explode the number of different 4ccs.
> 
> > Your case is a bit different, since you're passing data from application
> > to a device. Maybe we could somewhat standardize the meta data buffer
> > content,
> 
> We need to define a proper format for this. It can include other per-buffer
> parameters to / from the device as well.
>
> > e.g. by using some standard header specifying what kind of meta data
> > follows. Perhaps struct v4l2_plane::data_offset can be helpful here. This
> > is how it's documented
> > 
> >  * @data_offset:	offset in the plane to the start of data; usually 0,
> >  *			unless there is a header in front of the data
> > 
> > I mean, the header would specify what actual meta-data is in that
> > additional plane. Standardising that "standard" meta-data would be
> > another issue.
> > 
> > I think this per buffer device control issue emerged in the past during
> > the Exynos Multi Format Codec development. There were proposals of per-
> > buffer v4l2 controls. IIRC it is currently resolved in that driver by
> > doing VIDIOC_S_CTRL before QBUF. However the meta data plane approach
> > looks more interesting to me.
> 
> That sounds like a simple (and thus good) solution to me: a button control
> for resetting the average bitrate calculation. It'd be by far more simple
> than using the metadata plane for it. Any known drawbacks that I can't see?
> Even if the number of these parameters grow a little extended controls are
> fine for the purpose.

The main issue as far as I know would be to synchronize the control with 
buffers.

-- 
Regards,

Laurent Pinchart

