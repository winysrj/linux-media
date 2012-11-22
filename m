Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46197 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2KVSyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:54:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.7-rc] Samsung SoC media driver fixes
Date: Thu, 22 Nov 2012 19:55:06 +0100
Message-ID: <84619288.LAxNEDMoLt@avalon>
In-Reply-To: <50AE6D36.1060805@samsung.com>
References: <50AE6BAC.1030208@samsung.com> <50AE6D36.1060805@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 22 November 2012 19:21:42 Sylwester Nawrocki wrote:
> Hi Mauro,
> 
> this is what I've just sent (this time from the office my samsung.com
> account) to linux-media@vger.kernel.org. And can't see it neither on the
> mailing list nor at the patchwork.

Nothing like that coming from you in my mail server logs. It looks like an 
SMTP server in the chain silently drops the e-mail.

> On 11/22/2012 07:15 PM, Sylwester Nawrocki wrote:
> > Hi Mauro,
> > 
> > The following changes since commit 
30677fd9ac7b9a06555318ec4f9a0db39804f9b2:
> >   s5p-fimc: Fix potential NULL pointer dereference (2012-11-22 10:15:40
> >   +0100)> 
> > are available in the git repository at:
> >   git://git.infradead.org/users/kmpark/linux-samsung media_fixes_for_v3.7
> > 
> > for you to fetch changes up to 28f497f26c67ab734bdb923b457016122368f69a:
> >   s5p-mfc: Handle multi-frame input buffer (2012-11-22 15:13:53 +0100)
> > 
> > This is a bunch of quite important fixes for the Exynos SoC drivers,
> > please apply for v3.7 if possible. This depends on my previous pull
> > request (I've applied the patches you indicated you take for v3.7
> > previously to the media_fixes_for_v3.7 branch as well).
> > 
> > ----------------------------------------------------------------
> > 
> > Arun Kumar K (2):
> >       s5p-mfc: Bug fix of timestamp/timecode copy mechanism
> >       s5p-mfc: Handle multi-frame input buffer
> > 
> > Shaik Ameer Basha (1):
> >       exynos-gsc: Fix settings for input and output image RGB type
> > 
> > Sylwester Nawrocki (5):
> >       s5p-fimc: Prevent race conditions during subdevs registration
> >       s5p-fimc: Don't use mutex_lock_interruptible() in device release()
> >       fimc-lite: Don't use mutex_lock_interruptible() in device release()
> >       exynos-gsc: Don't use mutex_lock_interruptible() in device release()
> >       exynos-gsc: Add missing video device vfl_dir flag initialization
> >  
> >  drivers/media/platform/exynos-gsc/gsc-m2m.c     |    4 ++--
> >  drivers/media/platform/exynos-gsc/gsc-regs.h    |   16 ++++++++--------
> >  drivers/media/platform/s5p-fimc/fimc-capture.c  |   10 +++++++---
> >  drivers/media/platform/s5p-fimc/fimc-lite.c     |    6 ++++--
> >  drivers/media/platform/s5p-fimc/fimc-m2m.c      |    3 +--
> >  drivers/media/platform/s5p-fimc/fimc-mdevice.c  |    4 ++--
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    7 ++-----
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 +-
> >  8 files changed, 27 insertions(+), 25 deletions(-)

-- 
Regards,

Laurent Pinchart

