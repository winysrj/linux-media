Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4161 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0IVStj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 14:49:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] davinci & videobuf fixes
Date: Wed, 22 Sep 2010 20:49:07 +0200
Cc: linux-media@vger.kernel.org,
	Mats Randgaard <mats.randgaard@tandberg.com>
References: <201009071123.25174.hverkuil@xs4all.nl> <4C9A4D47.3080605@redhat.com>
In-Reply-To: <4C9A4D47.3080605@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009222049.07597.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, September 22, 2010 20:39:03 Mauro Carvalho Chehab wrote:
> Em 07-09-2010 06:23, Hans Verkuil escreveu:
> > Hi Mauro,
> > 
> > The following changes since commit 50b9d21ae2ac1b85be46f1ee5aa1b5e588622361:
> >   Jarod Wilson (1):
> >         V4L/DVB: mceusb: add two new ASUS device IDs
> > 
> > are available in the git repository at:
> > 
> >   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git for-2.6.37
> > 
> > Hans Verkuil (1):
> >       videobuf-dma-sg: set correct size in last sg element
> 
> Ok.
> > 
> > Mats Randgaard (5):
> >       videobuf-core.c: Replaced BUG_ON with WARN_ON
> 
> Why? Please provide a description to allow us to understand why this change makes sense.
> Is there any condition where this would be acceptable?

Does it indicate a driver bug? Yes. But it's not a harmful driver bug, i.e. it
will not cause a crash later. So BUG_ON is way overkill. WARN_ON is sufficient.

A bug in the davinci driver actually triggered this BUG_ON for us. Since it's
a BUG_ON you are forced to reboot for no good reason. Note that we are working
on fixing the davinci bug as well.

AFAIK BUG_ON is meant for fatal errors, i.e. continuing will cause crashes later.
That's not at all the case here.

Regards,

	Hans

> >       vpif_cap/disp: Removed section mismatch warning
> >       vpif_cap/disp: Replaced kmalloc with kzalloc
> >	vpif_cap: don't ignore return code of videobuf_poll_stream()
> 
> The better would be to provide some description for all patches, but, in this
> specific case, they're trivial.
> 
> Applied, thanks.
> 
> >       vpif_cap/disp: Fixed strlcpy NULL pointer bug
> 
> Hmm... this one doesn't make sense to me. Instead, you should be sure that
> config->card_name (or cap->card) is always filled.
> 
> Ok, I've applied 4 of the 6 patches (I've included the patch of the last email
> on the above).
> 
> Please, provide a better solution for the strlcpy NULL pointer bug, properly
> filling the config struct in all cases.
> 
> Cheers,
> Mauro
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
