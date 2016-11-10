Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34947 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933808AbcKJPBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 10:01:46 -0500
Received: by mail-vk0-f43.google.com with SMTP id w194so205309378vkw.2
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2016 07:01:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161110060717.221e8d88@vento.lan>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
 <20161108155520.224229d5@vento.lan> <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
 <20161109073331.204b53c4@vento.lan> <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
 <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
 <20161109153521.232b0956@vento.lan> <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
 <20161110060717.221e8d88@vento.lan>
From: VDR User <user.vdr@gmail.com>
Date: Thu, 10 Nov 2016 07:01:44 -0800
Message-ID: <CAA7C2qiPZnqpJ8MYkQ3wGhnmHzK25kLEP_Sm-1UOu8aECzkOGA@mail.gmail.com>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> commit 0c979a12309af49894bb1dc60e747c3cd53fa888
> Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Date:   Wed Nov 9 15:33:17 2016 -0200
>
>     [media] gp8psk: Fix DVB frontend attach
>
>     it should be calling module_get() at attach, as otherwise
>     module_put() will crash.
>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
> index cede0d8b0f8a..24eb6c6c8e24 100644
> --- a/drivers/media/usb/dvb-usb/gp8psk.c
> +++ b/drivers/media/usb/dvb-usb/gp8psk.c
> @@ -250,7 +250,7 @@ static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>
>  static int gp8psk_frontend_attach(struct dvb_usb_adapter *adap)
>  {
> -       adap->fe_adap[0].fe = gp8psk_fe_attach(adap->dev);
> +       adap->fe_adap[0].fe = dvb_attach(gp8psk_fe_attach, adap->dev);
>         return 0;
>  }

This gives:

[119150.498863] DVB: Unable to find symbol gp8psk_fe_attach()
[119150.498928] dvb-usb: no frontend was attached by 'Genpix
SkyWalker-2 DVB-S receiver'
