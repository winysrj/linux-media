Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3AFMFs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 07:05:48 -0500
Date: Sun, 6 Jan 2013 10:05:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.9] Exynos SoC media drivers updates
Message-ID: <20130106100513.484dab11@redhat.com>
In-Reply-To: <50E75A10.8090906@gmail.com>
References: <50E726F4.7060704@samsung.com>
	<50E75A10.8090906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Jan 2013 23:39:12 +0100
Sylwester Nawrocki <sylvester.nawrocki@gmail.com> escreveu:

> On 01/04/2013 08:01 PM, Sylwester Nawrocki wrote:
> > Hi Mauro,
> >
> > Please pull the following for 3.9, it includes Exynos SoC drivers cleanups and
> > fixes. DMABUF exporting support for Exynos5 GScaler driver, device tree support
> > for Exynos MFC driver (platform bits for it got merged already for v3.8).
> >
> > There is also included a patch removing deprecated image centering controls.
> >
> > The following changes since commit 8cd7085ff460ead3aba6174052a408f4ad52ac36:
> >
> >    [media] get_dvb_firmware: Fix the location of firmware for Terratec HTC
> > (2013-01-01 11:18:26 -0200)
> >
> > are available in the git repository at:
> >
> >    git://git.infradead.org/users/kmpark/linux-samsung media_for_v3.9
> >
> > for you to fetch changes up to 36073ee2f7b3b5ae91900cb992b292404614243b:
> >
> >    V4L: Remove deprecated image centering controls (2013-01-04 11:35:43 +0100)
> >
> > ----------------------------------------------------------------
> > Arun Kumar K (2):
> >        s5p-mfc: Add device tree support
> >        s5p-mfc: Flush DPB buffers during stream off
> >
> > Kamil Debski (4):
> >        s5p-mfc: Move firmware allocation point to avoid allocation problems
> >        s5p-mfc: Correct check of vb2_dma_contig_init_ctx return value
> >        s5p-mfc: Change internal buffer allocation from vb2 ops to dma_alloc_coherent
> >        s5p-mfc: Context handling in open() bugfix
> >
> > Sachin Kamat (9):
> >        s5p-tv: Add missing braces around sizeof in sdo_drv.c
> >        s5p-tv: Add missing braces around sizeof in mixer_video.c
> >        s5p-tv: Add missing braces around sizeof in mixer_reg.c
> >        s5p-tv: Add missing braces around sizeof in mixer_drv.c
> >        s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
> >        s5p-tv: Add missing braces around sizeof in hdmi_drv.c
> >        s5p-mfc: Remove redundant 'break'
> >        s5p-mfc: Fix a typo in error message in s5p_mfc_pm.c
> >        s5p-mfc: Fix an error check
> >
> > Shaik Ameer Basha (1):
> >        exynos-gsc: Support dmabuf export buffer
> >
> > Sylwester Nawrocki (5):
> >        s5p-fimc: Avoid possible NULL pointer dereference in set_fmt op
> >        s5p-fimc: Prevent potential buffer overflow
> >        s5p-fimc: Prevent AB-BA deadlock during links reconfiguration
> >        s5p-tv: Fix return value in sdo_probe() on error paths
> >        V4L: Remove deprecated image centering controls
> >
> > Tomasz Stanislawski (1):
> >        s5p-tv: mixer: fix handling of VIDIOC_S_FMT
> >
> > Tony Prisk (3):
> >        s5p-fimc: Fix incorrect usage of IS_ERR_OR_NULL
> >        s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL
> >        s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL
> >
> > Wei Yongjun (1):
> >        s5p-mfc: remove unused variable
> 
> Related patchwork commands:
> 
> pwclient update -s 'accepted' 15333
> pwclient update -s 'accepted' 15565
> pwclient update -s 'accepted' 16071
> pwclient update -s 'accepted' 16072
> pwclient update -s 'accepted' 16073
> pwclient update -s 'accepted' 15657
> pwclient update -s 'accepted' 15656
> pwclient update -s 'accepted' 15658
> pwclient update -s 'accepted' 15659
> pwclient update -s 'accepted' 15660
> pwclient update -s 'accepted' 15661
> pwclient update -s 'accepted' 16013
> pwclient update -s 'superseded' 16059
> pwclient update -s 'accepted' 16060
> pwclient update -s 'accepted' 16080
> pwclient update -s 'accepted' 16081
> pwclient update -s 'accepted' 16084
> pwclient update -s 'accepted' 15647
> pwclient update -s 'superseded' 16083
> pwclient update -s 'accepted' 15765

Those status updates were missing:

pwclient update -s 'superseded' 14608
pwclient update -s 'superseded' 15188
pwclient update -s 'accepted' 16058
pwclient update -s 'accepted' 16108

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
