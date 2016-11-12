Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38093 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938386AbcKLKUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:20:38 -0500
Received: by mail-it0-f52.google.com with SMTP id q124so24067967itd.1
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2016 02:20:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161112061443.4c7cfd3b@vela.lan>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
 <20161108155520.224229d5@vento.lan> <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
 <20161109073331.204b53c4@vento.lan> <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
 <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
 <20161109153521.232b0956@vento.lan> <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
 <20161110060717.221e8d88@vento.lan> <CAA7C2qiPZnqpJ8MYkQ3wGhnmHzK25kLEP_Sm-1UOu8aECzkOGA@mail.gmail.com>
 <20161111104903.607428e5@vela.lan> <CAA7C2qhAaA0KVj4MNBE4KejhGcfbWuN_7Pj0u=uKdbYc8yvYjQ@mail.gmail.com>
 <20161111195353.3b4ee8e0@vela.lan> <20161111201011.2ce05c47@vela.lan>
 <CAA7C2qi-hj=2=wPqOtzhuUXWAkKfNiUb5ayG6rYS5MfDaJut+Q@mail.gmail.com> <20161112061443.4c7cfd3b@vela.lan>
From: VDR User <user.vdr@gmail.com>
Date: Sat, 12 Nov 2016 02:20:37 -0800
Message-ID: <CAA7C2qi-NmpnRJO6DGmh9O1_21vK=Q82A_qkfBJ0ujYPakL6XQ@mail.gmail.com>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, I think I had too much patching going on (I switched from 4.8.4
kernel drivers to media_build) so I started from scratch with a fresh
update to kernel 4.8.7. First I applied the dma stuff in this order:

(from https://patchwork.linuxtv.org/patch/37395/raw/)
v2-18-31-gp8psk-don-t-do-DMA-on-stack.patch
(from https://patchwork.linuxtv.org/patch/37386/raw/)
v2-19-31-gp8psk-don-t-go-past-the-buffer-size.patch
(from https://patchwork.linuxtv.org/patch/37929/raw/)
media-gp8psk-fix-gp8psk_usb_in_op-logic.patch

It works fine at this point but we still have the attach bug. Then I applied:

(from https://patchwork.linuxtv.org/patch/38040/raw/)
Question-about-2-gp8psk-patches-I-noticed-and-possible-bug..patch

Attach bug is fixed, tuning works, module unloads without crashing.
Everything seems ok! I think the gp8psk issues are resolved with the
above 4 patches. As you know, there are some other drivers which
attach the same way as gp8psk was.

Thanks for your help & patience!

One quick question.. Shouldn't gp8psk_fe be listed in the "used by"
column of dvb_usb_gp8psk or the other dvb_* modules?:

Module                  Size  Used by
gp8psk_fe               3803  1
dvb_usb_gp8psk          7344  19
dvb_usb                17495  1 dvb_usb_gp8psk
dvb_core               62327  1 dvb_usb
