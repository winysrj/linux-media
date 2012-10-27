Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2J0K3A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 06:29:00 -0400
Date: Sat, 27 Oct 2012 08:19:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.7] Samsung media drivers fixes
Message-ID: <20121027081959.4db3aecc@redhat.com>
In-Reply-To: <508A62CD.5090909@samsung.com>
References: <5089624D.2000903@samsung.com>
	<20121025144616.7e7863f4@redhat.com>
	<50898BFD.7040104@gmail.com>
	<508A62CD.5090909@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Oct 2012 12:15:41 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> On 10/25/2012 08:59 PM, Sylwester Nawrocki wrote:
> > On 10/25/2012 06:46 PM, Mauro Carvalho Chehab wrote:
> >> Em Thu, 25 Oct 2012 18:01:17 +0200
> >> Sylwester Nawrocki<s.nawrocki@samsung.com>  escreveu:
> >>
> >>> Hi Mauro,
> >>>
> >>> please pull following fixes for v3.7-rc.
> >>>
> >>> The following changes since commit 1fdead8ad31d3aa833bc37739273fcde89ace93c:
> >>>
> >>>    [media] m5mols: Add missing #include<linux/sizes.h>  (2012-10-10 08:17:16 -0300)
> >>>
> >>> are available in the git repository at:
> >>>
> >>>    git://git.infradead.org/users/kmpark/linux-samsung v4l_fixes_for_v3.7
> >>>
> >>> for you to fetch changes up to df79eb9e19331685e509d62112972b3c35569f0b:
> >>>
> >>>    s5p-fimc: Fix potential NULL pointer dereference (2012-10-25 16:08:12 +0200)
> >>>
> >>> ----------------------------------------------------------------
> >>> Jesper Juhl (1):
> >>>        s5p-tv: don't include linux/version.h in mixer_video.c
> >>>
> >>> Sachin Kamat (5):
> >>>        s5p-mfc: Fix compilation warning
> >>>        exynos-gsc: Fix compilation warning
> >>>        s5p-mfc: Make 'clk_ref' static in s5p_mfc_pm.c
> >>>        s5p-fimc: Make 'fimc_pipeline_s_stream' function static
> >>>        s5p-fimc: Fix potential NULL pointer dereference
> >>>
> >>> Shaik Ameer Basha (3):
> >>>        exynos-gsc: change driver compatible string
> >>>        exynos-gsc: fix variable type in gsc_m2m_device_run()
> >>>        s5p-fimc: fix variable type in fimc_device_run()
> >>>
> >>> Sylwester Nawrocki (4):
> >>>        s5p-fimc: Don't ignore return value of vb2_queue_init()
> >>>        s5p-csis: Select S5P_SETUP_MIPIPHY
> >>>        s5p-fimc: Add missing new line character
> >>>        s5p-fimc: Fix platform entities registration
> >>
> >>
> >> Only a few of the above seems to be material for -rc:
> >> 	s5p-fimc: Fix potential NULL pointer dereference (59 seconds ago)
> >> 	s5p-fimc: Fix platform entities registration (60 seconds ago)
> >> 	s5p-csis: Select S5P_SETUP_MIPIPHY (60 seconds ago)
> >> 	s5p-fimc: Don't ignore return value of vb2_queue_init() (61 seconds ago)
> >>
> >> The other ones are warnings/sparse warnings and cleanups. I'll
> >> be applying only the 4 above patches for 3.7, adding the other
> >> ones for 3.8.
> 
> I've noticed "s5p-fimc: Fix platform entities registration" will cause
> a race condition. Can you please drop entirely these two patches from
> the 3.7 queue:
> 
>  	s5p-fimc: Fix potential NULL pointer dereference (59 seconds ago)
>  	s5p-fimc: Fix platform entities registration (60 seconds ago)
> ?
> 
> Alternatively I can send a subsequent follow up patch.

As I already applied pinchartl patches on my 3.7 sandbox, I prefer if you
could send it as a follow up patch.

Regards,
Mauro
