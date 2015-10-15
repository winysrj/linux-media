Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33939 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbJOV1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 17:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <1444940565-30730-1-git-send-email-wuninsu@gmail.com>
References: <1444940565-30730-1-git-send-email-wuninsu@gmail.com>
Date: Thu, 15 Oct 2015 17:27:47 -0400
Message-ID: <CAOcJUbxeaHRTy_YaE7CbYAFacHj4SeHSEQPJ2P2RMk6CsFEZnQ@mail.gmail.com>
Subject: Re: [PATCH] mxl111sf: missing return values validation
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Insu Yun <wuninsu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, taesoo@gatech.edu,
	yeongjin.jang@gatech.edu, insu@gatech.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 15, 2015 at 4:22 PM, Insu Yun <wuninsu@gmail.com> wrote:
> Return values of mxl111sf_enable_usb_output and mxl1x1sf_top_master_ctrl
> are not validated.
>
> Signed-off-by: Insu Yun <wuninsu@gmail.com>



Eeek!  You're right!  ...and I'm the one who wrote the offending code.
My bad O:-)

Thank you for this patch.  Mauro, please apply it.

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>



> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> index bec12b0..b71b2e6 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -288,9 +288,9 @@ static int mxl111sf_adap_fe_init(struct dvb_frontend *fe)
>         err = mxl1x1sf_set_device_mode(state, adap_state->device_mode);
>
>         mxl_fail(err);
> -       mxl111sf_enable_usb_output(state);
> +       err = mxl111sf_enable_usb_output(state);
>         mxl_fail(err);
> -       mxl1x1sf_top_master_ctrl(state, 1);
> +       err = mxl1x1sf_top_master_ctrl(state, 1);
>         mxl_fail(err);
>
>         if ((MXL111SF_GPIO_MOD_DVBT != adap_state->gpio_mode) &&
> --
> 1.9.1
>
