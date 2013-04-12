Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52598 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab3DLAMX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 20:12:23 -0400
Message-ID: <5167513D.60804@iki.fi>
Date: Fri, 12 Apr 2013 03:11:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>
Subject: Keene
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,
That device is working very, thank you for it. Anyhow, I noticed two things.

1) it does not start transmitting just after I plug it - I have to 
retune it!
Output says it is tuned to 95.160000 MHz by default, but it is not. 
After I issue retune, just to same channel it starts working.
$ v4l2-ctl -d /dev/radio0 --set-freq=95.16

2) What is that log printing?
ALSA sound/usb/mixer.c:932 13:0: cannot get min/max values for control 2 
(id 13)


usb 5-2: new full-speed USB device number 3 using ohci_hcd
usb 5-2: New USB device found, idVendor=046d, idProduct=0a0e
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: B-LINK USB Audio
usb 5-2: Manufacturer: HOLTEK
ALSA sound/usb/mixer.c:932 13:0: cannot get min/max values for control 2 
(id 13)
radio-keene 5-2:1.2: V4L2 device registered as radio0


$ v4l2-ctl -d /dev/radio0 --all -L
Driver Info (not using libv4l2):
	Driver name   : radio-keene
	Card type     : Keene FM Transmitter
	Bus info      : usb-0000:00:13.0-2
	Driver version: 3.9.0
	Capabilities  : 0x800C0000
		Modulator
		Radio
Frequency: 1522560 (95.160000 MHz)
Modulator:
	Name                 : FM
	Capabilities         : 62.5 Hz stereo
	Frequency range      : 76.0 MHz - 108.0 MHz
	Subchannel modulation: stereo
Priority: 2

User Controls

                            mute (bool)   : default=0 value=0

FM Radio Modulator Controls

          audio_compression_gain (int)    : min=-15 max=18 step=3 
default=0 value=0 flags=slider
                    pre_emphasis (menu)   : min=0 max=2 default=1 value=1
				1: 50 Microseconds
				2: 75 Microseconds
                tune_power_level (int)    : min=84 max=118 step=1 
default=118 value=118 flags=slider


regards
Antti

-- 
http://palosaari.fi/
