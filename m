Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4800 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab3BAHt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 02:49:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: [RFC PATCH 00/18] tlg2300: various v4l2-compliance fixes
Date: Fri, 1 Feb 2013 08:49:20 +0100
Cc: linux-media@vger.kernel.org
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <CAMiH66HAGRuPUYhbxm8_DUOPFfbKW832eJ4n-qq+-cNDMYr+9A@mail.gmail.com>
In-Reply-To: <CAMiH66HAGRuPUYhbxm8_DUOPFfbKW832eJ4n-qq+-cNDMYr+9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302010849.20841.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri February 1 2013 03:22:22 Huang Shijie wrote:
> Hi Hans:
> 
> On Thu, Jan 31, 2013 at 6:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi all,
> >
> > Last year I worked on this driver to improve it and fix v4l2-compliance
> > issues.
> 
> I am glad to know that there are still some people use the
> tlg2300. thanks a lot.
> 
> >
> > It required a lot of effort to even find a USB stick with this chipset
> > (telegent no longer exists) and unfortunately at some point I managed
> > to break the USB stick, so I am no longer able to work on it.
> >
> > This patch series represents that part of the work I've done that has
> > been tested. I have additional patches in my tlg2300-wip branch:
> >
> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/tlg2300-wip
> >
> > but since I am no longer certain at what point in those remaining patches
> > things broke down I've decided not to post them for upstreaming. If I or
> > someone else ever manages to get a working tlg2300 that code might be used
> > for further work.
> 
> Could you tell me how did you test your patch set?

I used the v4l2-compliance tool which we use to validate drivers. It's part of
v4l-utils.git: http://git.linuxtv.org/v4l-utils.git


> did you test the hibernate and suspend/resume?

No, it was on my todo list but the stick broke before I had a chance to test it.
However, none of the patches touch on suspend/resume.

> > Huang Shijie, are you still able to act as maintainer? If not, then I can
> > put my name in. The MAINTAINER status should probably move to 'Odd Fixes'
> 
> Yes, you can put your name in.

OK, I'll update that patch.

Regards,

	Hans

> I am busy some other drivers recently.
> 
> thanks
> Huang Shijie
> 
> > as well.
> >
> > Regards,
> >
> >         Hans
> >
> 
