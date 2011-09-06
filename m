Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55274 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1IFNmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 09:42:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "LBM" <lbm9527@qq.com>
Subject: Re: use soc-camera mt9m111 with omap3isp
Date: Tue, 6 Sep 2011 15:42:36 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <tencent_4AC8C95272078A03064A0924@qq.com>
In-Reply-To: <tencent_4AC8C95272078A03064A0924@qq.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061542.36870.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee,

On Tuesday 06 September 2011 15:40:09 LBM wrote:
> hi Laurent Pinchart
> 
> you say "Everything is in the latest mainline kernel." but my kernel
> just 2.6.32.so I need to migrate the new V4L2 subdev to the old kernel .  
> please show me the diff

You will need to backport all that yourself, I have no patches readily 
available. My advice would be to upgrade your kernel though.

-- 
Regards,

Laurent Pinchart
