Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:36238 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752317AbeBEMYE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 07:24:04 -0500
Date: Mon, 5 Feb 2018 14:24:01 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        Alan Chiang <alanx.chiang@intel.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] media: dt-bindings: Add bindings for Dongwoon DW9807
 voice coil
Message-ID: <20180205122401.o5od2vfgvqiqqwgs@paasikivi.fi.intel.com>
References: <1517500092-12121-1-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517500092-12121-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Thu, Feb 01, 2018 at 11:48:12PM +0800, Andy Yeh wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
> 
> Dongwoon DW9807 is a voice coil lens driver.
> 
> Also add a vendor prefix for Dongwoon for one did not exist previously.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>

Could you send DT binding patches to the devicetree list as well, please?

I'm cc'ing the DT list this time.

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
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
