Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+f81c9f6d5612c94c69b1+1968+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LMFgY-0006PP-KC
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 06:50:03 +0100
Date: Mon, 12 Jan 2009 03:49:25 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: wk <handygewinnspiel@gmx.de>
Message-ID: <20090112034925.7c215735@pedra.chehab.org>
In-Reply-To: <4968E723.3090705@gmx.de>
References: <20090110102705.129600@gmx.net> <20090110103700.107530@gmx.net>
	<49688176.5030603@gmx.de> <4968E723.3090705@gmx.de>
Mime-Version: 1.0
Cc: Hans Werner <HWerner4@gmx.de>,
	Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
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

On Sat, 10 Jan 2009 19:21:23 +0100
wk <handygewinnspiel@gmx.de> wrote:

> wk schrieb:
> > Hans Werner schrieb:
> >   =

> >>> Hi all,
> >>>
> >>> Compiling on 2.6.28 seems to be broken (v4l-dvb-985ecd81d993,
> >>> linux-2.6.28, gcc-3.4.1), is this known or already some patch around?
> >>>     =

> >>>       =

> >> I can compile fine with 2.6.28, x86_64, gcc 4.2.4. Did you do 'make di=
stclean' first?
> >>
> >>   =

> >>     =

> > Well, i did not start with distclean, since i expect a freshly =

> > downloaded package to be distclean.
> > Nevertheless make distclean and/or make clean also doesnt work properly:
> >
> > -bash-3.00# make distclean
> > make -C /usr/src/v4l-dvb-985ecd81d993/v4l distclean
> > make[1]: Entering directory `/usr/src/v4l-dvb-985ecd81d993/v4l'
> > find: .: Value too large for defined data type

I never found this error. It seems to be some trouble on your local
environment. The Makefile is probably running those commands:

	find ../linux/drivers/media -name '*.[ch]' -type f -print0 | xargs -0n 255=
 ln -sf --target-directory=3D.
        find ../linux/sound -name '*.[ch]' -type f -print0 | xargs -0n 255 =
ln -sf --target-directory=3D.

> if i try to compile after a previous run with 2.6.26.3 or 2.6.27.9 =

> compiling runs (but still the error message of find after creating =

> symbolic links),
> because the symbolic links are already created from previous run. I'm =

> wondering wether i'm the only one with that problem..

I'm not suffering this issue, as you can see:

$ make distclean

make -C /home/v4l/master/v4l distclean
make[1]: Entrando no diret=F3rio `/home/v4l/master/v4l'
rm -f *~ *.o *.ko .*.o.cmd .*.ko.cmd *.mod.c av7110_firm.h fdump \
		config-compat.h Module.symvers
make -C firmware clean
make[2]: Entering directory `/home/v4l/master/v4l/firmware'
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make=
 rule.
rm -f ihex2fw vicam/firmware.fw dabusb/firmware.fw dabusb/bitstream.bin ttu=
sb-budget/dspbootcode.bin cpia2/stv0672_vp4.bin
make[2]: Leaving directory `/home/v4l/master/v4l/firmware'
rm -f .version .*.o.flags .*.o.d Makefile.media \
		Kconfig Kconfig.kern .config .config.cmd .myconfig \
		.kconfig.dep
