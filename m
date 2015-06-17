Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40331 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbbFQLze (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 07:55:34 -0400
Date: Wed, 17 Jun 2015 08:55:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [RFC PATCH 1/3] modify the vb2_buffer structure for common
 video buffer and make struct vb2_v4l2_buffer
Message-ID: <20150617085528.127ec347@recife.lan>
In-Reply-To: <557AAFBC.2050509@xs4all.nl>
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
	<1433770535-21143-2-git-send-email-jh1009.sung@samsung.com>
	<557AAD40.9020009@xs4all.nl>
	<557AAFBC.2050509@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 12 Jun 2015 12:09:00 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/12/2015 11:58 AM, Hans Verkuil wrote:
> > Hi Junghak,
> > 
> > On 06/08/2015 03:35 PM, Junghak Sung wrote:
> >> Make the struct vb2_buffer to common buffer by removing v4l2-specific members.
> >> And common video buffer is embedded into v4l2-specific video buffer like:
> >> struct vb2_v4l2_buffer {
> >>     struct vb2_buffer    vb2;
> >>     struct v4l2_buffer    v4l2_buf;
> >>     struct v4l2_plane    v4l2_planes[VIDEO_MAX_PLANES];
> >> };
> >> This changes require the modifications of all device drivers that use this structure.
> > 
> > It's next to impossible to review just large diffs, but it is unavoidable for
> > changes like this I guess.
> > 
> > I do recommend that you do a 'git grep videobuf2-core' to make sure all usages
> > of that have been replaced with videobuf2-v4l2. I think I saw videobuf2-core
> > mentioned in a comment, but it is hard to be sure.
> > 
> > It would also be easier to review if the renaming of core.[ch] to v4l2.[ch] was
> > done in a separate patch. If it is relatively easy to split it up like that,
> > then I would appreciate it, but if it takes a lot of time, then leave it as is.
> > 
> > Anyway, assuming that 'git grep videobuf2-core' doesn't find anything:
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Sorry, I'm retracting that Acked-by: I tried to apply it and I saw it was against
> an old kernel version, not against the media_tree master branch.

Well, no matter on what version this patch is produced, it would very
likely cause merge conflicts. The best here would be if you add a
small shell/perl script at the body of the patch that would be doing
the renaming thing at the drivers. This way, the maintainer can run the
script when merging it. That would warrant that this would be changed
everywhere and noting was left behind.

> Also, I thought videobuf2-core.[ch] was renamed to videobuf2-v4l2.[ch], but that's
> not the case. I think that would make much more sense. Later patches can split up
> videobuf2-v4l2.c/h into a videobuf2-core and -v4l2 part.

> >>  copy drivers/media/v4l2-core/{videobuf2-core.c => videobuf2-v4l2.c} (89%)
> >>  copy include/media/{videobuf2-core.h => videobuf2-v4l2.h} (94%)

Actually, it is being copied, with is almost the same.

I agree that this series could be better split into:

1) a patch that would be just doing:
	mv drivers/media/v4l2-core/videobuf2-core.c drivers/media/v4l2-core/videobuf2-v4l2.c 
	mv include/media/videobuf2-core.h include/media/videobuf2-v4l2.h

And changing the includes and Makefile bits to use the new header.

2) this patch (with the script used to produce it);

3) patches that would be gradually moving the common functions from
   videobuf2-v4l2.c into videobuf2-core.c.

Regards,
Mauro

