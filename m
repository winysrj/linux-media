Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1973 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934822AbZFOVOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 17:14:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFC: remove video_register_device_index, add video_register_device_range
Date: Mon, 15 Jun 2009 23:14:30 +0200
Cc: linux-media@vger.kernel.org
References: <200906151325.29079.hverkuil@xs4all.nl> <200906151602.40677.hverkuil@xs4all.nl> <20090615165113.190a9de5@pedra.chehab.org>
In-Reply-To: <20090615165113.190a9de5@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906152314.31198.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 15 June 2009 21:51:13 Mauro Carvalho Chehab wrote:
> Em Mon, 15 Jun 2009 16:02:40 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> >
> > The sticking point for me is that warning since for cx18/ivtv it is OK if you
> > get something else then you specified (since it is a starting index meant to
> > distinguish mpeg encoders from raw video inputs, from mpeg decoders, etc.).
> > 
> > So generating a warning for those two drivers is not correct.
> Ok.
> 
> > Perhaps we should add a V4L2_FL_KNUM_OFFSET flag for the struct video_device
> > flags field that tell the register function that 'nr' should be interpreted
> > as a kernel number offset, and not as a preferred number. In the latter case
> > you generate a warning, in the first case you don't.
> 
> Hmm... V4L2_FL_KNUM_OFFSET seems a too obfuscated name. Also, such flag would
> be needed by just the register function, so, IMO, a parameter would work better.

That was the idea with the video_register_device_range() proposal. I don't want
to modify all existing video_register_device() calls.

> Also, am I wrong or is there anything wrong with the flags?
> 
> The only place I'm seeing this being used is here:
> 
> $ grep 'vdev->flags' v4l/*.[ch]
> v4l/v4l2-dev.c: set_bit(V4L2_FL_UNREGISTERED, &vdev->flags);
> 
> It is being set, but no code seems to actually test for it. So, IMO, we can
> just remove this field.

No, it is used a lot through the video_is_unregistered() inline in
media/v4l2-dev.h.

> 
> One alternative would be to implement it as something like:
> 
> +int __must_check __video_register_device(struct video_device *vdev,
> +                                      const int type, const int nr, int warn_if_skip);
> 
> #define video_register_device(vdev, type, nr) __video_register_device(vdev, type, nr, 0)

Hmm, that's an option. Although I'd make it a static inline:

static inline int __must_check video_register_device(...)
{
	return __video_register_device(vdev, type, nr, 1);
}

Regards,

	Hans

> 
> > 
> > I think it isn't a bad idea to use a flag. It reflects the two possible use
> > cases: one for drivers that create multiple video (or vbi) devices and use the
> > kernel number to reflect the purpose of each video device, and the other where
> > the user wants a specific kernel number. In the latter case the driver creates
> > a single video device.
> > 
> > I don't want to see a lot of kernel warnings each time an ivtv or cx18 driver
> > is loaded. Those warnings do not apply to those drivers.
> > 
> > BTW: please note that my v4l-dvb-misc tree contains a patch to clean up the
> > comments/variable names in v4l2-dev.c. You might want to pull that in first.
> 
> Please see my comments for your v4l-dvb-misc tree pull request. Let's first
> work on that changeset, and then we can discuss better about the warning issue.
> 
> > Regards,
> > 
> > 	Han
> 
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
