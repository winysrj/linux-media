Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46400 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbdHMMWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 08:22:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: crope@iki.fi, mchehab@kernel.org, ezequiel@vanguardiasur.com.ar,
        royale@zerezo.com, sean@mess.org, klimov.linux@gmail.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] usb: constify usb_device_id
Date: Sun, 13 Aug 2017 15:23:08 +0300
Message-ID: <6110957.VAtsH2oBFn@avalon>
In-Reply-To: <1502614485-2150-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com> <1502614485-2150-2-git-send-email-arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvind,

Thank you for the patch.

On Sunday 13 Aug 2017 14:24:43 Arvind Yadav wrote:
> usb_device_id are not supposed to change at runtime. All functions
> working with usb_device_id provided by <linux/usb.h> work with
> const usb_device_id. So mark the non-const structs as const.
> 
> 'drivers/media/usb/b2c2/flexcop-usb.c' Fix checkpatch.pl error:
> ERROR: space prohibited before open square bracket '['.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  drivers/media/usb/airspy/airspy.c                 | 2 +-
>  drivers/media/usb/as102/as102_usb_drv.c           | 2 +-
>  drivers/media/usb/b2c2/flexcop-usb.c              | 2 +-
>  drivers/media/usb/cpia2/cpia2_usb.c               | 2 +-
>  drivers/media/usb/dvb-usb-v2/az6007.c             | 2 +-
>  drivers/media/usb/hackrf/hackrf.c                 | 2 +-
>  drivers/media/usb/hdpvr/hdpvr-core.c              | 2 +-
>  drivers/media/usb/msi2500/msi2500.c               | 2 +-
>  drivers/media/usb/s2255/s2255drv.c                | 2 +-
>  drivers/media/usb/stk1160/stk1160-core.c          | 2 +-
>  drivers/media/usb/stkwebcam/stk-webcam.c          | 2 +-
>  drivers/media/usb/tm6000/tm6000-cards.c           | 2 +-
>  drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 2 +-
>  drivers/media/usb/ttusb-dec/ttusb_dec.c           | 2 +-
>  drivers/media/usb/usbtv/usbtv-core.c              | 2 +-
>  drivers/media/usb/uvc/uvc_driver.c                | 2 +-

For the UVC driver,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  drivers/media/usb/zr364xx/zr364xx.c               | 2 +-
>  17 files changed, 17 insertions(+), 17 deletions(-)

-- 
Regards,

Laurent Pinchart
