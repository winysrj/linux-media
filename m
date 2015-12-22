Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbbLVRth (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 12:49:37 -0500
Subject: Re: sn9c20x: incorrect support for 0c45:6270 MT9V011/MT9V111 ?
To: TJ <linux@iam.tj>, linux-media@vger.kernel.org
References: <f75a1c2564625a7c0ea49822e4553f1f@iam.tj>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <56798D2C.8010504@redhat.com>
Date: Tue, 22 Dec 2015 18:49:32 +0100
MIME-Version: 1.0
In-Reply-To: <f75a1c2564625a7c0ea49822e4553f1f@iam.tj>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi TJ,

On 12/18/2015 12:48 PM, TJ wrote:
> I've been trying to get the 0c45:6270 Vehoh VMS-001 'Discovery' Microscope to work correctly and discovered what seem to be differences in the bridge_init and other control commands. The most obvious difference currently is the LEDs do not turn on, but there seem to be other problems with empty frames, bad/unrecognised formats, and resolutions, although vlc is able to render a usable JPEG stream.
>
> I've installed the Windows XP Sonix driver package in a Qemu virtual machine guest and used wireshark on the host (Kubuntu 15.10, kernel v4.2) to capture and analyse the control commands.
>
> https://iam.tj/projects/misc/usbmon-0c45-6270.pcapng
>
> That seems to show the bridge_init, and possibly some of the i2c_init, byte sequences are different. It being the first time I've sniffed a USB driver though, I'm not yet 100% confident I'm identifying the correct starting point of the control command flow or the relationships between code and what is on the wire.
>
> The Windows .inf seems to indicate the chipset is MT9V111:
>
> %USBPCamDesc% = SN.USBPCam,USB\VID_0c45&PID_6270 ; SN9C201 + MI0360\MT9V111
>
> but the sn9c20x is matching as the MT9V011 (I've copied the module to a DKMS build location and named the clone sn9c20x_vehoh, matching only on 0c45_6270, to make testing easier):

Right, so it likely actually is an MT9V011, at least we are successfully reading the sensor-id,
and it has the id of an MT9V011, reading the id is more reliable then relying on the windows
inf file :)

>   gspca_main: v2.14.0 registered
>   gspca_main: sn9c20x_vehoh-2.14.0 probing 0c45:6270
>   sn9c20x_vehoh: MT9V011 sensor detected
>   sn9c20x_vehoh: MT9VPRB sensor detected
>   input: sn9c20x_vehoh as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/input/input34
>   sn9c20x_vehoh 2-3:1.0: video1 created
>
> I'd like to know the best way to add the correct command support in this situation where the existing Linux driver's control data is different to that in use by the Windows driver?

The best way I can think of to do this is to add a "#define SENSOR_MT9V011_ALT" to the list
of sensor defines which uses the correct init sequences for your cam, and add a module
option to override the sd->sensor value from the cmdline, so you would get something like
this in sd_config():

	if (sensor_override != -1)
		sd->sensor = sensor_override;
	else
		sd->sensor = id->driver_info >> 8;

And then you can set the sensor_override module option to SENSOR_MT9V011_ALT when loading
the module to work with your cam. I realize that this is not ideal, but I'm afraid it is
the best I can come up with, this at least will allow you to develop support for your cam,
once we have that we can see if we can find some way to autodetect it.

Regards,

Hans



>
> Do I somehow create another profile in the driver, or directly modify the existing data and command sequences (this latter would seem to risk regressions for other users) ?
>
> If creating another profile, how would they differentiate seeing as the device IDs are identical (I've not seen any sign of obvious version responses so far) ?
>
> My first attempt to add the correct command values for controlling the LEDs failed, and seems to indicate that more than 1 command is sent to control the LEDs, unlike the sn9c20x driver.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
