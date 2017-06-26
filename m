Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33034 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdFZTHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 15:07:39 -0400
Date: Mon, 26 Jun 2017 14:07:37 -0500
From: Rob Herring <robh@kernel.org>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: mark.rutland@arm.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        horms@verge.net.au, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: media: Add r8a7796 DRIF bindings
Message-ID: <20170626190737.lzaqrnusvj75wtgp@rob-hp-laptop>
References: <20170623092502.57818-1-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170623092502.57818-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 23, 2017 at 10:25:02AM +0100, Ramesh Shanmugasundaram wrote:
> Add r8a7796 DRIF bindings.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
> Hi DT & Media maintainers, All,
> 
>    This patch adds DRIF bindings for R8A7796 SoC.
>    It is based on media_tree - commit 76724b30f222
> 
> Thanks,
> Ramesh.
> 
>  Documentation/devicetree/bindings/media/renesas,drif.txt | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Rob Herring <robh@kernel.org>
