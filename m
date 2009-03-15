Return-path: <linux-media-owner@vger.kernel.org>
Received: from powered.by.root24.eu ([91.121.20.142]:33778 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZCOABE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 20:01:04 -0400
Message-ID: <49BC4535.6090700@ionic.de>
Date: Sun, 15 Mar 2009 01:00:53 +0100
From: Mihai Moldovan <ionic@ionic.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Markus Rechberger <mrechberger@gmail.com>,
	Mateusz <m.jedrasik@gmail.com>, Jacek <wafelj@epf.pl>,
	Kurt <kurtandre@gmail.com>, Juergen <juergenhaas@gmx.net>,
	Obri <obri@chaostreff.ch>, Kamre <kamre@student.agh.edu.pl>,
	=?ISO-8859-1?Q?=C1lvaro?= <aarranz@pegaso.ls.fi.upm.es>,
	Alfred <garbagemail@web.de>, Andy <andaug@mailbolt.com>
Subject: Re: Pinnacle PCTV Hybrid Pro Card (310c)... once again...
References: <49BC3DEE.9050307@ionic.de> <d9def9db0903141641g457b9cdar317b0d8e5f132150@mail.gmail.com>
In-Reply-To: <d9def9db0903141641g457b9cdar317b0d8e5f132150@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigBB3E03C6CD3E47A3298476E9"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBB3E03C6CD3E47A3298476E9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

* On 15.03.2009 00:41, Markus Rechberger wrote:
> On Sun, Mar 15, 2009 at 12:29 AM, Mihai Moldovan <ionic@ionic.de> wrote=
:
>  =20
>> Hello readers,
>>
>> Amazon just had this card transported to me today... and of course I
>> gave the in-kernel 2.6.28.7 drivers a shot, but it didn't work out at
>> all, so I thought giving the repo provided in the wiki article (for
>> reference:
>> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_Hybrid_Pro_Card_%2=
8310c%29)
>> would be a good idea.
>>
>> Thus, I removed every in-kernel tuner and DVB module, checked the repo=

>> out, build the new modules and had them installed. This, however,
>> yielded following results (dmesg extract):
>>
>> [ 1988.812035] pcmcia_socket pcmcia_socket0: pccard: CardBus card
>> inserted into slot 0
>> [ 1988.812102] pci 0000:07:00.0: reg 10 32bit mmio: [0x000000-0xffffff=
]
>> [ 1988.812225] pci 0000:07:00.1: reg 10 32bit mmio: [0x000000-0xffffff=
]
>> [ 1988.812341] pci 0000:07:00.2: reg 10 32bit mmio: [0x000000-0xffffff=
]
>> [ 2003.326837] cx25843.c: starting probe for adapter SMBus I801 adapte=
r
>> at 18e0 (0x40004)
>> [ 2003.328060] cx25843.c: detecting cx25843 client on address 0x88
>> [ 2003.328090] cx25843.c: starting probe for adapter NVIDIA i2c adapte=
r
>> (0x0)
>> [ 2003.328511] cx25843.c: starting probe for adapter NVIDIA i2c adapte=
r
>> (0x0)
>> [ 2003.328961] cx25843.c: starting probe for adapter NVIDIA i2c adapte=
r
>> (0x0)
>> [ 2003.335211] em28xx: Unknown symbol v4l_compat_translate_ioctl
>> [ 2003.335404] em28xx: Unknown symbol v4l2_video_std_construct
>> [ 2003.335850] em28xx: Unknown symbol v4l2_type_names
>> [ 2003.339965] em28xx: Unknown symbol v4l_printk_ioctl
>> [ 2003.340663] em28xx: Unknown symbol video_unregister_device
>> [ 2003.340851] em28xx: Unknown symbol video_device_alloc
>> [ 2003.340948] em28xx: Unknown symbol video_register_device
>> [ 2003.342372] em28xx: Unknown symbol video_usercopy
>> [ 2003.342470] em28xx: Unknown symbol video_device_release
>> [ 2003.352874] em28xx_audio: Unknown symbol em28xx_i2c_call_clients
>> [ 2003.353305] em28xx_audio: Unknown symbol snd_pcm_new
>> [ 2003.353407] em28xx_audio: Unknown symbol snd_card_register
>> [ 2003.353508] em28xx_audio: Unknown symbol snd_card_free
>> [ 2003.353683] em28xx_audio: Unknown symbol snd_component_add
>> [ 2003.353873] em28xx_audio: Unknown symbol snd_card_new
>> [ 2003.353977] em28xx_audio: Unknown symbol snd_pcm_lib_ioctl
>> [ 2003.354280] em28xx_audio: Unknown symbol em28xx_unregister_extensio=
n
>> [ 2003.354465] em28xx_audio: Unknown symbol snd_pcm_set_ops
>> [ 2003.354570] em28xx_audio: Unknown symbol snd_pcm_hw_constraint_inte=
ger
>> [ 2003.354691] em28xx_audio: Unknown symbol em28xx_register_extension
>> [ 2003.354910] em28xx_audio: Unknown symbol snd_pcm_period_elapsed
>> [ 2003.357625] em28xx_aad: Unknown symbol em28xx_unregister_extension
>> [ 2003.357753] em28xx_aad: Unknown symbol em28xx_register_extension
>> [ 2003.358895] em28xx_dvb: Unknown symbol dvb_dmxdev_init
>> [ 2003.359262] em28xx_dvb: Unknown symbol dvb_register_adapter
>> [ 2003.359506] em28xx_dvb: Unknown symbol dvb_dmx_release
>> [ 2003.359602] em28xx_dvb: Unknown symbol em28xx_unregister_extension
>> [ 2003.359787] em28xx_dvb: Unknown symbol dvb_net_init
>> [ 2003.359886] em28xx_dvb: Unknown symbol dvb_dmx_swfilter
>> [ 2003.360514] em28xx_dvb: Unknown symbol dvb_dmxdev_release
>> [ 2003.360638] em28xx_dvb: Unknown symbol dvb_frontend_detach
>> [ 2003.360737] em28xx_dvb: Unknown symbol dvb_net_release
>> [ 2003.360898] em28xx_dvb: Unknown symbol em28xx_register_extension
>> [ 2003.361189] em28xx_dvb: Unknown symbol dvb_unregister_frontend
>> [ 2003.361455] em28xx_dvb: Unknown symbol dvb_register_frontend
>> [ 2003.361554] em28xx_dvb: Unknown symbol dvb_unregister_adapter
>> [ 2003.361653] em28xx_dvb: Unknown symbol dvb_dmx_init
>> [ 2003.362770] em28xx_audioep: Unknown symbol snd_pcm_new
>> [ 2003.362872] em28xx_audioep: Unknown symbol snd_card_register
>> [ 2003.362973] em28xx_audioep: Unknown symbol snd_card_free
>> [ 2003.363375] em28xx_audioep: Unknown symbol snd_card_new
>> [ 2003.363479] em28xx_audioep: Unknown symbol snd_pcm_lib_ioctl
>> [ 2003.363659] em28xx_audioep: Unknown symbol snd_pcm_set_ops
>> [ 2003.363843] em28xx_audioep: Unknown symbol snd_pcm_hw_constraint_in=
teger
>> [ 2003.364044] em28xx_audioep: Unknown symbol snd_pcm_period_elapsed
>> [ 2038.162200] pcmcia_socket pcmcia_socket0: pccard: card ejected from=

>> slot 0
>>
>> As you can see, there were several problems, I'll explain them a littl=
e
>> bit further: first of all a lot of unresolved symbols which are part o=
f
>> ALSA itself (snd_* ones.) This is perfectly valid and true since I don=
't
>> use ALSA but OSS, however, using the provided modules seems not to be
>> working without ALSA - bummer deal... I'd appreciate any help here
>> (other than "switch to ALSA" rants, of course, which are not very
>> productive!)
>>
>> Secondly, there are a lot of unresolved dvb* symbol errors personally =
I
>> can not explain.
>>
>> After this episode of failing I wanted to give LinuxTV.org's v4l-dvb
>> tree a shot... once again had all installed v4l and dvb modules remove=
d
>> (module-wise out of the Kernel as well as file-wise on the harddisk of=

>> course), checked out the other repo, built the modules, installed them=
,
>> re-inserted the card.
>>
>> This time I got the following new errors, but at least not the old one=
s:
>>
>> [ 2197.245488] cx88xx: Unknown symbol i2c_bit_add_bus
>> [ 2197.251385] cx8800: Unknown symbol cx88_reset
>> [ 2197.251672] cx8800: Unknown symbol cx88_call_i2c_clients
>> [ 2197.251774] cx8800: Unknown symbol cx88_wakeup
>> [ 2197.251904] cx8800: Unknown symbol cx88_risc_stopper
>> [ 2197.260330] cx8800: Unknown symbol cx88_print_irqbits
>> [ 2197.260435] cx8800: Unknown symbol cx88_set_scale
>> [ 2197.260567] cx8800: Unknown symbol cx88_shutdown
>> [ 2197.260763] cx8800: Unknown symbol cx88_vdev_init
>> [ 2197.260913] cx8800: Unknown symbol cx88_core_put
>> [ 2197.261231] cx8800: Unknown symbol cx88_audio_thread
>> [ 2197.261479] cx8800: Unknown symbol cx88_core_irq
>> [ 2197.261614] cx8800: Unknown symbol cx88_core_get
>> [ 2197.261715] cx8800: Unknown symbol cx88_get_stereo
>> [ 2197.261816] cx8800: Unknown symbol cx88_ir_stop
>> [ 2197.262195] cx8800: Unknown symbol cx88_set_tvnorm
>> [ 2197.262297] cx8800: Unknown symbol cx88_ir_start
>> [ 2197.262705] cx8800: Unknown symbol cx88_risc_buffer
>> [ 2197.263412] cx8800: Unknown symbol cx88_set_stereo
>> [ 2197.263882] cx8800: Unknown symbol cx88_sram_channels
>> [ 2197.264169] cx8800: Unknown symbol cx88_set_tvaudio
>> [ 2197.264271] cx8800: Unknown symbol cx88_sram_channel_dump
>> [ 2197.264406] cx8800: Unknown symbol cx88_sram_channel_setup
>> [ 2197.264612] cx8800: Unknown symbol cx88_free_buffer
>> [ 2197.265458] cx8800: Unknown symbol cx88_newstation
>> [ 2197.276698] cx88xx: Unknown symbol i2c_bit_add_bus
>> [ 2197.289372] cx8802: Unknown symbol cx88_reset
>> [ 2197.289474] cx8802: Unknown symbol cx88_wakeup
>> [ 2197.289605] cx8802: Unknown symbol cx88_risc_stopper
>> [ 2197.289736] cx8802: Unknown symbol cx88_print_irqbits
>> [ 2197.289866] cx8802: Unknown symbol cx88_shutdown
>> [ 2197.289984] cx8802: Unknown symbol cx88_core_put
>> [ 2197.290382] cx8802: Unknown symbol cx88_core_irq
>> [ 2197.290513] cx8802: Unknown symbol cx88_core_get
>> [ 2197.290792] cx8802: Unknown symbol cx88_sram_channels
>> [ 2197.290893] cx8802: Unknown symbol cx88_sram_channel_dump
>> [ 2197.290997] cx8802: Unknown symbol cx88_sram_channel_setup
>> [ 2197.291381] cx8802: Unknown symbol cx88_free_buffer
>> [ 2197.291589] cx8802: Unknown symbol cx88_risc_databuffer
>>
>> I thought I had to remove any in-kernel driver before using the v4l-dv=
b
>> tree, but obviously this was wrong... however, after installing the
>> in-kernel cx88 module as well, I got the following result:
>>
>> [ 4734.289076] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
>> [ 4734.289113] cx8800 0000:07:00.0: enabling device (0000 -> 0002)
>> [ 4734.289123] cx8800 0000:07:00.0: PCI INT A -> GSI 22 (level, low) -=
>
>> IRQ 22
>> [ 4734.306537] cx88[0]: subsystem: 12ab:1788, board: Pinnacle Hybrid
>> PCTV [card=3D60,autodetected], frontend(s): 1
>> [ 4734.306541] cx88[0]: TV tuner type 71, Radio tuner type 71
>> [ 4734.317119] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 lo=
aded
>> [ 4734.428129] tuner' 4-0061: chip found @ 0xc2 (cx88[0])
>> [ 4734.525243] xc2028 4-0061: creating new instance
>> [ 4734.525247] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
>> [ 4734.525254] xc2028 4-0061: destroying instance
>> [ 4734.525345] xc2028 4-0061: creating new instance
>> [ 4734.525347] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
>> [ 4734.525350] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27=
=2Efw
>> [ 4734.525365] cx88[0]/0: found at 0000:07:00.0, rev: 5, irq: 22,
>> latency: 0, mmio: 0x8c000000
>> [ 4734.525375] cx8800 0000:07:00.0: setting latency timer to 64
>> [ 4734.525530] cx88[0]/0: registered device video0 [v4l2]
>> [ 4734.525564] cx88[0]/0: registered device vbi0
>> [ 4734.525596] cx88[0]/0: registered device radio0
>> [ 4734.525685] i2c-adapter i2c-4: firmware: requesting xc3028-v27.fw
>> [ 4734.529919] xc2028 4-0061: Error: firmware xc3028-v27.fw not found.=

>> [ 4734.530152] cx88[0]/2: cx2388x 8802 Driver Manager
>> [ 4734.530165] cx88-mpeg driver manager 0000:07:00.2: enabling device
>> (0000 -> 0002)
>> [ 4734.530175] cx88-mpeg driver manager 0000:07:00.2: PCI INT A -> GSI=

>> 22 (level, low) -> IRQ 22
>> [ 4734.530184] cx88-mpeg driver manager 0000:07:00.2: setting latency
>> timer to 64
>> [ 4734.530193] cx88[0]/2: found at 0000:07:00.2, rev: 5, irq: 22,
>> latency: 64, mmio: 0x8e000000
>> [ 4734.594309] cx88/2: cx2388x dvb driver version 0.0.6 loaded
>> [ 4734.594313] cx88/2: registering cx8802 driver, type: dvb access: sh=
ared
>> [ 4734.594316] cx88[0]/2: subsystem: 12ab:1788, board: Pinnacle Hybrid=

>> PCTV [card=3D60]
>> [ 4734.594319] cx88[0]/2: cx2388x based DVB/ATSC card
>> [ 4734.594321] cx8802_alloc_frontends() allocating 1 frontend(s)
>> [ 4734.598305] xc2028 4-0061: attaching existing instance
>> [ 4734.598308] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
>> [ 4734.598310] cx88[0]/2: xc3028 attached
>> [ 4734.598317] DVB: registering new adapter (cx88[0])
>> [ 4734.598320] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
>> DVB-T)...
>> [ 4734.608466] i2c-adapter i2c-4: firmware: requesting xc3028-v27.fw
>> [ 4734.626640] xc2028 4-0061: Error: firmware xc3028-v27.fw not found.=

