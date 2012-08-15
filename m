Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab2HOIa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 04:30:28 -0400
Date: Wed, 15 Aug 2012 10:30:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
In-Reply-To: <502A4CD1.1020108@redhat.com>
Message-ID: <Pine.LNX.4.64.1208151013300.4024@axis700.grange>
References: <502A4CD1.1020108@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Tue, 14 Aug 2012, Mauro Carvalho Chehab wrote:

> In order to help people to know about the status of the pending patches,
> I'm summing-up the patches pending for merge on this email.
> 
> If is there any patch missing, please check if it is at patchwork
> before asking what happened:
> 	http://patchwork.linuxtv.org/project/linux-media/list/?state=*
> 
> If patchwork didn't pick, then the emailer likely line-wrapped or
> corrupted the patch.
> 
> As announced, patchwork is now generating status change emails. So,
> those that didn't decide to opt-out emails there will receive
> notifications every time a patch is reviewed. Unfortunately, 
> patchwork doesn't send emails is when a patch is stored there.
> 
> For the ones explicitly copied on this email, I kindly ask you to update
> me about the review status of the patches below.
> 
> In special, on my track list, there are three patches from 2011 still
> not reviewed. Driver maintainers: I kindly ask you to be more active on
> patch reviewing, not holding any patch for long periods like that,
> and sending pull request more often. You should only be holding patches
> if you have very strong reasons why this is required.
> 
> A final note: patches from driver maintainers with git trees are generally
> just marked as RFC. Well, I still applied several of them, when they're
> trivial enough and they're seem to be addressing a real bug - helping
> myself to not need to re-review them later.
> 
> I really expect people to add more "RFC" on patches. We're having a net
> commit rate of about 500-600 patches per merge window, and perhaps 3 or 4
> times more patches at the ML that are just part of some discussions and
> aren't yet on their final version. It doesn't scale if I need to review
> ~3000 patches per merge window, as that would mean reviewing 75 patches per
> working day. Unfortunately, linux-media patch reviewing is not my full-time
> job. So, please help me marking those under-discussion patches as RFC, in
> order to allow me to focus on the 600 ones that will actually be merged.
> 
> Thank you!
> Mauro
> 
> 
> Number of pending patches per reviewer (excluding the newer ones):
>   Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 17
>   Manu Abraham <abraham.manu@gmail.com>                                 : 11
>   Silvester Nawrocki <sylvester.nawrocki@gmail.com>                     : 11
>   Laurent Pinchart <laurent.pinchart@ideasonboard.com>                  : 3
>   Jonathan Corbet <corbet@lwn.net>                                      : 2
>   David Härdeman <david@hardeman.nu>                                    : 1
>   Prabhakar Lad <prabhakar.lad@ti.com>                                  : 1

[snip]

> 		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> == 
> 
> Aug, 2 2012: [v3] mt9v022: Add support for mt9v024                                  http://patchwork.linuxtv.org/patch/13582  Alex Gershgorin <alexg@meprolight.com>
> Aug, 6 2012: [1/1] media: mx3_camera: Improve data bus width check code for probe   http://patchwork.linuxtv.org/patch/13618  Liu Ying <Ying.liu@freescale.com>

above two waiting to be reviewed for 3.7

> Aug, 9 2012: [1/1, v2] media/video: vpif: fixing function name start to vpif_config http://patchwork.linuxtv.org/patch/13689  Dror Cohen <dror@liveu.tv>

That one is not for me

> Aug, 1 2012: media: soc_camera: don't clear pix->sizeimage in JPEG mode when try_fm http://patchwork.linuxtv.org/patch/13565  Albert Wang <twang13@marvell.com>
> Jul,30 2012: media: mx3_camera: buf_init() add buffer state check                   http://patchwork.linuxtv.org/patch/13528  Alex Gershgorin <alexg@meprolight.com>
> Jul,11 2012: [v2] media: mx2_camera: Don't modify non volatile parameters in try_fm http://patchwork.linuxtv.org/patch/13310  Javier Martin <javier.martin@vista-silicon.com>

will handle these, some are fixes for 3.6, others for 3.7

> Jul,11 2012: [v6] media: mx2_camera: Fix mbus format handling                       http://patchwork.linuxtv.org/patch/13314  Javier Martin <javier.martin@vista-silicon.com>
> Jul,12 2012: media: mx2_camera: Add YUYV output format.                             http://patchwork.linuxtv.org/patch/13330  Javier Martin <javier.martin@vista-silicon.com>

These patches are among those, that I pushed for 3.6 and that have been 
lost.

> Jul,12 2012: media: mx2_camera: Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MS http://patchwork.linuxtv.org/patch/13331  Javier Martin <javier.martin@vista-silicon.com>

3.7 or even 3.8

> Jul,12 2012: [1/2,v2] media: Add mem2mem deinterlacing driver.                      http://patchwork.linuxtv.org/patch/13332  Javier Martin <javier.martin@vista-silicon.com>

I didn't necessarily consider this one for me? I could help review it id 
you like, but so far I'm happy with others taking care of it;-)

> Jul,30 2012: mt9v022: Add support for mt9v024                                       http://patchwork.linuxtv.org/patch/13525  Alex Gershgorin <alexg@meprolight.com>

A duplicate of the first patch in this list.

> Aug, 1 2012: [v2] media: mx2_camera: Fix clock handling for i.MX27.                 http://patchwork.linuxtv.org/patch/13569  Javier Martin <javier.martin@vista-silicon.com>

IIRC, a fix for 3.6-rc.

> Aug, 2 2012: [v2] mt9v022: Add support for mt9v024                                  http://patchwork.linuxtv.org/patch/13579  Alex Gershgorin <alexg@meprolight.com>

a triplicate

> May,25 2012: [06/15] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepar http://patchwork.linuxtv.org/patch/11505  Fabio Estevam <fabio.estevam@freescale.com>
> May,25 2012: [07/15] video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepar http://patchwork.linuxtv.org/patch/11506  Fabio Estevam <fabio.estevam@freescale.com>

dropped from 3.6 pull

> May,25 2012: [08/15] video: mx2_emmaprp: Use clk_prepare_enable/clk_disable_unprepa http://patchwork.linuxtv.org/patch/11507  Fabio Estevam <fabio.estevam@freescale.com>

not fot me

> Jun, 5 2012: media: mx2_camera: Add YUYV output format.                             http://patchwork.linuxtv.org/patch/11580  Javier Martin <javier.martin@vista-silicon.com>

a duplicate

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
