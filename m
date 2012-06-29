Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:48348 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab2F2OXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 10:23:31 -0400
From: Olivier GRENIE <olivier.grenie@parrot.com>
To: "cedric.dewijs@telfort.nl" <cedric.dewijs@telfort.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 29 Jun 2012 15:25:00 +0100
Subject: RE: dib0700 can't enable debug messages
Message-ID: <C73E570AC040D442A4DD326F39F0F00E15ACD0E4F5@SAPHIR.xi-lite.lan>
References: <4FC4F2690000C9F5@mta-nl-9.mail.tiscali.sys>
In-Reply-To: <4FC4F2690000C9F5@mta-nl-9.mail.tiscali.sys>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
did you enable the DVB USB debugging (CONFIG_DVB_USB_DEBUG) in your kernel configuration?

regards,
Olivier

________________________________________
From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of cedric.dewijs@telfort.nl [cedric.dewijs@telfort.nl]
Sent: Thursday, June 28, 2012 7:18 AM
To: linux-media@vger.kernel.org
Subject: dib0700 can't enable debug messages

Hi all,

I would like to see some debug messages from the dib0700 driver.
I have tried to enable debug messages like this, following the instructions
found here:
http://www.linuxtv.org/wiki/index.php/Template:Making-it-work:dvb-usb-dib0700

# rmmod dvb_usb_dib0700
# insmod /lib/modules/3.3.7-1-ARCH/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko.gz
debug=1
# rmmod dvb_usb_dib0700
# insmod /lib/modules/3.3.7-1-ARCH/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko.gz
debug=2
# rmmod dvb_usb_dib0700
# insmod /lib/modules/3.3.7-1-ARCH/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko.gz
debug=4
# rmmod dvb_usb_dib0700
# insmod /lib/modules/3.3.7-1-ARCH/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko.gz
debug=8
# rmmod dvb_usb_dib0700
# insmod /lib/modules/3.3.7-1-ARCH/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko.gz
debug 8
Error: could not insert module /lib/modules/3.3.7-1-ARCH/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko.gz:
Invalid parameters
# insmod /lib/modules/3.3.7-1-ARCH/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko.gz
debug=15
# rmmod dvb_usb_dib0700
# modprobe dvb_usb_dib0700 debug=15

