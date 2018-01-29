Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34082 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbeA2WNd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 17:13:33 -0500
Date: Tue, 30 Jan 2018 00:13:30 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [PATCH v1] media: dt-bindings: Add bindings for Dongwoon DW9807
 voice coil
Message-ID: <20180129221330.6nttrilkfcwco63a@kekkonen.localdomain>
References: <1517243672-17979-1-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517243672-17979-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Please add a cover page and send the entire set together (v5).

On Tue, Jan 30, 2018 at 12:34:32AM +0800, Andy Yeh wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
> 
> Dongwoon DW9807 is a voice coil lens driver.
> 
> Also add a vendor prefix for Dongwoon for one did not exist previously.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9 +++++++++
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

The DT binding patch needs to be cc'd to the devicetree list
<devicetree@vger.kernel.org>, please also cc Rob Herring
<robh@kernel.org>.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
