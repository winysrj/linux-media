Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55178 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbcARWkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 17:40:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Gjorgji Rosikopulos <grosikopulos@mm-sol.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: Re: [PATCH] v4l: Fix dma buf single plane compat handling
Date: Tue, 19 Jan 2016 00:41:08 +0200
Message-ID: <1632237.7Pf6uP9oia@avalon>
In-Reply-To: <569CCAC2.5010001@xs4all.nl>
References: <1449477939-5658-1-git-send-email-laurent.pinchart@ideasonboard.com> <1530239.WI7pDY4BZt@avalon> <569CCAC2.5010001@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 January 2016 12:21:38 Hans Verkuil wrote:
> Hi all,
> 
> While going through patchwork I found this patch that does the same as this
> one from Tiffany:
> 
> https://patchwork.linuxtv.org/patch/32631/
> 
> I haven't seen a second version of this patch from Laurent with the
> requested changes fixed,

As it was too late for v4.5 I was waiting for more comments before sending v2.

> so unless Laurent says otherwise I'd like to merge
> Tiffany's version.

I've now reviewed Tiffany's patch.

> Laurent, is that OK for you?

When patches conflict I usually try to merge the first one that was submitted. 
In this specific case I can make an exception.

-- 
Regards,

Laurent Pinchart

