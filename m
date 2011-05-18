Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64530 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1ERB1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 21:27:10 -0400
Received: by ewy4 with SMTP id 4so300261ewy.19
        for <linux-media@vger.kernel.org>; Tue, 17 May 2011 18:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110517142352.7d311ee8@glory.local>
References: <20110517142352.7d311ee8@glory.local>
Date: Tue, 17 May 2011 21:27:08 -0400
Message-ID: <BANLkTimk-WrKKqW4b_1G99euY6vjcoQxeQ@mail.gmail.com>
Subject: Re: [PATCH] xc5000, fix fw upload crash
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 17, 2011 at 12:23 AM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> Hi
>
> Fix crash when init tuner and upload twice the firmware into xc5000 at the some time.
>
> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
> index aa1b2e8..a491a5b 100644
> --- a/drivers/media/common/tuners/xc5000.c
> +++ b/drivers/media/common/tuners/xc5000.c
> @@ -996,6 +996,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
>        struct xc5000_priv *priv = fe->tuner_priv;
>        int ret = 0;
>
> +       mutex_lock(&xc5000_list_mutex);
> +
>        if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
>                ret = xc5000_fwupload(fe);
>                if (ret != XC_RESULT_SUCCESS)
> @@ -1015,6 +1017,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
>        /* Default to "CABLE" mode */
>        ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
>
> +       mutex_unlock(&xc5000_list_mutex);
> +
>        return ret;
>  }
>
>
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
>
> With my best regards, Dmitry.

NACK!

I don't think this patch is correct.  Concurrency problems are
expected to be handled in the upper layers, as there are usually much
more significant problems than just this case.  For example, if this
is a race between V4L2 and DVB, it is the responsibility of bridge
driver to provide proper locking.

If patches like this were accepted, we would need to litter every call
of all the tuner drivers with mutex lock/unlock, and it simply isn't
maintainable.

NACK unless Dmitri can provide a much better explanation as to why
this patch should be accepted rather than fixing the problem in the
bridge driver.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
