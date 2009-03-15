Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:63429 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCOAZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 20:25:25 -0400
Received: by fxm24 with SMTP id 24so3064673fxm.37
        for <linux-media@vger.kernel.org>; Sat, 14 Mar 2009 17:25:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BC4535.6090700@ionic.de>
References: <49BC3DEE.9050307@ionic.de>
	 <d9def9db0903141641g457b9cdar317b0d8e5f132150@mail.gmail.com>
	 <49BC4535.6090700@ionic.de>
Date: Sun, 15 Mar 2009 01:25:22 +0100
Message-ID: <d9def9db0903141725q86476e9i7fdf97d9198484ac@mail.gmail.com>
Subject: Re: Pinnacle PCTV Hybrid Pro Card (310c)... once again...
From: Markus Rechberger <mrechberger@gmail.com>
To: Mihai Moldovan <ionic@ionic.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mateusz <m.jedrasik@gmail.com>, Jacek <wafelj@epf.pl>,
	Kurt <kurtandre@gmail.com>, Juergen <juergenhaas@gmx.net>,
	Obri <obri@chaostreff.ch>, Kamre <kamre@student.agh.edu.pl>,
	=?ISO-8859-1?B?wWx2YXJv?= <aarranz@pegaso.ls.fi.upm.es>,
	Alfred <garbagemail@web.de>, Andy <andaug@mailbolt.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi Markus,
