Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:33639 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756136AbdLTSQ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 13:16:27 -0500
Date: Wed, 20 Dec 2017 12:16:24 -0600
From: Rob Herring <robh@kernel.org>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, Joao.Pinto@synopsys.com,
        Luis.Oliveira@synopsys.com, Jose.Abreu@synopsys.com,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: Re: [PATCH v4 11/16] dt-bindings: Document the Rockchip MIPI RX
 D-PHY bindings
Message-ID: <20171220181624.ygxasm726tcts5sx@rob-hp-laptop>
References: <20171218121445.6086-1-jacob-chen@iotwrt.com>
 <20171218121445.6086-8-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218121445.6086-8-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 18, 2017 at 08:14:40PM +0800, Jacob Chen wrote:
> From: Jacob Chen <jacob2.chen@rock-chips.com>
> 
> Add DT bindings documentation for Rockchip MIPI D-PHY RX
> 
> Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
> ---
>  .../bindings/media/rockchip-mipi-dphy.txt          | 88 ++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt

Reviewed-by: Rob Herring <robh@kernel.org>
