Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50968 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751417AbbFNKmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 06:42:53 -0400
Message-ID: <557D5A67.2080302@iki.fi>
Date: Sun, 14 Jun 2015 13:41:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 1/1] omap3isp: Fix sub-device power management code
References: <1434096127.3f3fQLryEJ@avalon> <1434150390-25898-1-git-send-email-sakari.ailus@iki.fi> <3552429.2UzJNcXoTA@avalon>
In-Reply-To: <3552429.2UzJNcXoTA@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 13 June 2015 02:06:23 Sakari Ailus wrote:
>> Commit 813f5c0ac5cc ("media: Change media device link_notify behaviour")
>> modified the media controller link setup notification API and updated the
>> OMAP3 ISP driver accordingly. As a side effect it introduced a bug by
>> turning power on after setting the link instead of before. This results in
>> sub-devices not being powered down in some cases when they should be. Fix
>> it.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> Fixes: 813f5c0ac5cc [media] media: Change media device link_notify behaviour
>> Cc: stable@vger.kernel.org # since v3.10
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Applied to my tree, and pull request sent.

Thanks!

-- 
Sakari Ailus
sakari.ailus@iki.fi
