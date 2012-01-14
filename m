Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40382 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2ANXlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 18:41:45 -0500
Received: by werb13 with SMTP id b13so1233014wer.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 15:41:43 -0800 (PST)
From: "RazzaList" <razzalist@gmail.com>
To: <linux-media@vger.kernel.org>
Subject: Hauppage Nova: doesn't know how to handle a DVBv3 call to delivery system 0
Date: Sat, 14 Jan 2012 23:41:31 -0000
Message-ID: <008301ccd316$0be6d440$23b47cc0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have followed the build instructions for the Hauppauge MyTV.t device here
- http://linuxtv.org/wiki/index.php/Hauppauge_myTV.t and built the drivers
as detailed here -
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_D
evice_Drivers on a CentOS 6.2 i386 build. 

When I use dvbscan, nothing happens. dmesg shows "
dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
delivery system 0"

[root@cos6 ~]# cd /usr/bin
[root@cos6 bin]# ./dvbscan /usr/share/dvb/dvb-t/uk-Hannington >
/usr/share/dvb/dvb-t/channels.conf
[root@cos6 bin]# dmesg | grep dvb
dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: Hauppauge Nova-T MyTV.t successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
delivery system 0

I have searched but can't locate a fix. Any pointers?


