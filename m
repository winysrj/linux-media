Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46713 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2DXRPO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 13:15:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SMjKZ-0001IL-W3
	for linux-media@vger.kernel.org; Tue, 24 Apr 2012 19:15:11 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2012 19:15:11 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2012 19:15:11 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: udev rules for persistent symlinks for adapter?/frontend0 devices
Date: Tue, 24 Apr 2012 13:14:54 -0400
Message-ID: <jn6n2e$gu1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig70620D3435885B5AD3D76935"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig70620D3435885B5AD3D76935
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I have two DVB devices in my machine that I want to be able to identify
persistently[1].  They are typically on /dev/dvb/adapter{0,1}/frontend0
but their order is arbitrary and can change from one boot to another.

So using udevadm info I tried to find attributes for them that I could
rely on consistently.  Here is the output from:

# udevadm info --attribute-walk --name /dev/dvb/adapter?/frontend0

First device:

  looking at device '/devices/pci0000:00/0000:00:1e.0/0000:02:09.0/dvb/dv=
b0.frontend0':
    KERNEL=3D=3D"dvb0.frontend0"
    SUBSYSTEM=3D=3D"dvb"
    DRIVER=3D=3D""

  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:02:09.0=
':
    KERNELS=3D=3D"0000:02:09.0"
    SUBSYSTEMS=3D=3D"pci"
    DRIVERS=3D=3D"cx18"
    ATTRS{vendor}=3D=3D"0x14f1"
    ATTRS{device}=3D=3D"0x5b7a"
    ATTRS{subsystem_vendor}=3D=3D"0x0070"
    ATTRS{subsystem_device}=3D=3D"0x7400"
    ATTRS{class}=3D=3D"0x040000"
    ATTRS{irq}=3D=3D"21"
    ATTRS{local_cpus}=3D=3D"ff"
    ATTRS{local_cpulist}=3D=3D"0-7"
    ATTRS{dma_mask_bits}=3D=3D"32"
    ATTRS{consistent_dma_mask_bits}=3D=3D"32"
    ATTRS{enable}=3D=3D"1"
    ATTRS{broken_parity_status}=3D=3D"0"
    ATTRS{msi_bus}=3D=3D""

  looking at parent device '/devices/pci0000:00/0000:00:1e.0':
    KERNELS=3D=3D"0000:00:1e.0"
    SUBSYSTEMS=3D=3D"pci"
    DRIVERS=3D=3D""
    ATTRS{vendor}=3D=3D"0x8086"
    ATTRS{device}=3D=3D"0x244e"
    ATTRS{subsystem_vendor}=3D=3D"0x0000"
    ATTRS{subsystem_device}=3D=3D"0x0000"
    ATTRS{class}=3D=3D"0x060400"
    ATTRS{irq}=3D=3D"0"
    ATTRS{local_cpus}=3D=3D"ff"
    ATTRS{local_cpulist}=3D=3D"0-7"
    ATTRS{dma_mask_bits}=3D=3D"32"
    ATTRS{consistent_dma_mask_bits}=3D=3D"32"
    ATTRS{enable}=3D=3D"1"
    ATTRS{broken_parity_status}=3D=3D"0"
    ATTRS{msi_bus}=3D=3D"1"

  looking at parent device '/devices/pci0000:00':
    KERNELS=3D=3D"pci0000:00"
    SUBSYSTEMS=3D=3D""
    DRIVERS=3D=3D""

And the second device:

  looking at device '/devices/pci0000:00/0000:00:1d.7/usb1/1-3/dvb/dvb1.f=
