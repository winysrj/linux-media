Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63984 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbeAYKaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 05:30:02 -0500
Date: Thu, 25 Jan 2018 12:29:58 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        jian.xu.zheng@intel.com, tian.shu.qiu@intel.com,
        andy.yeh@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH v1] media: ov13858: Avoid possible null first frame
Message-ID: <20180125102958.dxky4qrzv5ags6av@paasikivi.fi.intel.com>
References: <1516854879-15029-1-git-send-email-chiranjeevi.rapolu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516854879-15029-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

On Wed, Jan 24, 2018 at 08:34:39PM -0800, Chiranjeevi Rapolu wrote:
> Previously, the sensor, with default settings, was outputting SOF without
> data. This results in frame sync error on the receiver side.
> 
> Now, configure the sensor to output SOF with MIPI data for all frames. This
> avoids possible null first frame on the bus.
> 
> Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>

Thanks for the patch.

I'll apply this now, however I see that most of the registers in the four
modes are the same. In the future it'd be good to separate the parts that
are common in all of them (to be written in sensor power-on) to make this
(slightly) more maintainable.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
