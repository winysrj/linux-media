Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4038 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3CYIvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 04:51:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [REVIEW PATCH 01/19] solo6x10: sync to latest code from Bluecherry's git repo.
Date: Mon, 25 Mar 2013 09:51:37 +0100
Cc: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl> <1363609938-21735-2-git-send-email-hverkuil@xs4all.nl> <20130324112723.445693ea@redhat.com>
In-Reply-To: <20130324112723.445693ea@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303250951.37422.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 24 2013 15:27:23 Mauro Carvalho Chehab wrote:
> Em Mon, 18 Mar 2013 13:32:00 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Synced to commit e9815ac5503ae60cfbf6ff8037035de8f62e2846 from
> > branch next in git repository https://github.com/bluecherrydvr/solo6x10.git
> > 
> > Only removed some code under #if LINUX_VERSION_CODE < some-kernel-version,
> > renamed the driver back to solo6x10 from solo6x10-edge and removed the
> > unnecessary compat.h header.
> > 
> > Otherwise the code is identical.
> > 
> 
> ...
> 
> > @@ -21,29 +26,78 @@
> >  #include <linux/module.h>
> >  #include <linux/pci.h>
> >  #include <linux/interrupt.h>
> > -#include <linux/slab.h>
> 
> You can't remove slab.h if any k*alloc function is used, or it will
> break compilation, depending on the Kconfig options selected.

Well spotted, thanks!

> 
> The same type of removal are on other files inside this patch.
> 
> Please fix.

Done. New pull request posted.

Regards,

	Hans
