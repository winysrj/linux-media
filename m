Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward11p.cmail.yandex.net ([87.250.241.139]:39758 "EHLO
	forward11p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbbJTUvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 16:51:52 -0400
From: =?koi8-r?B?+8/L1dLP1yDhztTPzg==?= <shokurov.anton.v@yandex.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1445202086-3689-1-git-send-email-shokurov.anton.v@yandex.ru>
References: <1445202086-3689-1-git-send-email-shokurov.anton.v@yandex.ru>
Subject: Re: [PATCH 1/1] x86: Fix reading the current exposure value of UVC
MIME-Version: 1.0
Message-Id: <622811445373860@web25g.yandex.ru>
Date: Tue, 20 Oct 2015 23:44:20 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

Have you received my patch? When will it be included in the kernel?

Thanks!

19.10.2015, 00:02, "Anton V. Shokurov" <shokurov.anton.v@yandex.ru>:
> V4L2_CID_EXPOSURE_ABSOLUTE property does not return an updated value when
> autoexposure (V4L2_CID_EXPOSURE_AUTO) is turned on. This patch fixes this
> issue by adding the UVC_CTRL_FLAG_AUTO_UPDATE flag.
>
> Tested on a C920 camera.
>
> Signed-off-by: Anton V. Shokurov <shokurov.anton.v@yandex.ru>
> ---
> šdrivers/media/usb/uvc/uvc_ctrl.c | 3 ++-
> š1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index 3e59b28..c2ee6e3 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -227,7 +227,8 @@ static struct uvc_control_info uvc_ctrls[] = {
> ššššššššššššššššš.size = 4,
> ššššššššššššššššš.flags = UVC_CTRL_FLAG_SET_CUR
> ššššššššššššššššššššššššššššššššš| UVC_CTRL_FLAG_GET_RANGE
> - | UVC_CTRL_FLAG_RESTORE,
> + | UVC_CTRL_FLAG_RESTORE
> + | UVC_CTRL_FLAG_AUTO_UPDATE,
> ššššššššš},
> ššššššššš{
> ššššššššššššššššš.entity = UVC_GUID_UVC_CAMERA,
> --
> 2.6.0
