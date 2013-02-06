Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab3BFP7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:59:00 -0500
Date: Wed, 6 Feb 2013 13:58:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch update notification: 2 patches updated
Message-ID: <20130206135855.48b74ffb@redhat.com>
In-Reply-To: <5112782A.5000706@googlemail.com>
References: <20130205213301.13968.54926@www.linuxtv.org>
	<51117DA2.4030703@googlemail.com>
	<20130205200859.3ab68dd3@redhat.com>
	<5112782A.5000706@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 Feb 2013 16:35:06 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 05.02.2013 23:08, schrieb Mauro Carvalho Chehab:
> > Em Tue, 05 Feb 2013 22:46:10 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 05.02.2013 22:33, schrieb Patchwork:
> >>> Hello,
> >>>
> >>> The following patches (submitted by you) have been updated in patchwork:
> >> ...
> >>>  * [RFC] em28xx: fix analog streaming with USB bulk transfers
> >>>      - http://patchwork.linuxtv.org/patch/16197/
> >>>     was: New
> >>>     now: RFC
> >> What's your plan with this patch ?
> >> We have this regression in the media-tree since a few weeks now.
> >> Nobody replied to it or came up with a better solution...
> > Well, you tagged it as RFC. I just marked as such at patchwork. I don't even
> > read patches tagged as [RFC] or [REVIEW],
> 
> Uhm... even patches which are sent to you as the maintainer of the
> _driver_ ?
> Isn't commenting / reviewing patches the maintainers job ?
> 
> 
> >  as those patches will be
> > resubmitted later by the patch author, if they're ok, or a new version will
> > be sent instead.
> 
> That's what I'm asking you. Is this patch ok / ready ?
> Or can I generally conclude that patches are fine when there is no
> reaction on them ?

Frank,

As you may notice, my main "job" with regards to media stuff is to be
the media core maintainer. My work as a driver maintainer or as a
developer is forced to go to a second plane, as my time is limited.
So, I generally trust that driver developers are doing the right
thing.

ATM, I won't have anytime soon to test patches. So, if those patches 
require any test from me, they'll need to be postponed to 3.10, as I'm
finishing the handling of the patches for 3.9 today.

Also, from my side, there are simply too much patches sent to me, either
on my inbox (where I never read) and/or at linux-media ML. The last ones
I get from patchwork. Sometimes, even before picking the patches, I tag
everything with RFC or REVIEW on it as RFC. Then I handle the remaining
ones. This is to reduce the load to an acceptable work queue.

So, if you think that the USB patches are ok, just send it to the ML
without tagging it, and I'll analyze and apply if I believe that they're
ok. I'll eventually test the em28xx driver later, when I found some time.

If otherwise you think they may not be ready yet, the better to wait
for Devin to test, if it has some time, or send me a separate email asking
for me to test the patches.

Regards,
Mauro
