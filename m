Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27577 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbeJEWdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 18:33:08 -0400
Date: Fri, 5 Oct 2018 18:33:25 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2 0/6] media: video-i2c: support changing frame interval
 and runtime PM
Message-ID: <20181005153325.d22ygx4zmowmvpg3@paasikivi.fi.intel.com>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 24, 2018 at 01:34:46AM +0900, Akinobu Mita wrote:
> This patchset adds support for changing frame interval and runtime PM for
> video-i2c driver.  This also adds an helper macro to v4l2 common
> internal API that is used to to find a suitable frame interval.
> 
> There are a couple of unrelated changes that are included for simplifying
> driver initialization code and register accesses.
> 
> * v2
> - Add Acked-by and Reviewed-by tags
> - Update commit log to clarify the use after free
> - Add thermistor and termperature register address definisions
> - Stop adding v4l2_find_closest_fract() in v4l2 common internal API
> - Add V4L2_FRACT_COMPARE() macro in v4l2 common internal API
> - Use V4L2_FRACT_COMPARE() to find suitable frame interval instead of
>   v4l2_find_closest_fract()
> - Add comment for register address definisions
> 
> Akinobu Mita (6):
>   media: video-i2c: avoid accessing released memory area when removing
>     driver
>   media: video-i2c: use i2c regmap
>   media: v4l2-common: add V4L2_FRACT_COMPARE
>   media: vivid: use V4L2_FRACT_COMPARE
>   media: video-i2c: support changing frame interval
>   media: video-i2c: support runtime PM

For patches 2--6:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
