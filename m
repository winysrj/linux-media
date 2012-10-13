Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54166 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751810Ab2JMKZU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 06:25:20 -0400
Message-ID: <5079418D.5000903@iki.fi>
Date: Sat, 13 Oct 2012 13:25:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Antoine Reversat <a.reversat@gmail.com>
Subject: Re: [PATCH v3] omap3isp: Use monotonic timestamps for statistics
 buffers
References: <1350065617-17136-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1350065617-17136-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the update!

Laurent Pinchart wrote:
> V4L2 buffers use the monotonic clock, while statistics buffers use wall
> time. This makes it difficult to correlate video frames and statistics.
>
> Switch statistics buffers to the monotonic clock to fix this.
>
> Reported-by: Antoine Reversat <a.reversat@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/platform/omap3isp/ispstat.c |    5 +++--
>   drivers/media/platform/omap3isp/ispstat.h |    2 +-
>   2 files changed, 4 insertions(+), 3 deletions(-)
>
> Given the hard NACK on the switch to timespec for the public API in v2, v3 goes
> back to the same approach as v1.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
