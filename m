Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42774 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbeHNXla (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 19:41:30 -0400
Date: Tue, 14 Aug 2018 14:52:30 -0600
From: Rob Herring <robh@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/3] dt-bindings: media: Add i.MX Pixel Pipeline binding
Message-ID: <20180814205230.GA16370@rob-hp-laptop>
References: <20180810151822.18650-1-p.zabel@pengutronix.de>
 <20180810151822.18650-2-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810151822.18650-2-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 10 Aug 2018 17:18:20 +0200, Philipp Zabel wrote:
> Add DT binding documentation for the Pixel Pipeline (PXP) found on
> various NXP i.MX SoCs.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  .../devicetree/bindings/media/fsl-pxp.txt     | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/fsl-pxp.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
