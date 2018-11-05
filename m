Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:34247 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbeKERqe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 12:46:34 -0500
Date: Mon, 5 Nov 2018 10:27:56 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 05/16] intel-ipu3: abi: Add structs
Message-ID: <20181105082755.c65oh6c2ztk34kpb@kekkonen.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-6-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540851790-1777-6-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Oct 29, 2018 at 03:22:59PM -0700, Yong Zhi wrote:
> This add all the structs of IPU3 firmware ABI.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>

...

> +struct imgu_abi_shd_intra_frame_operations_data {
> +	struct imgu_abi_acc_operation
> +		operation_list[IMGU_ABI_SHD_MAX_OPERATIONS] __attribute__((aligned(32)));
> +	struct imgu_abi_acc_process_lines_cmd_data
> +		process_lines_data[IMGU_ABI_SHD_MAX_PROCESS_LINES] __attribute__((aligned(32)));
> +	struct imgu_abi_shd_transfer_luts_set_data
> +		transfer_data[IMGU_ABI_SHD_MAX_TRANSFERS] __attribute__((aligned(32)));

Could you replace this wth __aligned(32), please? The same for the rest of
the header.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