rm -rf .tmp_versions
rm -f scripts/lxdialog scripts/kconfig oss
make -C firmware distclean
make[2]: Entering directory `/home/v4l/master/v4l/firmware'
rm -f ihex2fw vicam/firmware.fw dabusb/firmware.fw dabusb/bitstream.bin ttu=
sb-budget/dspbootcode.bin cpia2/stv0672_vp4.bin
for i in vicam dabusb ttusb-budget cpia2; do if [ -d $i ]; then rmdir $i; f=
i; done
make[2]: Leaving directory `/home/v4l/master/v4l/firmware'
make[1]: Saindo do diret=F3rio `/home/v4l/master/v4l'

$ make release DIR=3D/usr/src/kernels/v2.6.28/

make -C /home/v4l/master/v4l release
make[1]: Entrando no diret=F3rio `/home/v4l/master/v4l'
Searching in /usr/src/kernels/v2.6.28//Makefile for kernel version.
Forcing compiling to version 2.6.28
make[1]: Saindo do diret=F3rio `/home/v4l/master/v4l'

$ make =


make -C /home/v4l/master/v4l =

make[1]: Entrando no diret=F3rio `/home/v4l/master/v4l'
scripts/make_makefile.pl
./scripts/make_kconfig.pl /usr/src/kernels/v2.6.28/ /usr/src/kernels/v2.6.2=
8/
Updating/Creating .config
Preparing to compile for kernel version 2.6.28
Preparing to compile for kernel version 2.6.28
Created default (all yes) .config file
./scripts/make_myconfig.pl
make[1]: Saindo do diret=F3rio `/home/v4l/master/v4l'
make[1]: Entrando no diret=F3rio `/home/v4l/master/v4l'
perl scripts/make_config_compat.pl /usr/src/kernels/v2.6.28/ ./.myconfig ./=
config-compat.h
ln -sf . oss
creating symbolic links...
Kernel build directory is /usr/src/kernels/v2.6.28/
make -C /usr/src/kernels/v2.6.28/ SUBDIRS=3D/home/v4l/master/v4l  modules
make[2]: Entering directory `/usr/src/kernels/v2.6.28'
  CC [M]  /home/v4l/master/v4l/tuner-xc2028.o
  CC [M]  /home/v4l/master/v4l/tuner-simple.o
  CC [M]  /home/v4l/master/v4l/tuner-types.o
  CC [M]  /home/v4l/master/v4l/mt20xx.o
  CC [M]  /home/v4l/master/v4l/tda8290.o
  CC [M]  /home/v4l/master/v4l/tea5767.o
  CC [M]  /home/v4l/master/v4l/tea5761.o
  CC [M]  /home/v4l/master/v4l/tda9887.o
  CC [M]  /home/v4l/master/v4l/tda827x.o
  CC [M]  /home/v4l/master/v4l/au0828-core.o
  CC [M]  /home/v4l/master/v4l/au0828-i2c.o
  CC [M]  /home/v4l/master/v4l/au0828-cards.o
  CC [M]  /home/v4l/master/v4l/au0828-dvb.o
  CC [M]  /home/v4l/master/v4l/flexcop-pci.o
  CC [M]  /home/v4l/master/v4l/flexcop-usb.o
  CC [M]  /home/v4l/master/v4l/flexcop.o
  CC [M]  /home/v4l/master/v4l/flexcop-fe-tuner.o
  CC [M]  /home/v4l/master/v4l/flexcop-i2c.o
  CC [M]  /home/v4l/master/v4l/flexcop-sram.o
  CC [M]  /home/v4l/master/v4l/flexcop-eeprom.o
  CC [M]  /home/v4l/master/v4l/flexcop-misc.o
  CC [M]  /home/v4l/master/v4l/flexcop-hw-filter.o
  CC [M]  /home/v4l/master/v4l/flexcop-dma.o
  CC [M]  /home/v4l/master/v4l/bttv-driver.o
  CC [M]  /home/v4l/master/v4l/bttv-cards.o
  CC [M]  /home/v4l/master/v4l/bttv-if.o
  CC [M]  /home/v4l/master/v4l/bttv-risc.o
  CC [M]  /home/v4l/master/v4l/bttv-vbi.o
  CC [M]  /home/v4l/master/v4l/bttv-i2c.o
  CC [M]  /home/v4l/master/v4l/bttv-gpio.o
  CC [M]  /home/v4l/master/v4l/bttv-input.o
  CC [M]  /home/v4l/master/v4l/bttv-audio-hook.o
  CC [M]  /home/v4l/master/v4l/cpia2_v4l.o
  CC [M]  /home/v4l/master/v4l/cpia2_usb.o
  CC [M]  /home/v4l/master/v4l/cpia2_core.o
  CC [M]  /home/v4l/master/v4l/cx18-driver.o
  CC [M]  /home/v4l/master/v4l/cx18-cards.o
  CC [M]  /home/v4l/master/v4l/cx18-i2c.o
  CC [M]  /home/v4l/master/v4l/cx18-firmware.o
  CC [M]  /home/v4l/master/v4l/cx18-gpio.o
  CC [M]  /home/v4l/master/v4l/cx18-queue.o
  CC [M]  /home/v4l/master/v4l/cx18-streams.o
  CC [M]  /home/v4l/master/v4l/cx18-fileops.o
  CC [M]  /home/v4l/master/v4l/cx18-ioctl.o
  CC [M]  /home/v4l/master/v4l/cx18-controls.o
  CC [M]  /home/v4l/master/v4l/cx18-mailbox.o
  CC [M]  /home/v4l/master/v4l/cx18-vbi.o
  CC [M]  /home/v4l/master/v4l/cx18-audio.o
  CC [M]  /home/v4l/master/v4l/cx18-video.o
  CC [M]  /home/v4l/master/v4l/cx18-irq.o
  CC [M]  /home/v4l/master/v4l/cx18-av-core.o
  CC [M]  /home/v4l/master/v4l/cx18-av-audio.o
  CC [M]  /home/v4l/master/v4l/cx18-av-firmware.o
  CC [M]  /home/v4l/master/v4l/cx18-av-vbi.o
  CC [M]  /home/v4l/master/v4l/cx18-scb.o
  CC [M]  /home/v4l/master/v4l/cx18-dvb.o
  CC [M]  /home/v4l/master/v4l/cx18-io.o
  CC [M]  /home/v4l/master/v4l/cx23885-cards.o
  CC [M]  /home/v4l/master/v4l/cx23885-video.o
  CC [M]  /home/v4l/master/v4l/cx23885-vbi.o
  CC [M]  /home/v4l/master/v4l/cx23885-core.o
  CC [M]  /home/v4l/master/v4l/cx23885-i2c.o
  CC [M]  /home/v4l/master/v4l/cx23885-dvb.o
  CC [M]  /home/v4l/master/v4l/cx23885-417.o
  CC [M]  /home/v4l/master/v4l/cx25840-core.o
  CC [M]  /home/v4l/master/v4l/cx25840-audio.o
  CC [M]  /home/v4l/master/v4l/cx25840-firmware.o
  CC [M]  /home/v4l/master/v4l/cx25840-vbi.o
  CC [M]  /home/v4l/master/v4l/cx88-video.o
  CC [M]  /home/v4l/master/v4l/cx88-vbi.o
  CC [M]  /home/v4l/master/v4l/cx88-mpeg.o
  CC [M]  /home/v4l/master/v4l/cx88-cards.o
  CC [M]  /home/v4l/master/v4l/cx88-core.o
  CC [M]  /home/v4l/master/v4l/cx88-i2c.o
  CC [M]  /home/v4l/master/v4l/cx88-tvaudio.o
  CC [M]  /home/v4l/master/v4l/cx88-input.o
  CC [M]  /home/v4l/master/v4l/dvbdev.o
  CC [M]  /home/v4l/master/v4l/dmxdev.o
  CC [M]  /home/v4l/master/v4l/dvb_demux.o
  CC [M]  /home/v4l/master/v4l/dvb_filter.o
  CC [M]  /home/v4l/master/v4l/dvb_ca_en50221.o
  CC [M]  /home/v4l/master/v4l/dvb_frontend.o
  CC [M]  /home/v4l/master/v4l/dvb_net.o
  CC [M]  /home/v4l/master/v4l/dvb_ringbuffer.o
  CC [M]  /home/v4l/master/v4l/dvb_math.o
  CC [M]  /home/v4l/master/v4l/av7110_hw.o
  CC [M]  /home/v4l/master/v4l/av7110_v4l.o
  CC [M]  /home/v4l/master/v4l/av7110_av.o
  CC [M]  /home/v4l/master/v4l/av7110_ca.o
  CC [M]  /home/v4l/master/v4l/av7110.o
  CC [M]  /home/v4l/master/v4l/av7110_ipack.o
  CC [M]  /home/v4l/master/v4l/av7110_ir.o
  CC [M]  /home/v4l/master/v4l/a800.o
  CC [M]  /home/v4l/master/v4l/af9005-remote.o
  CC [M]  /home/v4l/master/v4l/af9005.o
  CC [M]  /home/v4l/master/v4l/af9005-fe.o
  CC [M]  /home/v4l/master/v4l/af9015.o
  CC [M]  /home/v4l/master/v4l/anysee.o
  CC [M]  /home/v4l/master/v4l/au6610.o
  CC [M]  /home/v4l/master/v4l/cinergyT2-core.o
  CC [M]  /home/v4l/master/v4l/cinergyT2-fe.o
  CC [M]  /home/v4l/master/v4l/cxusb.o
  CC [M]  /home/v4l/master/v4l/dib0700_core.o
  CC [M]  /home/v4l/master/v4l/dib0700_devices.o
  CC [M]  /home/v4l/master/v4l/dibusb-common.o
  CC [M]  /home/v4l/master/v4l/dibusb-mb.o
  CC [M]  /home/v4l/master/v4l/dibusb-mc.o
  CC [M]  /home/v4l/master/v4l/digitv.o
  CC [M]  /home/v4l/master/v4l/dtt200u.o
  CC [M]  /home/v4l/master/v4l/dtt200u-fe.o
  CC [M]  /home/v4l/master/v4l/dtv5100.o
  CC [M]  /home/v4l/master/v4l/dw2102.o
  CC [M]  /home/v4l/master/v4l/gl861.o
  CC [M]  /home/v4l/master/v4l/gp8psk.o
  CC [M]  /home/v4l/master/v4l/gp8psk-fe.o
  CC [M]  /home/v4l/master/v4l/m920x.o
  CC [M]  /home/v4l/master/v4l/nova-t-usb2.o
  CC [M]  /home/v4l/master/v4l/opera1.o
  CC [M]  /home/v4l/master/v4l/ttusb2.o
  CC [M]  /home/v4l/master/v4l/umt-010.o
  CC [M]  /home/v4l/master/v4l/vp702x.o
  CC [M]  /home/v4l/master/v4l/vp702x-fe.o
  CC [M]  /home/v4l/master/v4l/vp7045.o
  CC [M]  /home/v4l/master/v4l/vp7045-fe.o
  CC [M]  /home/v4l/master/v4l/dvb-usb-firmware.o
  CC [M]  /home/v4l/master/v4l/dvb-usb-init.o
  CC [M]  /home/v4l/master/v4l/dvb-usb-urb.o
  CC [M]  /home/v4l/master/v4l/dvb-usb-i2c.o
  CC [M]  /home/v4l/master/v4l/dvb-usb-dvb.o
  CC [M]  /home/v4l/master/v4l/dvb-usb-remote.o
  CC [M]  /home/v4l/master/v4l/usb-urb.o
  CC [M]  /home/v4l/master/v4l/em28xx-audio.o
  CC [M]  /home/v4l/master/v4l/em28xx-video.o
  CC [M]  /home/v4l/master/v4l/em28xx-i2c.o
  CC [M]  /home/v4l/master/v4l/em28xx-cards.o
  CC [M]  /home/v4l/master/v4l/em28xx-core.o
  CC [M]  /home/v4l/master/v4l/em28xx-input.o
  CC [M]  /home/v4l/master/v4l/et61x251_core.o
  CC [M]  /home/v4l/master/v4l/et61x251_tas5130d1b.o
  CC [M]  /home/v4l/master/v4l/conex.o
  CC [M]  /home/v4l/master/v4l/etoms.o
  CC [M]  /home/v4l/master/v4l/finepix.o
  CC [M]  /home/v4l/master/v4l/m5602_core.o
  CC [M]  /home/v4l/master/v4l/m5602_ov9650.o
  CC [M]  /home/v4l/master/v4l/m5602_mt9m111.o
  CC [M]  /home/v4l/master/v4l/m5602_po1030.o
  CC [M]  /home/v4l/master/v4l/m5602_s5k83a.o
  CC [M]  /home/v4l/master/v4l/m5602_s5k4aa.o
  CC [M]  /home/v4l/master/v4l/gspca.o
  CC [M]  /home/v4l/master/v4l/mars.o
  CC [M]  /home/v4l/master/v4l/ov519.o
  CC [M]  /home/v4l/master/v4l/ov534.o
  CC [M]  /home/v4l/master/v4l/pac207.o
  CC [M]  /home/v4l/master/v4l/pac7311.o
  CC [M]  /home/v4l/master/v4l/sonixb.o
  CC [M]  /home/v4l/master/v4l/sonixj.o
  CC [M]  /home/v4l/master/v4l/spca500.o
  CC [M]  /home/v4l/master/v4l/spca501.o
  CC [M]  /home/v4l/master/v4l/spca505.o
  CC [M]  /home/v4l/master/v4l/spca506.o
  CC [M]  /home/v4l/master/v4l/spca508.o
  CC [M]  /home/v4l/master/v4l/spca561.o
  CC [M]  /home/v4l/master/v4l/stk014.o
  CC [M]  /home/v4l/master/v4l/stv06xx.o
  CC [M]  /home/v4l/master/v4l/stv06xx_vv6410.o
  CC [M]  /home/v4l/master/v4l/stv06xx_hdcs.o
  CC [M]  /home/v4l/master/v4l/stv06xx_pb0100.o
  CC [M]  /home/v4l/master/v4l/sunplus.o
  CC [M]  /home/v4l/master/v4l/t613.o
  CC [M]  /home/v4l/master/v4l/tv8532.o
  CC [M]  /home/v4l/master/v4l/vc032x.o
  CC [M]  /home/v4l/master/v4l/zc3xx.o
  CC [M]  /home/v4l/master/v4l/ir-functions.o
  CC [M]  /home/v4l/master/v4l/ir-keymaps.o
  CC [M]  /home/v4l/master/v4l/ivtv-routing.o
  CC [M]  /home/v4l/master/v4l/ivtv-cards.o
  CC [M]  /home/v4l/master/v4l/ivtv-controls.o
  CC [M]  /home/v4l/master/v4l/ivtv-driver.o
  CC [M]  /home/v4l/master/v4l/ivtv-fileops.o
  CC [M]  /home/v4l/master/v4l/ivtv-firmware.o
  CC [M]  /home/v4l/master/v4l/ivtv-gpio.o
  CC [M]  /home/v4l/master/v4l/ivtv-i2c.o
  CC [M]  /home/v4l/master/v4l/ivtv-ioctl.o
  CC [M]  /home/v4l/master/v4l/ivtv-irq.o
  CC [M]  /home/v4l/master/v4l/ivtv-mailbox.o
  CC [M]  /home/v4l/master/v4l/ivtv-queue.o
  CC [M]  /home/v4l/master/v4l/ivtv-streams.o
  CC [M]  /home/v4l/master/v4l/ivtv-udma.o
  CC [M]  /home/v4l/master/v4l/ivtv-vbi.o
  CC [M]  /home/v4l/master/v4l/ivtv-yuv.o
  CC [M]  /home/v4l/master/v4l/msp3400-driver.o
  CC [M]  /home/v4l/master/v4l/msp3400-kthreads.o
  CC [M]  /home/v4l/master/v4l/ovcamchip_core.o
  CC [M]  /home/v4l/master/v4l/ov6x20.o
  CC [M]  /home/v4l/master/v4l/ov6x30.o
  CC [M]  /home/v4l/master/v4l/ov7x10.o
  CC [M]  /home/v4l/master/v4l/ov7x20.o
  CC [M]  /home/v4l/master/v4l/ov76be.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-i2c-core.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-i2c-cmd-v4l2.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-audio.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-i2c-chips-v4l2.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-encoder.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-video-v4l.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-eeprom.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-tuner.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-main.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-hdw.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-v4l2.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-ctrl.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-std.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-devattr.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-context.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-io.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-ioread.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-cx2584x-v4l.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-wm8775.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-dvb.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-sysfs.o
  CC [M]  /home/v4l/master/v4l/pvrusb2-debugifc.o
  CC [M]  /home/v4l/master/v4l/pwc-if.o
  CC [M]  /home/v4l/master/v4l/pwc-misc.o
  CC [M]  /home/v4l/master/v4l/pwc-ctrl.o
  CC [M]  /home/v4l/master/v4l/pwc-v4l.o
  CC [M]  /home/v4l/master/v4l/pwc-uncompress.o
  CC [M]  /home/v4l/master/v4l/pwc-dec1.o
  CC [M]  /home/v4l/master/v4l/pwc-dec23.o
  CC [M]  /home/v4l/master/v4l/pwc-kiara.o
  CC [M]  /home/v4l/master/v4l/pwc-timon.o
  CC [M]  /home/v4l/master/v4l/s921_module.o
  CC [M]  /home/v4l/master/v4l/s921_core.o
  CC [M]  /home/v4l/master/v4l/saa7134-cards.o
  CC [M]  /home/v4l/master/v4l/saa7134-core.o
  CC [M]  /home/v4l/master/v4l/saa7134-i2c.o
  CC [M]  /home/v4l/master/v4l/saa7134-ts.o
  CC [M]  /home/v4l/master/v4l/saa7134-tvaudio.o
  CC [M]  /home/v4l/master/v4l/saa7134-vbi.o
  CC [M]  /home/v4l/master/v4l/saa7134-video.o
  CC [M]  /home/v4l/master/v4l/saa7134-input.o
  CC [M]  /home/v4l/master/v4l/saa7146_i2c.o
  CC [M]  /home/v4l/master/v4l/saa7146_core.o
  CC [M]  /home/v4l/master/v4l/saa7146_fops.o
  CC [M]  /home/v4l/master/v4l/saa7146_video.o
  CC [M]  /home/v4l/master/v4l/saa7146_hlp.o
  CC [M]  /home/v4l/master/v4l/saa7146_vbi.o
  CC [M]  /home/v4l/master/v4l/smscoreapi.o
  CC [M]  /home/v4l/master/v4l/smsusb.o
  CC [M]  /home/v4l/master/v4l/smsdvb.o
  CC [M]  /home/v4l/master/v4l/sms-cards.o
  CC [M]  /home/v4l/master/v4l/sn9c102_core.o
  CC [M]  /home/v4l/master/v4l/sn9c102_hv7131d.o
  CC [M]  /home/v4l/master/v4l/sn9c102_hv7131r.o
  CC [M]  /home/v4l/master/v4l/sn9c102_mi0343.o
  CC [M]  /home/v4l/master/v4l/sn9c102_mi0360.o
  CC [M]  /home/v4l/master/v4l/sn9c102_mt9v111.o
  CC [M]  /home/v4l/master/v4l/sn9c102_ov7630.o
  CC [M]  /home/v4l/master/v4l/sn9c102_ov7660.o
  CC [M]  /home/v4l/master/v4l/sn9c102_pas106b.o
  CC [M]  /home/v4l/master/v4l/sn9c102_pas202bcb.o
  CC [M]  /home/v4l/master/v4l/sn9c102_tas5110c1b.o
  CC [M]  /home/v4l/master/v4l/sn9c102_tas5110d.o
  CC [M]  /home/v4l/master/v4l/sn9c102_tas5130d1b.o
  CC [M]  /home/v4l/master/v4l/bt87x.o
  CC [M]  /home/v4l/master/v4l/tea575x-tuner.o
  CC [M]  /home/v4l/master/v4l/stb0899_drv.o
  CC [M]  /home/v4l/master/v4l/stb0899_algo.o
  CC [M]  /home/v4l/master/v4l/stk-webcam.o
  CC [M]  /home/v4l/master/v4l/stk-sensor.o
  CC [M]  /home/v4l/master/v4l/tda18271-maps.o
  CC [M]  /home/v4l/master/v4l/tda18271-common.o
  CC [M]  /home/v4l/master/v4l/tda18271-fe.o
  CC [M]  /home/v4l/master/v4l/tuner-core.o
  CC [M]  /home/v4l/master/v4l/usbvision-core.o
  CC [M]  /home/v4l/master/v4l/usbvision-video.o
  CC [M]  /home/v4l/master/v4l/usbvision-i2c.o
  CC [M]  /home/v4l/master/v4l/usbvision-cards.o
  CC [M]  /home/v4l/master/v4l/uvc_driver.o
  CC [M]  /home/v4l/master/v4l/uvc_queue.o
  CC [M]  /home/v4l/master/v4l/uvc_v4l2.o
  CC [M]  /home/v4l/master/v4l/uvc_video.o
  CC [M]  /home/v4l/master/v4l/uvc_ctrl.o
  CC [M]  /home/v4l/master/v4l/uvc_status.o
  CC [M]  /home/v4l/master/v4l/uvc_isight.o
  CC [M]  /home/v4l/master/v4l/v4l2-dev.o
  CC [M]  /home/v4l/master/v4l/v4l2-ioctl.o
  CC [M]  /home/v4l/master/v4l/v4l2-device.o
  CC [M]  /home/v4l/master/v4l/v4l2-subdev.o
  CC [M]  /home/v4l/master/v4l/zc0301_core.o
  CC [M]  /home/v4l/master/v4l/zc0301_pb0330.o
  CC [M]  /home/v4l/master/v4l/zc0301_pas202bcb.o
  CC [M]  /home/v4l/master/v4l/zoran_procfs.o
  CC [M]  /home/v4l/master/v4l/zoran_device.o
  CC [M]  /home/v4l/master/v4l/zoran_driver.o
  CC [M]  /home/v4l/master/v4l/zoran_card.o
  CC [M]  /home/v4l/master/v4l/xc5000.o
  CC [M]  /home/v4l/master/v4l/mt2060.o
  CC [M]  /home/v4l/master/v4l/mt2266.o
  CC [M]  /home/v4l/master/v4l/qt1010.o
  CC [M]  /home/v4l/master/v4l/mt2131.o
  CC [M]  /home/v4l/master/v4l/mxl5005s.o
  CC [M]  /home/v4l/master/v4l/mxl5007t.o
  CC [M]  /home/v4l/master/v4l/v4l2-int-device.o
  CC [M]  /home/v4l/master/v4l/v4l2-compat-ioctl32.o
  CC [M]  /home/v4l/master/v4l/v4l2-common.o
  CC [M]  /home/v4l/master/v4l/v4l1-compat.o
  CC [M]  /home/v4l/master/v4l/ir-kbd-i2c.o
  CC [M]  /home/v4l/master/v4l/tvaudio.o
  CC [M]  /home/v4l/master/v4l/tda7432.o
  CC [M]  /home/v4l/master/v4l/tda9875.o
  CC [M]  /home/v4l/master/v4l/saa6588.o
  CC [M]  /home/v4l/master/v4l/saa5246a.o
  CC [M]  /home/v4l/master/v4l/saa5249.o
  CC [M]  /home/v4l/master/v4l/c-qcam.o
  CC [M]  /home/v4l/master/v4l/bw-qcam.o
  CC [M]  /home/v4l/master/v4l/w9966.o
  CC [M]  /home/v4l/master/v4l/tda9840.o
  CC [M]  /home/v4l/master/v4l/tea6415c.o
  CC [M]  /home/v4l/master/v4l/tea6420.o
  CC [M]  /home/v4l/master/v4l/saa7110.o
  CC [M]  /home/v4l/master/v4l/saa7111.o
  CC [M]  /home/v4l/master/v4l/saa7114.o
  CC [M]  /home/v4l/master/v4l/saa7115.o
  CC [M]  /home/v4l/master/v4l/saa717x.o
  CC [M]  /home/v4l/master/v4l/saa7127.o
  CC [M]  /home/v4l/master/v4l/saa7185.o
  CC [M]  /home/v4l/master/v4l/saa7191.o
  CC [M]  /home/v4l/master/v4l/adv7170.o
  CC [M]  /home/v4l/master/v4l/adv7175.o
  CC [M]  /home/v4l/master/v4l/vpx3220.o
  CC [M]  /home/v4l/master/v4l/bt819.o
  CC [M]  /home/v4l/master/v4l/bt856.o
  CC [M]  /home/v4l/master/v4l/bt866.o
  CC [M]  /home/v4l/master/v4l/ks0127.o
  LD [M]  /home/v4l/master/v4l/zr36067.o
  CC [M]  /home/v4l/master/v4l/videocodec.o
  CC [M]  /home/v4l/master/v4l/zr36050.o
  CC [M]  /home/v4l/master/v4l/zr36016.o
  CC [M]  /home/v4l/master/v4l/zr36060.o
  CC [M]  /home/v4l/master/v4l/stradis.o
  CC [M]  /home/v4l/master/v4l/cpia.o
  CC [M]  /home/v4l/master/v4l/cpia_pp.o
  CC [M]  /home/v4l/master/v4l/cpia_usb.o
  LD [M]  /home/v4l/master/v4l/saa7134.o
  CC [M]  /home/v4l/master/v4l/saa7134-empress.o
  CC [M]  /home/v4l/master/v4l/saa6752hs.o
  CC [M]  /home/v4l/master/v4l/saa7134-alsa.o
  LD [M]  /home/v4l/master/v4l/cx88xx.o
  CC [M]  /home/v4l/master/v4l/saa7134-dvb.o
  LD [M]  /home/v4l/master/v4l/cx8800.o
  CC [M]  /home/v4l/master/v4l/cx88-alsa.o
  CC [M]  /home/v4l/master/v4l/cx88-blackbird.o
  LD [M]  /home/v4l/master/v4l/cx8802.o
  CC [M]  /home/v4l/master/v4l/cx88-dvb.o
  CC [M]  /home/v4l/master/v4l/cx88-vp3054-i2c.o
  LD [M]  /home/v4l/master/v4l/em28xx.o
  LD [M]  /home/v4l/master/v4l/em28xx-alsa.o
  CC [M]  /home/v4l/master/v4l/em28xx-dvb.o
  LD [M]  /home/v4l/master/v4l/usbvision.o
  CC [M]  /home/v4l/master/v4l/tvp5150.o
  CC [M]  /home/v4l/master/v4l/tvp514x.o
  LD [M]  /home/v4l/master/v4l/pvrusb2.o
  LD [M]  /home/v4l/master/v4l/msp3400.o
  CC [M]  /home/v4l/master/v4l/cs5345.o
  CC [M]  /home/v4l/master/v4l/cs53l32a.o
  CC [M]  /home/v4l/master/v4l/m52790.o
  CC [M]  /home/v4l/master/v4l/tlv320aic23b.o
  CC [M]  /home/v4l/master/v4l/wm8775.o
  CC [M]  /home/v4l/master/v4l/wm8739.o
  CC [M]  /home/v4l/master/v4l/vp27smpx.o
  LD [M]  /home/v4l/master/v4l/ovcamchip.o
  LD [M]  /home/v4l/master/v4l/cpia2.o
  CC [M]  /home/v4l/master/v4l/mxb.o
  CC [M]  /home/v4l/master/v4l/hexium_orion.o
  CC [M]  /home/v4l/master/v4l/hexium_gemini.o
  CC [M]  /home/v4l/master/v4l/videobuf-core.o
  CC [M]  /home/v4l/master/v4l/videobuf-dma-sg.o
  CC [M]  /home/v4l/master/v4l/videobuf-dma-contig.o
  CC [M]  /home/v4l/master/v4l/videobuf-vmalloc.o
  CC [M]  /home/v4l/master/v4l/videobuf-dvb.o
  CC [M]  /home/v4l/master/v4l/btcx-risc.o
  CC [M]  /home/v4l/master/v4l/tveeprom.o
  LD [M]  /home/v4l/master/v4l/cx25840.o
  CC [M]  /home/v4l/master/v4l/upd64031a.o
  CC [M]  /home/v4l/master/v4l/upd64083.o
  CC [M]  /home/v4l/master/v4l/cx2341x.o
  CC [M]  /home/v4l/master/v4l/cafe_ccic.o
  CC [M]  /home/v4l/master/v4l/ov7670.o
  CC [M]  /home/v4l/master/v4l/tcm825x.o
  CC [M]  /home/v4l/master/v4l/dabusb.o
  CC [M]  /home/v4l/master/v4l/ov511.o
  CC [M]  /home/v4l/master/v4l/se401.o
  CC [M]  /home/v4l/master/v4l/stv680.o
  CC [M]  /home/v4l/master/v4l/w9968cf.o
  CC [M]  /home/v4l/master/v4l/zr364xx.o
  LD [M]  /home/v4l/master/v4l/stkwebcam.o
  LD [M]  /home/v4l/master/v4l/sn9c102.o
  LD [M]  /home/v4l/master/v4l/et61x251.o
  LD [M]  /home/v4l/master/v4l/pwc.o
  LD [M]  /home/v4l/master/v4l/zc0301.o
  LD [M]  /home/v4l/master/v4l/gspca_main.o
  LD [M]  /home/v4l/master/v4l/gspca_conex.o
  LD [M]  /home/v4l/master/v4l/gspca_etoms.o
  LD [M]  /home/v4l/master/v4l/gspca_finepix.o
  LD [M]  /home/v4l/master/v4l/gspca_mars.o
  LD [M]  /home/v4l/master/v4l/gspca_ov519.o
  LD [M]  /home/v4l/master/v4l/gspca_ov534.o
  LD [M]  /home/v4l/master/v4l/gspca_pac207.o
  LD [M]  /home/v4l/master/v4l/gspca_pac7311.o
  LD [M]  /home/v4l/master/v4l/gspca_sonixb.o
  LD [M]  /home/v4l/master/v4l/gspca_sonixj.o
  LD [M]  /home/v4l/master/v4l/gspca_spca500.o
  LD [M]  /home/v4l/master/v4l/gspca_spca501.o
  LD [M]  /home/v4l/master/v4l/gspca_spca505.o
  LD [M]  /home/v4l/master/v4l/gspca_spca508.o
  LD [M]  /home/v4l/master/v4l/gspca_spca506.o
  LD [M]  /home/v4l/master/v4l/gspca_spca561.o
  LD [M]  /home/v4l/master/v4l/gspca_sunplus.o
  LD [M]  /home/v4l/master/v4l/gspca_t613.o
  LD [M]  /home/v4l/master/v4l/gspca_stk014.o
  LD [M]  /home/v4l/master/v4l/gspca_tv8532.o
  LD [M]  /home/v4l/master/v4l/gspca_vc032x.o
  LD [M]  /home/v4l/master/v4l/gspca_zc3xx.o
  LD [M]  /home/v4l/master/v4l/gspca_m5602.o
  LD [M]  /home/v4l/master/v4l/gspca_stv06xx.o
  CC [M]  /home/v4l/master/v4l/usbvideo.o
  CC [M]  /home/v4l/master/v4l/ibmcam.o
  CC [M]  /home/v4l/master/v4l/ultracam.o
  CC [M]  /home/v4l/master/v4l/konicawc.o
  CC [M]  /home/v4l/master/v4l/vicam.o
  CC [M]  /home/v4l/master/v4l/quickcam_messenger.o
  CC [M]  /home/v4l/master/v4l/s2255drv.o
  LD [M]  /home/v4l/master/v4l/ivtv.o
  CC [M]  /home/v4l/master/v4l/ivtvfb.o
  LD [M]  /home/v4l/master/v4l/cx18.o
  CC [M]  /home/v4l/master/v4l/vivi.o
  LD [M]  /home/v4l/master/v4l/cx23885.o
  CC [M]  /home/v4l/master/v4l/soc_camera.o
  CC [M]  /home/v4l/master/v4l/mt9m001.o
  CC [M]  /home/v4l/master/v4l/mt9m111.o
  CC [M]  /home/v4l/master/v4l/mt9t031.o
  CC [M]  /home/v4l/master/v4l/ov772x.o
  CC [M]  /home/v4l/master/v4l/soc_camera_platform.o
  CC [M]  /home/v4l/master/v4l/tw9910.o
  LD [M]  /home/v4l/master/v4l/au0828.o
  LD [M]  /home/v4l/master/v4l/uvcvideo.o
  CC [M]  /home/v4l/master/v4l/radio-maxiradio.o
  CC [M]  /home/v4l/master/v4l/radio-gemtek-pci.o
  CC [M]  /home/v4l/master/v4l/radio-maestro.o
  CC [M]  /home/v4l/master/v4l/dsbr100.o
  CC [M]  /home/v4l/master/v4l/radio-si470x.o
  CC [M]  /home/v4l/master/v4l/radio-mr800.o
  CC [M]  /home/v4l/master/v4l/radio-tea5764.o
  LD [M]  /home/v4l/master/v4l/dvb-core.o
  CC [M]  /home/v4l/master/v4l/dvb-pll.o
  CC [M]  /home/v4l/master/v4l/stv0299.o
  LD [M]  /home/v4l/master/v4l/stb0899.o
  CC [M]  /home/v4l/master/v4l/stb6100.o
  CC [M]  /home/v4l/master/v4l/cx22700.o
  CC [M]  /home/v4l/master/v4l/sp8870.o
  CC [M]  /home/v4l/master/v4l/cx24110.o
  CC [M]  /home/v4l/master/v4l/tda8083.o
  CC [M]  /home/v4l/master/v4l/l64781.o
  CC [M]  /home/v4l/master/v4l/dib3000mb.o
  CC [M]  /home/v4l/master/v4l/dib3000mc.o
  CC [M]  /home/v4l/master/v4l/dibx000_common.o
  CC [M]  /home/v4l/master/v4l/dib7000m.o
  CC [M]  /home/v4l/master/v4l/dib7000p.o
  CC [M]  /home/v4l/master/v4l/mt312.o
  CC [M]  /home/v4l/master/v4l/ves1820.o
  CC [M]  /home/v4l/master/v4l/ves1x93.o
  CC [M]  /home/v4l/master/v4l/tda1004x.o
  CC [M]  /home/v4l/master/v4l/sp887x.o
  CC [M]  /home/v4l/master/v4l/nxt6000.o
  CC [M]  /home/v4l/master/v4l/mt352.o
  CC [M]  /home/v4l/master/v4l/zl10353.o
  CC [M]  /home/v4l/master/v4l/cx22702.o
  CC [M]  /home/v4l/master/v4l/drx397xD.o
  CC [M]  /home/v4l/master/v4l/tda10021.o
  CC [M]  /home/v4l/master/v4l/tda10023.o
  CC [M]  /home/v4l/master/v4l/stv0297.o
  CC [M]  /home/v4l/master/v4l/nxt200x.o
  CC [M]  /home/v4l/master/v4l/or51211.o
  CC [M]  /home/v4l/master/v4l/or51132.o
  CC [M]  /home/v4l/master/v4l/bcm3510.o
  CC [M]  /home/v4l/master/v4l/s5h1420.o
  CC [M]  /home/v4l/master/v4l/lgdt330x.o
  CC [M]  /home/v4l/master/v4l/lgdt3304.o
  CC [M]  /home/v4l/master/v4l/cx24123.o
  CC [M]  /home/v4l/master/v4l/lnbp21.o
  CC [M]  /home/v4l/master/v4l/isl6405.o
  CC [M]  /home/v4l/master/v4l/isl6421.o
  CC [M]  /home/v4l/master/v4l/tda10086.o
  CC [M]  /home/v4l/master/v4l/tda826x.o
  CC [M]  /home/v4l/master/v4l/tda8261.o
  CC [M]  /home/v4l/master/v4l/dib0070.o
  CC [M]  /home/v4l/master/v4l/tua6100.o
  CC [M]  /home/v4l/master/v4l/s5h1409.o
  CC [M]  /home/v4l/master/v4l/itd1000.o
  CC [M]  /home/v4l/master/v4l/au8522.o
  CC [M]  /home/v4l/master/v4l/tda10048.o
  CC [M]  /home/v4l/master/v4l/cx24113.o
  CC [M]  /home/v4l/master/v4l/s5h1411.o
  CC [M]  /home/v4l/master/v4l/lgs8gl5.o
  CC [M]  /home/v4l/master/v4l/dvb_dummy_fe.o
  CC [M]  /home/v4l/master/v4l/af9013.o
  CC [M]  /home/v4l/master/v4l/cx24116.o
  CC [M]  /home/v4l/master/v4l/si21xx.o
  CC [M]  /home/v4l/master/v4l/stv0288.o
  CC [M]  /home/v4l/master/v4l/stb6000.o
  LD [M]  /home/v4l/master/v4l/s921.o
  CC [M]  /home/v4l/master/v4l/ttpci-eeprom.o
  CC [M]  /home/v4l/master/v4l/budget-core.o
  CC [M]  /home/v4l/master/v4l/budget.o
  CC [M]  /home/v4l/master/v4l/budget-av.o
  CC [M]  /home/v4l/master/v4l/budget-ci.o
  CC [M]  /home/v4l/master/v4l/budget-patch.o
  LD [M]  /home/v4l/master/v4l/dvb-ttpci.o
  CC [M]  /home/v4l/master/v4l/ttusb_dec.o
  CC [M]  /home/v4l/master/v4l/ttusbdecfe.o
  CC [M]  /home/v4l/master/v4l/dvb-ttusb-budget.o
  LD [M]  /home/v4l/master/v4l/b2c2-flexcop.o
  LD [M]  /home/v4l/master/v4l/b2c2-flexcop-pci.o
  LD [M]  /home/v4l/master/v4l/b2c2-flexcop-usb.o
  CC [M]  /home/v4l/master/v4l/bt878.o
  CC [M]  /home/v4l/master/v4l/dvb-bt8xx.o
  CC [M]  /home/v4l/master/v4l/dst.o
  CC [M]  /home/v4l/master/v4l/dst_ca.o
  LD [M]  /home/v4l/master/v4l/dvb-usb.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-vp7045.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-vp702x.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-gp8psk.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-dtt200u.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-dibusb-common.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-a800.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-dibusb-mb.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-dibusb-mc.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-nova-t-usb2.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-umt-010.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-m920x.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-gl861.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-au6610.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-digitv.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-cxusb.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-ttusb2.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-dib0700.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-opera.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-af9005.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-af9005-remote.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-anysee.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-dw2102.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-dtv5100.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-af9015.o
  LD [M]  /home/v4l/master/v4l/dvb-usb-cinergyT2.o
  CC [M]  /home/v4l/master/v4l/pluto2.o
  LD [M]  /home/v4l/master/v4l/sms1xxx.o
  CC [M]  /home/v4l/master/v4l/dm1105.o
  LD [M]  /home/v4l/master/v4l/snd-bt87x.o
  LD [M]  /home/v4l/master/v4l/snd-tea575x-tuner.o
  LD [M]  /home/v4l/master/v4l/tda18271.o
  LD [M]  /home/v4l/master/v4l/saa7146.o
  LD [M]  /home/v4l/master/v4l/saa7146_vv.o
  LD [M]  /home/v4l/master/v4l/ir-common.o
  LD [M]  /home/v4l/master/v4l/videodev.o
  LD [M]  /home/v4l/master/v4l/tuner.o
  LD [M]  /home/v4l/master/v4l/bttv.o
  Building modules, stage 2.
  MODPOST 280 modules
  CC      /home/v4l/master/v4l/adv7170.mod.o
  CC      /home/v4l/master/v4l/adv7175.mod.o
  CC      /home/v4l/master/v4l/af9013.mod.o
  CC      /home/v4l/master/v4l/au0828.mod.o
  CC      /home/v4l/master/v4l/au8522.mod.o
  CC      /home/v4l/master/v4l/b2c2-flexcop-pci.mod.o
  CC      /home/v4l/master/v4l/b2c2-flexcop-usb.mod.o
  CC      /home/v4l/master/v4l/b2c2-flexcop.mod.o
  CC      /home/v4l/master/v4l/bcm3510.mod.o
  CC      /home/v4l/master/v4l/bt819.mod.o
  CC      /home/v4l/master/v4l/bt856.mod.o
  CC      /home/v4l/master/v4l/bt866.mod.o
  CC      /home/v4l/master/v4l/bt878.mod.o
  CC      /home/v4l/master/v4l/btcx-risc.mod.o
  CC      /home/v4l/master/v4l/bttv.mod.o
  CC      /home/v4l/master/v4l/budget-av.mod.o
  CC      /home/v4l/master/v4l/budget-ci.mod.o
  CC      /home/v4l/master/v4l/budget-core.mod.o
  CC      /home/v4l/master/v4l/budget-patch.mod.o
  CC      /home/v4l/master/v4l/budget.mod.o
  CC      /home/v4l/master/v4l/bw-qcam.mod.o
  CC      /home/v4l/master/v4l/c-qcam.mod.o
  CC      /home/v4l/master/v4l/cafe_ccic.mod.o
  CC      /home/v4l/master/v4l/cpia.mod.o
  CC      /home/v4l/master/v4l/cpia2.mod.o
  CC      /home/v4l/master/v4l/cpia_pp.mod.o
  CC      /home/v4l/master/v4l/cpia_usb.mod.o
  CC      /home/v4l/master/v4l/cs5345.mod.o
  CC      /home/v4l/master/v4l/cs53l32a.mod.o
  CC      /home/v4l/master/v4l/cx18.mod.o
  CC      /home/v4l/master/v4l/cx22700.mod.o
  CC      /home/v4l/master/v4l/cx22702.mod.o
  CC      /home/v4l/master/v4l/cx2341x.mod.o
  CC      /home/v4l/master/v4l/cx23885.mod.o
  CC      /home/v4l/master/v4l/cx24110.mod.o
  CC      /home/v4l/master/v4l/cx24113.mod.o
  CC      /home/v4l/master/v4l/cx24116.mod.o
  CC      /home/v4l/master/v4l/cx24123.mod.o
  CC      /home/v4l/master/v4l/cx25840.mod.o
  CC      /home/v4l/master/v4l/cx88-alsa.mod.o
  CC      /home/v4l/master/v4l/cx88-blackbird.mod.o
  CC      /home/v4l/master/v4l/cx88-dvb.mod.o
  CC      /home/v4l/master/v4l/cx88-vp3054-i2c.mod.o
  CC      /home/v4l/master/v4l/cx8800.mod.o
  CC      /home/v4l/master/v4l/cx8802.mod.o
  CC      /home/v4l/master/v4l/cx88xx.mod.o
  CC      /home/v4l/master/v4l/dabusb.mod.o
  CC      /home/v4l/master/v4l/dib0070.mod.o
  CC      /home/v4l/master/v4l/dib3000mb.mod.o
  CC      /home/v4l/master/v4l/dib7000m.mod.o
  CC      /home/v4l/master/v4l/dib7000p.mod.o
  CC      /home/v4l/master/v4l/dib3000mc.mod.o
  CC      /home/v4l/master/v4l/dibx000_common.mod.o
  CC      /home/v4l/master/v4l/dm1105.mod.o
  CC      /home/v4l/master/v4l/drx397xD.mod.o
  CC      /home/v4l/master/v4l/dsbr100.mod.o
  CC      /home/v4l/master/v4l/dst.mod.o
  CC      /home/v4l/master/v4l/dst_ca.mod.o
  CC      /home/v4l/master/v4l/dvb-bt8xx.mod.o
  CC      /home/v4l/master/v4l/dvb-core.mod.o
  CC      /home/v4l/master/v4l/dvb-pll.mod.o
  CC      /home/v4l/master/v4l/dvb-ttpci.mod.o
  CC      /home/v4l/master/v4l/dvb-ttusb-budget.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-a800.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-af9005-remote.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-af9005.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-af9015.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-anysee.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-au6610.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-cinergyT2.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-cxusb.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-dib0700.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-dibusb-common.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-dibusb-mb.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-dibusb-mc.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-digitv.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-dtt200u.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-dtv5100.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-dw2102.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-gl861.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-gp8psk.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-m920x.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-nova-t-usb2.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-opera.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-ttusb2.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-umt-010.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-vp702x.mod.o
  CC      /home/v4l/master/v4l/dvb-usb-vp7045.mod.o
  CC      /home/v4l/master/v4l/dvb-usb.mod.o
  CC      /home/v4l/master/v4l/dvb_dummy_fe.mod.o
  CC      /home/v4l/master/v4l/em28xx-alsa.mod.o
  CC      /home/v4l/master/v4l/em28xx-dvb.mod.o
  CC      /home/v4l/master/v4l/em28xx.mod.o
  CC      /home/v4l/master/v4l/et61x251.mod.o
  CC      /home/v4l/master/v4l/gspca_conex.mod.o
  CC      /home/v4l/master/v4l/gspca_etoms.mod.o
  CC      /home/v4l/master/v4l/gspca_finepix.mod.o
  CC      /home/v4l/master/v4l/gspca_m5602.mod.o
  CC      /home/v4l/master/v4l/gspca_main.mod.o
  CC      /home/v4l/master/v4l/gspca_mars.mod.o
  CC      /home/v4l/master/v4l/gspca_ov519.mod.o
  CC      /home/v4l/master/v4l/gspca_ov534.mod.o
  CC      /home/v4l/master/v4l/gspca_pac207.mod.o
  CC      /home/v4l/master/v4l/gspca_pac7311.mod.o
  CC      /home/v4l/master/v4l/gspca_sonixb.mod.o
  CC      /home/v4l/master/v4l/gspca_sonixj.mod.o
  CC      /home/v4l/master/v4l/gspca_spca500.mod.o
  CC      /home/v4l/master/v4l/gspca_spca501.mod.o
  CC      /home/v4l/master/v4l/gspca_spca505.mod.o
  CC      /home/v4l/master/v4l/gspca_spca506.mod.o
  CC      /home/v4l/master/v4l/gspca_spca508.mod.o
  CC      /home/v4l/master/v4l/gspca_spca561.mod.o
  CC      /home/v4l/master/v4l/gspca_stk014.mod.o
  CC      /home/v4l/master/v4l/gspca_stv06xx.mod.o
  CC      /home/v4l/master/v4l/gspca_sunplus.mod.o
  CC      /home/v4l/master/v4l/gspca_t613.mod.o
  CC      /home/v4l/master/v4l/gspca_tv8532.mod.o
  CC      /home/v4l/master/v4l/gspca_vc032x.mod.o
  CC      /home/v4l/master/v4l/gspca_zc3xx.mod.o
  CC      /home/v4l/master/v4l/hexium_gemini.mod.o
  CC      /home/v4l/master/v4l/hexium_orion.mod.o
  CC      /home/v4l/master/v4l/ibmcam.mod.o
  CC      /home/v4l/master/v4l/ir-common.mod.o
  CC      /home/v4l/master/v4l/ir-kbd-i2c.mod.o
  CC      /home/v4l/master/v4l/isl6405.mod.o
  CC      /home/v4l/master/v4l/isl6421.mod.o
  CC      /home/v4l/master/v4l/itd1000.mod.o
  CC      /home/v4l/master/v4l/ivtv.mod.o
  CC      /home/v4l/master/v4l/ivtvfb.mod.o
  CC      /home/v4l/master/v4l/konicawc.mod.o
  CC      /home/v4l/master/v4l/ks0127.mod.o
  CC      /home/v4l/master/v4l/l64781.mod.o
  CC      /home/v4l/master/v4l/lgdt3304.mod.o
  CC      /home/v4l/master/v4l/lgdt330x.mod.o
  CC      /home/v4l/master/v4l/lgs8gl5.mod.o
  CC      /home/v4l/master/v4l/lnbp21.mod.o
  CC      /home/v4l/master/v4l/m52790.mod.o
  CC      /home/v4l/master/v4l/msp3400.mod.o
  CC      /home/v4l/master/v4l/mt2060.mod.o
  CC      /home/v4l/master/v4l/mt20xx.mod.o
  CC      /home/v4l/master/v4l/mt2131.mod.o
  CC      /home/v4l/master/v4l/mt2266.mod.o
  CC      /home/v4l/master/v4l/mt312.mod.o
  CC      /home/v4l/master/v4l/mt352.mod.o
  CC      /home/v4l/master/v4l/mt9m001.mod.o
  CC      /home/v4l/master/v4l/mt9m111.mod.o
  CC      /home/v4l/master/v4l/mt9t031.mod.o
  CC      /home/v4l/master/v4l/mxb.mod.o
  CC      /home/v4l/master/v4l/mxl5005s.mod.o
  CC      /home/v4l/master/v4l/mxl5007t.mod.o
  CC      /home/v4l/master/v4l/nxt200x.mod.o
  CC      /home/v4l/master/v4l/nxt6000.mod.o
  CC      /home/v4l/master/v4l/or51132.mod.o
  CC      /home/v4l/master/v4l/or51211.mod.o
  CC      /home/v4l/master/v4l/ov511.mod.o
  CC      /home/v4l/master/v4l/ov7670.mod.o
  CC      /home/v4l/master/v4l/ov772x.mod.o
  CC      /home/v4l/master/v4l/ovcamchip.mod.o
  CC      /home/v4l/master/v4l/pluto2.mod.o
  CC      /home/v4l/master/v4l/pvrusb2.mod.o
  CC      /home/v4l/master/v4l/pwc.mod.o
  CC      /home/v4l/master/v4l/qt1010.mod.o
  CC      /home/v4l/master/v4l/quickcam_messenger.mod.o
  CC      /home/v4l/master/v4l/radio-gemtek-pci.mod.o
  CC      /home/v4l/master/v4l/radio-maestro.mod.o
  CC      /home/v4l/master/v4l/radio-maxiradio.mod.o
  CC      /home/v4l/master/v4l/radio-si470x.mod.o
  CC      /home/v4l/master/v4l/radio-mr800.mod.o
  CC      /home/v4l/master/v4l/radio-tea5764.mod.o
  CC      /home/v4l/master/v4l/s2255drv.mod.o
  CC      /home/v4l/master/v4l/s5h1409.mod.o
  CC      /home/v4l/master/v4l/s5h1411.mod.o
  CC      /home/v4l/master/v4l/s5h1420.mod.o
  CC      /home/v4l/master/v4l/s921.mod.o
  CC      /home/v4l/master/v4l/saa5246a.mod.o
  CC      /home/v4l/master/v4l/saa5249.mod.o
  CC      /home/v4l/master/v4l/saa6588.mod.o
  CC      /home/v4l/master/v4l/saa6752hs.mod.o
  CC      /home/v4l/master/v4l/saa7110.mod.o
  CC      /home/v4l/master/v4l/saa7111.mod.o
  CC      /home/v4l/master/v4l/saa7114.mod.o
  CC      /home/v4l/master/v4l/saa7115.mod.o
  CC      /home/v4l/master/v4l/saa7127.mod.o
  CC      /home/v4l/master/v4l/saa7134-alsa.mod.o
  CC      /home/v4l/master/v4l/saa7134-dvb.mod.o
  CC      /home/v4l/master/v4l/saa7134-empress.mod.o
  CC      /home/v4l/master/v4l/saa7134.mod.o
  CC      /home/v4l/master/v4l/saa7146.mod.o
  CC      /home/v4l/master/v4l/saa7146_vv.mod.o
  CC      /home/v4l/master/v4l/saa717x.mod.o
  CC      /home/v4l/master/v4l/saa7185.mod.o
  CC      /home/v4l/master/v4l/saa7191.mod.o
  CC      /home/v4l/master/v4l/se401.mod.o
  CC      /home/v4l/master/v4l/si21xx.mod.o
  CC      /home/v4l/master/v4l/sms1xxx.mod.o
  CC      /home/v4l/master/v4l/sn9c102.mod.o
  CC      /home/v4l/master/v4l/snd-bt87x.mod.o
  CC      /home/v4l/master/v4l/snd-tea575x-tuner.mod.o
  CC      /home/v4l/master/v4l/soc_camera.mod.o
  CC      /home/v4l/master/v4l/soc_camera_platform.mod.o
  CC      /home/v4l/master/v4l/sp8870.mod.o
  CC      /home/v4l/master/v4l/sp887x.mod.o
  CC      /home/v4l/master/v4l/stb0899.mod.o
  CC      /home/v4l/master/v4l/stb6000.mod.o
  CC      /home/v4l/master/v4l/stb6100.mod.o
  CC      /home/v4l/master/v4l/stkwebcam.mod.o
  CC      /home/v4l/master/v4l/stradis.mod.o
  CC      /home/v4l/master/v4l/stv0288.mod.o
  CC      /home/v4l/master/v4l/stv0297.mod.o
  CC      /home/v4l/master/v4l/stv0299.mod.o
  CC      /home/v4l/master/v4l/stv680.mod.o
  CC      /home/v4l/master/v4l/tcm825x.mod.o
  CC      /home/v4l/master/v4l/tda10021.mod.o
  CC      /home/v4l/master/v4l/tda10023.mod.o
  CC      /home/v4l/master/v4l/tda10048.mod.o
  CC      /home/v4l/master/v4l/tda1004x.mod.o
  CC      /home/v4l/master/v4l/tda10086.mod.o
  CC      /home/v4l/master/v4l/tda18271.mod.o
  CC      /home/v4l/master/v4l/tda7432.mod.o
  CC      /home/v4l/master/v4l/tda8083.mod.o
  CC      /home/v4l/master/v4l/tda8261.mod.o
  CC      /home/v4l/master/v4l/tda826x.mod.o
  CC      /home/v4l/master/v4l/tda827x.mod.o
  CC      /home/v4l/master/v4l/tda8290.mod.o
  CC      /home/v4l/master/v4l/tda9840.mod.o
  CC      /home/v4l/master/v4l/tda9875.mod.o
  CC      /home/v4l/master/v4l/tda9887.mod.o
  CC      /home/v4l/master/v4l/tea5761.mod.o
  CC      /home/v4l/master/v4l/tea5767.mod.o
  CC      /home/v4l/master/v4l/tea6415c.mod.o
  CC      /home/v4l/master/v4l/tea6420.mod.o
  CC      /home/v4l/master/v4l/tlv320aic23b.mod.o
  CC      /home/v4l/master/v4l/ttpci-eeprom.mod.o
  CC      /home/v4l/master/v4l/ttusb_dec.mod.o
  CC      /home/v4l/master/v4l/ttusbdecfe.mod.o
  CC      /home/v4l/master/v4l/tua6100.mod.o
  CC      /home/v4l/master/v4l/tuner-simple.mod.o
  CC      /home/v4l/master/v4l/tuner-types.mod.o
  CC      /home/v4l/master/v4l/tuner-xc2028.mod.o
  CC      /home/v4l/master/v4l/tuner.mod.o
  CC      /home/v4l/master/v4l/tvaudio.mod.o
  CC      /home/v4l/master/v4l/tveeprom.mod.o
  CC      /home/v4l/master/v4l/tvp514x.mod.o
  CC      /home/v4l/master/v4l/tvp5150.mod.o
  CC      /home/v4l/master/v4l/tw9910.mod.o
  CC      /home/v4l/master/v4l/ultracam.mod.o
  CC      /home/v4l/master/v4l/upd64031a.mod.o
  CC      /home/v4l/master/v4l/upd64083.mod.o
  CC      /home/v4l/master/v4l/usbvideo.mod.o
  CC      /home/v4l/master/v4l/usbvision.mod.o
  CC      /home/v4l/master/v4l/uvcvideo.mod.o
  CC      /home/v4l/master/v4l/v4l1-compat.mod.o
  CC      /home/v4l/master/v4l/v4l2-common.mod.o
  CC      /home/v4l/master/v4l/v4l2-compat-ioctl32.mod.o
  CC      /home/v4l/master/v4l/v4l2-int-device.mod.o
  CC      /home/v4l/master/v4l/ves1820.mod.o
  CC      /home/v4l/master/v4l/ves1x93.mod.o
  CC      /home/v4l/master/v4l/vicam.mod.o
  CC      /home/v4l/master/v4l/videobuf-core.mod.o
  CC      /home/v4l/master/v4l/videobuf-dma-contig.mod.o
  CC      /home/v4l/master/v4l/videobuf-dma-sg.mod.o
  CC      /home/v4l/master/v4l/videobuf-dvb.mod.o
  CC      /home/v4l/master/v4l/videobuf-vmalloc.mod.o
  CC      /home/v4l/master/v4l/videocodec.mod.o
  CC      /home/v4l/master/v4l/videodev.mod.o
  CC      /home/v4l/master/v4l/vivi.mod.o
  CC      /home/v4l/master/v4l/vp27smpx.mod.o
  CC      /home/v4l/master/v4l/vpx3220.mod.o
  CC      /home/v4l/master/v4l/w9966.mod.o
  CC      /home/v4l/master/v4l/w9968cf.mod.o
  CC      /home/v4l/master/v4l/wm8739.mod.o
  CC      /home/v4l/master/v4l/wm8775.mod.o
  CC      /home/v4l/master/v4l/xc5000.mod.o
  CC      /home/v4l/master/v4l/zc0301.mod.o
  CC      /home/v4l/master/v4l/zl10353.mod.o
  CC      /home/v4l/master/v4l/zr36016.mod.o
  CC      /home/v4l/master/v4l/zr36050.mod.o
  CC      /home/v4l/master/v4l/zr36060.mod.o
  CC      /home/v4l/master/v4l/zr36067.mod.o
  CC      /home/v4l/master/v4l/zr364xx.mod.o
  LD [M]  /home/v4l/master/v4l/adv7170.ko
  LD [M]  /home/v4l/master/v4l/adv7175.ko
  LD [M]  /home/v4l/master/v4l/af9013.ko
  LD [M]  /home/v4l/master/v4l/au0828.ko
  LD [M]  /home/v4l/master/v4l/b2c2-flexcop-pci.ko
  LD [M]  /home/v4l/master/v4l/b2c2-flexcop-usb.ko
  LD [M]  /home/v4l/master/v4l/au8522.ko
  LD [M]  /home/v4l/master/v4l/b2c2-flexcop.ko
  LD [M]  /home/v4l/master/v4l/bcm3510.ko
  LD [M]  /home/v4l/master/v4l/bt819.ko
  LD [M]  /home/v4l/master/v4l/bt878.ko
  LD [M]  /home/v4l/master/v4l/btcx-risc.ko
  LD [M]  /home/v4l/master/v4l/bttv.ko
  LD [M]  /home/v4l/master/v4l/budget-av.ko
  LD [M]  /home/v4l/master/v4l/bt866.ko
  LD [M]  /home/v4l/master/v4l/budget-ci.ko
  LD [M]  /home/v4l/master/v4l/budget.ko
  LD [M]  /home/v4l/master/v4l/budget-core.ko
  LD [M]  /home/v4l/master/v4l/bw-qcam.ko
  LD [M]  /home/v4l/master/v4l/budget-patch.ko
  LD [M]  /home/v4l/master/v4l/c-qcam.ko
  LD [M]  /home/v4l/master/v4l/cafe_ccic.ko
  LD [M]  /home/v4l/master/v4l/cpia.ko
  LD [M]  /home/v4l/master/v4l/cpia_pp.ko
  LD [M]  /home/v4l/master/v4l/cpia_usb.ko
  LD [M]  /home/v4l/master/v4l/cs5345.ko
  LD [M]  /home/v4l/master/v4l/cs53l32a.ko
  LD [M]  /home/v4l/master/v4l/cx18.ko
  LD [M]  /home/v4l/master/v4l/cx22700.ko
  LD [M]  /home/v4l/master/v4l/cx22702.ko
  LD [M]  /home/v4l/master/v4l/cx2341x.ko
  LD [M]  /home/v4l/master/v4l/cx23885.ko
  LD [M]  /home/v4l/master/v4l/cx24110.ko
  LD [M]  /home/v4l/master/v4l/cpia2.ko
  LD [M]  /home/v4l/master/v4l/cx24113.ko
  LD [M]  /home/v4l/master/v4l/cx24116.ko
  LD [M]  /home/v4l/master/v4l/bt856.ko
  LD [M]  /home/v4l/master/v4l/cx24123.ko
  LD [M]  /home/v4l/master/v4l/cx88-alsa.ko
  LD [M]  /home/v4l/master/v4l/cx25840.ko
  LD [M]  /home/v4l/master/v4l/cx88-blackbird.ko
  LD [M]  /home/v4l/master/v4l/cx88-vp3054-i2c.ko
  LD [M]  /home/v4l/master/v4l/cx8800.ko
  LD [M]  /home/v4l/master/v4l/cx88-dvb.ko
  LD [M]  /home/v4l/master/v4l/cx8802.ko
  LD [M]  /home/v4l/master/v4l/cx88xx.ko
  LD [M]  /home/v4l/master/v4l/dib0070.ko
  LD [M]  /home/v4l/master/v4l/dabusb.ko
  LD [M]  /home/v4l/master/v4l/dib3000mb.ko
  LD [M]  /home/v4l/master/v4l/dib3000mc.ko
  LD [M]  /home/v4l/master/v4l/dib7000m.ko
  LD [M]  /home/v4l/master/v4l/dib7000p.ko
  LD [M]  /home/v4l/master/v4l/dibx000_common.ko
  LD [M]  /home/v4l/master/v4l/dm1105.ko
  LD [M]  /home/v4l/master/v4l/drx397xD.ko
  LD [M]  /home/v4l/master/v4l/dsbr100.ko
  LD [M]  /home/v4l/master/v4l/dst.ko
  LD [M]  /home/v4l/master/v4l/dvb-bt8xx.ko
  LD [M]  /home/v4l/master/v4l/dvb-core.ko
  LD [M]  /home/v4l/master/v4l/dst_ca.ko
  LD [M]  /home/v4l/master/v4l/dvb-pll.ko
  LD [M]  /home/v4l/master/v4l/dvb-ttpci.ko
  LD [M]  /home/v4l/master/v4l/dvb-ttusb-budget.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-a800.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-af9005-remote.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-af9005.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-af9015.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-anysee.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-au6610.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-cinergyT2.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-cxusb.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-dibusb-common.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-dibusb-mb.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-dibusb-mc.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-dib0700.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-digitv.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-dtt200u.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-dtv5100.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-gl861.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-dw2102.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-m920x.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-nova-t-usb2.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-ttusb2.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-opera.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-gp8psk.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-umt-010.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-vp702x.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb-vp7045.ko
  LD [M]  /home/v4l/master/v4l/dvb-usb.ko
  LD [M]  /home/v4l/master/v4l/dvb_dummy_fe.ko
  LD [M]  /home/v4l/master/v4l/em28xx-alsa.ko
  LD [M]  /home/v4l/master/v4l/em28xx-dvb.ko
  LD [M]  /home/v4l/master/v4l/em28xx.ko
  LD [M]  /home/v4l/master/v4l/et61x251.ko
  LD [M]  /home/v4l/master/v4l/gspca_conex.ko
  LD [M]  /home/v4l/master/v4l/gspca_etoms.ko
  LD [M]  /home/v4l/master/v4l/gspca_finepix.ko
  LD [M]  /home/v4l/master/v4l/gspca_m5602.ko
  LD [M]  /home/v4l/master/v4l/gspca_main.ko
  LD [M]  /home/v4l/master/v4l/gspca_ov519.ko
  LD [M]  /home/v4l/master/v4l/gspca_ov534.ko
  LD [M]  /home/v4l/master/v4l/gspca_mars.ko
  LD [M]  /home/v4l/master/v4l/gspca_pac207.ko
  LD [M]  /home/v4l/master/v4l/gspca_pac7311.ko
  LD [M]  /home/v4l/master/v4l/gspca_sonixb.ko
  LD [M]  /home/v4l/master/v4l/gspca_sonixj.ko
  LD [M]  /home/v4l/master/v4l/gspca_spca500.ko
  LD [M]  /home/v4l/master/v4l/gspca_spca501.ko
  LD [M]  /home/v4l/master/v4l/gspca_spca505.ko
  LD [M]  /home/v4l/master/v4l/gspca_spca506.ko
  LD [M]  /home/v4l/master/v4l/gspca_spca508.ko
  LD [M]  /home/v4l/master/v4l/gspca_spca561.ko
  LD [M]  /home/v4l/master/v4l/gspca_stk014.ko
  LD [M]  /home/v4l/master/v4l/gspca_stv06xx.ko
  LD [M]  /home/v4l/master/v4l/gspca_sunplus.ko
  LD [M]  /home/v4l/master/v4l/gspca_t613.ko
  LD [M]  /home/v4l/master/v4l/gspca_tv8532.ko
  LD [M]  /home/v4l/master/v4l/gspca_vc032x.ko
  LD [M]  /home/v4l/master/v4l/gspca_zc3xx.ko
  LD [M]  /home/v4l/master/v4l/hexium_gemini.ko
  LD [M]  /home/v4l/master/v4l/hexium_orion.ko
  LD [M]  /home/v4l/master/v4l/ibmcam.ko
  LD [M]  /home/v4l/master/v4l/ir-common.ko
  LD [M]  /home/v4l/master/v4l/ir-kbd-i2c.ko
  LD [M]  /home/v4l/master/v4l/isl6405.ko
  LD [M]  /home/v4l/master/v4l/isl6421.ko
  LD [M]  /home/v4l/master/v4l/itd1000.ko
  LD [M]  /home/v4l/master/v4l/ivtv.ko
  LD [M]  /home/v4l/master/v4l/ivtvfb.ko
  LD [M]  /home/v4l/master/v4l/konicawc.ko
  LD [M]  /home/v4l/master/v4l/ks0127.ko
  LD [M]  /home/v4l/master/v4l/l64781.ko
  LD [M]  /home/v4l/master/v4l/lgdt3304.ko
  LD [M]  /home/v4l/master/v4l/lgdt330x.ko
  LD [M]  /home/v4l/master/v4l/lgs8gl5.ko
  LD [M]  /home/v4l/master/v4l/lnbp21.ko
  LD [M]  /home/v4l/master/v4l/msp3400.ko
  LD [M]  /home/v4l/master/v4l/mt2060.ko
  LD [M]  /home/v4l/master/v4l/m52790.ko
  LD [M]  /home/v4l/master/v4l/mt20xx.ko
  LD [M]  /home/v4l/master/v4l/mt2266.ko
  LD [M]  /home/v4l/master/v4l/mt2131.ko
  LD [M]  /home/v4l/master/v4l/mt312.ko
  LD [M]  /home/v4l/master/v4l/mt352.ko
  LD [M]  /home/v4l/master/v4l/mt9m001.ko
  LD [M]  /home/v4l/master/v4l/mt9m111.ko
  LD [M]  /home/v4l/master/v4l/mt9t031.ko
  LD [M]  /home/v4l/master/v4l/mxl5005s.ko
  LD [M]  /home/v4l/master/v4l/mxl5007t.ko
  LD [M]  /home/v4l/master/v4l/mxb.ko
  LD [M]  /home/v4l/master/v4l/nxt200x.ko
  LD [M]  /home/v4l/master/v4l/nxt6000.ko
  LD [M]  /home/v4l/master/v4l/or51132.ko
  LD [M]  /home/v4l/master/v4l/or51211.ko
  LD [M]  /home/v4l/master/v4l/ov511.ko
  LD [M]  /home/v4l/master/v4l/ov7670.ko
  LD [M]  /home/v4l/master/v4l/ov772x.ko
  LD [M]  /home/v4l/master/v4l/ovcamchip.ko
  LD [M]  /home/v4l/master/v4l/pluto2.ko
  LD [M]  /home/v4l/master/v4l/pvrusb2.ko
  LD [M]  /home/v4l/master/v4l/qt1010.ko
  LD [M]  /home/v4l/master/v4l/quickcam_messenger.ko
  LD [M]  /home/v4l/master/v4l/pwc.ko
  LD [M]  /home/v4l/master/v4l/radio-gemtek-pci.ko
  LD [M]  /home/v4l/master/v4l/radio-maestro.ko
  LD [M]  /home/v4l/master/v4l/radio-maxiradio.ko
  LD [M]  /home/v4l/master/v4l/radio-mr800.ko
  LD [M]  /home/v4l/master/v4l/radio-si470x.ko
  LD [M]  /home/v4l/master/v4l/radio-tea5764.ko
  LD [M]  /home/v4l/master/v4l/s2255drv.ko
  LD [M]  /home/v4l/master/v4l/s5h1409.ko
  LD [M]  /home/v4l/master/v4l/s5h1411.ko
  LD [M]  /home/v4l/master/v4l/s5h1420.ko
  LD [M]  /home/v4l/master/v4l/s921.ko
  LD [M]  /home/v4l/master/v4l/saa5246a.ko
  LD [M]  /home/v4l/master/v4l/saa5249.ko
  LD [M]  /home/v4l/master/v4l/saa6752hs.ko
  LD [M]  /home/v4l/master/v4l/saa6588.ko
  LD [M]  /home/v4l/master/v4l/saa7110.ko
  LD [M]  /home/v4l/master/v4l/saa7111.ko
  LD [M]  /home/v4l/master/v4l/saa7114.ko
  LD [M]  /home/v4l/master/v4l/saa7115.ko
  LD [M]  /home/v4l/master/v4l/saa7127.ko
  LD [M]  /home/v4l/master/v4l/saa7134-alsa.ko
  LD [M]  /home/v4l/master/v4l/saa7134-dvb.ko
  LD [M]  /home/v4l/master/v4l/saa7134-empress.ko
  LD [M]  /home/v4l/master/v4l/saa7146.ko
  LD [M]  /home/v4l/master/v4l/saa7134.ko
  LD [M]  /home/v4l/master/v4l/saa7146_vv.ko
  LD [M]  /home/v4l/master/v4l/saa717x.ko
  LD [M]  /home/v4l/master/v4l/saa7185.ko
  LD [M]  /home/v4l/master/v4l/saa7191.ko
  LD [M]  /home/v4l/master/v4l/se401.ko
  LD [M]  /home/v4l/master/v4l/si21xx.ko
  LD [M]  /home/v4l/master/v4l/sms1xxx.ko
  LD [M]  /home/v4l/master/v4l/sn9c102.ko
  LD [M]  /home/v4l/master/v4l/snd-bt87x.ko
  LD [M]  /home/v4l/master/v4l/snd-tea575x-tuner.ko
  LD [M]  /home/v4l/master/v4l/soc_camera.ko
  LD [M]  /home/v4l/master/v4l/soc_camera_platform.ko
  LD [M]  /home/v4l/master/v4l/sp8870.ko
  LD [M]  /home/v4l/master/v4l/sp887x.ko
  LD [M]  /home/v4l/master/v4l/stb0899.ko
  LD [M]  /home/v4l/master/v4l/stb6000.ko
  LD [M]  /home/v4l/master/v4l/stb6100.ko
  LD [M]  /home/v4l/master/v4l/stkwebcam.ko
  LD [M]  /home/v4l/master/v4l/stradis.ko
  LD [M]  /home/v4l/master/v4l/stv0288.ko
  LD [M]  /home/v4l/master/v4l/stv0297.ko
  LD [M]  /home/v4l/master/v4l/stv0299.ko
  LD [M]  /home/v4l/master/v4l/stv680.ko
  LD [M]  /home/v4l/master/v4l/tcm825x.ko
  LD [M]  /home/v4l/master/v4l/tda10021.ko
  LD [M]  /home/v4l/master/v4l/tda10048.ko
  LD [M]  /home/v4l/master/v4l/tda10023.ko
  LD [M]  /home/v4l/master/v4l/tda1004x.ko
  LD [M]  /home/v4l/master/v4l/tda10086.ko
  LD [M]  /home/v4l/master/v4l/tda18271.ko
  LD [M]  /home/v4l/master/v4l/tda7432.ko
  LD [M]  /home/v4l/master/v4l/tda8083.ko
  LD [M]  /home/v4l/master/v4l/tda8261.ko
  LD [M]  /home/v4l/master/v4l/tda826x.ko
  LD [M]  /home/v4l/master/v4l/tda827x.ko
  LD [M]  /home/v4l/master/v4l/tda8290.ko
  LD [M]  /home/v4l/master/v4l/tda9840.ko
  LD [M]  /home/v4l/master/v4l/tda9875.ko
  LD [M]  /home/v4l/master/v4l/tda9887.ko
  LD [M]  /home/v4l/master/v4l/tea5761.ko
  LD [M]  /home/v4l/master/v4l/tea5767.ko
  LD [M]  /home/v4l/master/v4l/tea6415c.ko
  LD [M]  /home/v4l/master/v4l/tea6420.ko
  LD [M]  /home/v4l/master/v4l/tlv320aic23b.ko
  LD [M]  /home/v4l/master/v4l/ttpci-eeprom.ko
  LD [M]  /home/v4l/master/v4l/ttusb_dec.ko
  LD [M]  /home/v4l/master/v4l/ttusbdecfe.ko
  LD [M]  /home/v4l/master/v4l/tua6100.ko
  LD [M]  /home/v4l/master/v4l/tuner-simple.ko
  LD [M]  /home/v4l/master/v4l/tuner-types.ko
  LD [M]  /home/v4l/master/v4l/tuner-xc2028.ko
  LD [M]  /home/v4l/master/v4l/tuner.ko
  LD [M]  /home/v4l/master/v4l/tvaudio.ko
  LD [M]  /home/v4l/master/v4l/tvp514x.ko
  LD [M]  /home/v4l/master/v4l/tveeprom.ko
  LD [M]  /home/v4l/master/v4l/tvp5150.ko
  LD [M]  /home/v4l/master/v4l/tw9910.ko
  LD [M]  /home/v4l/master/v4l/ultracam.ko
  LD [M]  /home/v4l/master/v4l/upd64031a.ko
  LD [M]  /home/v4l/master/v4l/upd64083.ko
  LD [M]  /home/v4l/master/v4l/usbvideo.ko
  LD [M]  /home/v4l/master/v4l/usbvision.ko
  LD [M]  /home/v4l/master/v4l/uvcvideo.ko
  LD [M]  /home/v4l/master/v4l/v4l1-compat.ko
  LD [M]  /home/v4l/master/v4l/v4l2-common.ko
  LD [M]  /home/v4l/master/v4l/v4l2-int-device.ko
  LD [M]  /home/v4l/master/v4l/ves1820.ko
  LD [M]  /home/v4l/master/v4l/v4l2-compat-ioctl32.ko
  LD [M]  /home/v4l/master/v4l/ves1x93.ko
  LD [M]  /home/v4l/master/v4l/vicam.ko
  LD [M]  /home/v4l/master/v4l/videobuf-core.ko
  LD [M]  /home/v4l/master/v4l/videobuf-dma-contig.ko
  LD [M]  /home/v4l/master/v4l/videobuf-dma-sg.ko
  LD [M]  /home/v4l/master/v4l/videobuf-dvb.ko
  LD [M]  /home/v4l/master/v4l/videobuf-vmalloc.ko
  LD [M]  /home/v4l/master/v4l/videocodec.ko
  LD [M]  /home/v4l/master/v4l/videodev.ko
  LD [M]  /home/v4l/master/v4l/vivi.ko
  LD [M]  /home/v4l/master/v4l/vp27smpx.ko
  LD [M]  /home/v4l/master/v4l/vpx3220.ko
  LD [M]  /home/v4l/master/v4l/w9966.ko
  LD [M]  /home/v4l/master/v4l/wm8739.ko
  LD [M]  /home/v4l/master/v4l/w9968cf.ko
  LD [M]  /home/v4l/master/v4l/wm8775.ko
  LD [M]  /home/v4l/master/v4l/xc5000.ko
  LD [M]  /home/v4l/master/v4l/zc0301.ko
  LD [M]  /home/v4l/master/v4l/zl10353.ko
  LD [M]  /home/v4l/master/v4l/zr36016.ko
  LD [M]  /home/v4l/master/v4l/zr36050.ko
  LD [M]  /home/v4l/master/v4l/zr36060.ko
  LD [M]  /home/v4l/master/v4l/zr36067.ko
  LD [M]  /home/v4l/master/v4l/zr364xx.ko
make[2]: Leaving directory `/usr/src/kernels/v2.6.28'
./scripts/rmmod.pl check
found 280 modules
make[1]: Saindo do diret=F3rio `/home/v4l/master/v4l'


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
