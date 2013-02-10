Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60978 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab3BJVuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 16:50:35 -0500
Received: by mail-vc0-f178.google.com with SMTP id m8so3447889vcd.9
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 13:50:34 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 10 Feb 2013 21:50:34 +0000
Message-ID: <CALW4P+Kj8iT75JgNH6XXA4qe5LadgMWAc5RVnWZYskB66=6=Tg@mail.gmail.com>
Subject: [radio-si470x questions] Re: HI. problem with playing radio using
 fmtools, radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: Igor Stamatovski <stamatovski@gmail.com>
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>,
	Linux Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Igor,

First of all, i change subject of email to something more relevant
here. I think that a lot of people was spammed with subject "Hi" of
your email.

Second. Please do not drop media maillist and contacts from c/c.
And third, sorry for long delay.

On Mon, Jan 28, 2013 at 4:21 PM, Igor Stamatovski <stamatovski@gmail.com> wrote:
> Hi Alexey, seems like things have changed from the last time i was playing
> with the radio cards.
>
> This ADS Tech InstantFM card i have, even though i bought couple of them
> now, i see that the company is not active and the reference design for this
> card is not supported.
> On the site i found some information about first boot of the usb. There is
> windows software that sets up the card with initial parameters like spacing
> band etc...
>
> With the driver you can set all those parameters in  /etc/modules
> I used the source to see what those settings mean, and applied to the
> /etc/modules
>
> radio-usb-si470x de=1 band=0 space=1  //this all means europe bands and
> spacing
> snd_usb_audio
> usbhid
>
> Im using 12.10 ubuntu 32bit with latest upgades, with fmtools package and
> radio application both installed from ubuntu repo.
>
> the thing is that i must route audio from the FM card to the audio card to
> hear audio.
> I can do this with arecord -c2 -q -r96000 -f S16_LE
> i can pipe this to aplay so it looks like this:
>
> arecord -c2 -q -r96000 -f S16_LE | aplay -q
>
> i can also make initial scan with the radio application
>
> radio -S
>
> which scans whole band and recognizes local stations, then creates the
> config file in the directory where the radio app is started.
>
> Up to here everything works as expected...
>
> next thing is to use fmtools to set the card to a specific freq...
>
> you do this with
> fm on //unmute the card
> fm 95.5 100 //should set the card to 95.5Mhz and set the volume to 100%
> after this the command exits and mutes the radio automatically or maybe
> resets the band...
>
> same thing happens with radio application. radio has switch -q which tells
> the application to exit interactive mode in order to be used from command
> line.
> so
> radio -f 95.5 -q
> should set the freq to 95.5 and exit the application but the radio should
> continue operating with this settings. What happens is the radio gets muted
> or changes band.....

Well, last time i checked fmtools/radio programs i thought that they
used V4L version 1. I don't know if it will work well nowadays.

I experimented with my Kworld usb radio that uses the same driver
(radio-si470x). I use sox to redirect sound from radio:
sox --endian little -c 2 -S  -r 96000 -t alsa hw:1 -t alsa -r 96000 hw:0

(i have problem with "alsa: under-run" because of sound card and radio
are connected to the usb ports, not enough bandwidth)

To set up frequency and volume i used v4l2-ctrl utility. (Package name
in Debian is v4l-utils, should be available in Ubuntu.) Something like
this:
v4l2-ctl -d /dev/radio0 --set-ctrl=volume=10,mute=0 --set-freq=95.21

I can run sox in one terminal and i can run v4l2-ctl in another
terminal and radio still plays. I can change frequency without
stopping radio.

Could you please try v4l2-ctl? If it will not work for you it can be
problem with drivers, firmware..

> Now i have bought another TV tuner PCI 250 cinergy card which has FM tuner
> onboard and uses different driver for the radio....
> Both applications radio and fmtools behave the same with the two different
> cards.
>
> So the question is.... how do i keep radio running while issuing a command
> trough fmtools or radio app.
> Is there any other app that keeps radio open while receiving control
> commands.
>
> Thanks

I believe that feature you describe was called "Mute on exit?" in
gnomeradio program.

