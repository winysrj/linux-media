Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33426 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbeCFB2Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 20:28:16 -0500
Date: Mon, 5 Mar 2018 19:28:14 -0600
From: Rob Herring <robh@kernel.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] media: ov2680: dt: Add bindings for OV2680
Message-ID: <20180306012814.okxveqhhtz565iij@rob-hp-laptop>
References: <20180228152723.26392-1-rui.silva@linaro.org>
 <20180228152723.26392-2-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228152723.26392-2-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 28, 2018 at 03:27:22PM +0000, Rui Miguel Silva wrote:
> Add device tree binding documentation for the OV2680 camera sensor.
> 
> CC: devicetree@vger.kernel.org
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  .../devicetree/bindings/media/i2c/ov2680.txt       | 40 ++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt

Reviewed-by: Rob Herring <robh@kernel.org>
