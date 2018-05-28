Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:50395 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932451AbeE1UQq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 16:16:46 -0400
Date: Mon, 28 May 2018 23:16:42 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2] media: pxa_camera: avoid duplicate s_power calls
Message-ID: <20180528201642.z54unsmkhppnesah@kekkonen.localdomain>
References: <1527435011-9318-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527435011-9318-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 12:30:11AM +0900, Akinobu Mita wrote:
> The open() operation for the pxa_camera driver always calls s_power()
> operation to put its subdevice sensor in normal operation mode, and the
> release() operation always call s_power() operation to put the subdevice
> in power saving mode.
> 
> This requires the subdevice sensor driver to keep track of its power
> state in order to avoid putting the subdevice in power saving mode while
> the device is still opened by some users.
> 
> Many subdevice drivers handle it by the boilerplate code that increments
> and decrements an internal counter in s_power() like below:
> 
> 	/*
> 	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
> 	 * update the power state.
> 	 */
> 	if (sensor->power_count == !on) {
> 		ret = ov5640_set_power(sensor, !!on);
> 		if (ret)
> 			goto out;
> 	}
> 
> 	/* Update the power count. */
> 	sensor->power_count += on ? 1 : -1;
> 
> However, some subdevice drivers don't handle it and may cause a problem
> with the pxa_camera driver if the video device is opened by more than
> two users at the same time.
> 
> Instead of propagating the boilerplate code for each subdevice driver
> that implement s_power, this introduces an trick that many V4L2 drivers
> are using with v4l2_fh_is_singular_file().
> 
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
