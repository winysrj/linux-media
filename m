Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:18783 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388236AbeGXN2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 09:28:11 -0400
Date: Tue, 24 Jul 2018 15:21:55 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 17/35] media: camss: Add 8x96 resources
Message-ID: <20180724122154.nkb3px4tlzalhfit@paasikivi.fi.intel.com>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
 <1532343772-27382-18-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1532343772-27382-18-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Jul 23, 2018 at 02:02:34PM +0300, Todor Tomov wrote:
...
> @@ -61,7 +59,8 @@ struct ispif_device {
>  	struct mutex power_lock;
>  	struct ispif_intf_cmd_reg intf_cmd[MSM_ISPIF_VFE_NUM];
>  	struct mutex config_lock;
> -	struct ispif_line line[MSM_ISPIF_LINE_NUM];
> +	int line_num;

unsigned int?

I guess if there are only such changes then a patch on top of the current
set might be more practical than a new version of the entire set.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
