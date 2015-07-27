Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f44.google.com ([209.85.216.44]:33453 "EHLO
	mail-vn0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbG0Qyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 12:54:54 -0400
Received: by vnav141 with SMTP id v141so33141039vna.0
        for <linux-media@vger.kernel.org>; Mon, 27 Jul 2015 09:54:53 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Jul 2015 18:54:53 +0200
Message-ID: <CAO4ydsTFeZdOCvR+HkRBEKWiAULwzUbB2YRRC5Wdx94rHMSyDw@mail.gmail.com>
Subject: DMX_ADD_PID ioctl problem
From: =?UTF-8?B?TWFyY2luIEthxYJ1xbxh?= <marcin.kaluza@trioptimum.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
I'm trying to use demuxX device for reading multiple PIDs and I have a
problem. I do

f->fd = dvb_dmx_open(inp->adapter, inp->demux);

unsigned short int pid;

res = dvb_set_pesfilter(f->fd, pid, DMX_PES_OTHER,
DMX_OUT_TSDEMUX_TAP, 128*1024);  //that works
pid = another_pid
res = ioctl(f->fd, DMX_ADD_PID, &pid);//that doesn't res == -1, errno = ENOTTY

I'm using usb dongle with rtl2832 chip (it's supposed to have hardware
pid filters). I tried setting force_pid_filter_usage=1 on dvb-usb-v2
module but it doesn't help
dmesg (with force=1:
[ 3365.353154] usb 2-1.3: new high-speed USB device number 11 using ehci-pci
[ 3365.448694] usb 2-1.3: New USB device found, idVendor=1f4d, idProduct=c803
[ 3365.448699] usb 2-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 3365.448702] usb 2-1.3: Product: RTL2838UHIDIR
[ 3365.448704] usb 2-1.3: Manufacturer: Realtek
[ 3365.448706] usb 2-1.3: SerialNumber: 00000001
[ 3365.463475] usb 2-1.3: dvb_usb_v2: found a 'Trekstor DVB-T Stick
Terres 2.0' in warm state
[ 3365.497626] usb 2-1.3: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[ 3365.497631] usb 2-1.3: dvb_usb_v2: PID filter enabled by module option
[ 3365.497643] DVB: registering new adapter (Trekstor DVB-T Stick Terres 2.0)
[ 3365.506816] i2c i2c-10: Added multiplexed i2c bus 11
[ 3365.506820] rtl2832 10-0010: Realtek RTL2832 successfully attached
[ 3365.506829] usb 2-1.3: DVB: registering adapter 0 frontend 0
(Realtek RTL2832 (DVB-T))...
[ 3365.509961] fc0013: Fitipower FC0013 successfully attached.
[ 3365.516415] media: Linux media interface: v0.10
[ 3365.530762] Linux video capture interface: v2.00
[ 3365.542229] rtl2832_sdr rtl2832_sdr.0.auto: Registered as swradio0
[ 3365.542232] rtl2832_sdr rtl2832_sdr.0.auto: Realtek RTL2832 SDR attached
[ 3365.542234] rtl2832_sdr rtl2832_sdr.0.auto: SDR API is still
slightly experimental and functionality changes may follow
[ 3365.548824] Registered IR keymap rc-empty
[ 3365.548901] input: Trekstor DVB-T Stick Terres 2.0 as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/rc/rc0/input20
[ 3365.548938] rc0: Trekstor DVB-T Stick Terres 2.0 as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/rc/rc0
[ 3365.551458] IR NEC protocol handler initialized
[ 3365.552408] IR RC5(x/sz) protocol handler initialized
[ 3365.552868] usb 2-1.3: dvb_usb_v2: schedule remote query interval
to 200 msecs
[ 3365.554114] IR RC6 protocol handler initialized
[ 3365.555287] input: MCE IR Keyboard/Mouse (dvb_usb_rtl28xxu) as
/devices/virtual/input/input21
[ 3365.555419] IR MCE Keyboard/mouse protocol handler initialized
[ 3365.556299] IR JVC protocol handler initialized
[ 3365.556851] IR Sony protocol handler initialized
[ 3365.558365] IR SANYO protocol handler initialized
[ 3365.559217] IR Sharp protocol handler initialized
[ 3365.560860] IR XMP protocol handler initialized
[ 3365.561034] usb 2-1.3: dvb_usb_v2: 'Trekstor DVB-T Stick Terres
2.0' successfully initialized and connected

does the line
[ 3365.497626] usb 2-1.3: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
mean that it won't work and I have to filter in my application?
