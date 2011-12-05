Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52359 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1LESXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 13:23:32 -0500
Received: by ywa9 with SMTP id 9so4548861ywa.19
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2011 10:23:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321800978-27912-5-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
	<1321800978-27912-2-git-send-email-mchehab@redhat.com>
	<1321800978-27912-3-git-send-email-mchehab@redhat.com>
	<1321800978-27912-4-git-send-email-mchehab@redhat.com>
	<1321800978-27912-5-git-send-email-mchehab@redhat.com>
Date: Mon, 5 Dec 2011 13:23:31 -0500
Message-ID: <CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com>
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE
 HVR-930C again
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Eddi De Pieri <eddi@depieri.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 20, 2011 at 9:56 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
> index ecd1f95..048f489 100644
> --- a/drivers/media/common/tuners/xc5000.c
> +++ b/drivers/media/common/tuners/xc5000.c
> @@ -1004,6 +1004,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
>        struct xc5000_priv *priv = fe->tuner_priv;
>        int ret = 0;
>
> +       mutex_lock(&xc5000_list_mutex);
> +
>        if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
>                ret = xc5000_fwupload(fe);
>                if (ret != XC_RESULT_SUCCESS)
> @@ -1023,6 +1025,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
>        /* Default to "CABLE" mode */
>        ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
>
> +       mutex_unlock(&xc5000_list_mutex);
> +
>        return ret;
>  }

What's up with this change?  Is this a bugfix for some race condition?
 Why is it jammed into a patch for some particular product?

It seems like a change such as this could significantly change the
timing of tuner initialization if you have multiple xc5000 based
products that might have a slow i2c bus.  Was that intentional?

This patch should be NACK'd and resubmitted as it's own bugfix where
it's implications can be fully understood in the context of all the
other products that use xc5000.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
