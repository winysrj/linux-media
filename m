Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751831AbeB0WKx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 17:10:53 -0500
MIME-Version: 1.0
In-Reply-To: <1519402422-9595-3-git-send-email-andy.yeh@intel.com>
References: <1519402422-9595-1-git-send-email-andy.yeh@intel.com> <1519402422-9595-3-git-send-email-andy.yeh@intel.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 27 Feb 2018 16:10:31 -0600
Message-ID: <CAL_JsqKd8dxF1eSkST1GyKCS_bkzALv2aGHC9TXHWfnrxx33SQ@mail.gmail.com>
Subject: Re: [v5 2/2] media: dt-bindings: Add bindings for Dongwoon DW9807
 voice coil
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>, devicetree@vger.kernel.org,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 23, 2018 at 10:13 AM, Andy Yeh <andy.yeh@intel.com> wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
>
> Dongwoon DW9807 is a voice coil lens driver.
>
> Also add a vendor prefix for Dongwoon for one did not exist previously.

Where's that?

>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9 +++++++++

DACs generally go in bindings/iio/dac/

>  1 file changed, 9 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> new file mode 100644
> index 0000000..0a1a860
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> @@ -0,0 +1,9 @@
> +Dongwoon Anatech DW9807 voice coil lens driver
> +
> +DW9807 is a 10-bit DAC with current sink capability. It is intended for
> +controlling voice coil lenses.
> +
> +Mandatory properties:
> +
> +- compatible: "dongwoon,dw9807"
> +- reg: I2C slave address
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
