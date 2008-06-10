Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5A8fOks031259
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 04:41:24 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5A8eWpU016004
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 04:40:32 -0400
Received: from mail-in-06-z2.arcor-online.net (mail-in-06-z2.arcor-online.net
	[151.189.8.18])
	by mail-in-17.arcor-online.net (Postfix) with ESMTP id 45C7330E841
	for <video4linux-list@redhat.com>;
	Tue, 10 Jun 2008 10:40:31 +0200 (CEST)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mail-in-06-z2.arcor-online.net (Postfix) with ESMTP id 2E8A25BD6D
	for <video4linux-list@redhat.com>;
	Tue, 10 Jun 2008 10:40:31 +0200 (CEST)
Received: from [192.168.0.2] (e177035082.adsl.alicedsl.de [85.177.35.82])
	(Authenticated sender: robertherb@arcor.de)
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id 91D8D36E89C
	for <video4linux-list@redhat.com>;
	Tue, 10 Jun 2008 10:40:30 +0200 (CEST)
Message-ID: <484E3DFD.2080304@freenet.de>
Date: Tue, 10 Jun 2008 10:40:29 +0200
From: Robert Herb <proletheus@freenet.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: v4l-dvb compiling errors with kernel 2.6.25
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

since i've updated my kernel to 2.6.25, I always get the following 
errors, when i try to compile. Is this caused by my system or by the 
source-code? Can you help me?

My system:
openSUSE 10.3
kernel: 2.6.25.4-14-Intel
TV-Card: Hauppauge WinTV Hvr 1300

The Error:
10:29 RossTheBoss:../Rpms+Sources/v4l-dvb > make
make -C /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l
make[1]: Entering directory 
`/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l'
No version yet, using 2.6.25.4-14-Intel
make[1]: Leaving directory `/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l'
make[1]: Entering directory 
`/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.25
VIDEO_PLANB: Requires at least kernel 2.6.99
Created default (all yes) .config file
./scripts/make_myconfig.pl
make[1]: Leaving directory `/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l'
make[1]: Entering directory 
`/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.25.4-14-Intel/source 
./.myconfig ./config-compat.h
creating symbolic links...
ln -sf . oss
Kernel build directory is /lib/modules/2.6.25.4-14-Intel/build
make -C /lib/modules/2.6.25.4-14-Intel/build 
SUBDIRS=/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.25.4-14'
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tuner-xc2028.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tuner-simple.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tuner-types.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/mt20xx.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tda8290.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tea5767.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tea5761.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tda9887.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tda827x.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/au0828-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/au0828-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/au0828-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/au0828-dvb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-pci.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-usb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-fe-tuner.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-sram.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-eeprom.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-misc.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-hw-filter.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/flexcop-dma.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-driver.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-if.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-risc.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-gpio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-input.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bttv-audio-hook.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cpia2_v4l.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cpia2_usb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cpia2_core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-driver.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-firmware.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-gpio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-queue.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-streams.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-fileops.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-ioctl.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-controls.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-mailbox.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-audio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-video.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-irq.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-av-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-av-audio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-av-firmware.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-av-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-scb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx18-dvb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx23885-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx23885-video.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx23885-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx23885-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx23885-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx23885-dvb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx23885-417.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx25840-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx25840-audio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx25840-firmware.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx25840-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-video.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-mpeg.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-tvaudio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cx88-input.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvbdev.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dmxdev.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb_demux.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb_filter.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb_ca_en50221.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb_frontend.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb_net.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb_ringbuffer.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb_math.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/av7110_hw.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/av7110_v4l.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/av7110_av.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/av7110_ca.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/av7110.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/av7110_ipack.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/av7110_ir.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/a800.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/af9005-remote.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/af9005.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/af9005-fe.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/anysee.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/au6610.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/cxusb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dib0700_core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dib0700_devices.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dibusb-common.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dibusb-mb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dibusb-mc.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/digitv.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dtt200u.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dtt200u-fe.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/gl861.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/gp8psk.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/gp8psk-fe.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/m920x.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/nova-t-usb2.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/opera1.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ttusb2.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/umt-010.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/vp702x.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/vp702x-fe.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/vp7045.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/vp7045-fe.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb-usb-firmware.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb-usb-init.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb-usb-urb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb-usb-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb-usb-dvb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/dvb-usb-remote.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/usb-urb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/em28xx-audio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/em28xx-video.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/em28xx-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/em28xx-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/em28xx-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/em28xx-input.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/et61x251_core.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/et61x251_tas5130d1b.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ir-functions.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ir-keymaps.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-routing.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-controls.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-driver.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-fileops.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-firmware.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-gpio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-ioctl.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-irq.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-mailbox.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-queue.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-streams.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-udma.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ivtv-yuv.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/msp3400-driver.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/msp3400-kthreads.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ovcamchip_core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ov6x20.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ov6x30.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ov7x10.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ov7x20.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/ov76be.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-i2c-core.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-i2c-cmd-v4l2.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-audio.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-i2c-chips-v4l2.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-encoder.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-video-v4l.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-eeprom.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-tuner.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-main.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-hdw.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-v4l2.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-ctrl.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-std.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-devattr.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-context.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-io.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-ioread.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-cx2584x-v4l.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-wm8775.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-dvb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-sysfs.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pvrusb2-debugifc.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-if.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-misc.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-ctrl.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-v4l.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-uncompress.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-dec1.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-dec23.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-kiara.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/pwc-timon.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-ts.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-tvaudio.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-video.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7134-input.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7146_i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7146_core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7146_fops.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7146_video.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7146_hlp.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/saa7146_vbi.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_hv7131d.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_hv7131r.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_mi0343.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_mi0360.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_mt9v111.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_ov7630.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_ov7660.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_pas106b.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_pas202bcb.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_tas5110c1b.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_tas5110d.o
  CC [M]  
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/sn9c102_tas5130d1b.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/bt87x.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tea575x-tuner.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/stk-webcam.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/stk-sensor.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tda18271-maps.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tda18271-common.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tda18271-fe.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/tuner-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/usbvision-core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/usbvision-video.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/usbvision-i2c.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/usbvision-cards.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zc0301_core.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zc0301_pb0330.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zc0301_pas202bcb.o
  CC [M]  /home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zoran_procfs.o
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zoran_procfs.c: In 
function 'zoran_proc_init':
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zoran_procfs.c:208: 
error: implicit declaration of function 'proc_create_data'
/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zoran_procfs.c:208: 
warning: assignment makes pointer from integer without a cast
make[3]: *** 
[/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l/zoran_procfs.o] Error 1
make[2]: *** [_module_/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l] 
Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.25.4-14'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/home/Herbie/Programme/Rpms+Sources/v4l-dvb/v4l'
make: *** [all] Fehler 2

With my last kernel 2.6.23.xx it was always compiled without errors.

Greetings
Herbie


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
