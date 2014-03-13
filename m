Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:38917 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaCMOAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 10:00:36 -0400
Received: by mail-ob0-f177.google.com with SMTP id wo20so1034083obc.36
        for <linux-media@vger.kernel.org>; Thu, 13 Mar 2014 07:00:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1WO5gP-0006vh-0X@www.linuxtv.org>
References: <E1WO5gP-0006vh-0X@www.linuxtv.org>
From: =?UTF-8?B?SmFuIFbEjWVsw6Fr?= <jv@fcelda.cz>
Date: Thu, 13 Mar 2014 15:00:15 +0100
Message-ID: <CAM1xaJ-dpeZLVaMBMT6SyHrs4MPLJ61zW2q33WkcF_u7jKWm6g@mail.gmail.com>
Subject: Re: [git:media_tree/master] [media] rtl28xxu: add USB ID for Genius
 TVGo DVB-T03
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this patch seems to be committed by a mistake (commit 1c1b873). It is
a first version of my patch, which was superseded. The new version is
already merged (commit ac298cc).

The device ID is now twice in the list.

Jan

On Wed, Mar 12, 2014 at 6:00 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03
> Author:  Jan Vcelak <jv@fcelda.cz>
> Date:    Tue Feb 25 21:30:45 2014 -0300
>
> 0458:707f KYE Systems Corp. (Mouse Systems) TVGo DVB-T03 [RTL2832]
>
> The USB dongle uses RTL2832U demodulator and FC0012 tuner.
>
> Signed-off-by: Jan Vcelak <jv@fcelda.cz>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=1c1b8734094551eb4075cf68cf76892498c0da61
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index c6ff39e..e9294dc 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1444,6 +1444,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>         /* RTL2832P devices: */
>         { DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
>                 &rtl2832u_props, "Astrometa DVB-T2", NULL) },
> +       { DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
> +               &rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
>         { }
>  };
>  MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
