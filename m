Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2HMNMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 09:12:38 -0400
Message-ID: <5028FD7E.1010402@redhat.com>
Date: Mon, 13 Aug 2012 15:13:34 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
References: <201208131427.56961.hverkuil@xs4all.nl>
In-Reply-To: <201208131427.56961.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

<snip>

> Easy:
>
> 1) Split off the control part from videodev2.h. Controls are almost 30% of
>     videodev2.h. I think maintaining controls would be easier if they are moved
>     to e.g. linux/v4l2-controls.h which is included by videodev2.h.
>

Ack.

> 2) Currently there are three types of controls: standard controls, controls
>     that are specific to a chipset (e.g. cx2341x, mfc51) and driver-specific
>     controls. The controls of the first two types have well defined and unique
>     IDs. For driver-specific controls however there are no clear rules.
>
>     It all depends on one question: should driver-specific controls have a
>     unique control ID as well, or can they overlap with other drivers?
>
>     If the answer is that they should be unique as well, then all driver-specific
>     controls will have to be defined in a single header so you can be certain
>     that there is no overlap.
>
>     If the answer is that they may overlap, then each driver can either define
>     their controls inside their own driver, or in a driver-specific public header.
>
>     In both cases a control ID range has to be defined for such controls, to
>     ensure that they never clash with standard or chipset-specific control IDs.
>     E.g. >= V4L2_CTRL_CLASS_XXX + 0x8000 (no overlap) or + 0xf000 (overlap
>     allowed).
>
>     My preference is to allow overlap.
>

+1 for allowing overlap, and only when it is expected that some special app will
actually use the device specific controls (versus the user changing them in
a generic v4l2 control panel app), then the private controls should be defined
in a public header. If no such special app is expected, the private controls
should be defined inside a private header of the driver.

> 3) What should VIDIOC_STREAMON/OFF do if the stream is already started/stopped?
>     I believe they should do nothing and just return 0. The main reason for that
>     is it can be useful if an application can just call VIDIOC_STREAMOFF without
>     having to check whether streaming is in progress.

+1 for just returning 0

> 4) What should a driver return in TRY_FMT/S_FMT if the requested format is not
>     supported (possible behaviours include returning the currently selected format
>     or a default format).
>
>     The spec says this: "Drivers should not return an error code unless the input
>     is ambiguous", but it does not explain what constitutes an ambiguous input.
>     Frankly, I can't think of any and in my opinion TRY/S_FMT should never return
>     an error other than EINVAL (if the buffer type is unsupported) or EBUSY (for
>     S_FMT if streaming is in progress).
>
>     Returning an error for any other reason doesn't help the application since
>     the app will have no way of knowing what to do next.
>

Ack on not returning an error for requesting an unavailable format. As for what the
driver should do (default versus current format) I've no preference, I vote for
letting this be decided by the driver implementation.

> 5) VIDIOC_QUERYCAP allows bus_info to be empty. Since the purpose of bus_info
>     is to distinguish multiple identical devices this makes no sense. I propose
>     to make the spec more strict and require that bus_info is always filled in
>     with a unique string.
>

Ack.

> 6) Deprecate V4L2_BUF_TYPE_PRIVATE. None of the kernel drivers use it, and I
>     cannot see any good use-case for this. If some new type of buffer is needed,
>     then that should be added instead of allowing someone to abuse this buffer
>     type.
>

Ack.

> 7) A driver that has both a video node and a vbi node (for example) that uses
>     the same struct v4l2_ioctl_ops for both nodes will have to check in e.g.
>     vidioc_g_fmt_vid_cap or vidioc_g_fmt_vbi_cap whether it is called from the
>     correct node (video or vbi) and return an error if it isn't.
>
>     That's an annoying test that can be done in the V4L2 core as well. Especially
>     since few drivers actually test for that.
>
>     Should such checks be added to the V4L2 core? And if so, should we add some
>     additional VFL types? Currently we have GRABBER (video nodes), VBI, RADIO
>     and SUBDEV. But if we want to do proper core checks, then we would also need
>     OUTPUT, VBI_OUT and M2M.

I'm in favor of adding checks to the core.

