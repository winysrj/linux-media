Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx1.rz.ruhr-uni-bochum.de ([134.147.32.86])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <pepe_ml@gmx.net>) id 1JplAj-0000J7-6c
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 16:14:38 +0200
Date: Sat, 26 Apr 2008 16:14:33 +0200
From: Steffen Schulz <pepe_ml@gmx.net>
To: linux-dvb@linuxtv.org
Message-ID: <20080426141433.GA14917@cbg.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] crash with terratec cinergy hybrid XS [0ccd:0042]
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

Hi,


The mailman on mcentral.de seems to be dead, so I'll ask here.


I installed userspace-drivers and em28xx-userspace2 with a  2.6.24.4
kernel with mactel-linux patches(some macbook specific drivers).

I needed to activate some dvb-support to get the drivers compile
cleanly, e.g. v4l1-compat, IIRC.

When I plug in the device, em28xx.ko is loaded and the usb subsystem
kind of crashes. Internal and external keyboards(both attached via USB)
do not work anymore, but mouse+touchpad works. When media-daemon is
enabled, I get this with dmesg(USB freezes without media-daemon, too):

| usb 6-2: new high speed USB device using ehci_hcd and address 3
| usb 6-2: configuration #1 chosen from 1 choice
| em28xx v4l2 driver version 0.0.1 loaded
| em28xx new video device (0ccd:0042): interface 0, class 255
| em28xx: device is attached to a USB 2.0 bus
| em28xx #0: Alternate settings: 8
| em28xx #0: Alternate setting 0, max size=3D 0
| em28xx #0: Alternate setting 1, max size=3D 0
| em28xx #0: Alternate setting 2, max size=3D 1448
| em28xx #0: Alternate setting 3, max size=3D 2048
| em28xx #0: Alternate setting 4, max size=3D 2304
| em28xx #0: Alternate setting 5, max size=3D 2580
| em28xx #0: Alternate setting 6, max size=3D 2892
| em28xx #0: Alternate setting 7, max size=3D 3072
| input: em2880/em2870 remote control as /devices/virtual/input/input15
| em28xx-input.c: remote control handler attached
| moduleid: 0
| media-stub: adding support for Texas Instruments - tvp5150
| media-stub: userspace driver version 1
| media-stub: Copyright: Mauro Chehab
| em28xx: registered module_id 1
| media-stub: adding support for Texas Instruments - tvp5150
| media-stub: userspace driver version 1
| media-stub: Copyright: Mauro Chehab
| em28xx #0: V4L2 VBI device registered as /dev/vbi0
| media-daemon[2457]: segfault at 0000000c eip b7fc418e esp bfb82080 error 6
| removing support for Texas Instruments - tvp5150


The segfault is probably not intended.
Last time I looked, I have no /dev/dvb/* in this state.
Removing the device doesn't get the keyboard back.



any help appreciated,
/steffen
-- =

       _----------------
 (o< =B7-_    Less CO2    |  _o)                          +49/1781384223
 //\    | for more ice! |  /\\  .o) .o)        gpg --recv-key A04D7875
 V_/_    ---------------  _\_V _(\)_(\)    mailto: pepe@cbg.dyndns.org

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
