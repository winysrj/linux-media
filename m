Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36015 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935066AbcKLFWA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 00:22:00 -0500
Received: by mail-it0-f52.google.com with SMTP id q124so14934807itd.1
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 21:22:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qhK9rfCVBXcF9qf7XkV6_K=6-rLA797QfOqXyHBARhMew@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
 <20161108155520.224229d5@vento.lan> <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
 <20161109073331.204b53c4@vento.lan> <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
 <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
 <20161109153521.232b0956@vento.lan> <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
 <20161110060717.221e8d88@vento.lan> <CAA7C2qiPZnqpJ8MYkQ3wGhnmHzK25kLEP_Sm-1UOu8aECzkOGA@mail.gmail.com>
 <20161111104903.607428e5@vela.lan> <CAA7C2qhAaA0KVj4MNBE4KejhGcfbWuN_7Pj0u=uKdbYc8yvYjQ@mail.gmail.com>
 <20161111195353.3b4ee8e0@vela.lan> <20161111201011.2ce05c47@vela.lan>
 <CAA7C2qi-hj=2=wPqOtzhuUXWAkKfNiUb5ayG6rYS5MfDaJut+Q@mail.gmail.com> <CAA7C2qhK9rfCVBXcF9qf7XkV6_K=6-rLA797QfOqXyHBARhMew@mail.gmail.com>
From: VDR User <user.vdr@gmail.com>
Date: Fri, 11 Nov 2016 21:21:58 -0800
Message-ID: <CAA7C2qiKFFFdOG7C6wwXgedizmqiXqoXDx=h=_KtmghE29O-1g@mail.gmail.com>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> Sorry, forgot to add one file to the patch.
>>>
>>> The right fix is this one.
>>
>> This patch seems to fix the unload crash but unfortunately now all I
>> get is "frontend 0/0 timed out while tuning".
>
> Forgot to mention that I didn't see the gp8psk-fe entry in menuconfig
> customize frontends even though the gp8psk module was enabled and set
> to <m>. When I exited and saved .config, DVB_GP8PSK_FE was set though.
> Maybe something at `config DVB_USB_GP8PSK` in
> drivers/media/usb/dvb-usb/Kconfig needs adjusting too?

Ugh, forgot to add this as well:

Module                  Size  Used by
gp8psk_fe               3803  1
dvb_usb_gp8psk          7408  4
dvb_usb                17623  1 dvb_usb_gp8psk
dvb_core               74928  1 dvb_usb
lirc_serial             7502  3
lirc_dev                6991  1 lirc_serial
rc_core                16112  2 dvb_usb,lirc_dev

And I noticed something different in dmesg when loading the module.
The prior to the patch it logged:

[   92.041222] dvb-usb: found a 'Genpix SkyWalker-2 DVB-S receiver' in
warm state.
[   93.104244] gp8psk: FW Version = 2.14.6 (0x20e06)  Build 2010/10/10
[   93.104991] gp8psk: FPGA Version = 1
[   93.105367] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   93.105549] DVB: registering new adapter (Genpix SkyWalker-2 DVB-S receiver)
[   93.106614] usb 1-2: DVB: registering adapter 0 frontend 0 (Genpix DVB-S)...
[   93.107620] dvb-usb: Genpix SkyWalker-2 DVB-S receiver successfully
initialized and connected.
[   93.107627] gp8psk: found Genpix USB device pID = 206 (hex)
[   93.107674] usbcore: registered new interface driver dvb_usb_gp8psk

After the patch:

[  542.926237] dvb-usb: found a 'Genpix SkyWalker-2 DVB-S receiver' in
warm state.
[  543.989074] gp8psk: FW Version = 208.00.0 (0xd00000)  Build 2193/15/159
[  543.989945] gp8psk: FPGA Version = 2
[  543.990071] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  543.990257] dvbdev: DVB: registering new adapter (Genpix
SkyWalker-2 DVB-S receiver)
[  543.994589] usb 1-2: DVB: registering adapter 0 frontend 0 (Genpix DVB-S)...
[  543.995575] dvb-usb: Genpix SkyWalker-2 DVB-S receiver successfully
initialized and connected.
[  543.995581] gp8psk: found Genpix USB device pID = 206 (hex)
[  543.995628] usbcore: registered new interface driver dvb_usb_gp8psk

The FW Version and FPGA Version is messed up. Is it possible that
could cause the tuner timeout?
