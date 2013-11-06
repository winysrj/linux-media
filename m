Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53418 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754687Ab3KFPwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 10:52:25 -0500
Date: Wed, 6 Nov 2013 17:51:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:SMIA AND SMIA++ I..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH] smiapp: Fix BUG_ON() on an impossible condition
Message-ID: <20131106155151.GF24988@valkosipuli.retiisi.org.uk>
References: <1383747690-20003-1-git-send-email-ricardo.ribalda@gmail.com>
 <20131106145839.GE24988@valkosipuli.retiisi.org.uk>
 <CAPybu_1nxwEJCDA33j0TAP_NtvGB-Zs=9RxbrBT9jdi01aTNuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_1nxwEJCDA33j0TAP_NtvGB-Zs=9RxbrBT9jdi01aTNuA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Wed, Nov 06, 2013 at 04:03:37PM +0100, Ricardo Ribalda Delgado wrote:
> Hello Sakari
> 
> I always try to send the patches to the mails found by
> get-maintainer.pl, I thought it was unpolite not doint so :). In the
> future I will try to send the mails only to the media list.

Yeah, it seems get_maintainer.pl -f ... gives you LKML, and trying out a few
random files, it seems to give that for all of them. I don't think it's
intended that every single patch goes to LKML however.

Here's what Documentation/SubmittingPatches has to say on the topic:

------8<------
Look through the MAINTAINERS file and the source code, and determine
if your change applies to a specific subsystem of the kernel, with
an assigned maintainer.  If so, e-mail that person.  The script
scripts/get_maintainer.pl can be very useful at this step.

If no maintainer is listed, or the maintainer does not respond, send
your patch to the primary Linux kernel developer's mailing list,
linux-kernel@vger.kernel.org.  Most kernel developers monitor this
e-mail list, and can comment on your changes.


Do not send more than 15 patches at once to the vger mailing lists!!!
------8<------

So, patches should be sent to LKML if no other relevant list can be found.
But then, it goes on to state that:

------8<------
Linus Torvalds is the final arbiter of all changes accepted into the
Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
He gets a lot of e-mail, so typically you should do your best to -avoid-
sending him e-mail.

Patches which are bug fixes, are "obvious" changes, or similarly
require little discussion should be sent or CC'd to Linus.  Patches
which require discussion or do not have a clear advantage should
usually be sent first to linux-kernel.  Only after the patch is
discussed should the patch then be submitted to Linus.
------8<------

Could this be one of the reason Linus gets lots of mail? :-)

> I don't have a tree, so please do as you wish.

I'll apply that to my tree.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
