Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <legrandluc@gmail.com>) id 1Jy3Tu-0004vk-Aa
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 13:24:45 +0200
Received: by py-out-1112.google.com with SMTP id p76so410436pyb.0
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 04:24:35 -0700 (PDT)
Message-ID: <9f2475180805190424s9cbf4abxbc7b644e3d617a4@mail.gmail.com>
Date: Mon, 19 May 2008 13:24:33 +0200
From: "luc legrand" <legrandluc@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <d9def9db0805021215n3f5cbc06r24340d7dd551a541@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <9f2475180805020625nd6ff2a9ked408aa61ba3553@mail.gmail.com>
	<d9def9db0805020754tbe8fcd1k1c2bbe2024c17d9a@mail.gmail.com>
	<9f2475180805021058s2292cfe8pac958286b7cfb36a@mail.gmail.com>
	<d9def9db0805021124sf25e63fme8e4319169bc83de@mail.gmail.com>
	<9f2475180805021151r5ae14022w90603f5c3c66c8d9@mail.gmail.com>
	<d9def9db0805021215n3f5cbc06r24340d7dd551a541@mail.gmail.com>
Subject: Re: [linux-dvb] Avermedia M115 MiniPCI hybrid
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/5/2 Markus Rechberger <mrechberger@gmail.com>:
> On Fri, May 2, 2008 at 2:51 PM, luc legrand <legrandluc@gmail.com> wrote:
>> last time I tried with v4l-dvb-experimental from mcentral.de in order
>>  to compile I did :
>>  make LINUXINCLUDE=3D"-I`pwd`/linux/include -I`pwd`/v4l -Iinclude
>>  -include include/linux/autoconf.h"
>>
>>
>>  and here is what dmesg tells me :
>>
>>
>> # dmesg | grep saa
>>  saa7130/34: v4l2 driver version 0.2.14 loaded
>>  saa7133[0]: found at 0000:09:04.0, rev: 209, irq: 16, latency: 0,
>>  mmio: 0xd2005000
>>  saa7133[0]: subsystem: 1461:a836, board: Avermedia M115 [card=3D119,aut=
odetected]
>>
>> saa7133[0]: board init: gpio is a400000
>>  saa7133[0]: i2c eeprom 00: 61 14 36 a8 00 00 00 00 00 00 00 00 00 00 00=
 00
>>  saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff=
 ff
>>  saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 c0 ff ff ff=
 ff
>>  saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=
 ff
>>  saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff=
 ff
>>  saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=
 ff
>>  saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=
 ff
>>  saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=
 ff
>>
>> tuner 1-0061: chip found @ 0xc2 (saa7133[0])
>>  saa7133[0]: registered device video0 [v4l2]
>>  saa7133[0]: registered device vbi0
>>  saa7134_dvb: Unknown symbol videobuf_dvb_unregister
>>  saa7134_dvb: Unknown symbol videobuf_dvb_register
>>
>>  # dmesg | grep dvb
>>  /home/ouam/.TunerTV/v4l-dvb-experimental/v4l/tuner-core.c: setting
>>  tuner callback
>>  /home/ouam/.TunerTV/v4l-dvb-experimental/v4l/tuner-core.c: setting
>>  tuner callback
>>  /home/ouam/.TunerTV/v4l-dvb-experimental/v4l/xc3028-tuner.c: attach req=
uest!
>>  /home/ouam/.TunerTV/v4l-dvb-experimental/v4l/tuner-core.c: xc3028
>>  tuner successfully loaded
>>  videobuf_dvb: disagrees about version of symbol dvb_dmxdev_init
>>  videobuf_dvb: Unknown symbol dvb_dmxdev_init
>>  videobuf_dvb: disagrees about version of symbol videobuf_read_stop
>>  videobuf_dvb: Unknown symbol videobuf_read_stop
>>  videobuf_dvb: disagrees about version of symbol videobuf_waiton
>>  videobuf_dvb: Unknown symbol videobuf_waiton
>>  videobuf_dvb: disagrees about version of symbol dvb_dmx_release
>>  videobuf_dvb: Unknown symbol dvb_dmx_release
>>  videobuf_dvb: disagrees about version of symbol videobuf_read_start
>>  videobuf_dvb: Unknown symbol videobuf_read_start
>>  videobuf_dvb: disagrees about version of symbol dvb_net_init
>>  videobuf_dvb: Unknown symbol dvb_net_init
>>  videobuf_dvb: disagrees about version of symbol dvb_dmx_swfilter
>>  videobuf_dvb: Unknown symbol dvb_dmx_swfilter
>>  videobuf_dvb: disagrees about version of symbol dvb_dmxdev_release
>>  videobuf_dvb: Unknown symbol dvb_dmxdev_release
>>  videobuf_dvb: disagrees about version of symbol dvb_frontend_detach
>>  videobuf_dvb: Unknown symbol dvb_frontend_detach
>>  videobuf_dvb: disagrees about version of symbol dvb_net_release
>>  videobuf_dvb: Unknown symbol dvb_net_release
>>  videobuf_dvb: disagrees about version of symbol dvb_unregister_frontend
>>  videobuf_dvb: Unknown symbol dvb_unregister_frontend
>>  videobuf_dvb: disagrees about version of symbol dvb_register_frontend
>>  videobuf_dvb: Unknown symbol dvb_register_frontend
>>  videobuf_dvb: disagrees about version of symbol dvb_dmx_init
>>  videobuf_dvb: Unknown symbol dvb_dmx_init
>>  videobuf_dvb: Unknown symbol videobuf_to_dma
>>  saa7134_dvb: Unknown symbol videobuf_dvb_unregister
>>  saa7134_dvb: Unknown symbol videobuf_dvb_register
>>
>
> try
>
> rm -rf /lib/modules/`uname -r`/kernel/drivers/media
>
> and reinstall that package.
>
> Markus
>
Sorry for not posting sooner. I had hardware problems with my computer.
I tried rm -rf /lib/modules/`uname -r`/kernel/drivers/media
It works under kernel 2.6.24 but not under 2.6.25 (I tested it under
fedora 9 and sidux).
Here is where compilation end with kernel 2.6.25 after make :

/home/blob/.tunerTV/v4l-dvb-experimental/v4l/bt866.c:304: error:
unknown field 'usage_count' specified in initializer
/home/blob/.tunerTV/v4l-dvb-experimental/v4l/bt866.c:305: warning:
missing braces around initializer
/home/blob/.tunerTV/v4l-dvb-experimental/v4l/bt866.c:305: warning:
(near initialization for 'bt866_client_tmpl.dev')
make[3]: *** [/home/blob/.tunerTV/v4l-dvb-experimental/v4l/bt866.o] Error 1
make[2]: *** [_module_/home/blob/.tunerTV/v4l-dvb-experimental/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.25.3-18.fc9.x86_64'
make[1]: *** [default] Erreur 2
make[1]: quittant le r=E9pertoire =AB /home/blob/.tunerTV/v4l-dvb-experimen=
tal/v4l =BB
make: *** [all] Erreur 2

Luc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
