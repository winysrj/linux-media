Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54810 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbeB0InJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 03:43:09 -0500
Date: Tue, 27 Feb 2018 09:42:50 +0100
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: platform: Drop OF dependency of VIDEO_RENESAS_VSP1
Message-ID: <20180227084249.ogc7x5bdoc63gmt7@verge.net.au>
References: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 26, 2018 at 07:09:10PM +0100, Geert Uytterhoeven wrote:
> VIDEO_RENESAS_VSP1 depends on ARCH_RENESAS && OF.
> As ARCH_RENESAS implies OF, the latter can be dropped.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

My reasoning is that ARCH_RENESAS depends on ARCH_MULTI_V7,
which in turn depends on ARCH_MULTIPLATFORM which selects OF via USE_OF

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
