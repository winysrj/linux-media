Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab0IVTmG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 15:42:06 -0400
Message-ID: <4C9A5C0B.3040506@redhat.com>
Date: Wed, 22 Sep 2010 16:42:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.37] V4L documentation fixes
References: <201009150923.50132.hverkuil@xs4all.nl>
In-Reply-To: <201009150923.50132.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-09-2010 04:23, Hans Verkuil escreveu:
> The following changes since commit 57fef3eb74a04716a8dd18af0ac510ec4f71bc05:
>   Richard Zidlicky (1):
>         V4L/DVB: dvb: fix smscore_getbuffer() logic
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git misc2
> 
> Hans Verkuil (6):
>       V4L Doc: removed duplicate link

This doesn't seem right. the entry for V4L2-PIX-FMT-BGR666 seems to be duplicated.
We should remove the duplication, instead of just dropping the ID.

>       V4L Doc: fix DocBook syntax errors.
>       V4L Doc: document V4L2_CAP_RDS_OUTPUT capability.
>       V4L Doc: correct the documentation for VIDIOC_QUERYMENU.

Applied, thanks.

>       V4L Doc: rewrite the Device Naming section

The new text is incomplete, as it assumes only the old non-dynamic device node
creation. Also, some distros actually create /dev/v4l, as recommended. IMHO, we
need to improve this section, proposing a better way to name devices. This may
be an interesting theme for this year's LPC.


>       V4L Doc: clarify the V4L spec.

This is a mix of several changes on the same patch. I want to do comments about it,
but no time right now to write an email about that. It is a way harder to comment
Docbook changes than patches, as the diff output is not user-friendly.
I'll postpone this patch for a better analysis.

I don't want to postpone the DocBook correction patches due to that, so I'm applying
the patches I'm ok.

Cheers,
Mauro