> On Mon, Jan 28, 2013 at 3:27 PM, Alexey Klimov <klimov.linux@gmail.com>
> wrote:
>>
>> Hello Igor,
>>
>> On Mon, Jan 28, 2013 at 3:14 AM, Igor Stamatovski <stamatovski@gmail.com>
>> wrote:
>> > Im trying to use ADS tech instantFM music USB card.
>> >
>> > dmesg reports this after machine reset (USB stays on machine)
>> >
>> > [    6.387624] USB radio driver for Si470x FM Radio Receivers, Version
>> > 1.0.10
>> > [    6.930228] radio-si470x 1-1.2:1.2: DeviceID=0xffff ChipID=0xffff
>> > [    7.172429] radio-si470x 1-1.2:1.2: software version 0, hardware
>> > version 7
>> > [    7.355485] radio-si470x 1-1.2:1.2: This driver is known to work
>> > with software version 7,
>> > [    7.532554] radio-si470x 1-1.2:1.2: but the device has software
>> > version 0.
>> > [    7.644091] radio-si470x 1-1.2:1.2: If you have some trouble using
>> > this driver,
>> > [    7.728735] radio-si470x 1-1.2:1.2: please report to V4L ML at
>> > linux-media@vger.kernel.org
>> > [    7.840415] usbcore: registered new interface driver radio-si470x
>> > [    8.465398] usbcore: registered new interface driver snd-usb-audio
>> >
>> > i can note the deviceID and ChipID are not recognised but still some
>> > modules load for the card...
>> >
>> > after reinsert same USB card reports this
>> >
>> > [  102.460158] usb 1-1.2: USB disconnect, device number 4
>> > [  102.464721] radio-si470x 1-1.2:1.2: si470x_set_report:
>> > usb_control_msg returned -19
>> > [  106.535669] usb 1-1.2: new full-speed USB device number 6 using
>> > dwc_otg
>> > [  106.638514] usb 1-1.2: New USB device found, idVendor=06e1,
>> > idProduct=a155
>> > [  106.638545] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
>> > SerialNumber=0
>> > [  106.638562] usb 1-1.2: Product: ADS InstantFM Music
>> > [  106.638576] usb 1-1.2: Manufacturer: ADS TECH
>> > [  106.644537] radio-si470x 1-1.2:1.2: DeviceID=0x1242 ChipID=0x0a0f
>> > [  106.645257] radio-si470x 1-1.2:1.2: software version 0, hardware
>> > version 7
>> > [  106.645288] radio-si470x 1-1.2:1.2: This driver is known to work
>> > with software version 7,
>> > [  106.645306] radio-si470x 1-1.2:1.2: but the device has software
>> > version 0.
>> > [  106.645321] radio-si470x 1-1.2:1.2: If you have some trouble using
>> > this driver,
>> > [  106.645337] radio-si470x 1-1.2:1.2: please report to V4L ML at
>> > linux-media@vger.kernel.org
>> >
>> > the radio can scan local radios and create config file with the radio
>> > application.
>> > using arecord piped to aplay does nothing.
>>
>> Could you please give more details here? How do you scan local radios
>> and create config file? May i miss some information and this driver
>> can create config file by itself.
>>
>> Could you please try other ways to catch sound using
>> Documentation/video4linux/si470x.txt file ?
>> There are also few possible ways described in this file:
>>
>> [quote]
>> Audio Listing
>> =============
>> USB Audio is provided by the ALSA snd_usb_audio module. It is recommended
>> to
>> also select SND_USB_AUDIO, as this is required to get sound from the
>> radio. For
>> listing you have to redirect the sound, for example using one of the
>> following
>> commands. Please adjust the audio devices to your needs (/dev/dsp* and
>> hw:x,x).
>>
>> If you just want to test audio (very poor quality):
>> cat /dev/dsp1 > /dev/dsp
>>
>> If you use OSS try:
>> sox -2 --endian little -r 96000 -t oss /dev/dsp1 -t oss /dev/dsp
>>
>> If you use arts try:
>> arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -
>>
>> If you use mplayer try:
>> mplayer -radio adevice=hw=1.0:arate=96000 \
>>         -rawaudio rate=96000 \
>>         radio://<frequency>/capture
>>
>> [/quote]
>>
>> > i wanted to know how do i update software version 0 to software
>> > version 7 and try this driver?
>>
>> I don't know much about such update. May be doc file can be checked
>> for this also and i added Tobias (author) in c/c

-- 
Best regards, Klimov Alexey
