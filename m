Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37590 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1KKDTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 22:19:52 -0500
Received: by ggnb2 with SMTP id b2so3748217ggn.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 19:19:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBC8A2C.40305@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
	<CAGoCfiz5O4_GHnYWtt4RQsRCWV7iXEh8DYYNFX1_R7Ni2e3Yvg@mail.gmail.com>
	<4EBC8A2C.40305@gmail.com>
Date: Thu, 10 Nov 2011 22:19:51 -0500
Message-ID: <CAGoCfiyox6rW_g4paHXL7_U4wx3MF_178xCta3n2R58OgvZVCQ@mail.gmail.com>
Subject: Re: [PATCH 00/25] Add PCTV-80e Support to v4l
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Patrick Dickey <pdickeybeta@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 10, 2011 at 9:36 PM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> Also, I started to clean up the files tonight. Then I started thinking
> about what you told me about the as102 drivers, and thought I should
> submit them "as is" and then start the cleanup and submit those
> patches separately. Also that way others could help with some of the
> cleanup. I have to figure out if there's an easy way to convert all of
> the "DOS Line Endings" to the appropriate style, or if I'll have to do
> that manually (and whether my editor(s) caused this).

Definitely you want the cleanup fixes to be in separate patches from
the original patch with the driver.  This is necessary because it
makes it *much* easier to figure out if something got broken as a
result of a cleanup patch (which isn't supposed to make any functional
change).

> One reason I did the extra work is because your tree had other files
> (the cx18 drivers for example) that didn't seem to be needed by the
> tuner. So, I cleaned them out (partially because I have two cards that
> use those drivers and didn't want to break those).  I can review all
> of the files to make sure that I didn't miss any.  And I can update
> all of the files from your tree to the most current versions and
> submit everything again.

This shouldn't be the case (the two patches will have no interaction
with any driver other than em28xx).  I would suggest that instead of
treating it as a tree, just suck the two patches off the top and apply
them to your current tree one at a time, and fix any conflicts that
pop up.

http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/raw-rev/c119f08c4dd2
http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/raw-rev/30c6512030ac

If you just apply the patches instead of trying to hand-merge the two
trees together, you will only get the delta and will likely just have
to fix the 4 or five conflicts in em28xx.h and em28xx-cards.c (related
to the fact that subsequent boards were added to the driver after my
patch).

That approach should only take a few minutes, given the conflicts are
trivial to resolve.

Good luck!

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
