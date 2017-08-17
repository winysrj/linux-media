Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53369 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdHQIQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 04:16:53 -0400
Subject: Re: [PATCH v2 1/8] v4l: vsp1: Protect fragments against overflow
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
 <a434f2ae9b782b0d8cb7a00b1e636c17c6dd48ad.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
 <1552146.CLukKW7q3G@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <f7194551-e764-42e6-ed59-9cde393d0074@ideasonboard.com>
Date: Thu, 17 Aug 2017 09:16:48 +0100
MIME-Version: 1.0
In-Reply-To: <1552146.CLukKW7q3G@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your review,

On 16/08/17 22:53, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.

> How about
> 
> 	if (WARN_ONCE(dlb->num_entries >= dlb->max_entries,
> 		      "DLB size exceeded (max %u)", dlb->max_entries))
> 		return;
> 
> (WARN_ONCE contains the unlikely() already)
> 
> I'm not fussed either way,

That does seem cleaner. Updated ready for any repost.

Thanks
--
Kieran
