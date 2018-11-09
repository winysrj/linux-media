Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:25594 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbeKIVqz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 16:46:55 -0500
Date: Fri, 9 Nov 2018 14:06:31 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 12/16] intel-ipu3: css: Initialize css hardware
Message-ID: <20181109120631.7tqw3rplyf7usdng@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-13-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540851790-1777-13-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Oct 29, 2018 at 03:23:06PM -0700, Yong Zhi wrote:
> This patch implements the functions to initialize
> and configure IPU3 h/w such as clock, irq and power.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-css.c | 537 ++++++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-css.h | 203 ++++++++++++
>  2 files changed, 740 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.h
> 

...

> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css.h b/drivers/media/pci/intel/ipu3/ipu3-css.h
> new file mode 100644
> index 0000000..d16d0c4
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css.h

...

> +/* IPU3 Camera Sub System structure */
> +struct ipu3_css {
> +	struct device *dev;
> +	void __iomem *base;
> +	const struct firmware *fw;
> +	struct imgu_fw_header *fwp;
> +	int iomem_length;

u32? The same for the length parameter in ccs_init().

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