>>
>> Lazy people just scrolling by, reading the beginning and the end of
>> those dmesg messages might have spotted the problem already, which
>> particularly is:
>>
>> [ 4734.608466] i2c-adapter i2c-4: firmware: requesting xc3028-v27.fw
>> [ 4734.626640] xc2028 4-0061: Error: firmware xc3028-v27.fw not found.=

>>
>> This indicates that I seem to miss this firmware file. However, once
>> again the Wiki article suggests using the firmware driver package for
>> Pinnacle from this site: http://mcentral.de/firmware/
>>
>>    =20
>
> I use to build the firwmare into the drivers which are in userland nowa=
days.
> There are no drivers(sources) available which require any *external*
> firmware from mcentral.de anymore.
>  =20

Hi Markus,

that's cool... but which tree is the one you actually do speak about?
v4l-dvb-experimental? As stated... I've already tried it without any
success. :(

Other than this I am out of ideas... but you could mean
userspace-drivers though, is this the tree to go?  The page the README
file points to is outdated by the way...

When trying to compile all the stuff, I am getting this error messages:

sui userspace-drivers # ./build.sh
found kernel version (2.6.28.7-tuxonice-squashFS3.4-OSS4.1)
make -C /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/build
M=3D/usr/src/Pinnacle/userspace-drivers/kernel modules -Wall
make[1]: Entering directory `/usr/src/linux-2.6.28.7'
  CC [M]  /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.o
/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c: In Funktion
=BBtuner_request_module=AB:
/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:1466: Fehler:
Dereferenzierung eines Zeigers auf unvollst=E4ndigen Typen
/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c: In Funktion
=BBtuner_init=AB:
/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:2208: Fehler:
Implizite Deklaration der Funktion =BBclass_device_create=AB
/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:2208: Warnung:
Zuweisung erzeugt Zeiger von Ganzzahl ohne Typkonvertierung
/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c: In Funktion
=BBtuner_exit=AB:
/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:2218: Fehler:
Implizite Deklaration der Funktion =BBclass_device_destroy=AB
make[2]: *** [/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.o]
Fehler 1
make[1]: *** [_module_/usr/src/Pinnacle/userspace-drivers/kernel] Fehler =
2
make[1]: Leaving directory `/usr/src/linux-2.6.28.7'
make: *** [all] Fehler 2
make INSTALL_MOD_PATH=3D INSTALL_MOD_DIR=3Dkernel/drivers/media/userspace=
  \
        -C /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/build
M=3D/usr/src/Pinnacle/userspace-drivers/kernel modules_install
make[1]: Entering directory `/usr/src/linux-2.6.28.7'
  DEPMOD  2.6.28.7-tuxonice-squashFS3.4-OSS4.1
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol em28xx_i2c_call_clients
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_pcm_new
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_card_register
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_card_free
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_component_add
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_card_new
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_pcm_lib_ioctl
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_pcm_set_ops
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_pcm_hw_constraint_integer
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
needs unknown symbol snd_pcm_period_elapsed
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_pcm_new
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_card_register
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_card_free
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_card_new
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_pcm_lib_ioctl
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_pcm_set_ops
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_pcm_hw_constraint_integer
WARNING:
/lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko=

needs unknown symbol snd_pcm_period_elapsed
make[1]: Leaving directory `/usr/src/linux-2.6.28.7'
depmod -a
gcc -c media-core.c "-I/lib/modules/`uname -r`/source/include"
gcc media-core.o tuner-qt1010.c -o tuner-qt1010 "-I/lib/modules/`uname
-r`/source/include"  -g
gcc media-core.o tuner-mt2060.c -o tuner-mt2060 "-I/lib/modules/`uname
-r`/source/include"  -g
gcc -shared media-core.c -o libmedia-core.so "-I/lib/modules/`uname
-r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core tuner-xc3028.c -o libtuner-xc3028.so
"-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core demod-zl10353.c -o libdemod-zl10353.so
"-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -L. -lmedia-core demod-zl10353.c -o demod-zl10353
"-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -L. -lmedia-core vdecoder-tvp5150.c -o vdecoder-tvp5150
"-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core vdecoder-tvp5150.c -o libvdec-tvp5150.so
"-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core vdecoder-cx25840.c -o libvdec-cx25840.so
"-I/lib/modules/`uname -r`/source/include"  -fPIC -g
gcc -shared -L. -lmedia-core demod-lgdt3304.c -o libdemod-lgdt3304.so
"-I/lib/modules/`uname -r`/source/include"  -fPIC -g
make[1]: Entering directory
`/usr/src/Pinnacle/userspace-drivers/userspace/xc5000'
g++ XC5000_example_app.cpp i2c_driver.c xc5000_control.c -o test
"-I/lib/modules/`uname -r`/source/include" -lmedia-core -L..
gcc -shared tuner-xc5000.c i2c_driver.c xc5000_control.c -o
libtuner-xc5000.so -g -fPIC -lm "-I/lib/modules/`uname -r`/source/include=
"
gcc tuner-xc5000.c i2c_driver.c xc5000_control.c -o tuner-xc5000 -g -L..
-lmedia-core -lm "-I/lib/modules/`uname -r`/source/include"
make[1]: Leaving directory
`/usr/src/Pinnacle/userspace-drivers/userspace/xc5000'
make[1]: Entering directory
`/usr/src/Pinnacle/userspace-drivers/userspace/drx3975d'
gcc drx3973d.c drx_dap_wasi.c bsp_host.c bsp_i2c.c drx_driver.c main.c
-lmedia-core -L.. -DDRXD_TYPE_B -o test -lm -g "-I/lib/modules/`uname
-r`/source/include"
drx_dap_wasi.c: In Funktion =BBDRXDAP_WASI_WriteBlock=AB:
drx_dap_wasi.c:463: Warnung: Unvertr=E4gliche implizite Deklaration der
eingebauten Funktion =BBprintf=AB
gcc drx3973d.c drx_dap_wasi.c bsp_host.c bsp_i2c.c drx_driver.c
demod-drx3975d.c -shared -DDRXD_TYPE_B -DDRXD_TYPE_A -fPIC -o
libdemod-drx3975d.so -lm -L.. -lmedia-core -g "-I/lib/modules/`uname
-r`/source/include"
drx_dap_wasi.c: In Funktion =BBDRXDAP_WASI_WriteBlock=AB:
drx_dap_wasi.c:463: Warnung: Unvertr=E4gliche implizite Deklaration der
eingebauten Funktion =BBprintf=AB
make[1]: Leaving directory
`/usr/src/Pinnacle/userspace-drivers/userspace/drx3975d'
make[1]: Entering directory
`/usr/src/Pinnacle/userspace-drivers/userspace/xc3028'
gcc xc3028_example_app.c -lm -o test
gcc tuner-xc3028.c -o tuner-xc3028 -g -L.. -lmedia-core -lm
gcc -shared tuner-xc3028.c -o libtuner-xc3028.so -g -fPIC -lm
make[1]: Leaving directory
`/usr/src/Pinnacle/userspace-drivers/userspace/xc3028'
gcc media-daemon.c -L. -lmedia-core -ldl -o media-daemon
"-I/lib/modules/`uname -r`/source/include"  -g
mkdir -p //usr/sbin
mkdir -p //usr/lib
mkdir -p //usr/lib/v4l-dvb
install media-daemon //usr/sbin
cp libmedia-core.so //usr/lib
cp libtuner-xc3028.so //usr/lib/v4l-dvb
cp libdemod-zl10353.so //usr/lib/v4l-dvb
cp libvdec-tvp5150.so //usr/lib/v4l-dvb
cp libvdec-cx25840.so //usr/lib/v4l-dvb
cp libdemod-lgdt3304.so //usr/lib/v4l-dvb
cp xc5000/libtuner-xc5000.so //usr/lib/v4l-dvb
cp xc3028/libtuner-xc3028.so //usr/lib/v4l-dvb
cp drx3975d/libdemod-drx3975d.so //usr/lib/v4l-dvb
 * WARNING:  media-daemon has not yet been started.
Gentoo found

The latter ones are not fatal, but the first ones are, that said...
tuner-stub won't be built at all (bad stuff...)

I did use the following GCC version: gcc (GCC) 4.1.2 20070214 (  (gdc
0.24, using dmd 1.020)) (Gentoo 4.1.2 p1.0.2)

Best regards,


Mihai


--------------enigBB3E03C6CD3E47A3298476E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBCgAGBQJJvEU5AAoJEB/WLtluJTqH/dgP/2lWnN7XDHOW9d+HxiAR4QLu
uhIZmAZLAhX82aJm5GyiIoEf7sSP2bja7T7gEDlDAi0YX39UkjBgQw8KI53DlQvh
44pnnyrNsx/H2hM70pW/33u0KrC2w+AgwlKyrN2SM0RrJiZbPNbSl8pp7AQlCWMJ
jw8QQIxEFlybvFgEgjjPGCS4uj6Q5FhQu1TOzll2266/vdDScv+lFiN6GpTyQGV0
4HhqqgatqoOGaTejkou4ZTKiZtvjPYSl/mCQGEEXdnUXB1dp4mhXzXdH8jf7BpwV
BAmb6rYYh6oYoXQ+Fpl9akve05fYvJdN2eKMsI4iWgxZneolrmLLiJmz6H+WVuwE
3YlYdDUYEcsG7P/AWWZ8b1SQcbPXR1ImbKt09XZwrBCraVrkJSvmeBu8I35idX97
e/yOy8NamXMHWWBCTdXjTJnmYoWV2vvl5xRRCS/yzWhjUOT9HKm++Dtxu7Qa2P/j
a1UM0lDpHMSGdDV92r5hPCprlnKNKaUTNd2HMUKqiQYKuVjYS9CfE+E3WfHruxW/
KFxnv69KETncDVneKZTUk5v/deD35sjuUpn2xxDpIe9bI9UfymA3w5pOXcJw6XFW
msKcNowVaVegSqBlvvtfzoowtLMIPKplrLhKDbWiBFLUR/x4QjK6KyeDZNSHMLco
bObRJ1c03JdpTjUmYaCw
=lYrk
-----END PGP SIGNATURE-----

--------------enigBB3E03C6CD3E47A3298476E9--
