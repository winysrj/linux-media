Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbbGOVEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2015 17:04:05 -0400
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com [209.85.213.178])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: timur@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 394FF140888
	for <linux-media@vger.kernel.org>; Wed, 15 Jul 2015 21:04:02 +0000 (UTC)
Received: by igbpg9 with SMTP id pg9so46186705igb.0
        for <linux-media@vger.kernel.org>; Wed, 15 Jul 2015 14:04:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi>
References: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi>
Date: Wed, 15 Jul 2015 16:04:01 -0500
Message-ID: <CAOZdJXV84Uap3S6wfsdM4LTsBgW3QZpmf7HN1wvNMB_syTVFBw@mail.gmail.com>
Subject: Re: [PATCH 1/1] omap3isp: Fix async notifier registration order
From: Timur Tabi <timur@codeaurora.org>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mittals@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2015 at 6:08 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> @@ -2557,18 +2553,27 @@ static int isp_probe(struct platform_device *pdev)
>         if (ret < 0)
>                 goto error_iommu;
>
> -       isp->notifier.bound = isp_subdev_notifier_bound;
> -       isp->notifier.complete = isp_subdev_notifier_complete;
> -
>         ret = isp_register_entities(isp);
>         if (ret < 0)
>                 goto error_modules;
>
> +       if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {

So I have a question (for Laurent, I guess) that's unrelated to this patch.

Why is the "IS_ENABLED(CONFIG_OF)" important?  If CONFIG_OF is
disabled, isn't pdev->dev.of_node always NULL anyway?

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
