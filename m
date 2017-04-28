Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46398 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161903AbdD1HJl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 03:09:41 -0400
Date: Fri, 28 Apr 2017 09:09:35 +0200
From: Simon Horman <horms@verge.net.au>
To: Kieran Bingham <kbingham@kernel.org>
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH 0/5] RFC: ADV748x HDMI/Analog video receiver
Message-ID: <20170428070935.GC10196@verge.net.au>
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 27, 2017 at 07:25:59PM +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> This is an RFC for the Analog Devices ADV748x driver, and follows on from a
> previous posting by Niklas Söderlund [0] of an earlier incarnation of this
> driver.

...

> This series presents the following patches:
> 
>  [PATCH 1/5] v4l2-subdev: Provide a port mapping for asynchronous
>  [PATCH 2/5] rcar-vin: Match sources against ports if specified.
>  [PATCH 3/5] media: i2c: adv748x: add adv748x driver
>  [PATCH 4/5] arm64: dts: r8a7795: salvator-x: enable VIN, CSI and ADV7482
>  [PATCH 5/5] arm64: dts: r8a7796: salvator-x: enable VIN, CSI and ADV7482

I am marking the above dts patches as "RFC" and do not plan to apply them
unless you ping me or repost them. Assuming they don't cause any
regressions I would be happy to consider applying them as soon as their
dependencies are accepted.