rontend0':
    KERNEL=3D=3D"dvb1.frontend0"
    SUBSYSTEM=3D=3D"dvb"
    DRIVER=3D=3D""

  looking at parent device '/devices/pci0000:00/0000:00:1d.7/usb1/1-3':
    KERNELS=3D=3D"1-3"
    SUBSYSTEMS=3D=3D"usb"
    DRIVERS=3D=3D"usb"
    ATTRS{configuration}=3D=3D""
    ATTRS{bNumInterfaces}=3D=3D" 4"
    ATTRS{bConfigurationValue}=3D=3D"1"
    ATTRS{bmAttributes}=3D=3D"80"
    ATTRS{bMaxPower}=3D=3D"500mA"
    ATTRS{urbnum}=3D=3D"5941719"
    ATTRS{idVendor}=3D=3D"2040"
    ATTRS{idProduct}=3D=3D"7200"
    ATTRS{bcdDevice}=3D=3D"0005"
    ATTRS{bDeviceClass}=3D=3D"00"
    ATTRS{bDeviceSubClass}=3D=3D"00"
    ATTRS{bDeviceProtocol}=3D=3D"00"
    ATTRS{bNumConfigurations}=3D=3D"1"
    ATTRS{bMaxPacketSize0}=3D=3D"64"
    ATTRS{speed}=3D=3D"480"
    ATTRS{busnum}=3D=3D"1"
    ATTRS{devnum}=3D=3D"2"
    ATTRS{devpath}=3D=3D"3"
    ATTRS{version}=3D=3D" 2.00"
    ATTRS{maxchild}=3D=3D"0"
    ATTRS{quirks}=3D=3D"0x0"
    ATTRS{avoid_reset_quirk}=3D=3D"0"
    ATTRS{authorized}=3D=3D"1"
    ATTRS{manufacturer}=3D=3D"Hauppauge"
    ATTRS{product}=3D=3D"WinTV HVR-950"
    ATTRS{serial}=3D=3D"*********"

  looking at parent device '/devices/pci0000:00/0000:00:1d.7/usb1':
    KERNELS=3D=3D"usb1"
    SUBSYSTEMS=3D=3D"usb"
    DRIVERS=3D=3D"usb"
    ATTRS{configuration}=3D=3D""
    ATTRS{bNumInterfaces}=3D=3D" 1"
    ATTRS{bConfigurationValue}=3D=3D"1"
    ATTRS{bmAttributes}=3D=3D"e0"
    ATTRS{bMaxPower}=3D=3D"  0mA"
    ATTRS{urbnum}=3D=3D"52"
    ATTRS{idVendor}=3D=3D"1d6b"
    ATTRS{idProduct}=3D=3D"0002"
    ATTRS{bcdDevice}=3D=3D"0302"
    ATTRS{bDeviceClass}=3D=3D"09"
    ATTRS{bDeviceSubClass}=3D=3D"00"
    ATTRS{bDeviceProtocol}=3D=3D"00"
    ATTRS{bNumConfigurations}=3D=3D"1"
    ATTRS{bMaxPacketSize0}=3D=3D"64"
    ATTRS{speed}=3D=3D"480"
    ATTRS{busnum}=3D=3D"1"
    ATTRS{devnum}=3D=3D"1"
    ATTRS{devpath}=3D=3D"0"
    ATTRS{version}=3D=3D" 2.00"
    ATTRS{maxchild}=3D=3D"8"
    ATTRS{quirks}=3D=3D"0x0"
    ATTRS{avoid_reset_quirk}=3D=3D"0"
    ATTRS{authorized}=3D=3D"1"
    ATTRS{manufacturer}=3D=3D"Linux 3.2.0-18-generic ehci_hcd"
    ATTRS{product}=3D=3D"EHCI Host Controller"
    ATTRS{serial}=3D=3D"0000:00:1d.7"
    ATTRS{authorized_default}=3D=3D"1"

  looking at parent device '/devices/pci0000:00/0000:00:1d.7':
    KERNELS=3D=3D"0000:00:1d.7"
    SUBSYSTEMS=3D=3D"pci"
    DRIVERS=3D=3D"ehci_hcd"
    ATTRS{vendor}=3D=3D"0x8086"
    ATTRS{device}=3D=3D"0x24dd"
    ATTRS{subsystem_vendor}=3D=3D"0x1043"
    ATTRS{subsystem_device}=3D=3D"0x80a6"
    ATTRS{class}=3D=3D"0x0c0320"
    ATTRS{irq}=3D=3D"23"
    ATTRS{local_cpus}=3D=3D"ff"
    ATTRS{local_cpulist}=3D=3D"0-7"
    ATTRS{dma_mask_bits}=3D=3D"32"
    ATTRS{consistent_dma_mask_bits}=3D=3D"32"
    ATTRS{enable}=3D=3D"1"
    ATTRS{broken_parity_status}=3D=3D"0"
    ATTRS{msi_bus}=3D=3D""
    ATTRS{companion}=3D=3D""
    ATTRS{uframe_periodic_max}=3D=3D"100"

  looking at parent device '/devices/pci0000:00':
    KERNELS=3D=3D"pci0000:00"
    SUBSYSTEMS=3D=3D""
    DRIVERS=3D=3D""

So I tried rules like:

SUBSYSTEM=3D=3D"dvb", ATTRS{product}=3D=3D"WinTV HVR-950", SYMLINK=3D"dvb=
_pvr950q"
SUBSYSTEM=3D=3D"dvb", DRIVERS=3D=3D"cx18", SYMLINK=3D"dvb_hvr1600"

but those ended up symlinking to the "net0" device:

lrwxrwxrwx 1 root root 17 Apr 24 12:56 /dev/dvb_hvr1600 -> dvb/adapter0/n=
et0
lrwxrwxrwx 1 root root 17 Apr 24 12:56 /dev/dvb_pvr950q -> dvb/adapter1/n=
et0

How can I create symlinks to the "frontend0" device rather than the
net0 device?

Cheers,
b.

[1] You might wonder why I would care given that they both do
    quite the same thing and who cares which one is "0" and which
    one is "1".  But the reality is that while they might function
    the same the HVR-1600 produces streams with "glitches" in them
    (see my other message to this list "HVR-1600 QAM recordings with
    slight glitches in them" -- but yes, otherwise I couldn't really
    care less about which was which) and the PVR-950Q produces _perfect_
    streams, so I really only want to use the HVR-1600 in "overflow"
    situations.


--------------enig70620D3435885B5AD3D76935
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+W344ACgkQl3EQlGLyuXCCeQCeOsQx75/Iq25SLSpEsn+wxmKt
CckAnjN/DFqu9O4SwBEIUb/5V4xVtIu9
=2u+V
-----END PGP SIGNATURE-----

--------------enig70620D3435885B5AD3D76935--

