Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37838 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbcGOSw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 14:52:58 -0400
Received: by mail-wm0-f50.google.com with SMTP id i5so41410501wmg.0
        for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 11:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160715154004.GA840@ThinkPad-X200>
References: <20160715154004.GA840@ThinkPad-X200>
From: Kees Cook <keescook@google.com>
Date: Fri, 15 Jul 2016 11:52:56 -0700
Message-ID: <CAGXu5jLzMp32dbQdzG_EV0Gh-ZFs8dQ-vEHdwvjoM2uvQvpUCw@mail.gmail.com>
Subject: Re: [PATCH 1/1] subsystem:linux-media CVE-2016-5400
To: James Patrick-Evans <james@jmp-e.com>
Cc: mchehab@redhat.com, Antti Palosaari <crope@iki.fi>,
	linux-media@vger.kernel.org,
	"security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 15, 2016 at 8:40 AM, James Patrick-Evans <james@jmp-e.com> wrote:
> This patch addresses CVE-2016-5400, a local DOS vulnerability caused by a
> memory leak in the airspy usb device driver. The vulnerability is triggered
> when more than 64 usb devices register with v4l2 of type VFL_TYPE_SDR or
> VFL_TYPE_SUBDEV.A badusb device can emulate 64 of these devices then through
> continual emulated connect/disconnect of the 65th device, cause the kernel
> to run out of RAM and crash the kernel. The vulnerability exists in kernel
> versions from 3.17 to current 4.7.
> The memory leak is caused by the probe function of the airspy driver
> mishandeling errors and not freeing the corresponding control structures
> when an error occours registering the device to v4l2 core.

Thanks for getting this fixed!

> Signed-off-by: James Patrick-Evans <james@jmp-e.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

> ---
>  drivers/media/usb/airspy/airspy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/airspy/airspy.c
> b/drivers/media/usb/airspy/airspy.c
> index 87c1293..6c3ac8b 100644
> --- a/drivers/media/usb/airspy/airspy.c
> +++ b/drivers/media/usb/airspy/airspy.c
> @@ -1072,7 +1072,7 @@ static int airspy_probe(struct usb_interface *intf,
>         if (ret) {
>                 dev_err(s->dev, "Failed to register as video device (%d)\n",
>                                 ret);
> -               goto err_unregister_v4l2_dev;
> +               goto err_free_controls;
>         }
>         dev_info(s->dev, "Registered as %s\n",
>                         video_device_node_name(&s->vdev));
> --
> 1.9.1
>

-Kees

-- 
Kees Cook
Brillo & Chrome OS Security
