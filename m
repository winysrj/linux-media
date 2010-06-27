Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61304 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0F0TMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 15:12:12 -0400
Received: by wwi17 with SMTP id 17so2150944wwi.19
        for <linux-media@vger.kernel.org>; Sun, 27 Jun 2010 12:12:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilS2e9xJASSDfDkIIxU5yNE3Z-UVaDAergM5o8K@mail.gmail.com>
References: <AANLkTimAu1tX1Ta7CrvotfsVpV36CkJ-2nSLxZ4YgDZT@mail.gmail.com>
	<AANLkTilS2e9xJASSDfDkIIxU5yNE3Z-UVaDAergM5o8K@mail.gmail.com>
Date: Sun, 27 Jun 2010 21:12:09 +0200
Message-ID: <AANLkTikiOGuCqMUY42YOjrABApc2y2_HcYFe2llc9q7U@mail.gmail.com>
Subject: Re: v4l-dvb bug report
From: matteo sisti sette <matteosistisette@gmail.com>
To: Villy Thomsen <villyft@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yeah, thank you, I have found the FIREDTV=n trick on some other forum
just a few minutes before I read your reply, and with that change it
has compiled fine :)

I'm not sure what firedtv is but I don't think I need it :)

By the way may I ask a newbie question? If you need the kernel sources
to compile v4l-dvb, it does not mean that you're recompiling the
kernel, does it? :$

Thanks
m.


