Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:37177 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030895Ab2CFUho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 15:37:44 -0500
Message-ID: <4F567588.9020808@iki.fi>
Date: Tue, 06 Mar 2012 22:37:28 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v3 2/5] mt9p031: Remove unused xskip and yskip fields
 in struct mt9p031
References: <1331051559-13841-1-git-send-email-laurent.pinchart@ideasonboard.com> <1331051559-13841-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331051559-13841-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

Laurent Pinchart wrote:
> The fields are set but never used, remove them.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/mt9p031.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)

Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
