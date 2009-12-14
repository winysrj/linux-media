Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45600 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755155AbZLNKAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 05:00:45 -0500
Received: by pwi6 with SMTP id 6so2097507pwi.7
        for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 02:00:42 -0800 (PST)
Message-ID: <4B260ADE.6060803@lovedthanlost.net>
Date: Mon, 14 Dec 2009 20:52:30 +1100
From: James Turnbull <james@lovedthanlost.net>
Reply-To: james@lovedthanlost.net
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Dvico FusionHDTV Dual Express PCIe tuner issues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all

I've got a Dvico FusionHDTV Dual Express PCIe tuner, which returns
the following lspci output:

lspci output:

03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 02)
	Subsystem: DViCO Corporation Device db78
	Flags: fast devsel, IRQ 16
	Memory at fb800000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Count=1/1 Enable-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSVoil-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSVoil-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSVoil-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [200] Virtual Channel <?>
	Kernel modules: cx23885

I understood the digital side of the card was supported but I can't
get it to work.  I've tried the cx23885 module in v4l-dvb HEAD but
get the following error ( on kernel 2.6.27.41-170.2.117.fc10.i686):

# modprobe cx23885
FATAL: Error inserting cx23885
(/lib/modules/2.6.27.41-170.2.117.fc10.i686/kernel/drivers/media/video/cx23885/cx23885.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

dmesg output:

cx23885: Unknown symbol v4l2_i2c_new_probed_subdev
cx23885: Unknown symbol videobuf_dvb_alloc_frontend
cx23885: Unknown symbol v4l2_i2c_subdev_addr
cx23885: Unknown symbol videobuf_dvb_get_frontend
cx23885: Unknown symbol v4l2_device_register
cx23885: Unknown symbol videobuf_dvb_unregister_bus
cx23885: Unknown symbol videobuf_dvb_register_bus
cx23885: Unknown symbol v4l2_i2c_tuner_addrs
cx23885: Unknown symbol v4l2_device_unregister
cx23885: Unknown symbol v4l2_i2c_new_subdev
cx23885: Unknown symbol v4l2_i2c_new_probed_subdev
cx23885: Unknown symbol videobuf_dvb_alloc_frontend
cx23885: Unknown symbol v4l2_i2c_subdev_addr
cx23885: Unknown symbol videobuf_dvb_get_frontend
cx23885: Unknown symbol v4l2_device_register
cx23885: Unknown symbol videobuf_dvb_unregister_bus
cx23885: Unknown symbol videobuf_dvb_register_bus
cx23885: Unknown symbol v4l2_i2c_tuner_addrs
cx23885: Unknown symbol v4l2_device_unregister
cx23885: Unknown symbol v4l2_i2c_new_subdev
cx23885: Unknown symbol v4l2_i2c_new_subdev_cfg
cx23885: Unknown symbol videobuf_dvb_alloc_frontend
cx23885: Unknown symbol v4l2_i2c_subdev_addr
cx23885: Unknown symbol ir_codes_hauppauge_new_table
cx23885: Unknown symbol v4l2_device_register_subdev
cx23885: Unknown symbol v4l_bound_align_image
cx23885: Unknown symbol ir_rc5_timer_keyup
cx23885: Unknown symbol v4l2_device_unregister_subdev
cx23885: Unknown symbol videobuf_dvb_get_frontend
cx23885: Unknown symbol ir_input_init
cx23885: Unknown symbol v4l2_device_register
cx23885: Unknown symbol videobuf_dvb_unregister_bus
cx23885: Unknown symbol ir_input_nokey
cx23885: Unknown symbol ir_rc5_decode
cx23885: Unknown symbol ir_input_unregister
cx23885: Unknown symbol videobuf_dvb_register_bus
cx23885: Unknown symbol v4l2_i2c_tuner_addrs
cx23885: Unknown symbol v4l2_device_unregister
cx23885: Unknown symbol ir_input_keydown
cx23885: Unknown symbol ir_input_register
cx23885: Unknown symbol v4l2_i2c_new_subdev_cfg
cx23885: Unknown symbol videobuf_dvb_alloc_frontend
cx23885: Unknown symbol v4l2_i2c_subdev_addr
cx23885: Unknown symbol ir_codes_hauppauge_new_table
cx23885: Unknown symbol v4l2_device_register_subdev
cx23885: Unknown symbol v4l_bound_align_image
cx23885: Unknown symbol ir_rc5_timer_keyup
cx23885: Unknown symbol v4l2_device_unregister_subdev
cx23885: Unknown symbol videobuf_dvb_get_frontend
cx23885: Unknown symbol ir_input_init
cx23885: Unknown symbol v4l2_device_register
cx23885: Unknown symbol videobuf_dvb_unregister_bus
cx23885: Unknown symbol ir_input_nokey
cx23885: Unknown symbol ir_rc5_decode
cx23885: Unknown symbol ir_input_unregister
cx23885: Unknown symbol videobuf_dvb_register_bus
cx23885: Unknown symbol v4l2_i2c_tuner_addrs
cx23885: Unknown symbol v4l2_device_unregister
cx23885: Unknown symbol ir_input_keydown
cx23885: Unknown symbol ir_input_register

Anyone have any ideas/a fix for this?

Regards

James Turnbull

- --
Author of:
* Pro Linux System Administration (http://tinyurl.com/linuxadmin)
* Pulling Strings with Puppet (http://tinyurl.com/pupbook)
* Pro Nagios 2.0 (http://tinyurl.com/pronagios)
* Hardening Linux (http://tinyurl.com/hardeninglinux)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEVAwUBSyYK3iFa/lDkFHAyAQJSwggA0iI3ziFAR//BsHrRRvjBvOVRFWfZFEbT
d9kGq4L+wRbdimCE64MJhmGpDd+9OK2p4h14ezg++4C8Kp32P+5t3noUqKbAJn/f
1rh9fFol+XCvs7UQQ1OWwua8i345nozHLEkwabsOJ47geSeX6u9eNr/shgsQBXg8
E2v9JRC55bjkp48wL8knKLYv6ivW0zjeXVR2XS1VJov4iCP3j+yJmboFROh38KBB
NuynncP4uV9DDSW8Fg0DYC8yvm3w8Vhc5Y6dIEupJCLio+dQfZSSy8teHA7uPQkt
7Dra9+AzingqX1H0ba6Zr5gWukHdNsGI7GMmIi7M2Bai5Pc/gJYlnw==
=MB4w
-----END PGP SIGNATURE-----