2010/6/27 Villy Thomsen <villyft@gmail.com>:
> Hi Matteo,
>
> I had the same problem a while ago. Short answer, the firedtv driver
> needs full kernel source to compile. I think I ended up with the full
> kernel source for other reasons (you need full source if you are going
> to use make menuconfig/oldconfig/etc).
>
> But if make menuconfig and/or the firedtv driver doesn't matter for
> you - find your v4l-dvb/v4l/.config file, search for FIREDTV and set
> those entries to =n instead of =m or =y and you should be in business.
>
> Regards,
>
> Villy
>
>> I am a newbee so please be patient with me. I have followed all the
>> instructions and I tried to compile the sources and got a lot of
>> errors. I don't think it's my fault but i may be wrong.
>>
>> My system: Ubuntu 10.04 with kernel 2.6.32.22
>> I have the headers installed, not the full kernel source code
>> (shouldn't be required).
>>
>> My dvb-t interface is an usb stick: Conceptronic CTVDIGUSB2, I believe
>> it has an afatech chipset. Here's the output from lsusb:
>> Bus 002 Device 007: ID 1b80:d393 Afatech
>>
>> I downloaded the latest v4l-dvb source from
>> hg clone http://linuxtv.org/hg/v4l-dvb
>>
>> I had a look at the daily test log and I don't see any test against 2.6.32.22
>>
>> Here's the output from make:
>>
>> teo@XXX:~/v4l-dvb$ sudo make
>> make -C /home/teo/v4l-dvb/v4l
>> make[1]: Entering directory `/home/teo/v4l-dvb/v4l'
>> No version yet, using 2.6.32-22-generic
>> make[1]: Leaving directory `/home/teo/v4l-dvb/v4l'
>> make[1]: Entering directory `/home/teo/v4l-dvb/v4l'
>> scripts/make_makefile.pl
>> Updating/Creating .config
>> Preparing to compile for kernel version 2.6.32
>>
>> ***WARNING:*** You do not have the full kernel sources installed.
>> This does not prevent you from building the v4l-dvb tree if you have the
>> kernel headers, but the full kernel source may be required in order to use
>> make menuconfig / xconfig / qconfig.
>>
>> If you are experiencing problems building the v4l-dvb tree, please try
>> building against a vanilla kernel before reporting a bug.
>>
>> Vanilla kernels are available at http://kernel.org.
>> On most distros, this will compile a newly downloaded kernel:
>>
>> cp /boot/config-`uname -r` <your kernel dir>/.config
>> cd <your kernel dir>
>> make all modules_install install
>>
>> Please see your distro's web site for instructions to build a new kernel.
>>
>> V4L2_MEM2MEM_DEV: Requires at least kernel 2.6.33
>> VIDEO_TVP7002: Requires at least kernel 2.6.34
>> VIDEO_AK881X: Requires at least kernel 2.6.33
>> SOC_CAMERA: Requires at least kernel 2.6.33
>> SOC_CAMERA_MT9M001: Requires at least kernel 2.6.33
>> SOC_CAMERA_MT9M111: Requires at least kernel 2.6.33
>> SOC_CAMERA_MT9T031: Requires at least kernel 2.6.33
>> SOC_CAMERA_MT9V022: Requires at least kernel 2.6.33
>> SOC_CAMERA_TW9910: Requires at least kernel 2.6.33
>> SOC_CAMERA_PLATFORM: Requires at least kernel 2.6.33
>> SOC_CAMERA_OV772X: Requires at least kernel 2.6.33
>> RADIO_SAA7706H: Requires at least kernel 2.6.34
>> Created default (all yes) .config file
>> ./scripts/make_myconfig.pl
>> make[1]: Leaving directory `/home/teo/v4l-dvb/v4l'
>> make[1]: Entering directory `/home/teo/v4l-dvb/v4l'
>> perl scripts/make_config_compat.pl
>> /lib/modules/2.6.32-22-generic/build ./.myconfig ./config-compat.h
>> creating symbolic links...
>> ln -sf . oss
>> make -C firmware prep
>> make[2]: Entering directory `/home/teo/v4l-dvb/v4l/firmware'
>> make[2]: Leaving directory `/home/teo/v4l-dvb/v4l/firmware'
>> make -C firmware
>> make[2]: Entering directory `/home/teo/v4l-dvb/v4l/firmware'
>>  CC  ihex2fw
>> Generating vicam/firmware.fw
>> Generating dabusb/firmware.fw
>> Generating dabusb/bitstream.bin
>> Generating ttusb-budget/dspbootcode.bin
>> Generating cpia2/stv0672_vp4.bin
>> Generating av7110/bootcode.bin
>> make[2]: Leaving directory `/home/teo/v4l-dvb/v4l/firmware'
>> Kernel build directory is /lib/modules/2.6.32-22-generic/build
>> make -C /lib/modules/2.6.32-22-generic/build
>> SUBDIRS=/home/teo/v4l-dvb/v4l  modules
>> make[2]: Entering directory `/usr/src/linux-headers-2.6.32-22-generic'
>>  CC [M]  /home/teo/v4l-dvb/v4l/tuner-xc2028.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/tuner-simple.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/tuner-types.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/mt20xx.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/tda8290.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/tea5767.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/tea5761.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/tda9887.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/tda827x.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au0828-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au0828-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au0828-cards.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au0828-dvb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au0828-video.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au8522_dig.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au8522_decoder.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-pci.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-usb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-fe-tuner.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-sram.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-eeprom.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-misc.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-hw-filter.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/flexcop-dma.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-driver.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-cards.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-if.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-risc.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-gpio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-input.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/bttv-audio-hook.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cpia2_v4l.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cpia2_usb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cpia2_core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-alsa-main.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-alsa-pcm.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-driver.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-cards.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-firmware.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-gpio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-queue.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-streams.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-fileops.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-ioctl.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-controls.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-mailbox.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-audio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-video.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-irq.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-av-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-av-audio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-av-firmware.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-av-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-scb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-dvb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx18-io.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-audio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-video.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-cards.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-avcore.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-pcb-cfg.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx231xx-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-cards.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-video.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-dvb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-417.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-ioctl.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-ir.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-input.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23888-ir.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/netup-init.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cimax2.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/netup-eeprom.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx23885-f300.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx25840-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx25840-audio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx25840-firmware.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx25840-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-video.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-mpeg.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-cards.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-tvaudio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-dsp.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cx88-input.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvbdev.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dmxdev.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb_demux.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb_filter.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb_ca_en50221.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb_frontend.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb_net.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb_ringbuffer.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb_math.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/av7110_hw.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/av7110_v4l.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/av7110_av.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/av7110_ca.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/av7110.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/av7110_ipack.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/av7110_ir.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/a800.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/af9005-remote.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/af9005.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/af9005-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/af9015.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/anysee.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/au6610.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/az6027.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/ce6230.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cinergyT2-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cinergyT2-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/cxusb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dib0700_core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dib0700_devices.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dibusb-common.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dibusb-mb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dibusb-mc.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/digitv.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dtt200u.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dtt200u-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dtv5100.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dw2102.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/ec168.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/friio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/friio-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/gl861.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/gp8psk.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/gp8psk-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/m920x.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/nova-t-usb2.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/opera1.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/ttusb2.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/umt-010.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/vp702x.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/vp702x-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/vp7045.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/vp7045-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb-usb-firmware.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb-usb-init.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb-usb-urb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb-usb-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb-usb-dvb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/dvb-usb-remote.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/usb-urb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/pt1.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/va1j5jf8007s.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/va1j5jf8007t.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/em28xx-audio.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/em28xx-video.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/em28xx-i2c.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/em28xx-cards.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/em28xx-core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/em28xx-input.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/em28xx-vbi.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/et61x251_core.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/et61x251_tas5130d1b.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/firedtv-avc.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/firedtv-ci.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/firedtv-dvb.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/firedtv-fe.o
>>  CC [M]  /home/teo/v4l-dvb/v4l/firedtv-1394.o
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:22:17: error: dma.h: No such file
>> or directory
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:23:21: error: csr1212.h: No such
>> file or directory
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:24:23: error: highlevel.h: No
>> such file or directory
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:25:19: error: hosts.h: No such
>> file or directory
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:26:22: error: ieee1394.h: No such
>> file or directory
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:27:17: error: iso.h: No such file
>> or directory
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:28:21: error: nodemgr.h: No such
>> file or directory
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:41: warning: 'struct hpsb_iso'
>> declared inside parameter list
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:41: warning: its scope is only
>> this definition or declaration, which is probably not what you want
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'rawiso_activity_cb':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:57: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:58: error: implicit declaration
>> of function 'hpsb_iso_n_ready'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:65: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:66: error: implicit declaration
>> of function 'dma_region_i'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:66: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:66: error: expected expression
>> before 'unsigned'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:68: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:72: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:86: error: implicit declaration
>> of function 'hpsb_iso_recv_release_packets'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'node_of':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:91: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:91: warning: type defaults to
>> 'int' in declaration of '__mptr'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:91: warning: initialization from
>> incompatible pointer type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:91: error: invalid use of
>> undefined type 'struct unit_directory'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'node_lock':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:96: error: 'quadlet_t' undeclared
>> (first use in this function)
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:96: error: (Each undeclared
>> identifier is reported only once
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:96: error: for each function it
>> appears in.)
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:96: error: 'd' undeclared (first
>> use in this function)
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:97: warning: ISO C90 forbids
>> mixed declarations and code
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:99: error: implicit declaration
>> of function 'hpsb_node_lock'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:100: error:
>> 'EXTCODE_COMPARE_SWAP' undeclared (first use in this function)
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'node_read':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:108: error: implicit declaration
>> of function 'hpsb_node_read'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'node_write':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:113: error: implicit declaration
>> of function 'hpsb_node_write'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'start_iso':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:124: error: implicit declaration
>> of function 'hpsb_iso_recv_init'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:124: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:126: error:
>> 'HPSB_ISO_DMA_DEFAULT' undeclared (first use in this function)
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:135: error: implicit declaration
>> of function 'hpsb_iso_recv_start'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:138: error: implicit declaration
>> of function 'hpsb_iso_shutdown'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'stop_iso':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:149: error: implicit declaration
>> of function 'hpsb_iso_stop'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: At top level:
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:164: warning: 'struct hpsb_host'
>> declared inside parameter list
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'fcp_request':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:177: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:178: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'node_probe':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:192: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:192: warning: type defaults to
>> 'int' in declaration of '__mptr'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:192: warning: initialization from
>> incompatible pointer type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:192: error: invalid use of
>> undefined type 'struct unit_directory'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:197: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:198: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:199: error: implicit declaration
>> of function 'CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:199: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: At top level:
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:258: warning: 'struct
>> unit_directory' declared inside parameter list
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'node_update':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:260: error: dereferencing pointer
>> to incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: At top level:
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:268: error: variable
>> 'fdtv_driver' has initializer but incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:269: error: unknown field 'name'
>> specified in initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:269: warning: excess elements in
>> struct initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:269: warning: (near
>> initialization for 'fdtv_driver')
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:270: error: unknown field
>> 'id_table' specified in initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:270: warning: excess elements in
>> struct initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:270: warning: (near
>> initialization for 'fdtv_driver')
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:271: error: unknown field
>> 'update' specified in initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:271: warning: excess elements in
>> struct initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:271: warning: (near
>> initialization for 'fdtv_driver')
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:272: error: unknown field
>> 'driver' specified in initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:272: error: extra brace group at
>> end of initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:272: error: (near initialization
>> for 'fdtv_driver')
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:275: warning: excess elements in
>> struct initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:275: warning: (near
>> initialization for 'fdtv_driver')
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:278: error: variable
>> 'fdtv_highlevel' has initializer but incomplete type
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:279: error: unknown field 'name'
>> specified in initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:279: warning: excess elements in
>> struct initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:279: warning: (near
>> initialization for 'fdtv_highlevel')
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:280: error: unknown field
>> 'fcp_request' specified in initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:280: warning: excess elements in
>> struct initializer
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:280: warning: (near
>> initialization for 'fdtv_highlevel')
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_init':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:287: error: implicit declaration
>> of function 'hpsb_register_highlevel'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:288: error: implicit declaration
>> of function 'hpsb_register_protocol'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:291: error: implicit declaration
>> of function 'hpsb_unregister_highlevel'
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c: In function 'fdtv_1394_exit':
>> /home/teo/v4l-dvb/v4l/firedtv-1394.c:298: error: implicit declaration
>> of function 'hpsb_unregister_protocol'
>> make[3]: *** [/home/teo/v4l-dvb/v4l/firedtv-1394.o] Error 1
>> make[2]: *** [_module_/home/teo/v4l-dvb/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-22-generic'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/home/teo/v4l-dvb/v4l'
>> make: *** [all] Error 2
>>
>>
>> Hope this helps
>>
>> Thanks
>> m.
>>
>>
>>
>> --
>> Matteo Sisti Sette
>> matteosistisette@gmail.com
>> http://www.matteosistisette.com
>>
>> --
>> Matteo Sisti Sette
>> matteosistisette@gmail.com
>> http://www.matteosistisette.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Matteo Sisti Sette
matteosistisette@gmail.com
http://www.matteosistisette.com
