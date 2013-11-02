Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:34134 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3KBQjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:39:33 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVN00CU6A9VVK50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 02 Nov 2013 12:39:31 -0400 (EDT)
Date: Sat, 02 Nov 2013 14:39:27 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [linux-media] Patch notification: 1 patch updated
Message-id: <20131102143927.5a14b7cd@samsung.com>
In-reply-to: <5274F75D.3040107@googlemail.com>
References: <20131031121301.23020.52079@www.linuxtv.org>
 <5274F75D.3040107@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 02 Nov 2013 14:00:13 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 31.10.2013 13:13, schrieb Patchwork:
> > Hello,
> >
> > The following patch (submitted by you) has been updated in patchwork:
> >
> >  * linux-media: em28xx: make sure that all subdevices are powered on when needed
> >      - http://patchwork.linuxtv.org/patch/20422/
> >      - for: Linux Media kernel patches
> >     was: New
> >     now: Superseded
> This patch isn't superseeded.
> Guennadi didn't pick it up, so it's still up to you to review it.

>From what I understood, Guennadi's patch series made it obsolete.
Right?

If not, what's the usecase where this patch is needed?

Regards,
Mauro

> 
> Regards,
> Frank
> 
> > This email is a notification only - you do not need to respond.
> >
> > -
> >
> > Patches submitted to linux-media@vger.kernel.org have the following
> > possible states:
> >
> > New: Patches not yet reviewed (typically new patches);
> >
> > Under review: When it is expected that someone is reviewing it (typically,
> > 	      the driver's author or maintainer). Unfortunately, patchwork
> > 	      doesn't have a field to indicate who is the driver maintainer.
> > 	      If in doubt about who is the driver maintainer please check the
> > 	      MAINTAINERS file or ask at the ML;
> >
> > Superseded: when the same patch is sent twice, or a new version of the
> > 	    same patch is sent, and the maintainer identified it, the first
> > 	    version is marked as such. It is also used when a patch was
> > 	    superseeded by a git pull request.
> >
> > Obsoleted: patch doesn't apply anymore, because the modified code doesn't
> > 	   exist anymore.
> >
> > Changes requested: when someone requests changes at the patch;
> >
> > Rejected: When the patch is wrong or doesn't apply. Most of the
> > 	  time, 'rejected' and 'changes requested' means the same thing
> > 	  for the developer: he'll need to re-work on the patch.
> >
> > RFC: patches marked as such and other patches that are also RFC, but the
> >      patch author was not nice enough to mark them as such. That includes:
> > 	- patches sent by a driver's maintainer who send patches
> > 	  via git pull requests;
> > 	- patches with a very active community (typically from developers
> > 	  working with embedded devices), where lots of versions are
> > 	  needed for the driver maintainer and/or the community to be
> > 	  happy with.
> >
> > Not Applicable: for patches that aren't meant to be applicable via 
> > 	        the media-tree.git.
> >
> > Accepted: when some driver maintainer says that the patch will be applied
> > 	  via his tree, or when everything is ok and it got applied
> > 	  either at the main tree or via some other tree (fixes tree;
> > 	  some other maintainer's tree - when it belongs to other subsystems,
> > 	  etc);
> >
> > If you think any status change is a mistake, please send an email to the ML.
> >
> > -
> >
> > This is an automated mail sent by the patchwork system at
> > patchwork.linuxtv.org. To stop receiving these notifications, edit
> > your mail settings at:
> >   http://patchwork.linuxtv.org/mail/
> 


-- 

Cheers,
Mauro
