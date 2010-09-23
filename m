Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3260 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0IWFsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 01:48:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] V4L documentation fixes
Date: Thu, 23 Sep 2010 07:47:55 +0200
Cc: linux-media@vger.kernel.org
References: <201009150923.50132.hverkuil@xs4all.nl> <201009222206.11694.hverkuil@xs4all.nl> <4C9A7254.8010604@redhat.com>
In-Reply-To: <4C9A7254.8010604@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009230747.55283.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, September 22, 2010 23:17:08 Mauro Carvalho Chehab wrote:
> Em 22-09-2010 17:06, Hans Verkuil escreveu:
> > On Wednesday, September 22, 2010 21:42:03 Mauro Carvalho Chehab wrote:
> >> Em 15-09-2010 04:23, Hans Verkuil escreveu:
> >>> The following changes since commit 57fef3eb74a04716a8dd18af0ac510ec4f71bc05:
> >>>   Richard Zidlicky (1):
> >>>         V4L/DVB: dvb: fix smscore_getbuffer() logic
> >>>
> >>> are available in the git repository at:
> >>>
> >>>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git misc2
> >>>
> >>> Hans Verkuil (6):
> >>>       V4L Doc: removed duplicate link
> >>
> >> This doesn't seem right. the entry for V4L2-PIX-FMT-BGR666 seems to be duplicated.
> >> We should remove the duplication, instead of just dropping the ID.
> > 
> > No, this patch is correct. This section really duplicates the formats due to
> > confusion about the byte order in memory. But only one of these format tables
> > should have a valid ID.
> > 
> > See table 2.4 and 2.5 here:
> > 
> > http://www.xs4all.nl/~hverkuil/spec/media.html#packed-rgb
> > 
> > As you can see here there is no BGR666 entry in either table since the docbook
> > generation has been failing on this docbook error for some time now.
> > 
> >>
> >>>       V4L Doc: fix DocBook syntax errors.
> >>>       V4L Doc: document V4L2_CAP_RDS_OUTPUT capability.
> >>>       V4L Doc: correct the documentation for VIDIOC_QUERYMENU.
> >>
> >> Applied, thanks.
> >>
> >>>       V4L Doc: rewrite the Device Naming section
> >>
> >> The new text is incomplete, as it assumes only the old non-dynamic device node
> >> creation. Also, some distros actually create /dev/v4l, as recommended. IMHO, we
> >> need to improve this section, proposing a better way to name devices. This may
> >> be an interesting theme for this year's LPC.
> > 
> > No, the major is still 81 and the minors are still between 0 and 255. But the minor
> > ranges are gone (unless you turn that on explicitly). So this text is really correct
> > and way more understandable than the old text.
> 
> Hmm... are the V4L core artificially limiting minor range to be between 0 and 255?

Well, we do need to keep a mapping between minor and video_device (the video_device
array in v4l2-dev.c) so we do need a maximum number of devices. Increasing this number
is a matter of just increasing the VIDEO_NUM_DEVICES macro.

Since we no longer split up the 256 minors into ranges for each video type (video,
vbi, radio) we make full use of all minors. Nothing I've seen comes even close to
filling up all those minors.

That said, when we add support for the subdev device nodes we should probably at the
same time double the number of reserved minors. Just in case.

Regards,

	Hans

> 
> > 
> >>
> >>>       V4L Doc: clarify the V4L spec.
> >>
> >> This is a mix of several changes on the same patch. I want to do comments about it,
> >> but no time right now to write an email about that. It is a way harder to comment
> >> Docbook changes than patches, as the diff output is not user-friendly.
> >> I'll postpone this patch for a better analysis.
> > 
> > No problem.
> > 
> > Regards,
> > 
> > 	Hans
> >  
> >> I don't want to postpone the DocBook correction patches due to that, so I'm applying
> >> the patches I'm ok.
> >>
> >> Cheers,
> >> Mauro
> >>
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
