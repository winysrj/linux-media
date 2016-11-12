Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35586 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756780AbcKLEwJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 23:52:09 -0500
Received: by mail-it0-f49.google.com with SMTP id e187so13793702itc.0
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 20:52:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qi-hj=2=wPqOtzhuUXWAkKfNiUb5ayG6rYS5MfDaJut+Q@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
 <20161108155520.224229d5@vento.lan> <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
 <20161109073331.204b53c4@vento.lan> <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
 <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
 <20161109153521.232b0956@vento.lan> <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
 <20161110060717.221e8d88@vento.lan> <CAA7C2qiPZnqpJ8MYkQ3wGhnmHzK25kLEP_Sm-1UOu8aECzkOGA@mail.gmail.com>
 <20161111104903.607428e5@vela.lan> <CAA7C2qhAaA0KVj4MNBE4KejhGcfbWuN_7Pj0u=uKdbYc8yvYjQ@mail.gmail.com>
 <20161111195353.3b4ee8e0@vela.lan> <20161111201011.2ce05c47@vela.lan> <CAA7C2qi-hj=2=wPqOtzhuUXWAkKfNiUb5ayG6rYS5MfDaJut+Q@mail.gmail.com>
From: VDR User <user.vdr@gmail.com>
Date: Fri, 11 Nov 2016 20:52:08 -0800
Message-ID: <CAA7C2qhK9rfCVBXcF9qf7XkV6_K=6-rLA797QfOqXyHBARhMew@mail.gmail.com>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Sorry, forgot to add one file to the patch.
>>
>> The right fix is this one.
>
> This patch seems to fix the unload crash but unfortunately now all I
> get is "frontend 0/0 timed out while tuning".

Forgot to mention that I didn't see the gp8psk-fe entry in menuconfig
customize frontends even though the gp8psk module was enabled and set
to <m>. When I exited and saved .config, DVB_GP8PSK_FE was set though.
Maybe something at `config DVB_USB_GP8PSK` in
drivers/media/usb/dvb-usb/Kconfig needs adjusting too?
