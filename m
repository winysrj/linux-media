Return-path: <linux-media-owner@vger.kernel.org>
Received: from yes.iam.tj ([109.74.197.121]:58750 "EHLO iam.tj"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752504AbbLRLzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 06:55:03 -0500
To: linux-media@vger.kernel.org
Subject: sn9c20x: incorrect support for 0c45:6270 MT9V011/MT9V111  =?UTF-8?Q?=3F?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Dec 2015 11:48:19 +0000
From: TJ <linux@iam.tj>
Message-ID: <f75a1c2564625a7c0ea49822e4553f1f@iam.tj>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been trying to get the 0c45:6270 Vehoh VMS-001 'Discovery' 
Microscope to work correctly and discovered what seem to be differences 
in the bridge_init and other control commands. The most obvious 
difference currently is the LEDs do not turn on, but there seem to be 
other problems with empty frames, bad/unrecognised formats, and 
resolutions, although vlc is able to render a usable JPEG stream.

I've installed the Windows XP Sonix driver package in a Qemu virtual 
machine guest and used wireshark on the host (Kubuntu 15.10, kernel 
v4.2) to capture and analyse the control commands.

https://iam.tj/projects/misc/usbmon-0c45-6270.pcapng

That seems to show the bridge_init, and possibly some of the i2c_init, 
byte sequences are different. It being the first time I've sniffed a USB 
driver though, I'm not yet 100% confident I'm identifying the correct 
starting point of the control command flow or the relationships between 
code and what is on the wire.

The Windows .inf seems to indicate the chipset is MT9V111:

%USBPCamDesc% = SN.USBPCam,USB\VID_0c45&PID_6270 ; SN9C201 + 
MI0360\MT9V111

but the sn9c20x is matching as the MT9V011 (I've copied the module to a 
DKMS build location and named the clone sn9c20x_vehoh, matching only on 
0c45_6270, to make testing easier):

  gspca_main: v2.14.0 registered
  gspca_main: sn9c20x_vehoh-2.14.0 probing 0c45:6270
  sn9c20x_vehoh: MT9V011 sensor detected
  sn9c20x_vehoh: MT9VPRB sensor detected
  input: sn9c20x_vehoh as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/input/input34
  sn9c20x_vehoh 2-3:1.0: video1 created

I'd like to know the best way to add the correct command support in 
this situation where the existing Linux driver's control data is 
different to that in use by the Windows driver?

Do I somehow create another profile in the driver, or directly modify 
the existing data and command sequences (this latter would seem to risk 
regressions for other users) ?

If creating another profile, how would they differentiate seeing as the 
device IDs are identical (I've not seen any sign of obvious version 
responses so far) ?

My first attempt to add the correct command values for controlling the 
LEDs failed, and seems to indicate that more than 1 command is sent to 
control the LEDs, unlike the sn9c20x driver.
