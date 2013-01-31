Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40925 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3AaViO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 16:38:14 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so3312552wib.1
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 13:38:13 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 31 Jan 2013 22:38:13 +0100
Message-ID: <CAJ_iqtYTjVdx0rcx3RTbGPqy_eiUX_9VJAxvo--fsLvaJh=Q5g@mail.gmail.com>
Subject: media_build: getting a TerraTec H7 working?
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to get a TerraTec H7 working. I started with Xubuntu 12.04,
using kernel 3.2.24:
tingo@kg-f4:~/work/w_scan-20121111$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 12.04.1 LTS
Release:	12.04
Codename:	precise

tingo@kg-f4:~/work/w_scan-20121111$ uname -a
Linux kg-f4 3.2.24 #2 SMP Wed Sep 5 01:14:55 CEST 2012 x86_64 x86_64
x86_64 GNU/Linux

I have this H7 variant:
tingo@kg-f4:~/work/w_scan-20121111$ lsusb -s 2:2
Bus 002 Device 002: ID 0ccd:10a3 TerraTec Electronic GmbH

I added the media_build tree, by following these instructions:
http://git.linuxtv.org/media_build.git

relevant parts of dmesg output:
[    9.008181] WARNING: You are using an experimental version of the
media stack.
[    9.008186]  As the driver is backported to an older kernel, it doesn't offer
[    9.008188]  enough quality for its usage in production.
[    9.008190]  Use it with care.
[    9.008191] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[    9.008193]  a32f7d1ad3744914273c6907204c2ab3b5d496a0 Merge branch
'v4l_for_linus' into staging/for_v3.9
[    9.008195]  6b9e50c463efc5c361496ae6a895cc966ff8025b [media]
stv090x: On STV0903 do not set registers of the second path
[    9.008198]  f67102c49a123b32a4469b28407feb52b37144f5 [media]
mb86a20s: remove global BER/PER counters if per-layer counters vanish
[    9.013452] usbcore: registered new interface driver dvb_usb_az6007

[    9.014108] usb 2-1: dvb_usb_v2: found a 'Terratec H7' in cold state

[    9.746658] usb 2-1: dvb_usb_v2: downloading firmware from file
'dvb-usb-terratec-h7-az6007.fw'
[    9.770522] usb 2-1: dvb_usb_v2: found a 'Terratec H7' in warm state

[   11.008581] usb 2-1: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[   11.008625] DVB: registering new adapter (Terratec H7)
[   11.011489] usb 2-1: dvb_usb_v2: MAC address: c2:cd:0c:a3:10:00
[   11.025188] drxk: frontend initialized.
[   11.036565] usb 2-1: DVB: registering adapter 0 frontend 0 (DRXK)...
[   11.047302] mt2063_attach: Attaching MT2063
[   11.072035] Registered IR keymap rc-nec-terratec-cinergy-xs
[   11.072230] input: Terratec H7 as
/devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc0/input13
[   11.072346] rc0: Terratec H7 as
/devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc0
[   11.072354] usb 2-1: dvb_usb_v2: schedule remote query interval to 400 msecs
[   11.072361] usb 2-1: dvb_usb_v2: 'Terratec H7' successfully
initialized and connected
[   11.088076] drxk: status = 0x439130d9
[   11.088085] drxk: detected a drx-3913k, spin A2, xtal 27.000 MHz

I get this in /dev:
tingo@kg-f4:~/work/w_scan-20121111$ ls -l /dev/dvb/adapter0
total 0
crw-rw----+ 1 root video 212, 3 Jan 31 21:06 ca0
crw-rw----+ 1 root video 212, 0 Jan 31 21:06 demux0
crw-rw----+ 1 root video 212, 1 Jan 31 21:06 dvr0
crw-rw----+ 1 root video 212, 4 Jan 31 21:06 frontend0
crw-rw----+ 1 root video 212, 2 Jan 31 21:06 net0

But when I scan with w_scan, it doesn't find any channels:
tingo@kg-f4:~/work/w_scan-20121111$ ./w_scan -fc -c NO -C ISO-8859-1
w_scan version 20121111 (compiled for DVB API 5.4)
using settings for NORWAY
DVB cable
DVB-C
scan type CABLE, channellist 7
output format vdr-1.6
output charset 'ISO-8859-1'
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> CABLE "DRXK DVB-C DVB-T": good :-)
Using CABLE frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.a
frontend 'DRXK DVB-C DVB-T' supports
INVERSION_AUTO
QAM_AUTO not supported, trying QAM_64 QAM_256.
FEC_AUTO
FREQ (47.00MHz ... 865.00MHz)
SRATE (0.870MSym/s ... 11.700MSym/s)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
searching QAM64...
73000: sr6900 (time: 00:02) sr6875 (time: 00:05)
(lots of output snipped)
842000: sr6900 (time: 13:07) sr6875 (time: 13:10)
850000: sr6900 (time: 13:13) sr6875 (time: 13:15)
858000: sr6900 (time: 13:18) sr6875 (time: 13:20)

ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!

And yes - the H7 is connected to a cable with a DVB-C signal on it
(using a different DVBC-adapter, w_scan finds lamost 200 channels).

What more can I do to get this H7 working?
-- 
Regards,
Torfinn Ingolfsen
