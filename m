Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38173 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbGPHfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 03:35:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	mittals@codeaurora.org
Subject: Re: [PATCH 1/1] omap3isp: Fix async notifier registration order
Date: Thu, 16 Jul 2015 10:35:32 +0300
Message-ID: <1470564.5NvpJEivI3@avalon>
In-Reply-To: <CAOZdJXV84Uap3S6wfsdM4LTsBgW3QZpmf7HN1wvNMB_syTVFBw@mail.gmail.com>
References: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi> <CAOZdJXV84Uap3S6wfsdM4LTsBgW3QZpmf7HN1wvNMB_syTVFBw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Timur,

On Wednesday 15 July 2015 16:04:01 Timur Tabi wrote:
> On Tue, May 19, 2015 at 6:08 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > @@ -2557,18 +2553,27 @@ static int isp_probe(struct platform_device *pdev)
> >         if (ret < 0)
> >                 goto error_iommu;
> > 
> > -       isp->notifier.bound = isp_subdev_notifier_bound;
> > -       isp->notifier.complete = isp_subdev_notifier_complete;
> > -
> >         ret = isp_register_entities(isp);
> >         if (ret < 0)
> >                 goto error_modules;
> > 
> > +       if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
> 
> So I have a question (for Laurent, I guess) that's unrelated to this patch.
> 
> Why is the "IS_ENABLED(CONFIG_OF)" important?  If CONFIG_OF is
> disabled, isn't pdev->dev.of_node always NULL anyway?

IS_ENABLED(CONFIG_OF) can be evaluated at compile time, so it will allow the 
compiler to remove the code block completely when OF support is disabled. 
pdev->dev.of_node is a runtime-only check which would allow the same 
optimization.

-- 
Regards,

Laurent Pinchart

