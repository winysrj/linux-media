Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab2LWO5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 09:57:40 -0500
Date: Sun, 23 Dec 2012 12:57:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch update notification: 37 patches updated
Message-ID: <20121223125715.782e17e0@redhat.com>
In-Reply-To: <50D70AFB.5070702@googlemail.com>
References: <20121223000802.14820.14465@www.linuxtv.org>
	<50D70AFB.5070702@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 23 Dec 2012 14:45:31 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Hi Mauro,
> 
> Am 23.12.2012 01:08, schrieb Patchwork:
> > Hello,
> >
> > The following patches (submitted by you) have been updated in patchwork:
> >
> >  * [3/6] em28xx: fix capture type setting in em28xx_urb_data_copy_vbi()
> >      - http://patchwork.linuxtv.org/patch/15651/
> >     was: New
> >     now: Accepted
> >
> >  * [8/9] em28xx: move the em2710/em2750/em28xx specific frame data processing code to a separate function
> >      - http://patchwork.linuxtv.org/patch/15798/
> >     was: New
> >     now: Accepted
> >
> >  * [4/6] em28xx: fix/improve frame field handling in em28xx_urb_data_copy_vbi()
> >      - http://patchwork.linuxtv.org/patch/15652/
> >     was: New
> >     now: Accepted
> 
> This patch has not been applied yet to the media-tree.
> Without this patch, frame data processing for non-interlaced devices is
> broken.

Not sure what happened there: I couldn't see this specific patch. Yet,
at least some of the changes there seem to be applied. My guess is that
somehow, this patch got merged with some other patch, or maybe the
conflicts solving when the vbi-merge patches got applied (partially)
fixed it.

In any case, you'll need to rebase it, as it doesn't apply anymore.


Cheers,
Mauro
