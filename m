Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42724 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbbGPOIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 10:08:11 -0400
Message-ID: <55A7BAC7.1080703@codeaurora.org>
Date: Thu, 16 Jul 2015 09:08:07 -0500
From: Timur Tabi <timur@codeaurora.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	mittals@codeaurora.org
Subject: Re: [PATCH 1/1] omap3isp: Fix async notifier registration order
References: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi> <CAOZdJXV84Uap3S6wfsdM4LTsBgW3QZpmf7HN1wvNMB_syTVFBw@mail.gmail.com> <1470564.5NvpJEivI3@avalon>
In-Reply-To: <1470564.5NvpJEivI3@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> IS_ENABLED(CONFIG_OF) can be evaluated at compile time, so it will allow the
> compiler to remove the code block completely when OF support is disabled.
> pdev->dev.of_node is a runtime-only check which would allow the same
> optimization.

Ok, thanks.  I was thinking that there was more to it than just 
optimization, but I guess not.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
