Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:45506 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755899AbdLOXIc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 18:08:32 -0500
Date: Fri, 15 Dec 2017 17:08:31 -0600
From: Rob Herring <robh@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] media: dt-bindings: coda: Add compatible for CodaHx4
 on i.MX51
Message-ID: <20171215230831.gbu54ckvmn3k2cde@rob-hp-laptop>
References: <20171213140918.22500-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213140918.22500-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 13, 2017 at 03:09:17PM +0100, Philipp Zabel wrote:
> Add a compatible for the CodaHx4 VPU used on i.MX51.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/media/coda.txt | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Rob Herring <robh@kernel.org>
