Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:52475 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758442Ab0EYXyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 19:54:55 -0400
Subject: Re: v4l-dvb does not compile with kernel 2.6.34
From: hermann pitton <hermann-pitton@arcor.de>
To: Helmut Auer <vdr@helmutauer.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4BFC4858.8060403@helmutauer.de>
References: <4BFC4858.8060403@helmutauer.de>
Content-Type: text/plain
Date: Wed, 26 May 2010 01:43:53 +0200
Message-Id: <1274831033.3273.67.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helmut,

Am Dienstag, den 25.05.2010, 23:59 +0200 schrieb Helmut Auer:
> Hello
> 
> I just wanted to compile v4l-dvb for my Gen2VDR Ditribution with kernel 2.6.34, but it fails
> because many modules are missing:
> 
> #include <linux/slab.h>
> 
> and are getting errors like:
> 
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> 'free_firmware':
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:252: error: implicit
> declaration of function 'kfree'
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> 'load_all_firmwares':
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:314: error: implicit
> declaration of function
> 
> Am I missing something or is v4l-dvb broken ?
> 

I did not test on all, but had some rant few days ago and explanations
followed and I likely missed some RFCs in that direction previously.

If I do get it right now, the released vanilla 2.6.34 should be stable.

For the upcoming 2.6.35, like always, only the first upcoming rc1 is a
potential candidate for some first stability there.

On mercurial v4l-dvb, with all patch porting in this hybrid ;) situation
with mixed up- and backports, after the git branch is official, only
2.6.33 is considered to be stable for now.

There are still "compatibility bugs" on all earlier kernels I guess,
but /me agreed to have at least four weeks for "fixing" them.

An average kernel release cycle is about three months.

I asked, if we should not all go to latest stable vanilla and upcoming
rc candidates instead. By that mass of devices we have now, those with
relevant hardware must come back for testing on rc stuff anyway.

The decision for now was to keep backward compat, to allow to have more
testers, this was always my point of view over all the years too.
During all that, we changed a lot these days from "hacked" drivers to by
chip manufacturers and OEMs fully supported ones.

This is the root cause for going to git and includes to stay in sync
with other subsystems on git level doing the same.

For what is still trickling in from active users, I also have to say,
that this throws one back into time consuming efforts again, even more
time consuming than that times v4l and dvb did go out of sync on every
new kernel in the past and if it is only about to avoid latest vanilla
or upcoming rc stuff and keep staying on older kernels, is it worth it?

Testers will vote with their feet.

In other words, to keep bisecting reliable on Linus' git level is
already a huge task, to keep mercurial v4l-dvb bisecting with all the
compat stuff functional, ugh.

Also, no doubt, Hans' daily build reports are really helpful, but to
assume only seeing warnings there now, after a first "fix" for some
upper older kernel came in, and previously say eight did error out at
the same point, is no replacement for testing with real devices on every
such later kernel ...

The rest is pure luck and a rare case.

We likely should wait for two/three kernel release cycles, but I predict
Douglas will have a very hard job, if not much more people come in to
support backward compatibility on mercurial level.

Thanks for your report from the upper side ;)

Cheers,
Hermann








