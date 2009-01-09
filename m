Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <momesso.andrea@gmail.com>) id 1LLJVe-0000ez-8q
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 16:42:56 +0100
Received: by fg-out-1718.google.com with SMTP id e21so3567897fga.25
	for <linux-dvb@linuxtv.org>; Fri, 09 Jan 2009 07:42:49 -0800 (PST)
Date: Fri, 9 Jan 2009 16:40:25 +0100
From: Momesso Andrea <momesso.andrea@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20090109154025.GA7183@revolver>
MIME-Version: 1.0
Subject: [linux-dvb]  Terratec Cinergy Hybrid XE
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0378526854=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0378526854==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Has anybody got to make this usb stick work?

Here are some info:


/var/log/messages

Jan  9 16:03:05 revolver usb 2-1: new high speed USB device using
ehci_hcd and address 6
Jan  9 16:03:06 revolver usb 2-1: configuration #1 chosen from 1 choice

lsusb

Bus 002 Device 006: ID 0ccd:0086 TerraTec Electronic GmbH


lshw

*-usb:0 UNCLAIMED
  description: Generic USB device
  product: Cinergy Hybrid XE
  vendor: TerraTec Electronic GmbH
  physical id: 1
  bus info: usb@2:1
  version: 0.01
  serial: 0008CA123456
  capabilities: usb-2.00
  configuration: maxpower=500mA
  speed=480.0MB/s


hwinfo

  1: udi = '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA123456_if0'
    usb.vendor_id = 3277 (0xccd)
    usb.is_self_powered = false
    usb.product_id = 134 (0x86)
    usb.can_wake_up = true
    usb.vendor = 'TerraTec Electronic GmbH'
    usb.bus_number = 2 (0x2)
    linux.hotplug_type = 2 (0x2)
    info.subsystem = 'usb'
    linux.subsystem = 'usb'
    info.product = 'USB Vendor Specific Interface'
    usb.product = 'USB Vendor Specific Interface'
    info.udi = '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA123456_if0'
    usb.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.0'
    usb.device_revision_bcd = 1 (0x1)
    usb.configuration_value = 1 (0x1)
    usb.max_power = 500 (0x1f4)
    usb.num_configurations = 1 (0x1)
    usb.num_ports = 0 (0x0)
    usb.interface.number = 0 (0x0)
    usb.interface.class = 255 (0xff)
    usb.interface.subclass = 0 (0x0)
    usb.interface.protocol = 255 (0xff)
    usb.configuration =	'2.0'
    linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.0'
    info.parent = '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA123456'
    usb.num_interfaces = 1 (0x1)
    usb.linux.device_number = 6 (0x6)
    usb.device_class = 0 (0x0)
    usb.serial = '0008CA123456'
    usb.device_subclass = 0 (0x0)
    usb.speed = 480.000
    usb.device_protocol = 0 (0x0)
    usb.version = 2.00000

  2: udi = '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA123456'
    usb_device.num_interfaces = 1 (0x1)
    usb_device.linux.device_number = 6 (0x6)
    usb_device.configuration = '2.0'
    usb_device.device_class = 0 (0x0)
    usb_device.serial = '0008CA123456'
    linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1'
    info.subsystem = 'usb_device'
    usb_device.device_subclass = 0 (0x0)
    usb_device.speed = 480.000
    info.parent = '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_1d_7_0'
    usb_device.device_protocol = 0 (0x0)
    info.vendor = 'TerraTec Electronic GmbH'
    info.product = 'Cinergy Hybrid XE'
    usb_device.version = 2.00000
    usb_device.vendor_id = 3277 (0xccd)
    usb_device.is_self_powered = false
    info.udi = '/org/freedesktop/Hal/devices/usb_device_ccd_86_0008CA123456'
    info.linux.driver = 'usb'
    usb_device.product_id = 134 (0x86)
    usb_device.can_wake_up = true
    usb_device.vendor = 'TerraTec Electronic GmbH'
    usb_device.bus_number = 2 (0x2)
    linux.hotplug_type = 2 (0x2)
    usb_device.product = 'Cinergy Hybrid XE'
    linux.subsystem = 'usb'
    linux.device_file = '/dev/bus/usb/002/006'
    usb_device.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1'
    usb_device.device_revision_bcd = 1 (0x1)
    usb_device.configuration_value = 1 (0x1)
    usb_device.max_power = 500 (0x1f4)
    usb_device.num_configurations = 1 (0x1)
    usb_device.num_ports = 0 (0x0)

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklnb+kACgkQTusdC+HYtiLGewCg8vi/rOAopLNbxnv7sDkKl/iI
5ogAnRDDY2B92gliRsEnplRn04uWO/rX
=HTJf
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--


--===============0378526854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0378526854==--
