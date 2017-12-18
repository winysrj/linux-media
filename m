Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:44107 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758985AbdLRTzF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 14:55:05 -0500
MIME-Version: 1.0
In-Reply-To: <20171128113352.5jm3ur3bszey3y4l@rohdewald.de>
References: <20171128113352.5jm3ur3bszey3y4l@rohdewald.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 18 Dec 2017 20:55:03 +0100
Message-ID: <CAK8P3a1-xGO652LnkxEMun58dHXVQsdpLDVBnVZTPD7eywZfGg@mail.gmail.com>
Subject: Re: [PATCH] media: dvb_usb_pctv452e: module refcount changes were unbalanced
To: Wolfgang Rohdewald <wolfgang@rohdewald.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 28, 2017 at 12:33 PM, Wolfgang Rohdewald
<wolfgang@rohdewald.de> wrote:

> @@ -913,6 +913,14 @@ static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
>                                                 &a->dev->i2c_adap);
>         if (!a->fe_adap[0].fe)
>                 return -ENODEV;
> +
> +       /*
> +        * dvb_frontend will call dvb_detach for both stb0899_detach
> +        * and stb0899_release but we only do dvb_attach(stb0899_attach).
> +        * Increment the module refcount instead.
> +        */
> +       symbol_get(stb0899_attach);
> +
>         if ((dvb_attach(lnbp22_attach, a->fe_adap[0].fe,
>                                         &a->dev->i2c_adap)) == NULL)
>                 err("Cannot attach lnbp22\n");

This caused a build error in today's linux-next:

In file included from drivers/media/usb/dvb-usb/pctv452e.c:20:0:
drivers/media/usb/dvb-usb/pctv452e.c: In function 'pctv452e_frontend_attach':
drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak
declaration of 'stb0899_attach' being applied to a already existing,
static definition
 static inline struct dvb_frontend *stb0899_attach(struct
stb0899_config *config,

I don't really understand where the 'weak' declaration came from, but this seems
to be related to resolving a symbol for a function that was declared
'static inline'.

The random configuration that caused this included:

CONFIG_DVB_USB_PCTV452E=y
# CONFIG_DVB_STB0899 is not set
# CONFIG_MODULES is not set

       Arnd
