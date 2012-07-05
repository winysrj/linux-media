Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24496 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2GEI2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 04:28:53 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6O00IJHI8X1X40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 09:29:21 +0100 (BST)
Content-transfer-encoding: 8BIT
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M6O0047WI83W220@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 09:28:51 +0100 (BST)
Message-id: <4FF55042.6090102@samsung.com>
Date: Thu, 05 Jul 2012 10:28:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR v3.6] mostly remove V4L2_FL_LOCK_ALL_FOPS
References: <201207041942.04606.hverkuil@xs4all.nl>
 <4FF49957.3070604@gmail.com> <201207050854.20966.hverkuil@xs4all.nl>
In-reply-to: <201207050854.20966.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 07/05/2012 08:54 AM, Hans Verkuil wrote:
> Hi Sylwester,
> 
> It still doesn't apply. This patch starts with:
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
> index da2c40e..cb04a870 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -480,48 +480,59 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc);
>  static int fimc_capture_open(struct file *file)
>  {
>         struct fimc_dev *fimc = video_drvdata(file);
> -       int ret;
> +       int ret = -EBUSY;
> 
> The actual current source code starts with:
> 
> static int fimc_capture_open(struct file *file)
> {
>         struct fimc_dev *fimc = video_drvdata(file);
>         int ret = v4l2_fh_open(file);
> 
> Quite different. That 'int ret = v4l2_fh_open(file);' line was added June 10th, 2011, so
> I don't understand why that isn't in your git repository.

Because is has been removed by one of patches from v4l-fimc-fixes branch
that I sent to Mauro on 25th of May and is still not upstream.
Branch v4l-fimc-next depends on v4l-fimc-fixes, sorry if it wasn't clear
enough. You need to pull v4l-fimc-fixes branch first. If I would have
rebased patches for -next then the fixup patches wouldn't apply. That
just doesn't seem right.

Mauro, are you going to send another pull request to Linus for 3.5-rc,
including these patches: http://patchwork.linuxtv.org/patch/11503 ?

Regards,
-- 
Sylwester Nawrocki
실베스터 나브로츠키
Samsung Poland R&D Center
