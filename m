Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3331 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3DSJ6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 05:58:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Keene
Date: Fri, 19 Apr 2013 11:58:04 +0200
Cc: LMML <linux-media@vger.kernel.org>
References: <5167513D.60804@iki.fi> <201304190912.06319.hverkuil@xs4all.nl> <51710A3F.10909@iki.fi>
In-Reply-To: <51710A3F.10909@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191158.04116.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri April 19 2013 11:11:27 Antti Palosaari wrote:
> On 04/19/2013 10:12 AM, Hans Verkuil wrote:
> > On Wed April 17 2013 21:45:24 Antti Palosaari wrote:
> >> On 04/15/2013 09:55 AM, Hans Verkuil wrote:
> >>> On Fri April 12 2013 02:11:41 Antti Palosaari wrote:
> >>>> Hello Hans,
> >>>> That device is working very, thank you for it. Anyhow, I noticed two things.
> >>>>
> >>>> 1) it does not start transmitting just after I plug it - I have to
> >>>> retune it!
> >>>> Output says it is tuned to 95.160000 MHz by default, but it is not.
> >>>> After I issue retune, just to same channel it starts working.
> >>>> $ v4l2-ctl -d /dev/radio0 --set-freq=95.16
> >>>
> >>> Can you try this patch:
> >>>
> >>
> >> It does not resolve the problem. It is quite strange behavior. After I
> >> install modules, and modules are unload, plug stick in first time, it
> >> usually (not every-time) starts TX. But when I replug it without
> >> unloading modules, it will never start TX. Tx is started always when I
> >> set freq using v4l2-ctl.
> >
> > If you replace 'false' by 'true' in the cmd_main, does that make it work?
> > I'm fairly certain that's the problem.
> 
> Nope, I replaces all 'false' with 'true' and problem remains. When 
> modules were unload and device is plugged it starts TX. When I replug it 
> doesn't start anymore.
> 
> I just added msleep(1000); just before keene_cmd_main() in .probe() and 
> now it seems to work every-time. So it is definitely timing issue. I 
> will try to find out some smallest suitable value for sleep and and sent 
> patch.
> 
> 
> >
> >>
> >> Possible timing issue?
> >>
> >>
> >> Is there some flag API flag to tell start / stop device? For my mind
> >> correct behavior is to stop TX and sleep when device is plugged/module
> >> load. Something like set freq 0 when device is not active to tell user
> >> it is not sending/receiving and must be tuned in order to operate.
> >
> > This is actually a core problem with the radio API: there is no clear
> > way of turning the tuner or modulator on and off on command. With video
> > you know that you can turn off the tuner if no filehandle is open. But
> > with radio you do not have that luxury since audio can go through alsa
> > or through an audio jack.
> >
> > One option is to use mute. Most radio receivers start off muted and you
> > have to unmute first. This could be used as a signal for receivers to
> > turn the tuner on/off. But for a modulator that's not an option: turning
> > off the modulator means turning off the transmitter, and that's not what
> > you want if you are, say, the presenter of a radio program and you want
> > to quickly mute because you feel a sneeze coming :-)
> >
> > I think we need a specific API for this, but in the absence of one we should
> > just leave the modulator enabled from the start.
> 
> yeah, that's just the issue I was wondering. Is there some reason 
> frequency value could not be used? Defining frequency to 0MHz or -1MHz 
> and Tx (maybe Rx too) is off?

It's one option, yes. But I'm not entirely pleased with that as I'd like the
driver to remember the last frequency. I would prefer to handle this as a
separate setting. There may be other solutions as well, I'm not sure.

The core problem is of course a poor design of the radio API: it really should
behave like a video node where it is possible to power off if nobody has the
node open. But that breaks compatibility...

Since this is all very specific to radio devices I am inclined to introduce
a radio-specific ioctl or control for this.

But there is a related issue with USB video devices: after the last close()
do you power off the device immediately, wait a bit before doing that or keep
it alive all the time? This becomes relevant if powering up takes a long time
because of e.g. having to reload firmware or intializing i2c devices.

So perhaps this can be solved with two generic controls:

bool CID_POWER_OFF_AT_LAST_CLOSE
int CID_POWER_OFF_DELAY (unit: seconds)

If POWER_OFF_AT_LAST_CLOSE is false, then you never power off. If it is true,
then power off after a given delay. If the delay == 0 then power off immediately.

Drivers can decide on proper default values. But radio devices must start
with CID_POWER_OFF_AT_LAST_CLOSE set to false for compatibility reasons.

I don't have time for the next few weeks to investigate this further, so if
you are interested...

Regards,

	Hans

