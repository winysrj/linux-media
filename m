Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60358 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2JQAYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 20:24:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: media-workshop@linuxtv.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] RFC: V4L2 API ambiguities
Date: Wed, 17 Oct 2012 02:25 +0200
Message-ID: <1758580.dogfQVcdf2@avalon>
In-Reply-To: <201210151335.45477.hverkuil@xs4all.nl>
References: <201210151335.45477.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 15 October 2012 13:35:45 Hans Verkuil wrote:
> During the Plumbers Conference a few weeks ago we had a session to resolve
> V4L2 ambiguities. It was very successful, but we didn't manage to tackle
> two of the harder topics, and a third one (timestamps) cause a lot of
> discussion on the mailinglist after the conference.
> 
> So here is the list I have today. Any other ambiguities or new features that
> should be added to the list?

Small topic that we've briefly discussed on IRC: if a device doesn't tell the 
driver what color space it uses, should the driver guess or tell the 
application that the color space is unknown ? I've ran into that issue for the 
uvcvideo driver, while I agree with you that in that case the color space is 
very likely sRGB, and that the driver is probably in a better position to make 
that guess than the userspace application (as the driver knows it handles a 
webcam), what should be the rule ?

> 1) Make a decision how to tell userspace that the monotonic timestamp is
> used.
> 
> Several proposals were made, but no decision was taken AFAIK. Can someone
> (Sakari?) make a summary/current status of this?
> 
> 
> 2) Pixel Aspect Ratio
> 
> Pixel aspect: currently this is only available through VIDIOC_CROPCAP. It
> never really belonged to VIDIOC_CROPCAP IMHO. It's just not a property of
> cropping or composing. It really belongs to the input/output timings (STD
> or DV_TIMINGS). That's where the pixel aspect ratio is determined.
> 
> While it is possible to add it to the dv_timings struct, I see no way of
> cleanly adding it to struct v4l2_standard (mostly because VIDIOC_ENUMSTD is
> now handled inside the V4L2 core and doesn't call the drivers anymore).

Isn't that an implementation issue instead of an API issue ?

> An alternative is to add it to struct v4l2_input/output, but I don't know if
> it is possible to define a pixelaspect for inputs that are not the current
> input. What I am thinking of is just to add a new ioctl for this:
> VIDIOC_G_PIXELASPECT.
> 
> 
> 3) Tuner Ownership
> 
> How to handle tuner ownership if both a video and radio node share the same
> tuner?
> 
> Obvious rules:
> 
> - Calling S_FREQ, S_TUNER, S_MODULATOR or S_HW_FREQ_SEEK will make the
> filehandle the owner if possible. EBUSY is returned if someone else owns
> the tuner and you would need to switch the tuner mode.
> - Ditto for ioctls that expect a valid tuner configuration like QUERYSTD.
> This is likely to be driver dependent, though.
> - Just opening a device node should not switch ownership.
> 
> But it is not clear what to do when any of these ioctls are called:
> 
> - G_FREQUENCY: could just return the last set frequency for radio or TV:
> requires that that is remembered when switching ownership. This is what
> happens today, so G_FREQUENCY does not have to switch ownership.
> - G_TUNER: the rxsubchans, signal and afc fields all require ownership of
> the tuner. So in principle you would want to switch ownership when G_TUNER
> is called. On the other hand, that would mean that calling v4l2-ctl --all
> -d /dev/radio0 would change tuner ownership to radio for /dev/video0.
> That's rather unexpected.
> 
>   It is possible to just set rxsubchans, signal and afc to 0 if the device
> node doesn't own the tuner. I'm inclined to do that.
> - Should closing a device node switch ownership? E.g. if nobody has a radio
> device open, should the tuner switch back to TV mode automatically? I don't
> think it should.
> - How about hybrid tuners?

-- 
Regards,

Laurent Pinchart

