Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46003 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbeE2Inp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:43:45 -0400
Date: Tue, 29 May 2018 10:43:26 +0200
From: Simon Horman <horms@verge.net.au>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: vsp1: Document vsp1_dl_body refcnt
Message-ID: <20180529084325.sgpe62mg4qedgecr@verge.net.au>
References: <20180528102420.19150-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180528102420.19150-1-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 11:24:20AM +0100, Kieran Bingham wrote:
> In commit 2d9445db0ee9 ("media: vsp1: Use reference counting for
> bodies"), a new field was introduced to the vsp1_dl_body structure to
> account for usage tracking of the body.
> 
> Document the newly added field in the kerneldoc.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
