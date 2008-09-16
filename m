Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 16 Sep 2008 08:02:36 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
In-reply-to: <35680.33061.qm@web28404.mail.ukl.yahoo.com>
To: linux-dvb@linuxtv.org
Message-id: <48CF4BFC.4080606@hoogenraad.net>
MIME-version: 1.0
References: <35680.33061.qm@web28404.mail.ukl.yahoo.com>
Subject: Re: [linux-dvb] Kernel integration of rtl2831u driver
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

The repository at http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2.
Thus:
 > hg clone http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
 > make
 > make install
should be working at all times. I synchronise it once in a while to keep =

it running.

Splitting the code up into front-end and back-end is more of a hassle =

than I assumed. I'm struggling with the old include files, the data =

structures (where used) and the linux interface protocols in general.

A version that does not even compile (NO USE FOR END USERS !)
http://linuxtv.org/hg/~jhoogenraad/rtl2831-sepfront
I have synched the version with the version on my harddisk.

Part of the code is already recycled into the kernel.
As Alistair noticed, this is now blocking for getting the support for =

the stick into the main line. A pity for the users,


Peter Mayer wrote:
> --- Steven Toth <stoth@linuxtv.org> schrieb am So, 14.9.2008:
> =

>>> So, I wonder now what the next steps are to make
>> this driver available in the linux kernel, and when it will
>> probably happen.
>> I gather the tree has some significant merge issues,
>> that's probably why it hasn't been merged. Generally if the drivers are
>> legally clean, code clean they get merged in a couple of weeks.
> =

> Sorry if I need to ask again, but what does this actually mean with respe=
ct to that specific driver rtl2821u? I just wonder.
> =

> My problem is that in Ubuntu Hardy I managed to make this stick work, but=
 in Debian SID I have no idea how to get it work. When I do
> =

> hg clone http://linuxtv.org/hg/v4l-dvb
> make =

> make install
> =

> the stick is not recognized. The entries in /var/log/syslog are:
> =

> Sep 15 23:35:55  kernel: usb 3-3: New USB device found, idVendor=3D14aa, =
idProduct=3D0160
> Sep 15 23:35:55  kernel: usb 3-3: New USB device strings: Mfr=3D1, Produc=
t=3D2, SerialNumber=3D3
> Sep 15 23:35:55  kernel: usb 3-3: Product: DTV Receiver
> Sep 15 23:35:55  kernel: usb 3-3: Manufacturer: DTV Receiver
> Sep 15 23:35:55  kernel: usb 3-3: SerialNumber: 0000000000010205
> =

> When I unpack and make & make install rtl2831u_dvb-usb_v0.0.2mod, syslog =
says:
> =

> Sep 15 23:40:17  kernel: usb 3-3: new high speed USB device using ehci_hc=
d and address 3
> Sep 15 23:40:17  kernel: usb 3-3: configuration #1 chosen from 1 choice
> Sep 15 23:40:17  kernel: usb 3-3: New USB device found, idVendor=3D14aa, =
idProduct=3D0160
> Sep 15 23:40:17  kernel: usb 3-3: New USB device strings: Mfr=3D1, Produc=
t=3D2, SerialNumber=3D3
> Sep 15 23:40:17  kernel: usb 3-3: Product: DTV Receiver
> Sep 15 23:40:17  kernel: usb 3-3: Manufacturer: DTV Receiver
> Sep 15 23:40:17  kernel: usb 3-3: SerialNumber: 0000000000010205
> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.598859] nm_hal_devic=
e_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_d=
evice_14aa_160_0000000000010205').
> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.602281] nm_hal_devic=
e_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_d=
evice_14aa_160_0000000000010205_usbraw').
> Sep 15 23:40:17  kernel: dvb-usb: found a 'Freecom USB 2.0 DVB-T Device' =
in warm state.
> Sep 15 23:40:17  kernel: dvb-usb: will pass the complete MPEG2 transport =
stream to the software demuxer.
> Sep 15 23:40:17  udevd-event[3309]: run_program: '/sbin/modprobe' abnorma=
l exit
> Sep 15 23:40:17  NetworkManager: <debug> [1221514817.795519] nm_hal_devic=
e_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_d=
evice_14aa_160_0000000000010205_if0').
> =

> So, what can I try to make this stick work in Debian SID?
> =

> Greetings,
> Peter
> =

> =

> __________________________________________________
> Do You Yahoo!?
> Sie sind Spam leid? Yahoo! Mail verf=FCgt =FCber einen herausragenden Sch=
utz gegen Massenmails. =

> http://mail.yahoo.com =

> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> =

> =



-- =

Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
