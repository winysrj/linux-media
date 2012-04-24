Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34845 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2DXJHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 05:07:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] omap3isp: ccdc: Add crop support on output formatter source pad
Date: Tue, 24 Apr 2012 11:08:12 +0200
Message-ID: <14838654.TrzCLImese@avalon>
In-Reply-To: <4F95D64A.10505@iki.fi>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com> <1335180595-27931-4-git-send-email-laurent.pinchart@ideasonboard.com> <4F95D64A.10505@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 24 April 2012 01:23:06 Sakari Ailus wrote:
> Hi Laurent,
> 
> The patch looks good as such on the first glance, but I have another
> question: why are you not using the selections API instead? It's in
> Mauro's tree already.

You're totally right, we need to convert the selection API. The reason why 
I've implemented crop support at the CCDC output was simply that I needed it 
for a project and didn't have time to implement the selection API. As the code 
works, I considered it would be good to have it upstream until we switch to 
the selection API.

> Also, the old S_CROP IOCTL only has been defined for sink pads, not source.

We're already using crop on source pads on sensors ;-)

-- 
Regards,

Laurent Pinchart

