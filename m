Return-path: <linux-media-owner@vger.kernel.org>
Received: from ntc-mta1.newtec.eu ([62.58.98.207]:35188 "EHLO
	ntc-mta1.newtec.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab0CXPUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 11:20:06 -0400
Received: from localhost (unknown [127.0.0.1])
	by ntc-mta1.newtec.eu (Postfix) with ESMTP id 96FC924806B
	for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 16:10:42 +0100 (CET)
Received: from ntc-mta1.newtec.eu ([127.0.0.1])
	by localhost (ntc-mta1.newtec.eu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p+uvx6+e+Fwc for <linux-media@vger.kernel.org>;
	Wed, 24 Mar 2010 16:10:41 +0100 (CET)
Received: from ntc-mailstore.newtec.eu (ntc-mailstore1.newtec.eu [192.168.2.241])
	by ntc-mta1.newtec.eu (Postfix) with ESMTP id D4B23248067
	for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 16:10:41 +0100 (CET)
Date: Wed, 24 Mar 2010 16:10:41 +0100 (CET)
From: luc.boschmans@newtec.eu
To: linux-media@vger.kernel.org
Message-ID: <1080174267.162141269443441472.JavaMail.root@ntc-mailstore1.newtec.eu>
In-Reply-To: <1053716919.162031269443370641.JavaMail.root@ntc-mailstore1.newtec.eu>
Subject: PCTV 73eSE driver not loaded
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_8120_248199763.1269443441400"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_8120_248199763.1269443441400
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-NAIMIME-Disclaimer: 1
X-NAIMIME-Modified: 1


All,

I am a Linux newbie trying to install a PCTV 73eSE DVB-T receiver, but th=
e driver apparently does not get loaded.

These are the 'cookbook' steps I followed:
-Fresh Ubuntu 9.10 distribution installed.
-kernel upgraded to 2.6.31-20-generic (using Ubuntu upgrade tool)
-Mercurial installed
-V4L-DVB kernel modules downloaded (source)
-make (screen output attached)
-make install
-reboot (with the DVB-T USB dongle attached during boot)

Outcome:
-There is no /dev/dvb directory
-/proc/modules does not list any relevant reference to the PCTV 73eSE USB=
 dongle (apparently the correct driver for that should be the DIB0700 dri=
ver)

Looking at the mailing list, there is some history on the PCTV 73eSE devi=
ce: apparently this was originally owned by Pinnacle; the same device can=
 have 2 different manuf ID's. Posts on the list (nov / dec 2009) point ou=
t that corrections have been done to support both manuf ID's.

The relevant lsusb -v output is:

Bus 001 Device 003: ID 2013:0245 =20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x2013=20
  idProduct          0x0245=20
  bcdDevice            1.00
  iManufacturer           1 PCTV Systems
  iProduct                2 PCTV 73e SE
  iSerial                 3 0000000M99B4P6Q
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0=20
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

The vendor ID in my case apparently is 0x2013. I am able to find back thi=
s ID in the source files (but I am not a programmer), so it looks as if t=
his is not the reason why the driver doens't get loaded. Nevertheless, th=
e 'automagic' part of udev seems to have abandoned me:)

Any idea's to proceed on this?

Thanks in advance,
Luc Boschmans.








Newtec=E2=80=99s MENOS system awarded IBC Innovation Award for Content De=
livery & the IBC Judges=E2=80=99 Award  Newtec=E2=80=99s FlexACM awarded =
2009 Teleport Technology of the Year by WTA  *** e-mail confidentiality f=
ooter *** This message and any attachments thereto are confidential. They=
 may also be privileged or otherwise protected by work product immunity o=
r other legal rules. If you have received it by mistake, please let us kn=
ow by e-mail reply and delete it from your system; you may not copy this =
message or disclose its contents to anyone. E-mail transmission cannot be=
 guaranteed to be secure or error free as information could be intercepte=
d, corrupted, lost, destroyed, arrive late or incomplete, or contain viru=
ses. The sender therefore is in no way liable for any errors or omissions=
 in the content of this message, which may arise as a result of e-mail tr=
ansmission. If verification is required, please request a hard copy.

------=_Part_8120_248199763.1269443441400
Content-Type: text/plain; name=outputMake.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=outputMake.txt

make -C /home/mediacenter/v4l-dvb/v4l 
make[1]: Entering directory `/home/mediacenter/v4l-dvb/v4l'
No version yet, using 2.6.31-20-generic
make[1]: Leaving directory `/home/mediacenter/v4l-dvb/v4l'
make[1]: Entering directory `/home/mediacenter/v4l-dvb/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.31

***WARNING:*** You do not have the full kernel sources installed.
This does not prevent you from building the v4l-dvb tree if you have the
kernel headers, but the full kernel source may be required in order to use
make menuconfig / xconfig / qconfig.

If you are experiencing problems building the v4l-dvb tree, please try
building against a vanilla kernel before reporting a bug.

Vanilla kernels are available at http://kernel.org.
On most distros, this will compile a newly downloaded kernel:

cp /boot/config-`uname -r` <your kernel dir>/.config
cd <your kernel dir>
make all modules_install install

Please see your distro's web site for instructions to build a new kernel.

VIDEO_TVP7002: Requires at least kernel 2.6.34
SOC_CAMERA: Requires at least kernel 2.6.33
SOC_CAMERA_MT9M001: Requires at least kernel 2.6.33
SOC_CAMERA_MT9M111: Requires at least kernel 2.6.33
SOC_CAMERA_MT9T031: Requires at least kernel 2.6.33
SOC_CAMERA_MT9V022: Requires at least kernel 2.6.33
SOC_CAMERA_TW9910: Requires at least kernel 2.6.33
SOC_CAMERA_PLATFORM: Requires at least kernel 2.6.33
SOC_CAMERA_OV772X: Requires at least kernel 2.6.33
VIDEO_PXA27x: Requires at least kernel 2.6.32
VIDEO_SH_MOBILE_CEU: Requires at least kernel 2.6.32
VIDEO_TLG2300: Requires at least kernel 2.6.32
RADIO_SAA7706H: Requires at least kernel 2.6.34
Created default (all yes) .config file
./scripts/make_myconfig.pl
make[1]: Leaving directory `/home/mediacenter/v4l-dvb/v4l'
make[1]: Entering directory `/home/mediacenter/v4l-dvb/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.31-20-generic/build ./.myconfig ./config-compat.h
creating symbolic links...
ln -sf . oss
make -C firmware prep
make[2]: Entering directory `/home/mediacenter/v4l-dvb/v4l/firmware'
make[2]: Leaving directory `/home/mediacenter/v4l-dvb/v4l/firmware'
make -C firmware
make[2]: Entering directory `/home/mediacenter/v4l-dvb/v4l/firmware'
  CC  ihex2fw
Generating vicam/firmware.fw
Generating dabusb/firmware.fw
Generating dabusb/bitstream.bin
Generating ttusb-budget/dspbootcode.bin
Generating cpia2/stv0672_vp4.bin
Generating av7110/bootcode.bin
make[2]: Leaving directory `/home/mediacenter/v4l-dvb/v4l/firmware'
Kernel build directory is /lib/modules/2.6.31-20-generic/build
make -C /lib/modules/2.6.31-20-generic/build SUBDIRS=/home/mediacenter/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.31-20-generic'
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tuner-xc2028.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tuner-simple.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tuner-types.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/mt20xx.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tda8290.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tea5767.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tea5761.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tda9887.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/tda827x.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au0828-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au0828-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au0828-cards.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au0828-dvb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au0828-video.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au8522_dig.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au8522_decoder.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-pci.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-usb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-fe-tuner.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-sram.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-eeprom.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-misc.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-hw-filter.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/flexcop-dma.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-driver.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-cards.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-if.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-risc.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-gpio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-input.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/bttv-audio-hook.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cpia2_v4l.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cpia2_usb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cpia2_core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-alsa-main.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-alsa-pcm.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-driver.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-cards.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-firmware.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-gpio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-queue.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-streams.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-fileops.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-ioctl.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-controls.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-mailbox.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-audio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-video.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-irq.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-av-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-av-audio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-av-firmware.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-av-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-scb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-dvb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx18-io.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-audio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-video.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-cards.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-avcore.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-pcb-cfg.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx231xx-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-cards.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-video.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-dvb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-417.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-ioctl.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-ir.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-input.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23888-ir.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/netup-init.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cimax2.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/netup-eeprom.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx23885-f300.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx25840-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx25840-audio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx25840-firmware.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx25840-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-video.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-mpeg.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-cards.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-tvaudio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-dsp.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cx88-input.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvbdev.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dmxdev.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb_demux.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb_filter.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb_ca_en50221.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb_frontend.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb_net.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb_ringbuffer.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb_math.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/av7110_hw.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/av7110_v4l.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/av7110_av.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/av7110_ca.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/av7110.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/av7110_ipack.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/av7110_ir.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/a800.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/af9005-remote.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/af9005.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/af9005-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/af9015.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/anysee.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/au6610.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/az6027.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/ce6230.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cinergyT2-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cinergyT2-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/cxusb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dib0700_core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dib0700_devices.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dibusb-common.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dibusb-mb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dibusb-mc.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/digitv.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dtt200u.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dtt200u-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dtv5100.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dw2102.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/ec168.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/friio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/friio-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/gl861.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/gp8psk.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/gp8psk-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/m920x.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/nova-t-usb2.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/opera1.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/ttusb2.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/umt-010.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/vp702x.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/vp702x-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/vp7045.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/vp7045-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb-usb-firmware.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb-usb-init.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb-usb-urb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb-usb-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb-usb-dvb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/dvb-usb-remote.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/usb-urb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/pt1.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/va1j5jf8007s.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/va1j5jf8007t.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/em28xx-audio.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/em28xx-video.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/em28xx-i2c.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/em28xx-cards.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/em28xx-core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/em28xx-input.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/em28xx-vbi.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/et61x251_core.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/et61x251_tas5130d1b.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/firedtv-avc.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/firedtv-ci.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/firedtv-dvb.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/firedtv-fe.o
  CC [M]  /home/mediacenter/v4l-dvb/v4l/firedtv-1394.o
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-20-generic'
make[1]: Leaving directory `/home/mediacenter/v4l-dvb/v4l'

------=_Part_8120_248199763.1269443441400--
