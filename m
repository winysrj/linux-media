Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:54752 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751521AbdIUH60 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 03:58:26 -0400
Received: from pide.tip.net.au (pide.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 3xyTN20RcmzFt0L
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 17:52:02 +1000 (AEST)
Received: from e4.eyal.emu.id.au (124-171-202-151.dyn.iinet.net.au [124.171.202.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pide.tip.net.au (Postfix) with ESMTPSA id 3xyTN16hp0z97R4
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 17:52:01 +1000 (AEST)
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Hauppauge Nova-TD Stick fails on f26
To: list linux-media <linux-media@vger.kernel.org>
Message-ID: <112b92fe-5842-5aed-93db-3c2679c3d50f@eyal.emu.id.au>
Date: Thu, 21 Sep 2017 17:52:01 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an unusual problem with this tuner. On my workstation (f26) it works fine and I can watch
TV using vlc or tune with tzap.

On my mythtv server (which was recently upgraded to f26) the card does not work. An adapter is not created
in /dev/dvb.

The server has a few other tuners and it may be some interference causing the failure, but the reason
is beyond me.

This is what is loaded after the tuner is plugged in:

$ sudo lsmod|grep dvb
dvb_usb_dib0700       151552  0
dib7000m               24576  1 dvb_usb_dib0700
dib0090                40960  1 dvb_usb_dib0700
dib0070                20480  1 dvb_usb_dib0700
dib3000mc              20480  1 dvb_usb_dib0700
dibx000_common         16384  4 dib7000p,dvb_usb_dib0700,dib7000m,dib3000mc
dvb_usb                24576  1 dvb_usb_dib0700
dvb_usb_af9035         40960  0
dvb_usb_rtl28xxu       40960  0
dvb_usb_v2             40960  2 dvb_usb_af9035,dvb_usb_rtl28xxu
dvb_core              126976  5 dib7000p,dvb_usb,dvb_usb_v2,rtl2832,af9033
rc_core                36864  16 dvb_usb_af9035,ir_nec_decoder,dvb_usb_dib0700,ir_lirc_codec,dvb_usb,lirc_dev,dvb_usb_v2,nuvoton_cir,dvb_usb_rtl28xxu,rc_leadtek_y04g0051

This is the failure on the server:

kernel: usb 8-2: new high-speed USB device number 3 using xhci_hcd
kernel: usb 8-2: New USB device found, idVendor=2040, idProduct=9580
kernel: usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
kernel: usb 8-2: Product: NovaT 500Stick
kernel: usb 8-2: Manufacturer: Hauppauge
kernel: usb 8-2: SerialNumber: 4027868935
mtp-probe[19770]: checking bus 8, device 3: "/sys/devices/pci0000:00/0000:00:14.0/usb8/8-2"
mtp-probe[19770]: bus: 8, device: 3 was not an MTP device
kernel: dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity' in cold state, will try to load a firmware
kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
kernel: dib0700: firmware started successfully.
kernel: dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity' in warm state.
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
kernel: dvbdev: DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity)
baloo_file[2975]: QObject::connect: invalid null parameter
baloo_file[2975]: QObject::connect: invalid null parameter
baloo_file[2975]: QObject::connect: invalid null parameter
kernel: usb 8-2: DVB: registering adapter 7 frontend 0 (DiBcom 7000PC)...
	### note: /dev/dvb/adapter7 was present for about 1 second and then disappeared
baloo_file[2975]: QObject::connect: invalid null parameter
kernel: MT2266: successfully identified
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
kernel: dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity error while loading driver (-23)
kernel: usbcore: registered new interface driver dvb_usb_dib0700

For comparo, here is a successful result on the workstation:

kernel: usb 2-3: new high-speed USB device number 3 using ehci-pci
kernel: usb 2-3: New USB device found, idVendor=2040, idProduct=9580
kernel: usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
kernel: usb 2-3: Product: NovaT 500Stick
kernel: usb 2-3: Manufacturer: Hauppauge
kernel: usb 2-3: SerialNumber: 4027868935
mtp-probe[17719]: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3"
mtp-probe[17719]: bus: 2, device: 3 was not an MTP device
kernel: dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity' in cold state, will try to load a firmware
kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
kernel: dib0700: firmware started successfully.
kernel: dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity' in warm state.
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
kernel: dvbdev: DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity)
baloo_file[2874]: QObject::connect: invalid null parameter
baloo_file[2874]: QObject::connect: invalid null parameter
baloo_file[2874]: QObject::connect: invalid null parameter
kernel: usb 2-3: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
baloo_file[2874]: QObject::connect: invalid null parameter
kernel: MT2266: successfully identified
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
kernel: dvbdev: DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity)
baloo_file[2874]: QObject::connect: invalid null parameter
baloo_file[2874]: QObject::connect: invalid null parameter
baloo_file[2874]: QObject::connect: invalid null parameter
kernel: usb 2-3: DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
baloo_file[2874]: QObject::connect: invalid null parameter
kernel: MT2266: successfully identified
kernel: rc rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc0
kernel: Registered IR keymap rc-dib0700-rc5
kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc0/input21
kernel: dvb-usb: schedule remote query interval to 50 msecs.
kernel: dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity successfully initialized and connected.
kernel: usbcore: registered new interface driver dvb_usb_dib0700

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
