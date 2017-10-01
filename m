Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:56800 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdJAJy4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Oct 2017 05:54:56 -0400
Received: by mail-qt0-f195.google.com with SMTP id e19so349999qta.13
        for <linux-media@vger.kernel.org>; Sun, 01 Oct 2017 02:54:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1506338455-17055-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1506338455-17055-1-git-send-email-sakari.ailus@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 1 Oct 2017 12:54:55 +0300
Message-ID: <CAHp75VdNL1Jd6-BLCdusywOXBhWw9WeqJRzRwZLZR5QXcYWh9A@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging: atomisp: Update TODO regarding sensors
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 25, 2017 at 2:20 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> There was no specific item regarding what should be done to sensor, lens
> and flash drivers. Add one, to replace the vague item denoting support
> only to particular sensor, lens and flash devices.
>

I think it's right direction, though Alan would be one who can confirm.

Additionally the lm3554.c should gone in favour the one under driver/leds/.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/staging/media/atomisp/TODO | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/media/atomisp/TODO b/drivers/staging/media/atomisp/TODO
> index 737452c..a960247 100644
> --- a/drivers/staging/media/atomisp/TODO
> +++ b/drivers/staging/media/atomisp/TODO
> @@ -36,13 +36,18 @@
>     there are any specific things that can be done to fold in support for
>     multiple firmware versions.
>
> +8. Switch to V4L2 async API to set up sensor, lens and flash devices.
> +   Control those devices using V4L2 sub-device API without custom
> +   extensions.
>
> -Limitations:
> +9. Switch to standard V4L2 sub-device API for sensor, lens and flash
> +   drivers. In particular, the user space API needs to support V4L2
> +   controls as defined in the V4L2 spec and references to atomisp must be
> +   removed from these drivers.
>
> -1. Currently the patch only support some camera sensors
> -   gc2235/gc0310/0v2680/ov2722/ov5693/mt9m114...
> +Limitations:
>
> -2. To test the patches, you also need the ISP firmware
> +1. To test the patches, you also need the ISP firmware
>
>     for BYT:/lib/firmware/shisp_2400b0_v21.bin
>     for CHT:/lib/firmware/shisp_2401a0_v21.bin
> @@ -51,14 +56,14 @@ Limitations:
>     device but can also be extracted from the upgrade kit if you've managed
>     to lose them somehow.
>
> -3. Without a 3A libary the capture behaviour is not very good. To take a good
> +2. Without a 3A libary the capture behaviour is not very good. To take a good
>     picture, you need tune ISP parameters by IOCTL functions or use a 3A libary
>     such as libxcam.
>
> -4. The driver is intended to drive the PCI exposed versions of the device.
> +3. The driver is intended to drive the PCI exposed versions of the device.
>     It will not detect those devices enumerated via ACPI as a field of the
>     i915 GPU driver.
>
> -5. The driver supports only v2 of the IPU/Camera. It will not work with the
> +4. The driver supports only v2 of the IPU/Camera. It will not work with the
>     versions of the hardware in other SoCs.
>
> --
> 2.7.4
>



-- 
With Best Regards,
Andy Shevchenko