> Here is power consumption I measured:
> 26.5mA play=false (idle mode)
> 39.0mA Tx on 95.16 MHz
> 
> It wastes 12.5mA (from USB Vcc 5v) when Tx is enabled.
> 
> regards
> Antti
> 
> >
> > Regards,
> >
> > 	Hans
> >
> >>
> >>
> >> regards
> >> Antti
> >>
> >>
> >>
> >>
> >>
> >>
> >>> diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
> >>> index 4c9ae76..99da3d4 100644
> >>> --- a/drivers/media/radio/radio-keene.c
> >>> +++ b/drivers/media/radio/radio-keene.c
> >>> @@ -93,7 +93,7 @@ static int keene_cmd_main(struct keene_device *radio, unsigned freq, bool play)
> >>>    	/* If bit 4 is set, then tune to the frequency.
> >>>    	   If bit 3 is set, then unmute; if bit 2 is set, then mute.
> >>>    	   If bit 1 is set, then enter idle mode; if bit 0 is set,
> >>> -	   then enter transit mode.
> >>> +	   then enter transmit mode.
> >>>    	 */
> >>>    	radio->buffer[5] = (radio->muted ? 4 : 8) | (play ? 1 : 2) |
> >>>    							(freq ? 0x10 : 0);
> >>> @@ -350,7 +350,6 @@ static int usb_keene_probe(struct usb_interface *intf,
> >>>    	radio->pa = 118;
> >>>    	radio->tx = 0x32;
> >>>    	radio->stereo = true;
> >>> -	radio->curfreq = 95.16 * FREQ_MUL;
> >>>    	if (hdl->error) {
> >>>    		retval = hdl->error;
> >>>
> >>> @@ -383,6 +382,8 @@ static int usb_keene_probe(struct usb_interface *intf,
> >>>    	video_set_drvdata(&radio->vdev, radio);
> >>>    	set_bit(V4L2_FL_USE_FH_PRIO, &radio->vdev.flags);
> >>>
> >>> +	keene_cmd_main(radio, 95.16 * FREQ_MUL, false);
> >>> +
> >>>    	retval = video_register_device(&radio->vdev, VFL_TYPE_RADIO, -1);
> >>>    	if (retval < 0) {
> >>>    		dev_err(&intf->dev, "could not register video device\n");
> >>>
> >>>
> >>>> 2) What is that log printing?
> >>>> ALSA sound/usb/mixer.c:932 13:0: cannot get min/max values for control 2
> >>>> (id 13)
> >>>>
> >>>>
> >>>> usb 5-2: new full-speed USB device number 3 using ohci_hcd
> >>>> usb 5-2: New USB device found, idVendor=046d, idProduct=0a0e
> >>>> usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> >>>> usb 5-2: Product: B-LINK USB Audio
> >>>> usb 5-2: Manufacturer: HOLTEK
> >>>> ALSA sound/usb/mixer.c:932 13:0: cannot get min/max values for control 2
> >>>> (id 13)
> >>>> radio-keene 5-2:1.2: V4L2 device registered as radio0
> >>>
> >>> No idea, and I don't get that message either.
> >>>
> >>> Regards,
> >>>
> >>> 	Hans
> >>>
> >>>>
> >>>>
> >>>> $ v4l2-ctl -d /dev/radio0 --all -L
> >>>> Driver Info (not using libv4l2):
> >>>> 	Driver name   : radio-keene
> >>>> 	Card type     : Keene FM Transmitter
> >>>> 	Bus info      : usb-0000:00:13.0-2
> >>>> 	Driver version: 3.9.0
> >>>> 	Capabilities  : 0x800C0000
> >>>> 		Modulator
> >>>> 		Radio
> >>>> Frequency: 1522560 (95.160000 MHz)
> >>>> Modulator:
> >>>> 	Name                 : FM
> >>>> 	Capabilities         : 62.5 Hz stereo
> >>>> 	Frequency range      : 76.0 MHz - 108.0 MHz
> >>>> 	Subchannel modulation: stereo
> >>>> Priority: 2
> >>>>
> >>>> User Controls
> >>>>
> >>>>                               mute (bool)   : default=0 value=0
> >>>>
> >>>> FM Radio Modulator Controls
> >>>>
> >>>>             audio_compression_gain (int)    : min=-15 max=18 step=3
> >>>> default=0 value=0 flags=slider
> >>>>                       pre_emphasis (menu)   : min=0 max=2 default=1 value=1
> >>>> 				1: 50 Microseconds
> >>>> 				2: 75 Microseconds
> >>>>                   tune_power_level (int)    : min=84 max=118 step=1
> >>>> default=118 value=118 flags=slider
> >>>>
> >>>>
> >>>> regards
> >>>> Antti
> >>>>
> >>>>
> >>
> >>
> >>
> 
> 
> 
