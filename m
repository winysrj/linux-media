Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46960 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2HNPQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:16:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
Date: Tue, 14 Aug 2012 17:16:56 +0200
Message-ID: <1648356.GPjgaBcQZf@avalon>
In-Reply-To: <502A4CD1.1020108@redhat.com>
References: <502A4CD1.1020108@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 14 August 2012 10:04:17 Mauro Carvalho Chehab wrote:
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
> Manu Abraham <abraham.manu@gmail.com>                                 : 11
> Silvester Nawrocki <sylvester.nawrocki@gmail.com>                     : 11
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>                  : 3
> Jonathan Corbet <corbet@lwn.net>                                      : 2
> David Härdeman <david@hardeman.nu>                                    : 1
> Prabhakar Lad <prabhakar.lad@ti.com>                                  : 1
> 
> 
> 		== Patches waiting for some action ==

[snip]

> This one requires more testing:
> 
> May,15 2012: [GIT,PULL,FOR,3.5] DMABUF importer feature in V4L2 API         
>        http://patchwork.linuxtv.org/patch/11268
>        Sylwester Nawrocki <s.nawrocki@samsung.com>

What is needed here, can I help with testing ?

[snip]

> 		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> ==
> 
> Aug, 2 2012: [v3] mt9v022: Add support for mt9v024                          
>        http://patchwork.linuxtv.org/patch/13582
>        Alex Gershgorin <alexg@meprolight.com>
> Aug, 6 2012: [1/1] media: mx3_camera: Improve data bus width check code for
> probe
>		http://patchwork.linuxtv.org/patch/13618
>		Liu Ying <Ying.liu@freescale.com>
> Aug, 9 2012: [1/1, v2] media/video: vpif: fixing function name start to
> vpif_config
>		http://patchwork.linuxtv.org/patch/13689
>		Dror Cohen <dror@liveu.tv>

I think this one has been misclassified. v1 was correctly attributed to 
Prabhakar Lad <prabhakar.lad@ti.com>

[snip]

> 		== Laurent Pinchart <laurent.pinchart@ideasonboard.com> ==
> 
> Sep,27 2011: [v2,1/5] omap3evm: Enable regulators for camera interface
>        http://patchwork.linuxtv.org/patch/7969
>        Vaibhav Hiremath <hvaibhav@ti.com>

I'm fine with that one, shouldn't it go through the arm tree ?

> Jul,26 2012: [1/2,media] omap3isp: implement ENUM_FMT
>		http://patchwork.linuxtv.org/patch/13492
>		Michael Jones <michael.jones@matrix-vision.de>
> Jul,26 2012: [2/2,media] omap3isp: support G_FMT
>		http://patchwork.linuxtv.org/patch/13493
>		Michael Jones <michael.jones@matrix-vision.de>

A proper solution for this will first require CREATE_BUFS/PREPARE_BUF support 
in the OMAP3 ISP driver (and a move to videobuf2).

-- 
Regards,

Laurent Pinchart