The messaegs in /var/log/messages are the same in all the above cases:
Jun 28 00:46:27 localhost kernel: [29669.758363] dvb-usb: found a 'Pinnacle
PCTV 73e SE' in warm state.
Jun 28 00:46:27 localhost kernel: [29669.758428] dvb-usb: will pass the complete
MPEG2 transport stream to the software demuxer.
Jun 28 00:46:27 localhost kernel: [29669.758619] DVB: registering new adapter
(Pinnacle PCTV 73e SE)
Jun 28 00:46:27 localhost kernel: [29669.970031] DVB: registering adapter
0 frontend 0 (DiBcom 7000PC)...
Jun 28 00:46:28 localhost kernel: [29670.177652] DiB0070: successfully identified
Jun 28 00:46:28 localhost kernel: [29670.177669] Registered IR keymap rc-dib0700-rc5
Jun 28 00:46:28 localhost kernel: [29670.177887] input: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc6/input31
Jun 28 00:46:28 localhost kernel: [29670.178061] rc6: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc6
Jun 28 00:46:28 localhost kernel: [29670.178274] dvb-usb: schedule remote
query interval to 50 msecs.
Jun 28 00:46:28 localhost kernel: [29670.178278] dvb-usb: Pinnacle PCTV 73e
SE successfully initialized and connected.
Jun 28 00:46:28 localhost kernel: [29670.178426] usbcore: registered new
interface driver dvb_usb_dib0700
Jun 28 00:47:25 localhost kernel: [29727.435215] usbcore: deregistering interface
driver dvb_usb_dib0700
Jun 28 00:47:25 localhost acpid: input device has been disconnected, fd 20
Jun 28 00:47:25 localhost kernel: [29727.444744] dvb-usb: Pinnacle PCTV 73e
SE successfully deinitialized and disconnected.
Jun 28 00:47:27 localhost kernel: [29729.807075] dvb-usb: found a 'Pinnacle
PCTV 73e SE' in warm state.
Jun 28 00:47:27 localhost kernel: [29729.807151] dvb-usb: will pass the complete
MPEG2 transport stream to the software demuxer.
Jun 28 00:47:27 localhost kernel: [29729.807828] DVB: registering new adapter
(Pinnacle PCTV 73e SE)
Jun 28 00:47:27 localhost kernel: [29730.023174] DVB: registering adapter
0 frontend 0 (DiBcom 7000PC)...
Jun 28 00:47:28 localhost kernel: [29730.230923] DiB0070: successfully identified
Jun 28 00:47:28 localhost kernel: [29730.230940] Registered IR keymap rc-dib0700-rc5
Jun 28 00:47:28 localhost kernel: [29730.231159] input: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc7/input32
Jun 28 00:47:28 localhost kernel: [29730.231336] rc7: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc7
Jun 28 00:47:28 localhost kernel: [29730.231543] dvb-usb: schedule remote
query interval to 50 msecs.
Jun 28 00:47:28 localhost kernel: [29730.231547] dvb-usb: Pinnacle PCTV 73e
SE successfully initialized and connected.
Jun 28 00:47:28 localhost kernel: [29730.231692] usbcore: registered new
interface driver dvb_usb_dib0700
Jun 28 00:48:08 localhost kernel: [29770.891230] usbcore: deregistering interface
driver dvb_usb_dib0700
Jun 28 00:48:08 localhost acpid: input device has been disconnected, fd 20
Jun 28 00:48:08 localhost kernel: [29770.902035] dvb-usb: Pinnacle PCTV 73e
SE successfully deinitialized and disconnected.
Jun 28 00:48:11 localhost kernel: [29773.181745] dvb-usb: found a 'Pinnacle
PCTV 73e SE' in warm state.
Jun 28 00:48:11 localhost kernel: [29773.181812] dvb-usb: will pass the complete
MPEG2 transport stream to the software demuxer.
Jun 28 00:48:11 localhost kernel: [29773.182044] DVB: registering new adapter
(Pinnacle PCTV 73e SE)
Jun 28 00:48:11 localhost kernel: [29773.390057] DVB: registering adapter
0 frontend 0 (DiBcom 7000PC)...
Jun 28 00:48:11 localhost kernel: [29773.594311] DiB0070: successfully identified
Jun 28 00:48:11 localhost kernel: [29773.594328] Registered IR keymap rc-dib0700-rc5
Jun 28 00:48:11 localhost kernel: [29773.594544] input: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc8/input33
Jun 28 00:48:11 localhost kernel: [29773.594722] rc8: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc8
Jun 28 00:48:11 localhost kernel: [29773.594931] dvb-usb: schedule remote
query interval to 50 msecs.
Jun 28 00:48:11 localhost kernel: [29773.594935] dvb-usb: Pinnacle PCTV 73e
SE successfully initialized and connected.
Jun 28 00:48:11 localhost kernel: [29773.595109] usbcore: registered new
interface driver dvb_usb_dib0700
Jun 28 00:48:40 localhost kernel: [29802.539224] usbcore: deregistering interface
driver dvb_usb_dib0700
Jun 28 00:48:40 localhost acpid: input device has been disconnected, fd 20
Jun 28 00:48:40 localhost kernel: [29802.550560] dvb-usb: Pinnacle PCTV 73e
SE successfully deinitialized and disconnected.
Jun 28 00:48:43 localhost kernel: [29805.197557] dvb-usb: found a 'Pinnacle
PCTV 73e SE' in warm state.
Jun 28 00:48:43 localhost kernel: [29805.197634] dvb-usb: will pass the complete
MPEG2 transport stream to the software demuxer.
Jun 28 00:48:43 localhost kernel: [29805.198406] DVB: registering new adapter
(Pinnacle PCTV 73e SE)
Jun 28 00:48:43 localhost kernel: [29805.413323] DVB: registering adapter
0 frontend 0 (DiBcom 7000PC)...
Jun 28 00:48:43 localhost kernel: [29805.620944] DiB0070: successfully identified
Jun 28 00:48:43 localhost kernel: [29805.620961] Registered IR keymap rc-dib0700-rc5
Jun 28 00:48:43 localhost kernel: [29805.621177] input: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc9/input34
Jun 28 00:48:43 localhost kernel: [29805.624556] rc9: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc9
Jun 28 00:48:43 localhost kernel: [29805.624986] dvb-usb: schedule remote
query interval to 50 msecs.
Jun 28 00:48:43 localhost kernel: [29805.624991] dvb-usb: Pinnacle PCTV 73e
SE successfully initialized and connected.
Jun 28 00:48:43 localhost kernel: [29805.625292] usbcore: registered new
interface driver dvb_usb_dib0700

What am I missing?

Best regards,
Cedric






--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
