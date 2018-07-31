Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:27119 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbeGaDtG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 23:49:06 -0400
From: "Chen, Ping-chung" <ping-chung.chen@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        "tfiga@google.com" <tfiga@google.com>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: RE: [PATCH v2] media: imx208: Add imx208 camera sensor driver
Date: Tue, 31 Jul 2018 02:11:10 +0000
Message-ID: <5E40A82D0551C84FA2888225EDABBE093FAA3E4E@PGSMSX105.gar.corp.intel.com>
References: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
 <20180730103901.hl7cwutgna7xzf2u@paasikivi.fi.intel.com>
In-Reply-To: <20180730103901.hl7cwutgna7xzf2u@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

We will test the new flow on Atlas.
If everything is fine we will merge the code into patch v3 or v4.

Thanks,
PC Chen
-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com] 
Sent: Monday, July 30, 2018 6:39 PM
To: Chen, Ping-chung <ping-chung.chen@intel.com>
Cc: linux-media@vger.kernel.org; Yeh, Andy <andy.yeh@intel.com>; Lai, Jim <jim.lai@intel.com>; tfiga@google.com; grundler@chromium.org; Mani, Rajmohan <rajmohan.mani@intel.com>
Subject: Re: [PATCH v2] media: imx208: Add imx208 camera sensor driver

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