>
> 8) Remove the experimental tag from the following old drivers:
>
> 	VIDEO_TLV320AIC23B
> 	USB_STKWEBCAM
> 	VIDEO_CX18
> 	VIDEO_CX18_ALSA
> 	VIDEO_ZORAN_AVS6EYES
> 	DVB_USB_AF9005
> 	MEDIA_TUNER_TEA5761

ACK.

>
>     Removing this tag from these drivers might be too soon, though:
>
> 	VIDEO_NOON010PC30
> 	VIDEO_OMAP3
>

I've no opinion on these.

> 9) What should VIDIOC_G_STD/DV_PRESET/DV_TIMINGS return if the current input
>     or output does not support that particular timing approach? EINVAL? ENODATA?
>     This is relevant for the case where a driver has multiple inputs/outputs
>     where some are SDTV (and support the STD API) and others are HDTV (and
>     support the DV_TIMINGS API).
>
>     I propose ENODATA.

+1 for ENODATA, EINVAL makes no sense if all the input parameters are correct.

>
> 10) Proposal: add these defines:
>
> #define V4L2_IN_CAP_TIMINGS V4L2_IN_CAP_CUSTOM_TIMINGS
> #define V4L2_OUT_CAP_TIMINGS V4L2_OUT_CAP_CUSTOM_TIMINGS
>
> Since DV_TIMINGS is now used for any HDTV timings and no longer just for
> custom, non-standard timings, the word "CUSTOM" is no longer appropriate.
>

No opinion.

> 11) What should video output drivers do with the sequence and timestamp
>      fields when they return a v4l2_buffer from VIDIOC_DQBUF?
>
>      I think the spec is clear with respect to the timestamp:
>
>      "The driver stores the time at which the first data byte was actually
>       sent out in the timestamp field."
>
>      For sequence the spec just says:
>
>      "Set by the driver, counting the frames in the sequence."
>
>      So I think that output drivers should indeed set both sequence and
>      timestemp.
>

Ack.

> 12) Make the argument of write-only ioctls const in v4l2-ioctls.h. This makes
>      it obvious to drivers that they shouldn't change the contents of the input
>      struct since it won't make it back to userspace. It also simplifies
>      v4l2-ioctl.c since it can rely on the fact that after the ioctl call the
>      contents of the struct hasn't changed. Right now the struct contents is
>      logged (if debugging is on) before the ioctl call for write-only ioctls.
>

Ack (although this will break compilation of some drivers, but that can be fixed).

> Hard(er):
>
> 1) What is the right/best way to set the timestamp? The spec says gettimeofday,
>     but is it my understanding that ktime_get_ts is much more efficient.
>
>     Some drivers are already using ktime_get_ts.
>
>     Options:
>
>     a) all drivers must comply to the spec and use gettimeofday
>     b) we change the spec and all drivers must use the more efficient ktime_get_ts
>     c) we add a buffer flag V4L2_BUF_FLAG_MONOTONIC to tell userspace that a
>        monotonic clock like ktime_get_ts is used and all drivers that use
>        ktime_get_ts should set that flag.
>
>     If we go for c, then we should add a recommendation to use one or the other
>     as the preferred timestamp for new drivers.

Wouldn't b/c break the API?

> 2) If a driver supports only formats with more than one plane, should
>     V4L2_CAP_VIDEO_CAPTURE still be defined?

No

>     And if a driver also supports
>     single-plane formats in addition to >1 plane formats, should
>     V4L2_CAP_VIDEO_CAPTURE be compulsary?

Yes, so that non multi-plane aware apps keep working.

> 3) VIDIOC_CROPCAP: the spec says that CROPCAP must be implemented by all
>     capture and output devices (Section "Image Cropping, Inserting and Scaling").
>     In reality only a subset of the drivers support cropcap.
>
>     Should cropcap really be compulsory? Or only for drivers that can scale? And
>     in that case, should we make a default implementation for those drivers that
>     do not support it? (E.g.: call g_fmt and use the width/height as the
>     default and bounds rectangles, and set the pixel aspect to 1/1)
>

I vote for making it non compulsory, and simply returning -ENOTTY for drivers which
don't support it.

