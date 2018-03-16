Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:42075 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbeCPOTB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 10:19:01 -0400
Received: by mail-vk0-f54.google.com with SMTP id y127so6395029vky.9
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 07:19:01 -0700 (PDT)
Received: from mail-vk0-f49.google.com (mail-vk0-f49.google.com. [209.85.213.49])
        by smtp.gmail.com with ESMTPSA id b18sm1554303vkf.16.2018.03.16.07.18.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Mar 2018 07:19:00 -0700 (PDT)
Received: by mail-vk0-f49.google.com with SMTP id o205so2829877vke.11
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 07:18:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521128878-18689-1-git-send-email-andy.yeh@intel.com>
References: <1521128878-18689-1-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 16 Mar 2018 23:18:37 +0900
Message-ID: <CAAFQd5C35xqANNCaL7qo0vLtMvn3FJTv3FDqaG7nWXoRbSRNGA@mail.gmail.com>
Subject: Re: [PATCH v9] media: imx258: Add imx258 camera sensor driver
To: Andy Yeh <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Fri, Mar 16, 2018 at 12:47 AM, Andy Yeh <andy.yeh@intel.com> wrote:
> From: Jason Chen <jasonx.z.chen@intel.com>
>
> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> ---
> since v2:
> -- Update the streaming function to remove SW_STANDBY in the beginning.
> -- Adjust the delay time from 1ms to 12ms before set stream-on register.
> since v3:
> -- fix the sd.entity to make code be compiled on the mainline kernel.
> since v4:
> -- Enabled AG, DG, and Exposure time control correctly.
> since v5:
> -- Sensor vendor provided a new setting to fix different CLK issue
> -- Add one more resolution for 1048x780, used for VGA streaming
> since v6:
> -- improved i2c read/write function to support writing 2 registers
> -- modified i2c reg read/write function with a more portable way
> -- utilized v4l2_find_nearest_size instead of the local find_best_fit function
> -- defined an enum for the link freq entries for explicit indexing
> since v7:
> -- Removed usleep due to sufficient delay implemented in coreboot
> -- Added handling for VBLANK control that auto frame-line-control is enabled
> since v8:
> -- Fix some error return and intents
>

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Thanks for patiently addressing all the comments!

Best regards,
Tomasz
