Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59560 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754178AbdKIM1y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 07:27:54 -0500
Date: Thu, 9 Nov 2017 14:27:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, chiranjeevi.rapolu@intel.com,
        jerry.w.hu@intel.com
Subject: Re: [PATCH v8 0/4] add IPU3 CIO2 CSI2 driver
Message-ID: <20171109122751.doum5bf4b7jlqreh@valkosipuli.retiisi.org.uk>
References: <1510187439-19125-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510187439-19125-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong and others,

On Wed, Nov 08, 2017 at 04:30:35PM -0800, Yong Zhi wrote:
> Hi,
> 
> This is patch series(version 8) of Intel IPU3 CIO2 driver, the driver exposes
> V4L2, V4L2 sub-device and Media controller interfaces to the user space.
> 
> This series was tested on Kaby Lake based platform with 2 sensor configurations,
> media topology was pasted at end for reference.
> 
> Link to user space implementation:
> 
> <URL:https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master>
> 
> ===========
> = history =
> ===========
> 
> version 8:
> - cio2_fbpt_rearrange(): change return type and move function closer to caller.(Sakari)
> - cio2_vb2_start_streaming(): call pm_runtime_put() on failures.(Sakari)
> - cio2_queue_init(): remove colon in sub-device and video node names (Sakari)
> - Add MAINTAINER's entry for this driver.

Thanks for the update!

I've applied the patches to my ipu3 branch, with the MAINTAINERS change
squashed with the patch adding the driver. The MAINTAINERS file should come
with the driver as checkpatch.pl will otherwise complain about it, it's
also not too complicated or unrelated to warrant putting it to a separate
patch.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
