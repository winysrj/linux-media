Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1K6Nmt-0006yp-5N
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 12:42:44 +0200
Received: by wa-out-1112.google.com with SMTP id n7so2268442wag.13
	for <linux-dvb@linuxtv.org>; Wed, 11 Jun 2008 03:42:38 -0700 (PDT)
Message-ID: <36e8a7020806110342n311a737flab37ddd5e8672c91@mail.gmail.com>
Date: Wed, 11 Jun 2008 13:42:37 +0300
From: bvidinli <bvidinli@gmail.com>
To: "Nicolas Will" <nico@youplala.net>, linux-dvb@linuxtv.org,
	martin.pitt@ubuntu.com
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Failure: Ubuntu users, rejoyce!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks Martin,
i tested it, partial success...
we would be happy if you fix that too.... or say us way to fix it..

below dmesg output:
[   46.895374] saa7133[0]: found at 0000:00:14.0, rev: 209, irq: 10,
latency: 32, mmio: 0xde003000
[   46.895392] saa7133[0]: subsystem: 1461:a7a2, board: Avermedia
DVB-S Hybrid+FM A700 [card=3D141,autodetected]
[   46.895465] saa7133[0]: board init: gpio is 2f600
[   46.895476] saa7133[0]: Avermedia DVB-S Hybrid+FM A700: hybrid
analog/dvb card
[   46.895482] saa7133[0]: Sorry, only the analog inputs are supported for =
now.
[   47.231035] irda_init()
[   47.231081] NET: Registered protocol family 23
[   47.530880] saa7133[0]: i2c eeprom 00: 61 14 a2 a7 ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.530910] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.530933] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.530956] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.530979] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531001] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531024] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531047] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531069] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531092] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531115] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531138] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531160] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531183] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.531206] saa7133[0]: i2c eeprom e0: 00 01 81 af fe f6 ff ff ff
ff ff ff ff ff ff ff
[   47.531229] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   47.647164] saa7133[0]: registered device video0 [v4l2]
[   47.647251] saa7133[0]: registered device vbi0
[   47.647491] via-ircc: dongle probing not supported, please specify
dongle_id module parameter.
[   47.648266] IrDA: Registered device irda0 (via-ircc)
[   48.655540] saa7134_alsa: disagrees about version of symbol
saa7134_tvaudio_setmute
[   48.655559] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
[   48.655959] saa7134_alsa: disagrees about version of symbol saa_dsp_writ=
el
[   48.655968] saa7134_alsa: Unknown symbol saa_dsp_writel
[   48.656474] saa7134_alsa: disagrees about version of symbol videobuf_dma=
_free
[   48.656483] saa7134_alsa: Unknown symbol videobuf_dma_free
[   48.656991] saa7134_alsa: disagrees about version of symbol
saa7134_pgtable_alloc
[   48.657000] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
[   48.657148] saa7134_alsa: disagrees about version of symbol
saa7134_pgtable_build
[   48.657156] saa7134_alsa: Unknown symbol saa7134_pgtable_build
[   48.657284] saa7134_alsa: disagrees about version of symbol
saa7134_pgtable_free
[   48.657293] saa7134_alsa: Unknown symbol saa7134_pgtable_free
[   48.657421] saa7134_alsa: disagrees about version of symbol
saa7134_dmasound_init
[   48.657430] saa7134_alsa: Unknown symbol saa7134_dmasound_init
[   48.657810] saa7134_alsa: disagrees about version of symbol
saa7134_dmasound_exit
[   48.657819] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
[   48.658101] saa7134_alsa: disagrees about version of symbol videobuf_dma=
_init
[   48.658110] saa7134_alsa: Unknown symbol videobuf_dma_init
[   48.658519] saa7134_alsa: disagrees about version of symbol
videobuf_dma_init_kernel
[   48.658528] saa7134_alsa: Unknown symbol videobuf_dma_init_kernel
[   48.658974] saa7134_alsa: Unknown symbol videobuf_pci_dma_unmap
[   48.659410] saa7134_alsa: Unknown symbol videobuf_pci_dma_map
[   48.659574] saa7134_alsa: disagrees about version of symbol
saa7134_set_dmabits
[   48.659583] saa7134_alsa: Unknown symbol saa7134_set_dmabits



2008/6/10 Nicolas Will <nico@youplala.net>:
> http://martinpitt.wordpress.com/2008/06/10/packaged-dvb-t-drivers-for-ubu=
ntu-804/
>
> automatic build of a recent v4l-dvb tree, automatically rebuilt upon
> kernel upgrades.
>
> That's the last manual step going away on my MythTV system.
>
> Thanks Martin, Matt and Mario, from me too.
>
> Nico
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- =

=DD.Bahattin Vidinli
Elk-Elektronik M=FCh.
-------------------
iletisim bilgileri (Tercih sirasina gore):
skype: bvidinli (sesli gorusme icin, www.skype.com)
msn: bvidinli@iyibirisi.com
yahoo: bvidinli

+90.532.7990607
+90.505.5667711
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
