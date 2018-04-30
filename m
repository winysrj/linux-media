Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:22479 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753996AbeD3PDT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 11:03:19 -0400
Date: Mon, 30 Apr 2018 18:03:15 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, Bingbu Cao <bingbu.cao@intel.com>,
        Andy Yeh <andy.yeh@intel.com>
Subject: Re: [PATCH] media: intel-ipu3: cio2: Handle IRQs until INT_STS is
 cleared
Message-ID: <20180430150315.6dqyhqlqzf2ix4ex@paasikivi.fi.intel.com>
References: <1525098640-3165-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525098640-3165-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 30, 2018 at 09:30:40AM -0500, Yong Zhi wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
> 
> Interrupt behavior shows that some time the frame end and frame start
> of next frame is unstable and can range from several to hundreds of micro-sec.
> In the case of ~10us, isr may not clear next sof interrupt status in
> single handling, which prevents new interrupts from coming.
> 
> Fix this by handling all pending IRQs before exiting isr, so any abnormal
> behavior results from very short interrupt status changes is protected.
> 
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
> Hi, Sakari,
> 
> Re-send with correct signed-off-by order.

Thanks, Yong. I've replaced the patch in my ipu3 branch, with the commit
message wrapped --- after adding four spaces to the left margin it exceeded
80 characters.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
