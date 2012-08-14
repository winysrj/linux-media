Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2072 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2HNNqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 09:46:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
Date: Tue, 14 Aug 2012 15:46:19 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	David =?utf-8?q?H=C3=A4rdeman?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
References: <502A4CD1.1020108@redhat.com>
In-Reply-To: <502A4CD1.1020108@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208141546.19560.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 15:04:17 Mauro Carvalho Chehab wrote:
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

Does that mean that if you are a maintainer with a git tree such as myself
you should make a pull request instead of posting a [PATCH] because otherwise
you mark it as an RFC patch?

I often just post simple patches instead of making a pull request, and I
always use [RFC PATCH] if I believe the patches need more discussion.

So if I post a [PATCH] as opposed to an [RFC PATCH], then that means that
I believe that the [PATCH] is ready for merging. If I should no longer
do that, but make a pull request instead, then that needs to be stated
very explicitly by you. Otherwise things will get very confusing.

> I really expect people to add more "RFC" on patches. We're having a net
> commit rate of about 500-600 patches per merge window, and perhaps 3 or 4
> times more patches at the ML that are just part of some discussions and
> aren't yet on their final version. It doesn't scale if I need to review
> ~3000 patches per merge window, as that would mean reviewing 75 patches per
> working day. Unfortunately, linux-media patch reviewing is not my full-time
> job. So, please help me marking those under-discussion patches as RFC, in
> order to allow me to focus on the 600 ones that will actually be merged.

In fairness: often you get no comments when you post the RFC patch series,
but once you post what you consider to be the final version you suddenly do
get comments.


> 		== Silvester Nawrocki <sylvester.nawrocki@gmail.com> == 
> 
> Aug, 2 2012: [PATH,v3,1/2] v4l: Add factory register values form S5K4ECGX sensor    http://patchwork.linuxtv.org/patch/13580  Sangwook Lee <sangwook.lee@linaro.org>
> Aug, 2 2012: [PATH,v3,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor          http://patchwork.linuxtv.org/patch/13581  Sangwook Lee <sangwook.lee@linaro.org>
> Aug,10 2012: [1/2,media] s5p-tv: Use devm_regulator_get() in sdo_drv.c file         http://patchwork.linuxtv.org/patch/13719  Sachin Kamat <sachin.kamat@linaro.org>
> Aug,10 2012: [2/2,media] s5p-tv: Use devm_* functions in sii9234_drv.c file         http://patchwork.linuxtv.org/patch/13720  Sachin Kamat <sachin.kamat@linaro.org>
> Aug,10 2012: [RESEND] v4l/s5p-mfc: added support for end of stream handling in MFC  http://patchwork.linuxtv.org/patch/13721  Andrzej Hajda <a.hajda@samsung.com>
> Aug,10 2012: [v4,1/2] v4l: Add factory register values form S5K4ECGX sensor         http://patchwork.linuxtv.org/patch/13727  Sangwook Lee <sangwook.lee@linaro.org>
> Aug,10 2012: [v4,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor               http://patchwork.linuxtv.org/patch/13728  Sangwook Lee <sangwook.lee@linaro.org>
> Jun,11 2012: [1/3,media] s5p-tv: Replace printk with pr_* functions                 http://patchwork.linuxtv.org/patch/11666  Sachin Kamat <sachin.kamat@linaro.org>
> Jun,11 2012: [2/3,media] s5p-mfc: Replace printk with pr_* functions                http://patchwork.linuxtv.org/patch/11667  Sachin Kamat <sachin.kamat@linaro.org>
> Jun,11 2012: [3/3,media] s5p-fimc: Replace printk with pr_* functions               http://patchwork.linuxtv.org/patch/11668  Sachin Kamat <sachin.kamat@linaro.org>
> Jun,12 2012: [1/1, media] s5p-fimc: Replace custom err() macro with v4l2_err() macr http://patchwork.linuxtv.org/patch/11675  Sachin Kamat <sachin.kamat@linaro.org>

One example where you apparently marked a [PATCH] as RFC is this one:

http://patchwork.linuxtv.org/patch/13659/

Is this because Sylwester has his own git tree and you were expecting a pull
request?

In this case it is a simple compiler warning fix which I would really like to
see merged since it fixes a fair number of compiler warnings during the
daily build.

Regards,

	Hans
