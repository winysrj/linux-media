Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:33813 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbeEOHqp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:46:45 -0400
Date: Tue, 15 May 2018 09:46:25 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Fix potential buffer overrun root cause
Message-ID: <20180515074625.lbelepoh2637qfwe@verge.net.au>
References: <20180511144126.24804-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180511144126.24804-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 11, 2018 at 04:41:24PM +0200, Niklas Söderlund wrote:
> Hi,
> 
> Commit 015060cb7795eac3 ("media: rcar-vin: enable field toggle after a
> set number of lines for Gen3") was an attempt to fix the issue of
> writing outside the capture buffer for VIN Gen3. Unfortunately it only
> fixed a symptom of a problem to such a degree I could no longer
> reproduce it.
> 
> Jacopo on the other hand working on a different setup still ran into the
> issue. And he even figured out the root cause of the issue. When I
> submitted the original VIN Gen3 support I had when addressing a review
> comment missed to keep the crop and compose dimensions in sync with the
> requested format resulting in the DMA engine not properly stopping
> before writing outside the buffer.
> 
> This series reverts the incorrect fix in 1/2 and applies a correct one
> in 2/2. I think this should be picked up for v4.18.
> 
> * Changes since v1
> - Add commit message to 1/2.
> 
> Niklas Söderlund (2):
>   Revert "media: rcar-vin: enable field toggle after a set number of
>     lines for Gen3"
>   rcar-vin: fix crop and compose handling for Gen3

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