> 4) Pixel aspect: currently this is only available through VIDIOC_CROPCAP. It
>     never really belonged to VIDIOC_CROPCAP IMHO. It's just not a property of
>     cropping/composing. It really belongs to the input/output timings (STD or
>     DV_TIMINGS). That's where the pixel aspect ratio is determined.
>
>     While it is possible to add it to the dv_timings struct, I see no way of
>     cleanly adding it to struct v4l2_standard (mostly because VIDIOC_ENUMSTD
>     is now handled inside the V4L2 core and doesn't call the drivers anymore).
>
>     An alternative is to add it to struct v4l2_input/output, but I don't know
>     if it is possible to defined a pixelaspect for inputs that are not the
>     current input.
>
>     What I am thinking of is just to add a new ioctl for this VIDIOC_G_PIXELASPECT.
>     The argument is then:
>
> 	struct v4l2_pixelaspect {
> 		__u32 type;
> 		struct v4l2_fract pixelaspect;
> 		__u32 reserved[5];
> 	};
>
>     This combines well with the selection API.

We will want to be able to enumerate this too, so I vote for extending v4l2_frmsize_discrete
with a struct v4l2_fract pixelaspect, and likewise for v4l2_frmsize_stepwise.

Likewise we also want to get the pixelaspect on a TRY_FMT, which is a bit tricky, since
we cannot extend  v4l2_pix_format (*) instead we could add a v4l2_pix_format_w_aspect, and add
that to the v4l2_format union. Then apps who want to pixelratio can look inside
v4l2_pix_format_w_aspect instead, with the note that the aspect may be reported as 0/0 by
drivers which don't support reporting it. This avoids adding a new ioctl, and gives us
a way to get the pixelratio without actually having to set the fmt.

(*) no reserved space inside it, and if we would allow it to grow, we still would have an
issue because that would also grow v4l2_framebuffer, which we certainly cannot do.

> 5) How to handle tuner ownership if both a video and radio node share the same
>     tuner?
>
>     Obvious rules:
>
>     - Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will change owner
>       or return EBUSY if streaming is in progress.

That won't work, as there is no such thing as streaming from a radio node, I
suggest we go with the simple approach we discussed at our last meeting in
your Dutch House: Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will
make an app the tuner-owner, and *closing* the device handle makes an app
release its tuner ownership. If an other app already is the tuner owner
-EBUSY is returned.

>     - Ditto for STREAMON, read/write and polling for read/write.

No, streaming and tuning are 2 different things, if an app does both, it
will likely tune before streaming, but in some cases a user may use a streaming
only app together with say v4l2-ctl to do the actual tuning. I think keeping
things simple here is key. Lets just treat the "tuner" and "stream" as 2 separate
entities with a separate ownership.

>     - Ditto for ioctls that expect a valid tuner configuration like QUERYSTD.

QUERY is a read only ioctl, so it should not be influenced by any ownership, nor
imply ownership.

>     - Just opening a device node should *not* switch ownership.
Ack!

>     But it is not clear what to do when any of these ioctls are called:
>
>     - G_FREQUENCY: could just return the last set frequency for radio or TV:
>       requires that that is remembered when switching ownership. This is what
>       happens today, so G_FREQUENCY does not have to switch ownership.

Ack.

>     - G_TUNER: the rxsubchans, signal and afc fields all require ownership of
>       the tuner. So in principle you would want to switch ownership when
>       G_TUNER is called. On the other hand, that would mean that calling
>       v4l2-ctl --all -d /dev/radio0 would change tuner ownership to radio for
>       /dev/video0. That's rather unexpected.
>
>       It is possible to just set rxsubchans, signal and afc to 0 if the device
>       node doesn't own the tuner. I'm inclined to do that.

Right, G_TUNER should not change ownership, if the tuner is currently in radio
mode and a G_TUNER is done on the video node just 0 out the fields which we cannot
fill with useful info.

>     - Should closing a device node switch ownership? E.g. if nobody has a radio
>       device open, should the tuner switch back to TV mode automatically? I don't
>       think it should.

+1 on delaying the mode switch until it is actually necessary to switch mode.

>     - How about hybrid tuners?

No opinion.

Regards,

Hans
