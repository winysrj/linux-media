Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZFOTvP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 15:51:15 -0400
Date: Mon, 15 Jun 2009 16:51:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: RFC: remove video_register_device_index, add
 video_register_device_range
Message-ID: <20090615165113.190a9de5@pedra.chehab.org>
In-Reply-To: <200906151602.40677.hverkuil@xs4all.nl>
References: <200906151325.29079.hverkuil@xs4all.nl>
	<20090615104421.5d6db842@pedra.chehab.org>
	<200906151602.40677.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Jun 2009 16:02:40 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

>
> The sticking point for me is that warning since for cx18/ivtv it is OK if you
> get something else then you specified (since it is a starting index meant to
> distinguish mpeg encoders from raw video inputs, from mpeg decoders, etc.).
> 
> So generating a warning for those two drivers is not correct.
Ok.

> Perhaps we should add a V4L2_FL_KNUM_OFFSET flag for the struct video_device
> flags field that tell the register function that 'nr' should be interpreted
> as a kernel number offset, and not as a preferred number. In the latter case
> you generate a warning, in the first case you don't.

Hmm... V4L2_FL_KNUM_OFFSET seems a too obfuscated name. Also, such flag would
be needed by just the register function, so, IMO, a parameter would work better.

Also, am I wrong or is there anything wrong with the flags?

The only place I'm seeing this being used is here:

$ grep 'vdev->flags' v4l/*.[ch]
v4l/v4l2-dev.c: set_bit(V4L2_FL_UNREGISTERED, &vdev->flags);

It is being set, but no code seems to actually test for it. So, IMO, we can
just remove this field.

One alternative would be to implement it as something like:

+int __must_check __video_register_device(struct video_device *vdev,
+                                      const int type, const int nr, int warn_if_skip);

#define video_register_device(vdev, type, nr) __video_register_device(vdev, type, nr, 0)

> 
> I think it isn't a bad idea to use a flag. It reflects the two possible use
> cases: one for drivers that create multiple video (or vbi) devices and use the
> kernel number to reflect the purpose of each video device, and the other where
> the user wants a specific kernel number. In the latter case the driver creates
> a single video device.
> 
> I don't want to see a lot of kernel warnings each time an ivtv or cx18 driver
> is loaded. Those warnings do not apply to those drivers.
> 
> BTW: please note that my v4l-dvb-misc tree contains a patch to clean up the
> comments/variable names in v4l2-dev.c. You might want to pull that in first.

Please see my comments for your v4l-dvb-misc tree pull request. Let's first
work on that changeset, and then we can discuss better about the warning issue.

> Regards,
> 
> 	Han



Cheers,
Mauro
