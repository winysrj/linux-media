Return-Path: <SRS0=8CHB=RF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFE7C43381
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 11:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB6020838
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551526286;
	bh=FCxHQXmEBcCH4o8hiOtFBrcKikqZ3zv7FvCohZQk/qA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=asrflK6EMSoG+Sz4nV4XHTKTD+z2ywO/fqjWf83gYSwxsrSSHIwfMBCJhJkuloDLs
	 l6MM1oTGyf3lQK8uCE9Tq90fctXm2Lf/lkDFNMgjwhZdwLzrrdjTntZyVmMQOfseec
	 UmbvKFQqwqcn62sb/lPL0vYpL2F3eArNt8emfTTY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfCBLbZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Mar 2019 06:31:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfCBLbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2019 06:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jhn7Ed08cRAEu3UxkV1LbGsGbnjB8oViSJ96gU45AfE=; b=kCpM0ieumRaNbk44u6Cygon5/
        KSeJPSJmnl+uSlrtK5JTARIKlLISs/zLxkXTeEpMOd5efTy2nlhBKAMmAOiq9THIeWi0v1jafFSTR
        t5c3uMdBc8JB3AzjehvHbyK/8PjdbXvRg1xSQb7RoKzjUWcMbVZ4esPM92bDXLRIFDhUwvdlKXw+E
        dotETc4ZFQMnZwDpelHhb3RMkUWJN1CpZJ1GPtF5xVsW5fsETt4H9wxCDmz1Wnmpd1wOhFB5+udp9
        q2qVZJSxqcWYjvNdvBeukgfNO/8t8WCuAmneb6v/PkyFMm5qXROZFwvOYa3cdRuLz15yyXEgbVaQd
        SIvstq7/w==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h02rT-0007X1-5v; Sat, 02 Mar 2019 11:31:23 +0000
Date:   Sat, 2 Mar 2019 08:31:19 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: Re: [PATCH v2] media: vim2m: better handle cap/out buffers with
 different sizes
Message-ID: <20190302083119.2162026d@coco.lan>
In-Reply-To: <01f029cc-1e2b-524c-5db8-4cd87c18b669@xs4all.nl>
References: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
        <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
        <20190228110914.0b2613eb@coco.lan>
        <4cc0d8e1-7e25-1b9d-8bfe-921716522909@xs4all.nl>
        <20190228122139.6ac6c25d@coco.lan>
        <170efbf2-794a-7314-179d-d5c4af4d7e57@xs4all.nl>
        <20190228143124.3953adff@coco.lan>
        <01f029cc-1e2b-524c-5db8-4cd87c18b669@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 1 Mar 2019 11:19:06 +0100
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> >>> At least on GStreamer, codecs are implemented on a separate logic.
> >>> GStreamer checks it using the FOURCC types. If one of the sides is
> >>> compressed, it is either an encoder or a decoder. Otherwise, it is
> >>> a transform device.
> >>>
> >>> From what I understood from the code (and from my tests), it
> >>> assumes that scaler is supported for transform devices.    
> >>
> >> I find it hard to believe that it assumes a transform device can always
> >> scale. Nicolas?  
> > 
> > Provided that you have gst-plugins-good compiled with --enable-v4l2-probe
> > (needed in order to enable M2M support), you can easily test it with:
> > 
> > $ gst-launch-1.0 videotestsrc num-buffers=120 ! video/x-raw,format=RGB,width=322,height=200 ! v4l2convert disable-passthrough=1 ! video/x-raw,width=428,height=400 ! videoconvert ! xvimagesink
> > 
> > At dmesg, you'll see:
> > 
> > [246685.031750] vim2m vim2m.0: vidioc_s_fmt: Format for type Output: 322x200 (24 bpp), fmt: RGB3
> > [246685.032300] vim2m vim2m.0: vidioc_s_fmt: Format for type Capture: 428x400 (24 bpp), fmt: RGB3
> > 
> > Note: that's the Gstreamer 1.5.x syntax. "v4l2convert" has a different
> > name on version 1.4.x.. There, you should use "v4l2video0convert" instead:
> > 
> > $ gst-launch-1.0 videotestsrc num-buffers=120 ! video/x-raw,format=RGB,width=322,height=200 ! v4l2video0convert disable-passthrough=1 ! video/x-raw,width=428,height=400 ! videoconvert ! xvimagesink  
> 
> But you explicitly set different resolutions for source and sink.

