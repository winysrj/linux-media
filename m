Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:57742 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbeKEVOz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 16:14:55 -0500
Date: Mon, 5 Nov 2018 13:55:26 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 06/16] intel-ipu3: mmu: Implement driver
Message-ID: <20181105115525.fuwuxnsyzsvl5oj7@kekkonen.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-7-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540851790-1777-7-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Oct 29, 2018 at 03:23:00PM -0700, Yong Zhi wrote:
> From: Tomasz Figa <tfiga@chromium.org>
> 
> This driver translates IO virtual address to physical
> address based on two levels page tables.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---

...

> +static void call_if_ipu3_is_powered(struct ipu3_mmu *mmu,
> +				    void (*func)(struct ipu3_mmu *mmu))
> +{
> +	pm_runtime_get_noresume(mmu->dev);
> +	if (pm_runtime_active(mmu->dev))
> +		func(mmu);
> +	pm_runtime_put(mmu->dev);

How about:

	if (!pm_runtime_get_if_in_use(mmu->dev))
		return;

	func(mmu);
	pm_runtime_put(mmu->dev);
	

> +}

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
