Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2LXPGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 10:06:41 -0500
Date: Mon, 24 Dec 2012 13:06:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch update notification: 37 patches updated
Message-ID: <20121224130615.00211d85@redhat.com>
In-Reply-To: <50D834D6.7080207@googlemail.com>
References: <20121223000802.14820.14465@www.linuxtv.org>
	<50D70AFB.5070702@googlemail.com>
	<20121223125715.782e17e0@redhat.com>
	<50D834D6.7080207@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 24 Dec 2012 11:56:22 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 23.12.2012 15:57, schrieb Mauro Carvalho Chehab:
> > Em Sun, 23 Dec 2012 14:45:31 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Hi Mauro,
> >>
> >> Am 23.12.2012 01:08, schrieb Patchwork:
> >>> Hello,
> >>>
> >>> The following patches (submitted by you) have been updated in patchwork:
> >>>
> >>>  * [3/6] em28xx: fix capture type setting in em28xx_urb_data_copy_vbi()
> >>>      - http://patchwork.linuxtv.org/patch/15651/
> >>>     was: New
> >>>     now: Accepted
> >>>
> >>>  * [8/9] em28xx: move the em2710/em2750/em28xx specific frame data processing code to a separate function
> >>>      - http://patchwork.linuxtv.org/patch/15798/
> >>>     was: New
> >>>     now: Accepted
> >>>
> >>>  * [4/6] em28xx: fix/improve frame field handling in em28xx_urb_data_copy_vbi()
> >>>      - http://patchwork.linuxtv.org/patch/15652/
> >>>     was: New
> >>>     now: Accepted
> >> This patch has not been applied yet to the media-tree.
> >> Without this patch, frame data processing for non-interlaced devices is
> >> broken.
> > Not sure what happened there: I couldn't see this specific patch. Yet,
> > at least some of the changes there seem to be applied. My guess is that
> > somehow, this patch got merged with some other patch, or maybe the
> > conflicts solving when the vbi-merge patches got applied (partially)
> > fixed it.
> >
> > In any case, you'll need to rebase it, as it doesn't apply anymore.
> 
> Ok, I did a git diff against my local version and all changes (except
> the remaining i2c stuff) seem to be applied.
> 
> One thing I noticed: you fixed strings with lines > 80 characters.
> This is handled differently everywhere...
> I know splitting strings breaks grepping, OTOH checkpatch complains.
> So you prefer violating the 80 chars rule ?

80-chars is a warning, and, from time to time, it rises discussions here
and at LKML, as there are know cases where this is violated for good.

We prefer to not break long string lines due to grep. It also can makes the
code a little more obfuscate (like on one place on your patchset where
the same string was broken into 3 or 4 lines).

The hole idea of the 80 cols rule is to avoid obfuscation, by avoiding
having complex logic inside the Kernel, and not to create more obfuscation ;)

Of course, we don't want a big "style fix" patch changing it, but, as the
code is being touched, we fix those style stuff.

Regards,
Mauro