Yes. That's the Gstreamer's way to select the resolution.

> What happens in gstreamer if the driver doesn't support scaling? Will
> gstreamer continue with wrong values? Give an error?

See Nicolas e-mail.

> 
> >   
> >>  
> >>>     
> >>>> I don't think there are many m2m devices that do scaling: most do
> >>>> format conversion of one type or another (codecs, deinterlacers,
> >>>> yuv-rgb converters). Scalers tend to be integrated into a video
> >>>> pipeline. The only m2m drivers I found that also scale are
> >>>> exynos-gsc, ti-vpe, mtk-mdp and possibly sti/bdisp.    
> >>>
> >>> Well, the M2M API was added with Exynos. 
> >>>     
> >>>>>
> >>>>> So, a non-scaling M2M device is something that, in thesis, we don't
> >>>>> support[1].
> >>>>>
> >>>>> [1] Very likely we have several ones that don't do scaling, but the
> >>>>> needed API bits for apps to detect if scaling is supported or not
> >>>>> aren't implemented.
> >>>>>
> >>>>> The problem of enforcing the resolution to be identical on both capture
> >>>>> and output buffers is that the V4L2 API doesn't really have
> >>>>> a way for userspace apps to identify that it won't scale until
> >>>>> too late.
> >>>>>
> >>>>> How do you imagine an application negotiating the image resolution?
> >>>>>
> >>>>> I mean, application A may set first the capture buffer to, let's say,
> >>>>> 320x200 and then try to set the output buffer. 
> >>>>>
> >>>>> Application B may do the reverse, e. g. set first the output buffer
> >>>>> to 320x200 and then try to set the capture buffer.
> >>>>>
> >>>>> Application C could try to initialize with some default for both 
> >>>>> capture and output buffers and only later decide what resolution
> >>>>> it wants and try to set both sides.
> >>>>>
> >>>>> Application D could have setup both sides, started streaming at 
> >>>>> 320x200. Then, it stopped streaming and changed the capture 
> >>>>> resolution to, let's say 640x480, without changing the resolution
> >>>>> of the output buffer.
> >>>>>
> >>>>> For all the above scenarios, the app may either first set both
> >>>>> sides and then request the buffer for both, or do S_FMT/REQBUFS
> >>>>> for one side and then to the other side.
> >>>>>
> >>>>> What I mean is that, wit just use the existing ioctls and flags, I 
> >>>>> can't see any way for all the above scenarios work on devices that
> >>>>> don't scale.      
> >>>>
> >>>> If the device cannot scale, then setting the format on either capture
> >>>> or output will modify the format on the other side as well.    
> >>>
> >>> That's one way to handle it, but what happens if buffers were already
> >>> allocated at one side?    
> >>
> >> Then trying to change the format on the other side will simply return
> >> the current format.  
> > 
> > That's one way to handle that, but it somewhat violates the V4L2 API,
> > as this kind of thing was never enforced.  
> 
> I don't see how this violates the spec. There is never any guarantee that
> the format that you set is also the format that it returned.

No, but there was always a guarantee that the format returned by S_FMT
would be the one the driver will use. In other words, setting the
capture's format should be independent of setting the output format.

So, if one sets capture to RGB and then sets output to YUYV, a set
to the output should not change the capture to RGB. While this is
not really explicit at the API, it is a contra-sense to let a S_FMT
to one side to silently affect the other side's resolution.

