Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n41.bullet.mail.ukl.yahoo.com ([87.248.110.174])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <horuljo@yahoo.de>) id 1KfMKQ-0006Hr-Hw
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 00:13:56 +0200
Date: Mon, 15 Sep 2008 22:12:58 +0000 (GMT)
From: Peter Mayer <horuljo@yahoo.de>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48CD2193.2000106@linuxtv.org>
MIME-Version: 1.0
Message-ID: <35680.33061.qm@web28404.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kernel integration of rtl2831u driver
Reply-To: horuljo@yahoo.de
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

--- Steven Toth <stoth@linuxtv.org> schrieb am So, 14.9.2008:

> > So, I wonder now what the next steps are to make
> this driver available in the linux kernel, and when it will
> probably happen.
> > =

> =

> I gather the tree has some significant merge issues,
> that's probably why it hasn't been merged. Generally if the drivers are
> legally clean, code clean they get merged in a couple of weeks.

Sorry if I need to ask again, but what does this actually mean with respect=
 to that specific driver rtl2821u? I just wonder.

My problem is that in Ubuntu Hardy I managed to make this stick work, but i=
n Debian SID I have no idea how to get it work. When I do

hg clone http://linuxtv.org/hg/v4l-dvb
make =

make install

the stick is not recognized. The entries in /var/log/syslog are:

Sep 15 23:35:55  kernel: usb 3-3: New USB device found, idVendor=3D14aa, id=
Product=3D0160
Sep 15 23:35:55  kernel: usb 3-3: New USB device strings: Mfr=3D1, Product=
=3D2, SerialNumber=3D3
Sep 15 23:35:55  kernel: usb 3-3: Product: DTV Receiver
Sep 15 23:35:55  kernel: usb 3-3: Manufacturer: DTV Receiver
Sep 15 23:35:55  kernel: usb 3-3: SerialNumber: 0000000000010205

When I unpack and make & make install rtl2831u_dvb-usb_v0.0.2mod, syslog sa=
ys:

Sep 15 23:40:17  kernel: usb 3-3: new high speed USB device using ehci_hcd =
and address 3
Sep 15 23:40:17  kernel: usb 3-3: configuration #1 chosen from 1 choice
Sep 15 23:40:17  kernel: usb 3-3: New USB device found, idVendor=3D14aa, id=
Product=3D0160
Sep 15 23:40:17  kernel: usb 3-3: New USB device strings: Mfr=3D1, Product=
=3D2, SerialNumber=3D3
Sep 15 23:40:17  kernel: usb 3-3: Product: DTV Receiver
Sep 15 23:40:17  kernel: usb 3-3: Manufacturer: DTV Receiver
Sep 15 23:40:17  kernel: usb 3-3: SerialNumber: 0000000000010205
Sep 15 23:40:17  NetworkManager: <debug> [1221514817.598859] nm_hal_device_=
added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_dev=
ice_14aa_160_0000000000010205').
Sep 15 23:40:17  NetworkManager: <debug> [1221514817.602281] nm_hal_device_=
added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_dev=
ice_14aa_160_0000000000010205_usbraw').
Sep 15 23:40:17  kernel: dvb-usb: found a 'Freecom USB 2.0 DVB-T Device' in=
 warm state.
Sep 15 23:40:17  kernel: dvb-usb: will pass the complete MPEG2 transport st=
ream to the software demuxer.
Sep 15 23:40:17  udevd-event[3309]: run_program: '/sbin/modprobe' abnormal =
exit
Sep 15 23:40:17  NetworkManager: <debug> [1221514817.795519] nm_hal_device_=
added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_dev=
ice_14aa_160_0000000000010205_if0').

So, what can I try to make this stick work in Debian SID?

Greetings,
Peter


__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verf=FCgt =FCber einen herausragenden Schut=
z gegen Massenmails. =

http://mail.yahoo.com =



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
