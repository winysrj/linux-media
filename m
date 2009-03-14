Return-path: <linux-media-owner@vger.kernel.org>
Received: from powered.by.root24.eu ([91.121.20.142]:50240 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbZCNXgX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 19:36:23 -0400
Message-ID: <49BC3DEE.9050307@ionic.de>
Date: Sun, 15 Mar 2009 00:29:50 +0100
From: Mihai Moldovan <ionic@ionic.de>
MIME-Version: 1.0
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
CC: "Mateusz" <m.jedrasik@gmail.com>, "Jacek" <wafelj@epf.pl>,
	"Kurt" <kurtandre@gmail.com>, "Juergen" <juergenhaas@gmx.net>,
	"Obri" <obri@chaostreff.ch>, "Kamre" <kamre@student.agh.edu.pl>,
	=?UTF-8?B?IsOBbHZhcm8i?= <aarranz@pegaso.ls.fi.upm.es>,
	"Alfred" <garbagemail@web.de>, "Andy" <andaug@mailbolt.com>
Subject: Pinnacle PCTV Hybrid Pro Card (310c)... once again...
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig2EC65DC9757B40C0B17A5730"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2EC65DC9757B40C0B17A5730
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello readers,

Amazon just had this card transported to me today... and of course I
gave the in-kernel 2.6.28.7 drivers a shot, but it didn't work out at
all, so I thought giving the repo provided in the wiki article (for
reference:
http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_Hybrid_Pro_Card_%2831=
0c%29)
would be a good idea.

Thus, I removed every in-kernel tuner and DVB module, checked the repo
out, build the new modules and had them installed. This, however,
yielded following results (dmesg extract):

[ 1988.812035] pcmcia_socket pcmcia_socket0: pccard: CardBus card
inserted into slot 0
[ 1988.812102] pci 0000:07:00.0: reg 10 32bit mmio: [0x000000-0xffffff]
[ 1988.812225] pci 0000:07:00.1: reg 10 32bit mmio: [0x000000-0xffffff]
[ 1988.812341] pci 0000:07:00.2: reg 10 32bit mmio: [0x000000-0xffffff]
[ 2003.326837] cx25843.c: starting probe for adapter SMBus I801 adapter
at 18e0 (0x40004)
[ 2003.328060] cx25843.c: detecting cx25843 client on address 0x88
[ 2003.328090] cx25843.c: starting probe for adapter NVIDIA i2c adapter=20
(0x0)
[ 2003.328511] cx25843.c: starting probe for adapter NVIDIA i2c adapter=20
(0x0)
[ 2003.328961] cx25843.c: starting probe for adapter NVIDIA i2c adapter=20
(0x0)
[ 2003.335211] em28xx: Unknown symbol v4l_compat_translate_ioctl
[ 2003.335404] em28xx: Unknown symbol v4l2_video_std_construct
[ 2003.335850] em28xx: Unknown symbol v4l2_type_names
[ 2003.339965] em28xx: Unknown symbol v4l_printk_ioctl
[ 2003.340663] em28xx: Unknown symbol video_unregister_device
[ 2003.340851] em28xx: Unknown symbol video_device_alloc
[ 2003.340948] em28xx: Unknown symbol video_register_device
[ 2003.342372] em28xx: Unknown symbol video_usercopy
[ 2003.342470] em28xx: Unknown symbol video_device_release
[ 2003.352874] em28xx_audio: Unknown symbol em28xx_i2c_call_clients
[ 2003.353305] em28xx_audio: Unknown symbol snd_pcm_new
[ 2003.353407] em28xx_audio: Unknown symbol snd_card_register
[ 2003.353508] em28xx_audio: Unknown symbol snd_card_free
[ 2003.353683] em28xx_audio: Unknown symbol snd_component_add
[ 2003.353873] em28xx_audio: Unknown symbol snd_card_new
[ 2003.353977] em28xx_audio: Unknown symbol snd_pcm_lib_ioctl
[ 2003.354280] em28xx_audio: Unknown symbol em28xx_unregister_extension
[ 2003.354465] em28xx_audio: Unknown symbol snd_pcm_set_ops
[ 2003.354570] em28xx_audio: Unknown symbol snd_pcm_hw_constraint_integer=

[ 2003.354691] em28xx_audio: Unknown symbol em28xx_register_extension
[ 2003.354910] em28xx_audio: Unknown symbol snd_pcm_period_elapsed
[ 2003.357625] em28xx_aad: Unknown symbol em28xx_unregister_extension
[ 2003.357753] em28xx_aad: Unknown symbol em28xx_register_extension
[ 2003.358895] em28xx_dvb: Unknown symbol dvb_dmxdev_init
[ 2003.359262] em28xx_dvb: Unknown symbol dvb_register_adapter
[ 2003.359506] em28xx_dvb: Unknown symbol dvb_dmx_release
[ 2003.359602] em28xx_dvb: Unknown symbol em28xx_unregister_extension
[ 2003.359787] em28xx_dvb: Unknown symbol dvb_net_init
[ 2003.359886] em28xx_dvb: Unknown symbol dvb_dmx_swfilter
[ 2003.360514] em28xx_dvb: Unknown symbol dvb_dmxdev_release
[ 2003.360638] em28xx_dvb: Unknown symbol dvb_frontend_detach
[ 2003.360737] em28xx_dvb: Unknown symbol dvb_net_release
[ 2003.360898] em28xx_dvb: Unknown symbol em28xx_register_extension
[ 2003.361189] em28xx_dvb: Unknown symbol dvb_unregister_frontend
[ 2003.361455] em28xx_dvb: Unknown symbol dvb_register_frontend
[ 2003.361554] em28xx_dvb: Unknown symbol dvb_unregister_adapter
[ 2003.361653] em28xx_dvb: Unknown symbol dvb_dmx_init
[ 2003.362770] em28xx_audioep: Unknown symbol snd_pcm_new
[ 2003.362872] em28xx_audioep: Unknown symbol snd_card_register
[ 2003.362973] em28xx_audioep: Unknown symbol snd_card_free
[ 2003.363375] em28xx_audioep: Unknown symbol snd_card_new
[ 2003.363479] em28xx_audioep: Unknown symbol snd_pcm_lib_ioctl
[ 2003.363659] em28xx_audioep: Unknown symbol snd_pcm_set_ops
[ 2003.363843] em28xx_audioep: Unknown symbol snd_pcm_hw_constraint_integ=
er
[ 2003.364044] em28xx_audioep: Unknown symbol snd_pcm_period_elapsed
[ 2038.162200] pcmcia_socket pcmcia_socket0: pccard: card ejected from
slot 0

As you can see, there were several problems, I'll explain them a little
bit further: first of all a lot of unresolved symbols which are part of
ALSA itself (snd_* ones.) This is perfectly valid and true since I don't
use ALSA but OSS, however, using the provided modules seems not to be
working without ALSA - bummer deal... I'd appreciate any help here
(other than "switch to ALSA" rants, of course, which are not very
productive!)

Secondly, there are a lot of unresolved dvb* symbol errors personally I
can not explain.

After this episode of failing I wanted to give LinuxTV.org's v4l-dvb
tree a shot... once again had all installed v4l and dvb modules removed
(module-wise out of the Kernel as well as file-wise on the harddisk of
course), checked out the other repo, built the modules, installed them,
re-inserted the card.

This time I got the following new errors, but at least not the old ones:

[ 2197.245488] cx88xx: Unknown symbol i2c_bit_add_bus
[ 2197.251385] cx8800: Unknown symbol cx88_reset
[ 2197.251672] cx8800: Unknown symbol cx88_call_i2c_clients
[ 2197.251774] cx8800: Unknown symbol cx88_wakeup
[ 2197.251904] cx8800: Unknown symbol cx88_risc_stopper
[ 2197.260330] cx8800: Unknown symbol cx88_print_irqbits
[ 2197.260435] cx8800: Unknown symbol cx88_set_scale
[ 2197.260567] cx8800: Unknown symbol cx88_shutdown
[ 2197.260763] cx8800: Unknown symbol cx88_vdev_init
[ 2197.260913] cx8800: Unknown symbol cx88_core_put
[ 2197.261231] cx8800: Unknown symbol cx88_audio_thread
[ 2197.261479] cx8800: Unknown symbol cx88_core_irq
[ 2197.261614] cx8800: Unknown symbol cx88_core_get
[ 2197.261715] cx8800: Unknown symbol cx88_get_stereo
[ 2197.261816] cx8800: Unknown symbol cx88_ir_stop
[ 2197.262195] cx8800: Unknown symbol cx88_set_tvnorm
[ 2197.262297] cx8800: Unknown symbol cx88_ir_start
[ 2197.262705] cx8800: Unknown symbol cx88_risc_buffer
[ 2197.263412] cx8800: Unknown symbol cx88_set_stereo
[ 2197.263882] cx8800: Unknown symbol cx88_sram_channels
[ 2197.264169] cx8800: Unknown symbol cx88_set_tvaudio
[ 2197.264271] cx8800: Unknown symbol cx88_sram_channel_dump
[ 2197.264406] cx8800: Unknown symbol cx88_sram_channel_setup
[ 2197.264612] cx8800: Unknown symbol cx88_free_buffer
[ 2197.265458] cx8800: Unknown symbol cx88_newstation
[ 2197.276698] cx88xx: Unknown symbol i2c_bit_add_bus
[ 2197.289372] cx8802: Unknown symbol cx88_reset
[ 2197.289474] cx8802: Unknown symbol cx88_wakeup
[ 2197.289605] cx8802: Unknown symbol cx88_risc_stopper
[ 2197.289736] cx8802: Unknown symbol cx88_print_irqbits
[ 2197.289866] cx8802: Unknown symbol cx88_shutdown
[ 2197.289984] cx8802: Unknown symbol cx88_core_put
[ 2197.290382] cx8802: Unknown symbol cx88_core_irq
[ 2197.290513] cx8802: Unknown symbol cx88_core_get
[ 2197.290792] cx8802: Unknown symbol cx88_sram_channels
[ 2197.290893] cx8802: Unknown symbol cx88_sram_channel_dump
[ 2197.290997] cx8802: Unknown symbol cx88_sram_channel_setup
[ 2197.291381] cx8802: Unknown symbol cx88_free_buffer
[ 2197.291589] cx8802: Unknown symbol cx88_risc_databuffer

I thought I had to remove any in-kernel driver before using the v4l-dvb
tree, but obviously this was wrong... however, after installing the
in-kernel cx88 module as well, I got the following result:

[ 4734.289076] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[ 4734.289113] cx8800 0000:07:00.0: enabling device (0000 -> 0002)
[ 4734.289123] cx8800 0000:07:00.0: PCI INT A -> GSI 22 (level, low) ->
IRQ 22
[ 4734.306537] cx88[0]: subsystem: 12ab:1788, board: Pinnacle Hybrid
PCTV [card=3D60,autodetected], frontend(s): 1
[ 4734.306541] cx88[0]: TV tuner type 71, Radio tuner type 71
[ 4734.317119] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loade=
d
[ 4734.428129] tuner' 4-0061: chip found @ 0xc2 (cx88[0])
[ 4734.525243] xc2028 4-0061: creating new instance
[ 4734.525247] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[ 4734.525254] xc2028 4-0061: destroying instance
[ 4734.525345] xc2028 4-0061: creating new instance
[ 4734.525347] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[ 4734.525350] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw=

[ 4734.525365] cx88[0]/0: found at 0000:07:00.0, rev: 5, irq: 22,
latency: 0, mmio: 0x8c000000
[ 4734.525375] cx8800 0000:07:00.0: setting latency timer to 64
[ 4734.525530] cx88[0]/0: registered device video0 [v4l2]
[ 4734.525564] cx88[0]/0: registered device vbi0
[ 4734.525596] cx88[0]/0: registered device radio0
[ 4734.525685] i2c-adapter i2c-4: firmware: requesting xc3028-v27.fw
[ 4734.529919] xc2028 4-0061: Error: firmware xc3028-v27.fw not found.
[ 4734.530152] cx88[0]/2: cx2388x 8802 Driver Manager
[ 4734.530165] cx88-mpeg driver manager 0000:07:00.2: enabling device
(0000 -> 0002)
[ 4734.530175] cx88-mpeg driver manager 0000:07:00.2: PCI INT A -> GSI
22 (level, low) -> IRQ 22
[ 4734.530184] cx88-mpeg driver manager 0000:07:00.2: setting latency
timer to 64
[ 4734.530193] cx88[0]/2: found at 0000:07:00.2, rev: 5, irq: 22,
latency: 64, mmio: 0x8e000000
[ 4734.594309] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[ 4734.594313] cx88/2: registering cx8802 driver, type: dvb access: share=
d
[ 4734.594316] cx88[0]/2: subsystem: 12ab:1788, board: Pinnacle Hybrid
PCTV [card=3D60]
[ 4734.594319] cx88[0]/2: cx2388x based DVB/ATSC card
[ 4734.594321] cx8802_alloc_frontends() allocating 1 frontend(s)
[ 4734.598305] xc2028 4-0061: attaching existing instance
[ 4734.598308] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[ 4734.598310] cx88[0]/2: xc3028 attached
[ 4734.598317] DVB: registering new adapter (cx88[0])
[ 4734.598320] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
DVB-T)...
[ 4734.608466] i2c-adapter i2c-4: firmware: requesting xc3028-v27.fw
[ 4734.626640] xc2028 4-0061: Error: firmware xc3028-v27.fw not found.

