Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from harpoon.unitedhosting.co.uk ([83.223.124.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert@watkin5.net>) id 1L3s1G-0003ss-LL
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 13:55:28 +0100
Received: from [192.168.1.10] (host-84-9-144-120.dslgb.com [84.9.144.120])
	(authenticated bits=0)
	by harpoon.unitedhosting.co.uk (8.13.1/8.13.1) with ESMTP id
	mAMCssDh028103
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 12:55:02 GMT
From: Robert Watkins <robert@watkin5.net>
To: Linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <412bdbff0811201702n6893fb87je2e93538dae1cdc4@mail.gmail.com>
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811201702n6893fb87je2e93538dae1cdc4@mail.gmail.com>
Date: Sat, 22 Nov 2008 12:54:54 +0000
Message-Id: <1227358494.6733.43.camel@watkins-desktop>
Mime-Version: 1.0
Subject: [linux-dvb] Hauppauge Nova T 500,
	dvb-usb: error while enabling fifo.
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

Hello,

I've been using a Hauppauge Nova T 500 for a while using Ubtuntu Hardy
with an occasional "mt2060 I2C read failed" error, but it's been
tolerable.

After upgrading to Intrepid Ibex it's now failing the instant the second
tuner kicks in. A reboot doesn't fix the problem. I have to shutdown and
start from cold to clear the error.

Any help would be greatly appreciated.

I've read the recent threads on the subject at
http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026715.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023738.html
and many older ones.

I've installed the lasted drivers and firmware from
http://linuxtv.org/hg/v4l-dvb

I've add the following to /etc/modprobe.d/options
	options dvb-usb-dib0700 force_lna_activation=1
	options dvb_usb disable_rc_polling=1
	options usbcore autosuspend=-1
and follows the instructions at
http://www.blackberryforums.com/linux-users-corner/97661-enable-disable-config_usb_suspend-s-autosuspend-mode.html to rebuild the initrd for my kernel.

I've tried the dvb-usb-dib0700-1.20.fw and dvb-usb-dib0700-1.10.fw
firmware.

I've edited my mythtv setting in accordance with the instructions at
http://www.youplala.net/linux/home-theater-pc#toc-not-losing-one-of-the-nova-t-500s-tuners

If I "echo on > /sys/usb_device/.../device/power/level" to all the usb
devices set to auto, then I don't seem to get the mt2060 errors. (I
waited 10 minutes and it never turned up.)

However I still get
	[ 1661.529152] dvb-usb: error while enabling fifo.
within seconds of the second tuner starting to record, and Mythtv then
locks up.

(The current driver fixes all the problems I had with uvcvideo and the
USB microphone on my Logitech QuickCam Pro 9000, so I really want to
upgrade.)

I would appreciate any clue on what to try next.

Regards and Best Wishes,
Robert Watkins

P.S.

The firmware often fails to load first time.

[   24.192100] dib0700: loaded with support for 8 different device-types
[   24.193512] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
cold state, will try to load a firmware
[   24.193523] firmware: requesting dvb-usb-dib0700-1.20.fw
[   24.346192] input: PC Speaker
as /devices/platform/pcspkr/input/input5
[   25.808218] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[   26.936250] dib0700: firmware download failed at 17248 with -110
[   26.936354] usbcore: registered new interface driver dvb_usb_dib0700
...

unloading the modules followed by modprobe dvb-usb-dib0700 always fixes
it.

[   81.023443] usbcore: deregistering interface driver dvb_usb_dib0700
[   81.203808] dib0700: loaded with support for 8 different device-types
[   81.205974] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
cold state, will try to load a firmware
[   81.205988] firmware: requesting dvb-usb-dib0700-1.20.fw
[   81.216530] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[   81.434123] dib0700: firmware started successfully.
[   81.936060] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
warm state.
[   81.936153] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   81.936504] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   82.056946] DVB: registering adapter 0 frontend 0 (DiBcom
3000MC/P)...
[   82.125910] MT2060: successfully identified (IF1 = 1229)
[   82.623250] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   82.623487] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   82.632653] DVB: registering adapter 1 frontend 0 (DiBcom
3000MC/P)...
[   82.637883] MT2060: successfully identified (IF1 = 1217)
[   83.205318] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
[   83.205632] usbcore: registered new interface driver dvb_usb_dib0700
[ 1661.529152] dvb-usb: error while enabling fifo.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
