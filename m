Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx1.redhat.com ([66.187.233.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rkeech@redhat.com>) id 1JUgoE-0006gW-Uf
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 12:20:19 +0100
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com
	[172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1SBK1IW001634
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 06:20:01 -0500
Received: from pobox.brisbane.redhat.com (pobox.brisbane.redhat.com
	[172.16.44.10])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1SBJxeB015567
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 06:20:00 -0500
Message-ID: <47C6990A.9010400@redhat.com>
Date: Thu, 28 Feb 2008 22:20:42 +1100
From: Richard Keech <rkeech@redhat.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] corrupted video problem with DiBcom 3000MC/P
	(TERRESTRIAL)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

hi guys,

I'm experiencing problems with DVB playback with MythTV.   The problems
are restricted mainly to one channel.
Suggestions most welcome.


Setup

The tuner is a Leadtek WinFast DTV USB dongle  (driver  dib3000mc).
I got firmware from
http://www.linuxtv.org/downloads/firmware/dvb-usb-dibusb-6.0.0.8.fw
The signal strength is good.  I've recently added a masthead amp to see
if it fixed the problem but there was no change.
OS is Fedora 8 and kernel 2.6.23.15-137.fc8.
MythTV version is mythtv-0.20.2-174.fc8.
CPU 1.8MHz dual core.  1GB RAM.


Troubleshooting and mitigation

To show the problem I've got some output of femon when the problem
commenced.

status 1f | signal 44d4 | snr 0000 | ber 00000000 | unc 0000000f |
FE_HAS_LOCK
status 1f | signal 44f2 | snr 0000 | ber 00000030 | unc 00000019 |
FE_HAS_LOCK
status 1f | signal 44c3 | snr 0000 | ber 00000120 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 44a4 | snr 0000 | ber 0000f520 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 44c2 | snr 0000 | ber 00000000 | unc 0000022a |
FE_HAS_LOCK
status 1f | signal 44c0 | snr 0000 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 44d7 | snr 0000 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 44fc | snr 0000 | ber 00000d70 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 44d0 | snr 0000 | ber 0001e8e0 | unc 00000210 |
FE_HAS_LOCK
status 1f | signal 44ab | snr 0000 | ber 00021bd0 | unc 000006d0 |
FE_HAS_LOCK
status 1f | signal 44c4 | snr 0000 | ber 000220d0 | unc 0000037f |
FE_HAS_LOCK
status 1f | signal 450e | snr 0000 | ber 00015c50 | unc 0000006c |
FE_HAS_LOCK
status 1f | signal 4504 | snr 0000 | ber 00013280 | unc 00000008 |
FE_HAS_LOCK



Note ber (bit error rate) increasing

Signal/Noise ratio is showing as zero here which it shouldn't.  It does
that on all channels.

When the media player mode returns from TV mode, the output of femon
stillshows "FE_HAS_LOCK"
so I suspect device is decoding all the time the system is on.

When the problem commences, changing channels and back again sometimes
improves the situation.



Any ideas how I can get good video?

-- 
G. Richard Keech                  gpg key id: F9AFA1DD
Red Hat Asia-Pacific              key serv: pgp.mit.edu
rkeech@redhat.com
+61 419 036 463


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
