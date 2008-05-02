Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <legrandluc@gmail.com>) id 1Js0Lq-0002uG-Ru
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 20:51:24 +0200
Received: by fg-out-1718.google.com with SMTP id 13so1000280fge.25
	for <linux-dvb@linuxtv.org>; Fri, 02 May 2008 11:51:19 -0700 (PDT)
Message-ID: <9f2475180805021151r5ae14022w90603f5c3c66c8d9@mail.gmail.com>
Date: Fri, 2 May 2008 20:51:19 +0200
From: "luc legrand" <legrandluc@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <d9def9db0805021124sf25e63fme8e4319169bc83de@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <9f2475180805020625nd6ff2a9ked408aa61ba3553@mail.gmail.com>
	<d9def9db0805020754tbe8fcd1k1c2bbe2024c17d9a@mail.gmail.com>
	<9f2475180805021058s2292cfe8pac958286b7cfb36a@mail.gmail.com>
	<d9def9db0805021124sf25e63fme8e4319169bc83de@mail.gmail.com>
Subject: Re: [linux-dvb] Avermedia M115 MiniPCI hybrid
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

last time I tried with v4l-dvb-experimental from mcentral.de in order
to compile I did :
make LINUXINCLUDE="-I`pwd`/linux/include -I`pwd`/v4l -Iinclude
-include include/linux/autoconf.h"

and here is what dmesg tells me :

# dmesg | grep saa
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:09:04.0, rev: 209, irq: 16, latency: 0,
mmio: 0xd2005000
saa7133[0]: subsystem: 1461:a836, board: Avermedia M115 [card=119,autodetected]
saa7133[0]: board init: gpio is a400000
saa7133[0]: i2c eeprom 00: 61 14 36 a8 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 c0 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-0061: chip found @ 0xc2 (saa7133[0])
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7134_dvb: Unknown symbol videobuf_dvb_unregister
saa7134_dvb: Unknown symbol videobuf_dvb_register

# dmesg | grep dvb
/home/ouam/.TunerTV/v4l-dvb-experimental/v4l/tuner-core.c: setting
tuner callback
/home/ouam/.TunerTV/v4l-dvb-experimental/v4l/tuner-core.c: setting
tuner callback
/home/ouam/.TunerTV/v4l-dvb-experimental/v4l/xc3028-tuner.c: attach request!
/home/ouam/.TunerTV/v4l-dvb-experimental/v4l/tuner-core.c: xc3028
tuner successfully loaded
videobuf_dvb: disagrees about version of symbol dvb_dmxdev_init
videobuf_dvb: Unknown symbol dvb_dmxdev_init
videobuf_dvb: disagrees about version of symbol videobuf_read_stop
videobuf_dvb: Unknown symbol videobuf_read_stop
videobuf_dvb: disagrees about version of symbol videobuf_waiton
videobuf_dvb: Unknown symbol videobuf_waiton
videobuf_dvb: disagrees about version of symbol dvb_dmx_release
videobuf_dvb: Unknown symbol dvb_dmx_release
videobuf_dvb: disagrees about version of symbol videobuf_read_start
videobuf_dvb: Unknown symbol videobuf_read_start
videobuf_dvb: disagrees about version of symbol dvb_net_init
videobuf_dvb: Unknown symbol dvb_net_init
videobuf_dvb: disagrees about version of symbol dvb_dmx_swfilter
videobuf_dvb: Unknown symbol dvb_dmx_swfilter
videobuf_dvb: disagrees about version of symbol dvb_dmxdev_release
videobuf_dvb: Unknown symbol dvb_dmxdev_release
videobuf_dvb: disagrees about version of symbol dvb_frontend_detach
videobuf_dvb: Unknown symbol dvb_frontend_detach
videobuf_dvb: disagrees about version of symbol dvb_net_release
videobuf_dvb: Unknown symbol dvb_net_release
videobuf_dvb: disagrees about version of symbol dvb_unregister_frontend
videobuf_dvb: Unknown symbol dvb_unregister_frontend
videobuf_dvb: disagrees about version of symbol dvb_register_frontend
videobuf_dvb: Unknown symbol dvb_register_frontend
videobuf_dvb: disagrees about version of symbol dvb_dmx_init
videobuf_dvb: Unknown symbol dvb_dmx_init
videobuf_dvb: Unknown symbol videobuf_to_dma
saa7134_dvb: Unknown symbol videobuf_dvb_unregister
saa7134_dvb: Unknown symbol videobuf_dvb_register

Luc

2008/5/2 Markus Rechberger <mrechberger@gmail.com>:
> Hi,
>
>
>  On 5/2/08, luc legrand <legrandluc@gmail.com> wrote:
>
> > Thank you Markus for your answer.
>  > I have seen that patch but it seems that there is still a problem with
>  > this card.
>  > As you can see here I'm not the onlyone who encounter this problem
>  > with this card (second post from luca porcu) :
>  > http://fcp.surfsite.org/modules/newbb/viewtopic.php?viewmode=flat&order=ASC&topic_id=55288&forum=10&move=prev&topic_time=1208143235
>  >
>
>  what error do you actually get there?
>
>  -Markus
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
