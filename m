Return-path: <mchehab@gaivota>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55679 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0L0NrY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 08:47:24 -0500
Received: by qwa26 with SMTP id 26so8474360qwa.19
        for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 05:47:23 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 27 Dec 2010 13:47:23 +0000
Message-ID: <AANLkTikCN7vAwox5PeW8yaX=t9Hav2b_Swru6XfSy66c@mail.gmail.com>
Subject: Hauppauge Nova-T Stick 3 Issues
From: Ray Kinsella <raykinsella78@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

I recently purchased a Hauppauge Nova-T USB DVB-T receiver and have
been having trouble getting it to work.
I read through the Wiki page
(http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-Stick)
for this device and followed the instructions but still no luck.

Most of the time the frontend will fail to attach (as show below), on
the rare occasions when the frontend does attach it will hang when I
try to scan for channels.
In both cases the driver complains of I2C read/write failures.
I am using the latest from code from the V4L-DVB backports repository
with a 2.6.35 Kernel (Mythubuntu 10.10)

Any advice on what to try?

ray@pvr:~$ uname -a
Linux pvr 2.6.35-22-generic #33-Ubuntu SMP Sun Sep 19 20:34:50 UTC
2010 i686 GNU/Linux

ray@pvr:~$ lsusb
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
...
Bus 001 Device 004: ID 2040:7070 Hauppauge Nova-T Stick 3
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

ray@pvr:~$ dmesg
[   18.492014] usb 1-4: new high speed USB device using ehci_hcd and address 4
[   18.653158] WARNING: You're using an experimental version of the
DVB stack. As the driver
[   18.653160]          is backported to an older kernel, it doesn't
offer enough quality for
[   18.653161]          its usage in production.
[   18.653161]          Use it with care.
[   18.667402] dib0700: loaded with support for 14 different device-types
[   18.667425] check for cold 10b8 1e14
[   18.667426] check for cold 10b8 1e78
[   18.667427] check for cold 2040 7050
[   18.667428] check for cold 2040 7060
[   18.667430] check for cold 7ca a807
[   18.667431] check for cold 7ca b808
[   18.667432] check for cold 185b 1e78
[   18.667433] check for cold 185b 1e80
[   18.667434] check for cold 1584 6003
[   18.667436] check for cold 413 6f00
[   18.667437] check for cold 413 6f01
[   18.667438] check for cold 7ca b568
[   18.667439] check for cold 1044 7001
[   18.667440] check for cold 2040 9941
[   18.667441] check for cold 2040 9950
[   18.667443] check for cold 2304 22c
[   18.667444] check for cold ccd 5a
[   18.667445] check for cold 2040 9580
[   18.667446] check for cold 10b8 1ef0
[   18.667447] check for cold 1164 1e8c
[   18.667448] check for cold b05 171f
[   18.667450] check for cold 1164 1edc
[   18.667451] check for cold ccd 62
[   18.667452] check for cold 10b8 1ebc
[   18.667453] check for cold 2304 228
[   18.667454] check for cold 5d8 810f
[   18.667456] check for cold b05 173f
[   18.667457] check for cold 2040 7070
[   18.667565] FW GET_VERSION length: -32
[   18.667567] cold: 1
[   18.667568] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold
state, will try to load a firmware
[   18.674300] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[   18.875965] dib0700: firmware started successfully.
[   24.376079] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   24.376086] power control: 1
[   24.376129] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   24.376546] DVB: registering new adapter (Hauppauge Nova-T Stick)
[   74.424074] ep 0 read error (status = -110)
[   74.424079] I2C read failed on address 0x40
[   84.424148] ep 0 read error (status = -110)
[   84.424151] I2C read failed on address 0x09
[   84.424157] dib0700: stk7070p_frontend_attach:
dib7000p_i2c_enumeration failed.  Cannot continue
[   84.424159]
[   84.424162] dvb-usb: no frontend was attached by 'Hauppauge Nova-T Stick'
[   84.424166] power control: 0
[   84.424168] dvb-usb: Hauppauge Nova-T Stick successfully
initialized and connected.
[   89.424093] Firmware version: 0, -1941421839, 0x1000000, 1348026105
[   94.424065] dib0700: ir protocol setup failed
[   94.424104] usbcore: registered new interface driver dvb_usb_dib0700


ray@pvr:~$ cat /etc/modprobe.d/options.conf
options dvb_usb_dib0700 force_lna_activation=1 debug=1
options dvb_usb disable_rc_polling=1 debug=1
options dvb_core debug=1

ray@pvr:~$ lsmod
Module                  Size  Used by
dvb_usb_dib0700        56317  0
dib7000p               16176  1 dvb_usb_dib0700
dib0090                13333  1 dvb_usb_dib0700
dib7000m               13132  1 dvb_usb_dib0700
dib0070                 7766  1 dvb_usb_dib0700
dvb_usb                17643  1 dvb_usb_dib0700
dib8000                25510  1 dvb_usb_dib0700
dvb_core               86744  3 dib7000p,dvb_usb,dib8000
dib3000mc              11200  1 dvb_usb_dib0700
dibx000_common          3112  4 dib7000p,dib7000m,dib8000,dib3000mc
usbhid                 36882  0
hid                    67742  1 usbhid
...

Thanks

Ray Kinsella