> >   
> >>
> >>  If the buffer is USERPTR, this is even worse,  
> >>> as the size may not fit the image anymore.    
> >>
> >> That's why you shouldn't remove the check in buf_prepare :-)  
> > 
> > Yeah, sure.
> >   
> >>  
> >>>
> >>> Also, changing drivers to this new behavior could break some stuff.    
> >>
> >> I'm not at all certain if all m2m drivers are safe when in comes to this.
> >> The v4l2-compliance testing for m2m devices has always lagged behind the
> >> testing for non-m2m devices, so we don't do in-depth tests. Otherwise we'd
> >> found this vim2m issue a long time ago.  
> > 
> > Yes. Btw, this kind of test is a good candidate for v4l2-compliance,
> > once we define the proper behavior.
> >   
> >>
> >> And I don't think it is new behavior. When it comes to m2m devices
> >> they just behave according to the standard v4l2 behavior: the driver
> >> always tries to fulfill the last ioctl to the best of its ability.  
> > 
> > Yes, but in this case, it violates a basic concept: it is overriding
> > the resolution that was set before for a separate part of the pipeline.
> > 
> > I doubt any application would expect this kind of behavior and re-check.
> > 
> > I'm not saying I'm against it, but it doesn't look right to do that on
> > my eyes. Yet, not sure what other options we would have.  
> 
> I went through the spec to see where we need to improve the documentation.
> 
> There are several levels of ioctls that can influence others:
> 
> S_INPUT/OUTPUT: these should come first since changing input or output
> can reset everything else.
> 
> This is clearly stated for ioctls.
> 
> Next are S_STD and S_DV_TIMINGS: these can change the format and any
> cropping/composing rectangles. Neither makes any mention of this.
> 
> This should be fixed.

I think that we should have a chapter mentioning the driver's expected
order. Yet, we should take care to avoid breaking existing apps.

> 
> Note that the Data Formats section (1.22) makes implicit mention of this
> ("A video standard change ... can invalidate the selected image format.").
> But that isn't quite right: it doesn't invalidate it, it only changes it.
> As an aside, there are more issues with this section since it says that
> setting the format 'assigns a logical stream exclusively to one file
> descriptor', but that's wrong. It is when buffers are allocated that this
> happens.
> 
> S_FMT and S_SELECTION (and S_CROP): sadly only S_CROP makes any mention
> that changing the crop rectangle can also change the format.

What are you meaning by format? fourcc or resolution.

IMO, it doesn't make any sense to change fourcc after crop.

Are there any drivers doing that after S_CROP/S_SELECTION?
What driver? Why?

Are out there any drivers that allow crop only on certain fourcc?

-

Reducing the resolution after CROP makes sense, though. As far as I
remember, CROP was added before USB drivers. On that time, its main goal
were to adjust the visible area to remove the VBI lines and any black
lines/columns.

So, IMO, it makes sense to explicitly mention that S_CROP/S_SELECTION
should guarantee that fourcc won't be touched. Yet, applications 
should call G_FMT after S_CROP/S_SELECTION, as the resolution could
be affected.

> In practice changing for the format can change any existing crop/compose
> rectangles and vice versa. This is so dependent on hardware constraints
> that it is hard to say anything specific.

There are two separate issues here:

1) I don't see why this would depend on the hardware. I mean, if changing
one register (with resolution or crop) would reset the other one affecting
fourcc, it should be up to the driver to rewrite the affected register
to a value that would ensure that the previous set would be honored.

2) IMO, S_FMT should always reset the crop/selection. If app decided
for a change, it very likely expect that crop/selection would return
to its default.

We should make both explicit at the documentation.

> The general rule is that the driver will do its best to satisfy the
> request. It's mentioned in section 1.22.1: "Negotiation means the
> application asks for a particular format and the driver selects and
> reports the best the hardware can do to satisfy the request."

