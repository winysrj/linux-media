Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37551 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728960AbeJAQSy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 12:18:54 -0400
Subject: Re: [PATCH v2 0/6] media: video-i2c: support changing frame interval
 and runtime PM
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <92579b08-72cc-cfa6-a57a-85810d582f4d@xs4all.nl>
Date: Mon, 1 Oct 2018 11:41:54 +0200
MIME-Version: 1.0
In-Reply-To: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/23/2018 06:34 PM, Akinobu Mita wrote:
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

1) What's wrong with v4l2_find_closest_fract()?

2) Please test this with the latest v4l2-compliance: I recently improved
   the S_PARM checks, so I want to make sure this driver passes those tests.

Regards,

	Hans

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
> 
>  drivers/media/i2c/video-i2c.c                | 286 ++++++++++++++++++++++-----
>  drivers/media/platform/vivid/vivid-vid-cap.c |   9 +-
>  include/media/v4l2-common.h                  |   5 +
>  3 files changed, 247 insertions(+), 53 deletions(-)
> 
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> 
