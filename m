Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34779 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbcDRQgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 12:36:37 -0400
Received: by mail-yw0-f171.google.com with SMTP id j74so30316435ywg.1
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2016 09:36:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460994401-25830-1-git-send-email-aletorrado@gmail.com>
References: <1460994401-25830-1-git-send-email-aletorrado@gmail.com>
From: Alejandro Torrado <aletorrado@gmail.com>
Date: Mon, 18 Apr 2016 13:36:17 -0300
Message-ID: <CAKdORb055qVVfe_DTuiKuyWKFpocpaoANeOsqnwn6+8DoMgwpg@mail.gmail.com>
Subject: Re: [PATCH] USB_PID_DIBCOM_STK8096GP also comes with USB_VID_DIBCOM
 vendor ID.
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is incomplete. Sorry about that. New one coming soon.

2016-04-18 12:46 GMT-03:00 Alejandro Torrado <aletorrado@gmail.com>:
> Signed-off-by: Alejandro Torrado <aletorrado@gmail.com>
> ---
>  drivers/media/usb/dvb-usb/dib0700_devices.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index ea0391e..ee7bafc 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -3814,6 +3814,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
>         { USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E) },
>         { USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E_SE) },
>         { USB_DEVICE(USB_VID_PCTV,      USB_PID_DIBCOM_STK8096PVR) },
> +       { USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096PVR) },
>         { 0 }           /* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
> --
> 1.9.1
>