>
> that's cool... but which tree is the one you actually do speak about?
> v4l-dvb-experimental? As stated... I've already tried it without any
> success. :(
>

this tree doesn't exist anymore it's just a symlink to the split out
em28xx driver on mcentral.de
you should try your luck with the linuxtv.org/hg/v4l-dvb repository

> Other than this I am out of ideas... but you could mean
> userspace-drivers though, is this the tree to go?  The page the README
> file points to is outdated by the way...
>

those things are not relevant for your device, no drivers on
mcentral.de are relevant for your device.
read your first dmesg log carefully and try to obtain the xc3028
firmware and put it to /lib/firmware

regards,
Markus

> When trying to compile all the stuff, I am getting this error messages:
>
> sui userspace-drivers # ./build.sh
> found kernel version (2.6.28.7-tuxonice-squashFS3.4-OSS4.1)
> make -C /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/build
> M=/usr/src/Pinnacle/userspace-drivers/kernel modules -Wall
> make[1]: Entering directory `/usr/src/linux-2.6.28.7'
>  CC [M]  /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.o
> /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c: In Funktion
> »tuner_request_module«:
> /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:1466: Fehler:
> Dereferenzierung eines Zeigers auf unvollständigen Typen
> /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c: In Funktion
> »tuner_init«:
> /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:2208: Fehler:
> Implizite Deklaration der Funktion »class_device_create«
> /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:2208: Warnung:
> Zuweisung erzeugt Zeiger von Ganzzahl ohne Typkonvertierung
> /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c: In Funktion
> »tuner_exit«:
> /usr/src/Pinnacle/userspace-drivers/kernel/media-stub.c:2218: Fehler:
> Implizite Deklaration der Funktion »class_device_destroy«
> make[2]: *** [/usr/src/Pinnacle/userspace-drivers/kernel/media-stub.o]
> Fehler 1
> make[1]: *** [_module_/usr/src/Pinnacle/userspace-drivers/kernel] Fehler 2
> make[1]: Leaving directory `/usr/src/linux-2.6.28.7'
> make: *** [all] Fehler 2
> make INSTALL_MOD_PATH= INSTALL_MOD_DIR=kernel/drivers/media/userspace  \
>        -C /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/build
> M=/usr/src/Pinnacle/userspace-drivers/kernel modules_install
> make[1]: Entering directory `/usr/src/linux-2.6.28.7'
>  DEPMOD  2.6.28.7-tuxonice-squashFS3.4-OSS4.1
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol em28xx_i2c_call_clients
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_pcm_new
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_card_register
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_card_free
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_component_add
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_card_new
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_pcm_lib_ioctl
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_pcm_set_ops
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_pcm_hw_constraint_integer
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audio.ko
> needs unknown symbol snd_pcm_period_elapsed
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_pcm_new
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_card_register
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_card_free
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_card_new
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_pcm_lib_ioctl
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_pcm_set_ops
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_pcm_hw_constraint_integer
> WARNING:
> /lib/modules/2.6.28.7-tuxonice-squashFS3.4-OSS4.1/empia/em28xx-audioep.ko
> needs unknown symbol snd_pcm_period_elapsed
> make[1]: Leaving directory `/usr/src/linux-2.6.28.7'
> depmod -a
> gcc -c media-core.c "-I/lib/modules/`uname -r`/source/include"
> gcc media-core.o tuner-qt1010.c -o tuner-qt1010 "-I/lib/modules/`uname
> -r`/source/include"  -g
> gcc media-core.o tuner-mt2060.c -o tuner-mt2060 "-I/lib/modules/`uname
> -r`/source/include"  -g
> gcc -shared media-core.c -o libmedia-core.so "-I/lib/modules/`uname
> -r`/source/include"  -fPIC -g
> gcc -shared -L. -lmedia-core tuner-xc3028.c -o libtuner-xc3028.so
> "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
> gcc -shared -L. -lmedia-core demod-zl10353.c -o libdemod-zl10353.so
> "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
> gcc -L. -lmedia-core demod-zl10353.c -o demod-zl10353
> "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
> gcc -L. -lmedia-core vdecoder-tvp5150.c -o vdecoder-tvp5150
> "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
> gcc -shared -L. -lmedia-core vdecoder-tvp5150.c -o libvdec-tvp5150.so
> "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
> gcc -shared -L. -lmedia-core vdecoder-cx25840.c -o libvdec-cx25840.so
> "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
> gcc -shared -L. -lmedia-core demod-lgdt3304.c -o libdemod-lgdt3304.so
> "-I/lib/modules/`uname -r`/source/include"  -fPIC -g
> make[1]: Entering directory
> `/usr/src/Pinnacle/userspace-drivers/userspace/xc5000'
> g++ XC5000_example_app.cpp i2c_driver.c xc5000_control.c -o test
> "-I/lib/modules/`uname -r`/source/include" -lmedia-core -L..
> gcc -shared tuner-xc5000.c i2c_driver.c xc5000_control.c -o
> libtuner-xc5000.so -g -fPIC -lm "-I/lib/modules/`uname -r`/source/include"
> gcc tuner-xc5000.c i2c_driver.c xc5000_control.c -o tuner-xc5000 -g -L..
> -lmedia-core -lm "-I/lib/modules/`uname -r`/source/include"
> make[1]: Leaving directory
> `/usr/src/Pinnacle/userspace-drivers/userspace/xc5000'
> make[1]: Entering directory
> `/usr/src/Pinnacle/userspace-drivers/userspace/drx3975d'
> gcc drx3973d.c drx_dap_wasi.c bsp_host.c bsp_i2c.c drx_driver.c main.c
> -lmedia-core -L.. -DDRXD_TYPE_B -o test -lm -g "-I/lib/modules/`uname
> -r`/source/include"
> drx_dap_wasi.c: In Funktion »DRXDAP_WASI_WriteBlock«:
> drx_dap_wasi.c:463: Warnung: Unverträgliche implizite Deklaration der
> eingebauten Funktion »printf«
> gcc drx3973d.c drx_dap_wasi.c bsp_host.c bsp_i2c.c drx_driver.c
> demod-drx3975d.c -shared -DDRXD_TYPE_B -DDRXD_TYPE_A -fPIC -o
> libdemod-drx3975d.so -lm -L.. -lmedia-core -g "-I/lib/modules/`uname
> -r`/source/include"
> drx_dap_wasi.c: In Funktion »DRXDAP_WASI_WriteBlock«:
> drx_dap_wasi.c:463: Warnung: Unverträgliche implizite Deklaration der
> eingebauten Funktion »printf«
> make[1]: Leaving directory
> `/usr/src/Pinnacle/userspace-drivers/userspace/drx3975d'
> make[1]: Entering directory
> `/usr/src/Pinnacle/userspace-drivers/userspace/xc3028'
> gcc xc3028_example_app.c -lm -o test
> gcc tuner-xc3028.c -o tuner-xc3028 -g -L.. -lmedia-core -lm
> gcc -shared tuner-xc3028.c -o libtuner-xc3028.so -g -fPIC -lm
> make[1]: Leaving directory
> `/usr/src/Pinnacle/userspace-drivers/userspace/xc3028'
> gcc media-daemon.c -L. -lmedia-core -ldl -o media-daemon
> "-I/lib/modules/`uname -r`/source/include"  -g
> mkdir -p //usr/sbin
> mkdir -p //usr/lib
> mkdir -p //usr/lib/v4l-dvb
> install media-daemon //usr/sbin
> cp libmedia-core.so //usr/lib
> cp libtuner-xc3028.so //usr/lib/v4l-dvb
> cp libdemod-zl10353.so //usr/lib/v4l-dvb
> cp libvdec-tvp5150.so //usr/lib/v4l-dvb
> cp libvdec-cx25840.so //usr/lib/v4l-dvb
> cp libdemod-lgdt3304.so //usr/lib/v4l-dvb
> cp xc5000/libtuner-xc5000.so //usr/lib/v4l-dvb
> cp xc3028/libtuner-xc3028.so //usr/lib/v4l-dvb
> cp drx3975d/libdemod-drx3975d.so //usr/lib/v4l-dvb
>  * WARNING:  media-daemon has not yet been started.
> Gentoo found
>
> The latter ones are not fatal, but the first ones are, that said...
> tuner-stub won't be built at all (bad stuff...)
>
> I did use the following GCC version: gcc (GCC) 4.1.2 20070214 (  (gdc
> 0.24, using dmd 1.020)) (Gentoo 4.1.2 p1.0.2)
>
> Best regards,
>
>
> Mihai
>
>
