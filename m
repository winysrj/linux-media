Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:55255 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754103AbeBGNrf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 08:47:35 -0500
Date: Wed, 7 Feb 2018 15:47:32 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [PATCH v5] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180207134731.n6zziksk2mcsqzor@paasikivi.fi.intel.com>
References: <1516903135-23136-1-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516903135-23136-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the update.

On Fri, Jan 26, 2018 at 01:58:55AM +0800, Andy Yeh wrote:
> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Signed-off-by: Jason Chen <jasonx.z.chen@intel.com>
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> ---
> since v2:
> -- Update the streaming function to remove SW_STANDBY in the beginning.
> -- Adjust the delay time from 1ms to 12ms before set stream-on register.
> since v3:
> -- fix the sd.entity to make code be compiled on the mainline kernel.
> since v4:
> -- Enabled AG, DG, and Exposure time control correctly.

This patch seems to include also DIGITAL_GAIN control support but also the
removal of the VBLANK control from s_ctrl callback. Is there still an
intent to support the VBLANK control?

Also registers are written one octet at a time rather than two, which could
lead to sensor using settings that are only half-updated (does the
datasheet say this is safe?). Is there a reason for this?

Seems fine otherwise to me.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
