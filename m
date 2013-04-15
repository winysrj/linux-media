Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4369 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3DOGzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 02:55:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Keene
Date: Mon, 15 Apr 2013 08:55:07 +0200
Cc: LMML <linux-media@vger.kernel.org>
References: <5167513D.60804@iki.fi>
In-Reply-To: <5167513D.60804@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304150855.07081.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri April 12 2013 02:11:41 Antti Palosaari wrote:
> Hello Hans,
> That device is working very, thank you for it. Anyhow, I noticed two things.
> 
> 1) it does not start transmitting just after I plug it - I have to 
> retune it!
> Output says it is tuned to 95.160000 MHz by default, but it is not. 
> After I issue retune, just to same channel it starts working.
> $ v4l2-ctl -d /dev/radio0 --set-freq=95.16

Can you try this patch:

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 4c9ae76..99da3d4 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -93,7 +93,7 @@ static int keene_cmd_main(struct keene_device *radio, unsigned freq, bool play)
 	/* If bit 4 is set, then tune to the frequency.
 	   If bit 3 is set, then unmute; if bit 2 is set, then mute.
 	   If bit 1 is set, then enter idle mode; if bit 0 is set,
-	   then enter transit mode.
+	   then enter transmit mode.
 	 */
 	radio->buffer[5] = (radio->muted ? 4 : 8) | (play ? 1 : 2) |
 							(freq ? 0x10 : 0);
@@ -350,7 +350,6 @@ static int usb_keene_probe(struct usb_interface *intf,
 	radio->pa = 118;
 	radio->tx = 0x32;
 	radio->stereo = true;
-	radio->curfreq = 95.16 * FREQ_MUL;
 	if (hdl->error) {
 		retval = hdl->error;
 
@@ -383,6 +382,8 @@ static int usb_keene_probe(struct usb_interface *intf,
 	video_set_drvdata(&radio->vdev, radio);
 	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
 
+	keene_cmd_main(radio, 95.16 * FREQ_MUL, false);
+
 	retval = video_register_device(&radio->vdev, VFL_TYPE_RADIO, -1);
 	if (retval < 0) {
 		dev_err(&intf->dev, "could not register video device\n");


> 2) What is that log printing?
> ALSA sound/usb/mixer.c:932 13:0: cannot get min/max values for control 2 
> (id 13)
> 
> 
> usb 5-2: new full-speed USB device number 3 using ohci_hcd
> usb 5-2: New USB device found, idVendor=046d, idProduct=0a0e
> usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 5-2: Product: B-LINK USB Audio
> usb 5-2: Manufacturer: HOLTEK
> ALSA sound/usb/mixer.c:932 13:0: cannot get min/max values for control 2 
> (id 13)
> radio-keene 5-2:1.2: V4L2 device registered as radio0

No idea, and I don't get that message either.

Regards,

	Hans

> 
> 
> $ v4l2-ctl -d /dev/radio0 --all -L
> Driver Info (not using libv4l2):
> 	Driver name   : radio-keene
> 	Card type     : Keene FM Transmitter
> 	Bus info      : usb-0000:00:13.0-2
> 	Driver version: 3.9.0
> 	Capabilities  : 0x800C0000
> 		Modulator
> 		Radio
> Frequency: 1522560 (95.160000 MHz)
> Modulator:
> 	Name                 : FM
> 	Capabilities         : 62.5 Hz stereo
> 	Frequency range      : 76.0 MHz - 108.0 MHz
> 	Subchannel modulation: stereo
> Priority: 2
> 
> User Controls
> 
>                             mute (bool)   : default=0 value=0
> 
> FM Radio Modulator Controls
> 
>           audio_compression_gain (int)    : min=-15 max=18 step=3 
> default=0 value=0 flags=slider
>                     pre_emphasis (menu)   : min=0 max=2 default=1 value=1
> 				1: 50 Microseconds
> 				2: 75 Microseconds
>                 tune_power_level (int)    : min=84 max=118 step=1 
> default=118 value=118 flags=slider
> 
> 
> regards
> Antti
> 
> 
