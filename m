Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbeIUCqx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:46:53 -0400
Subject: Re: [RESEND PATCH 1/1] v4l: samsung, ov9650: Rely on V4L2-set
 sub-device names
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Kyungmin Park <kyungmin.park@samsung.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>
References: <20180915225213.12946-1-sakari.ailus@linux.intel.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <7d4b3c0e-5199-7283-ed21-ce063f7ed970@kernel.org>
Date: Thu, 20 Sep 2018 23:01:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180915225213.12946-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/16/2018 12:52 AM, Sakari Ailus wrote:
> v4l2_i2c_subdev_init() sets the name of the sub-devices (as well as
> entities) to what is fairly certainly known to be unique in the system,
> even if there were more devices of the same kind.
> 
> These drivers (m5mols, noon010pc30, ov9650, s5c73m3, s5k4ecgx, s5k6aa) set
> the name to the name of the driver or the module while omitting the
> device's I²C address and bus, leaving the devices with a static name and
> effectively limiting the number of such devices in a media device to 1.
> 
> Address this by using the name set by the V4L2 framework.
> 
> Signed-off-by: Sakari Ailus<sakari.ailus@linux.intel.com>
> Reviewed-by: Akinobu Mita<akinobu.mita@gmail.com>  (ov9650)

I'm not against this patch but please don't expect an ack from me as this
patch breaks existing user space code, scripts using media-ctl, etc. will 
need to be updated after kernel upgrade. I'm mostly concerned about ov9650
as other drivers are likely only used by Samsung or are obsoleted.

--
Thanks,
Sylwester
