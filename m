Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f13.google.com ([209.85.220.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <momesso.andrea@gmail.com>) id 1LMRGT-0000u6-50
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 19:11:58 +0100
Received: by fxm6 with SMTP id 6so10911fxm.17
	for <linux-dvb@linuxtv.org>; Mon, 12 Jan 2009 10:11:18 -0800 (PST)
Date: Mon, 12 Jan 2009 19:08:54 +0100
From: Momesso Andrea <momesso.andrea@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20090112180854.GA15628@revolver>
References: <20090109154025.GA7183@revolver>
MIME-Version: 1.0
In-Reply-To: <20090109154025.GA7183@revolver>
Subject: Re: [linux-dvb] Terratec Cinergy Hybrid XE
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0859085586=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0859085586==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2009 at 04:40:25PM +0100, Momesso Andrea wrote:
> Has anybody got to make this usb stick work?

Bump...

I'm not used to bump on mailing lists, btw I'd like to know if:

1) has anyone got to make this stick work
2) there is no way to make it work
3) someone is interested in making it work and I can provide some info
to help

Sorry again for bumping and thanks in advance.


>=20
> Here are some info:
>=20
>=20
> /var/log/messages
>=20
> Jan  9 16:03:05 revolver usb 2-1: new high speed USB device using
> ehci_hcd and address 6
> Jan  9 16:03:06 revolver usb 2-1: configuration #1 chosen from 1 choice
>=20
> lsusb
>=20
> Bus 002 Device 006: ID 0ccd:0086 TerraTec Electronic GmbH
>=20
>=20
> lshw
>=20
> *-usb:0 UNCLAIMED
>   description: Generic USB device
>   product: Cinergy Hybrid XE
>   vendor: TerraTec Electronic GmbH
>   physical id: 1
>   bus info: usb@2:1
>   version: 0.01
>   serial: 0008CA123456
>   capabilities: usb-2.00
>   configuration: maxpower=3D500mA
>   speed=3D480.0MB/s
>=20
>=20
> hwinfo
>=20
>   1: udi =3D '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA123456=
_if0'
>     usb.vendor_id =3D 3277 (0xccd)
>     usb.is_self_powered =3D false
>     usb.product_id =3D 134 (0x86)
>     usb.can_wake_up =3D true
>     usb.vendor =3D 'TerraTec Electronic GmbH'
>     usb.bus_number =3D 2 (0x2)
>     linux.hotplug_type =3D 2 (0x2)
>     info.subsystem =3D 'usb'
>     linux.subsystem =3D 'usb'
>     info.product =3D 'USB Vendor Specific Interface'
>     usb.product =3D 'USB Vendor Specific Interface'
>     info.udi =3D '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA12=
3456_if0'
>     usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:1d.7/usb2/2=
-1/2-1:1.0'
>     usb.device_revision_bcd =3D 1 (0x1)
>     usb.configuration_value =3D 1 (0x1)
>     usb.max_power =3D 500 (0x1f4)
>     usb.num_configurations =3D 1 (0x1)
>     usb.num_ports =3D 0 (0x0)
>     usb.interface.number =3D 0 (0x0)
>     usb.interface.class =3D 255 (0xff)
>     usb.interface.subclass =3D 0 (0x0)
>     usb.interface.protocol =3D 255 (0xff)
>     usb.configuration =3D	'2.0'
>     linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2=
-1:1.0'
>     info.parent =3D '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008C=
A123456'
>     usb.num_interfaces =3D 1 (0x1)
>     usb.linux.device_number =3D 6 (0x6)
>     usb.device_class =3D 0 (0x0)
>     usb.serial =3D '0008CA123456'
>     usb.device_subclass =3D 0 (0x0)
>     usb.speed =3D 480.000
>     usb.device_protocol =3D 0 (0x0)
>     usb.version =3D 2.00000
>=20
>   2: udi =3D '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA123456'
>     usb_device.num_interfaces =3D 1 (0x1)
>     usb_device.linux.device_number =3D 6 (0x6)
>     usb_device.configuration =3D '2.0'
>     usb_device.device_class =3D 0 (0x0)
>     usb_device.serial =3D '0008CA123456'
>     linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1'
>     info.subsystem =3D 'usb_device'
>     usb_device.device_subclass =3D 0 (0x0)
>     usb_device.speed =3D 480.000
>     info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_=
00_1d_7_0'
>     usb_device.device_protocol =3D 0 (0x0)
>     info.vendor =3D 'TerraTec Electronic GmbH'
>     info.product =3D 'Cinergy Hybrid XE'
>     usb_device.version =3D 2.00000
>     usb_device.vendor_id =3D 3277 (0xccd)
>     usb_device.is_self_powered =3D false
>     info.udi =3D '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA12=
3456'
>     info.linux.driver =3D 'usb'
>     usb_device.product_id =3D 134 (0x86)
>     usb_device.can_wake_up =3D true
>     usb_device.vendor =3D 'TerraTec Electronic GmbH'
>     usb_device.bus_number =3D 2 (0x2)
>     linux.hotplug_type =3D 2 (0x2)
>     usb_device.product =3D 'Cinergy Hybrid XE'
>     linux.subsystem =3D 'usb'
>     linux.device_file =3D '/dev/bus/usb/002/006'
>     usb_device.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:1d.7=
/usb2/2-1'
>     usb_device.device_revision_bcd =3D 1 (0x1)
>     usb_device.configuration_value =3D 1 (0x1)
>     usb_device.max_power =3D 500 (0x1f4)
>     usb_device.num_configurations =3D 1 (0x1)
>     usb_device.num_ports =3D 0 (0x0)



--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklrhzUACgkQTusdC+HYtiKU9gCfbOIXN21wemff+jQ/48+Ugo8K
fM0An1f8/qocm5gUosfm8YXGdV5HMb9t
=jL8D
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--


--===============0859085586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0859085586==--
