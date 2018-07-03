Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:39673 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932440AbeGCQ1W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 12:27:22 -0400
Date: Tue, 3 Jul 2018 10:27:19 -0600
From: Rob Herring <robh@kernel.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v7 1/2] media: ov2680: dt: Add bindings for OV2680
Message-ID: <20180703162719.GA21086@rob-hp-laptop>
References: <20180703140803.19580-1-rui.silva@linaro.org>
 <20180703140803.19580-2-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703140803.19580-2-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 03, 2018 at 03:08:02PM +0100, Rui Miguel Silva wrote:
> Add device tree binding documentation for the OV2680 camera sensor.
> 
> CC: devicetree@vger.kernel.org
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  .../devicetree/bindings/media/i2c/ov2680.txt  | 46 +++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt

Please add acks/reviews when posting new versions.

Rob
