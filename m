Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63028 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757408AbdLUCQp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 21:16:45 -0500
Date: Thu, 21 Dec 2017 11:16:39 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 1/6] media: rc: update sunxi-ir driver to get base
 clock frequency from devicetree
Message-id: <20171221021639.GG25647@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20171219080747.4507-2-embed3d@gmail.com>
References: <20171219080747.4507-1-embed3d@gmail.com>
        <CGME20171219080753epcas5p15f4f2921a98e18db022afe8b3f2b445d@epcas5p1.samsung.com>
        <20171219080747.4507-2-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Dec 19, 2017 at 09:07:42AM +0100, Philipp Rossak wrote:
> This patch updates the sunxi-ir driver to set the base clock frequency from
> devicetree.
> 
> This is necessary since there are different ir receivers on the
> market, that operate with different frequencies. So this value could be
> set if the attached ir receiver needs a different base clock frequency,
> than the default 8 MHz.
> 
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>

feel free to add

Reviewed-by: Andi Shyti <andi.shyti@samsung.com>

Andi
