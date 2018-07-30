Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:16183 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbeG3MN0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 08:13:26 -0400
Date: Mon, 30 Jul 2018 13:39:01 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ping-chung Chen <ping-chung.chen@intel.com>
Cc: linux-media@vger.kernel.org, andy.yeh@intel.com, jim.lai@intel.com,
        tfiga@google.com, grundler@chromium.org, rajmohan.mani@intel.com
Subject: Re: [PATCH v2] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180730103901.hl7cwutgna7xzf2u@paasikivi.fi.intel.com>
References: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ping-chung,

On Mon, Jul 30, 2018 at 05:26:39PM +0800, Ping-chung Chen wrote:
> From: "Chen, Ping-chung" <ping-chung.chen@intel.com>
> 
> Add a V4L2 sub-device driver for the Sony IMX208 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
> 
> Signed-off-by: Ping-Chung Chen <ping-chung.chen@intel.com>

Could you add obtaining the valid link frequencies from the firmware, i.e.
use v4l2_fwnode_endpoint_alloc_parse()?

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
