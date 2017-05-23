Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33116 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760007AbdEWPIw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 11:08:52 -0400
Date: Tue, 23 May 2017 10:08:50 -0500
From: Rob Herring <robh@kernel.org>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        geert@linux-m68k.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        sergei.shtylyov@cogentembedded.com, horms@verge.net.au,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 3/4] media: adv7180: Add adv7180cp, adv7180st bindings
Message-ID: <20170523150850.25x4vvswlxvb4kpg@rob-hp-laptop>
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1495199224-16337-4-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495199224-16337-4-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 19, 2017 at 03:07:03PM +0200, Ulrich Hecht wrote:
> To differentiate between two classes of chip packages that have
> different numbers of input ports.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/adv7180.txt | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>
