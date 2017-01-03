Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33481 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbdACXSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 18:18:31 -0500
Date: Tue, 3 Jan 2017 17:18:30 -0600
From: Rob Herring <robh@kernel.org>
To: Michael Tretter <m.tretter@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v3 1/7] [media] dt-bindings: Add a binding for Video Data
 Order Adapter
Message-ID: <20170103231829.am6mup7q5drwjy26@rob-hp-laptop>
References: <20170102132352.23669-1-m.tretter@pengutronix.de>
 <20170102132352.23669-2-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170102132352.23669-2-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 02, 2017 at 02:23:46PM +0100, Michael Tretter wrote:
> From: Philipp Zabel <philipp.zabel@gmail.com>
> 
> Add a DT binding documentation for the Video Data Order Adapter (VDOA)
> of the Freescale i.MX6 SoC.
> 
> Also, add the compatible property and correct clock to the device tree
> to match the documentation.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
>  .../devicetree/bindings/media/fsl-vdoa.txt          | 21 +++++++++++++++++++++
>  arch/arm/boot/dts/imx6qdl.dtsi                      |  2 ++
>  2 files changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/fsl-vdoa.txt

Acked-by: Rob Herring <robh@kernel.org>