For me, that applies only for the ioctls that are designed to change
the format (mainly S_FMT, but S_STD and S_DV_TIMINGS may also do that).
S_CROP (and its new variant S_SELECTION) are designed to affect
the captured area (and resolution). It should preserve the fourcc
or return an error if the driver cannot work with the previously
selected fourcc.

> Unfortunately it is not clear from the text that crop/compose is part
> of the negotiation and follows the same rule.

We should explicitly mention what ioctls may affect the resolution
and would require a G_FMT.

> 
> >   
> >> That said, this has never been made explicit in the spec.  
> > 
> > Well, we need to make it clear, and a way for userspace to know if
> > it will scale or just override the last setting.
> >   
> >>> (with this particular matter, changing vim2m code doesn't count as a
> >>> change, as this driver should not be used in production - but if any
> >>> other driver is doing something different, then we're limited to do
> >>> such change)
> >>>     
> >>>>
> >>>> If the device also support cropping and composing, then it becomes
> >>>> more complicated, but the basics remain the same.
> >>>>    
> >>>
> >>> I suspect that the above are just assumptions (and perhaps the current
> >>> implementation on most drivers). At least, I was unable to find any mention
> >>> about the M2M chapter at the V4L2 specs.
> >>>     
> >>>> It would certainly be nice if there was a scaling capability. I suspect
> >>>> one reason that nobody requested this is that you usually know what
> >>>> you are doing when you use an m2m device.    
> >>>
> >>> And that's a bad assumption, as it prevents having generic apps
> >>> using it. The expected behavior for having and not having scaler
> >>> should be described, and we need to be able to cope with legacy stuff.    
> >>
> >> We should likely write up something similar as what we are doing for
> >> the codec documentation, but then for m2m transform devices.  
> > 
> > Yes.
> >   
> >>  
> >>>     
> >>>>    
> >>>>> One solution would be to filter the output of ENUM_FMT, TRY_FMT,
> >>>>> G_FMT and S_FMT when one of the sides of the M2M buffer is set,
> >>>>> but that would break some possible real usecases.      
> >>>>
> >>>> Not sure what you mean here.    
> >>>
> >>> I mean that one possible solution would be that, if one side sets 
> >>> resolution, the answer for the ioctls on the other side would be
> >>> different. IMHO, that's a bad idea.
> >>>     
> >>>>>
> >>>>> I suspect that the option that it would work best is to have a
> >>>>> flag to indicate that a M2M device has scalers.
> >>>>>
> >>>>> In any case, this should be discussed and properly documented
> >>>>> before we would be able to implement a non-scaling M2M device.      
> >>>>
> >>>> I don't know where you get the idea that most m2m devices scale.
> >>>> The reverse is true, very few m2m devices have a scaler.    
> >>>
> >>> No, I didn't say that most m2m devices scale. I said that the initial
> >>> M2M implementations scale, and that's probably one of the reasons why 
> >>> this is the behavior that Gstreamer expects scales on transform devices.    
> >>
> >> Well, it doesn't really matter. The fact is that gstreamer apparently
> >> makes assumptions that are not in general valid.
> >>
> >> And all this is made worse by insufficiently detailed documentation and
> >> insufficient compliance testing.  
> > 
> > Well, any change now would break an existing userspace app, and this is
> > something we shouldn't do. Worse than that, I suspect that Gstreamer is
> > actually used on several custom platform-dependent media applications.
> >   
> >> Patches are welcome.  
> > 
> > I know. Need to think a little bit more about what would be the best
> > solution for it though. We have very few space at VIDIOC_QUERYCAP, and
> > I'm not sure if a "HAVE_SCALER" flag would belong there.  
> 
> We have a u32 reserved[3] for QUERYCAP, so we have room for many more
> capabilities.
> 
> What I would like to see are these flags:
> 
> V4L2_CAP_HAS_DEVICE_CAPS2: indicate that there is a device_caps2 capability
> field.

