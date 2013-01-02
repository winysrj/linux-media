Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51125 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3ABDYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 22:24:10 -0500
Received: by mail-oa0-f43.google.com with SMTP id k1so12598354oag.2
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 19:24:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355100335-2123-7-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
	<1355100335-2123-7-git-send-email-crope@iki.fi>
Date: Wed, 2 Jan 2013 01:24:09 -0200
Message-ID: <CAOMZO5Ac_EAjzYkLec6ZOxvm4fpvvFr7pLyKYNz=8EhAFM+6Pw@mail.gmail.com>
Subject: Re: [PATCH RFC 07/11] it913x: make remote controller optional
From: Fabio Estevam <festevam@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 9, 2012 at 10:45 PM, Antti Palosaari <crope@iki.fi> wrote:
> Do not compile remote controller when RC-core is disabled by Kconfig.
>
> Cc: Malcolm Priestley <tvboxspy@gmail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/it913x.c | 36 +++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
> index 4720428..5dc352b 100644
> --- a/drivers/media/usb/dvb-usb-v2/it913x.c
> +++ b/drivers/media/usb/dvb-usb-v2/it913x.c
> @@ -308,6 +308,7 @@ static struct i2c_algorithm it913x_i2c_algo = {
>  };
>
>  /* Callbacks for DVB USB */
> +#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)

Maybe you could use:

#if IS_ENABLED(CONFIG_RC_CORE)

Regards,

Fabio Estevam
