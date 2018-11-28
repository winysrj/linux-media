Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:2337 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbeK2JZW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 04:25:22 -0500
Date: Thu, 29 Nov 2018 00:22:04 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 09/16] intel-ipu3: css: Add support for firmware
 management
Message-ID: <20181128222204.usznfaurffntifei@kekkonen.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-10-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540851790-1777-10-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Oct 29, 2018 at 03:23:03PM -0700, Yong Zhi wrote:
...
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-fw.h b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
> new file mode 100644
> index 0000000..954bb31
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css-fw.h
> @@ -0,0 +1,188 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */
> +
> +#ifndef __IPU3_CSS_FW_H
> +#define __IPU3_CSS_FW_H
> +
> +/******************* Firmware file definitions *******************/
> +
> +#define IMGU_FW_NAME			"ipu3-fw.bin"

Shouldn't this be "intel/ipu3-fw.bin"?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