makes sense, except that _CAPS2 is a bad name ;-) EXTENDED_CAPS?

Or if we end by adding such caps per format (see below) name it as
V4L2_CAP_HAS_PER_FMT_CAPS.

> 
> And add these defines for the device_caps2 field:
> 
> V4L2_CAP2_VIDEO_CAPTURE_HAS_CROP
> V4L2_CAP2_VIDEO_CAPTURE_HAS_COMPOSE
> V4L2_CAP2_VIDEO_CAPTURE_HAS_SCALER

Makes sense.

> V4L2_CAP2_VIDEO_OUTPUT_HAS_CROP
> V4L2_CAP2_VIDEO_OUTPUT_HAS_COMPOSE
> V4L2_CAP2_VIDEO_OUTPUT_HAS_SCALER

Not so so sure about that. At the moment we start needing to put
multiple caps, it sounds that this flag should be per interface.
See below.

> V4L2_CAP2_VIDEO_M2M_HAS_SCALER

IMHO, We don't need this. As far as I can see, on a M2M driver, scaler
affects the capture buffer.

Btw, a M2M device with crop/composite in thesis could have it
either on capture or output (or even on both).

I'm stating to think that we should have this flag returned instead
when the app is adjusting the capture/output format.

In other words, a device with dozens of interfaces may need such flag
per interface (and, if M2M, on each side of the pipeline). 

So, IMO, the best would be to return such kind of flags at
S_FMT, G_FMT and TRY_FMT return. ON other words, this should be
added into v4l2_format.

So, the new v4l2_format.flags would be something like:

	V4L2_FMT_HAS_CROP
	V4L2_FMT_HAS_COMPOSE
	V4L2_FMT_HAS_SCALER

I suspect we have enough space for it already at v4l2_format, as it
reserves 200 bytes for format-specific structs, but, if I counted
well, the biggest one is 52 bytes (struct v4l2_pix_format_mplane).

So, we could define it, for example, as:

struct v4l2_format {
	__u32	 type;
	union {
		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
		struct v4l2_sdr_format		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
		struct v4l2_meta_format		meta;    /* V4L2_BUF_TYPE_META_CAPTURE */
		__u8	raw_data[188];                   /* reserve space for other structs */
	} fmt;
	__u32	flags;		/* This should be 64-bit aligned */
	__u8	reserved[8];
};

> The main problem is what to do with drivers that do not explicitly set
> these capabilities.

If the driver doesn't set those new capabilities, just don't return
V4L2_CAP_HAS_PER_FMT_CAPS (or whatever name we give for it).

I would make an effort tough to ensure that all drivers would be using
those flags, trying to touch all of them for the same Kernel version.

> Applications need to know whether the driver never
> sets the capabilities, or that it is not capable of these features.
> 
> Perhaps the best way is to add these caps:
> 
> V4L2_CAP2_VIDEO_CAPTURE_FIXED
> V4L2_CAP2_VIDEO_OUTPUT_FIXED
> V4L2_CAP2_VIDEO_M2M_FIXED

That doesn't make any sense for me. I mean, all drivers that return
V4L2_CAP_HAS_PER_FMT_CAPS to QUERYCAP should properly fill the new
v4l2_format.flags field, telling if it supports or not scaler/crop/compose.

> 
> that are set when the driver is incapable of cropping/composing/scaling.
> 
> If all bits are 0, then you don't know and you have to test for these
> features (i.e. the current situation). You want to have a nice macro
> to test this.

If V4L2_CAP_HAS_PER_FMT_CAPS is not set, apps should probe.

> 
> v4l2-compliance can easily use these caps to verify if the driver isn't
> lying to the user, so that is a nice bonus.
> 
> What do you think about this?
> 
> I can make an RFC PATCH if you think this is the right direction.

Yeah, a RFC is welcomed.

> 
> Regards,
> 
> 	Hans

Thanks,
Mauro