Lazy people just scrolling by, reading the beginning and the end of
those dmesg messages might have spotted the problem already, which
particularly is:

[ 4734.608466] i2c-adapter i2c-4: firmware: requesting xc3028-v27.fw
[ 4734.626640] xc2028 4-0061: Error: firmware xc3028-v27.fw not found.

This indicates that I seem to miss this firmware file. However, once
again the Wiki article suggests using the firmware driver package for
Pinnacle from this site: http://mcentral.de/firmware/

This package does not include the requested file and I haven't seen it
around doing a Google recherche either... but I found some web pages
with other dmesg output revealing that actually the requested file is
not the file to be used with my card but instead the xc3028_init0.i2c.fw
file...

Am I using the wrong drivers? What's happening? I'm quite a bit sad and
depressed despite Marvin not being my name... err, actually I have no
idea how I can get this card working...

Anybody around here knowing any helpful hints?

I hope I didn't forgot any information.

Best regards,


Mihai



P.S.: I have added the people mentioned on the wiki page as CC's, I hope
this is OK for you guys and the email addresses are still valid...
well... one never knows.


--------------enig2EC65DC9757B40C0B17A5730
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBCgAGBQJJvD34AAoJEB/WLtluJTqHd/YQAInGEGWKUUXN0hiCj29pwIGC
Y45/fXueD6jVWKYqy7CwabtJ8DDxu11Kjk4d83DN0HMnd1FCPUEQJRF6sGSkFN0q
7ML61Bu4J0HIVrzF76sXDu9x/dbfmDc9wi0qRbuJ17R1BULROKiLSiO57DUFZv9Y
5EWQ3hGEvPuSGkUjkSbz9UOFkqP6bLvv0y4NY+jGDcMCOqtrDz65/TNy1EfoFOC/
X/EW55Nt+hYaLSAxUse1Gj8L2VOqs2PvOxsRV+dka3/DG1Pf8PoDPEd0RIZmgakb
mBlCeTrdmvEucTcTVOLrbJ0DDEt0WQVySy1n5nTYk9A/0JeXZcWEOiF4Co1dRS2W
9EZ/XLC+3UhXh/GzLKb+PWfcEOdbJOIEn7qmY6EfhpBvHGIUYtQku+Ib4elK+IJf
o3fpbq2okIZ46Y7uiJJnHxXlwU9s948wNikiNMh3MRiRRohF5JcQpVeS2DLrsU97
R2J2pmvMFZoyXy3R9X93U+FZHEhRWFdbXuMdjJA9Imw6Rf8IjPL51+2pzVQtzgRw
BiL9Blmq6x+5p+qHH+oz07S2K7ZyY6Tu+y0o/MMJDcM1Bhh8j3vE3RwufmMezOwx
ApqUz2Vzrun25ScAcM0QFsg2ZmrK9EuAvdr9Gwymr+khQghR4iZtVdWTL1Jp4xRg
YoyKg7MXoBW1dUe8sw+k
=ccsc
-----END PGP SIGNATURE-----

--------------enig2EC65DC9757B40C0B17A5730--
