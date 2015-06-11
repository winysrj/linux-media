Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59136 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbbFKOkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 10:40:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-metag@vger.kernel.org, kvm-ppc@vger.kernel.org,
	linux-wireless@vger.kernel.org, sparclinux@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] treewide: Fix typo compatability -> compatibility
Date: Thu, 11 Jun 2015 07:23:46 +0300
Message-ID: <5648670.yvOusp8qsY@avalon>
In-Reply-To: <CALLJCT38g36pxj1xjHbJYgd+JTx5fUHKnXvOwCnChHGU69g4UQ@mail.gmail.com>
References: <1432728342-32748-1-git-send-email-laurent.pinchart@ideasonboard.com> <20150609192703.4a8babf6@recife.lan> <CALLJCT38g36pxj1xjHbJYgd+JTx5fUHKnXvOwCnChHGU69g4UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday 10 June 2015 13:00:20 Masanari Iida wrote:
> On Wed, Jun 10, 2015 at 7:27 AM, Mauro Carvalho Chehab wrote:
> > Em Wed, 27 May 2015 15:05:42 +0300
> > 
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> >> Even though 'compatability' has a dedicated entry in the Wiktionary,
> >> it's listed as 'Mispelling of compatibility'. Fix it.
> >> 
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> >> ---
> >> 
> >>  arch/metag/include/asm/elf.h             | 2 +-
> >>  arch/powerpc/kvm/book3s.c                | 2 +-
> >>  arch/sparc/include/uapi/asm/pstate.h     | 2 +-
> >>  drivers/gpu/drm/drm_atomic_helper.c      | 4 ++--
> >>  drivers/media/dvb-frontends/au8522_dig.c | 2 +-
> >>  drivers/net/wireless/ipw2x00/ipw2100.h   | 2 +-
> >>  6 files changed, 7 insertions(+), 7 deletions(-)
> >> 
> >> I can split this into one patch per subsystem, but that seems a bit
> >> overkill. Can someone take it ?
> > 
> > Who? That's the problem with treewide patches ;)
> > 
> > Perhaps you should re-submit it with the acks you got to akpm.
> 
> Laurent,
> Please re-submit your patch to  trivial@kernel.org  with [trivial] in the
> title.
> 
> Ex.
> [PATCH] [trivial]  treewide: Fix typo compatability -> compatibility

Done, thank you.

-- 
Regards,

Laurent Pinchart

