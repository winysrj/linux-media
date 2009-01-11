Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0BKAhru003564
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 15:10:43 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.239])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0BKAQSi027156
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 15:10:26 -0500
Received: by rv-out-0506.google.com with SMTP id f6so11266103rvb.51
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 12:10:26 -0800 (PST)
Message-ID: <b101ebb80901111210h4bc4b59do3a5075852e275f24@mail.gmail.com>
Date: Mon, 12 Jan 2009 15:40:25 +1930
From: "Jose Diaz" <xt4mhz@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <b101ebb80901111205l4a0c8bccga17dc6686034cd60@mail.gmail.com>
MIME-Version: 1.0
References: <b101ebb80901081906i5343bf1dl21020c2e89fdfdf0@mail.gmail.com>
	<Pine.LNX.4.58.0901110356290.1626@shell2.speakeasy.net>
	<b101ebb80901111205l4a0c8bccga17dc6686034cd60@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Fwd: Help with Osprey 230 cards - no sound.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Thank you very much Trent for your help.

I have tried a lot of things, even installing a new sound card and usb sound
card but I dont like it because I think I have to enable the input audio
from the osprey 230 card.

Let me share with you some info:

The lists of devices recognized by "arecord" are:

root@zsrvvids:~# arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: CMI8738 [C-Media CMI8738], device 0: CMI8738-MC6 [C-Media PCI
DAC/ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: CMI8738 [C-Media CMI8738], device 2: CMI8738-MC6 [C-Media PCI
IEC958]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: default [USB  AUDIO  ], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: Bt878 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: Bt878 [Brooktree Bt878], device 1: Bt87x Analog [Bt87x Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 3: Bt878_1 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 3: Bt878_1 [Brooktree Bt878], device 1: Bt87x Analog [Bt87x Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

A you can see the PC have:

1. PCI Sound card.
2. USB Sound card.
3. Analog and digital sound inputs for Osprey 1.
4. Analog and digital sound inputs form Osprey 2.

The v4lctl tool tells me:

For Osprey 1:

root@zsrvvids:~# v4lctl -v 0 -c /dev/video0 list
attribute  | type   | current | default | comment
-----------+--------+---------+---------+-------------------------------------
norm       | choice | NTSC    | PAL     | PAL NTSC SECAM PAL-Nc PAL-M PAL-N
NTSC-JP PAL-60
input      | choice | Composi | Composi | Composite0 S-Video
bright     | int    |   32768 |   32768 | range is 0 => 65535
contrast   | int    |   32768 |   32768 | range is 0 => 65535
color      | int    |   32768 |   32768 | range is 0 => 65535
hue        | int    |   32768 |   32768 | range is 0 => 65535
volume     | int    | -1208350688 |   65535 | range is 0 => 65535
Balance    | int    |   32768 |   32768 | range is 0 => 65535
Bass       | int    |   32768 |   32768 | range is 0 => 65535
Treble     | int    |   32768 |   32768 | range is 0 => 65535
mute       | bool   | on      | off     |
chroma agc | bool   | off     | off     |
combfilter | bool   | off     | off     |
automute   | bool   | on      | off     |
luma decim | bool   | off     | off     |
agc crush  | bool   | on      | off     |
vcr hack   | bool   | off     | off     |
whitecrush | int    |     207 |     207 | range is 0 => 255
whitecrush | int    |     127 |     127 | range is 0 => 255
uv ratio   | int    |      50 |      50 | range is 0 => 100
full luma  | bool   | off     | off     |
coring     | int    |       0 |       0 | range is 0 => 3

And for Osprey 2:

root@zsrvvids:~# v4lctl -v 0 -c /dev/video1 list
attribute  | type   | current | default | comment
-----------+--------+---------+---------+-------------------------------------
norm       | choice | NTSC    | PAL     | PAL NTSC SECAM PAL-Nc PAL-M PAL-N
NTSC-JP PAL-60
input      | choice | Composi | Composi | Composite0 S-Video
bright     | int    |   32768 |   32768 | range is 0 => 65535
contrast   | int    |   32768 |   32768 | range is 0 => 65535
color      | int    |   32768 |   32768 | range is 0 => 65535
hue        | int    |   32768 |   32768 | range is 0 => 65535
volume     | int    | -1208842208 |   65535 | range is 0 => 65535
Balance    | int    |   32768 |   32768 | range is 0 => 65535
Bass       | int    |   32768 |   32768 | range is 0 => 65535
Treble     | int    |   32768 |   32768 | range is 0 => 65535
mute       | bool   | on      | off     |
chroma agc | bool   | off     | off     |
combfilter | bool   | off     | off     |
automute   | bool   | on      | off     |
luma decim | bool   | off     | off     |
agc crush  | bool   | on      | off     |
vcr hack   | bool   | off     | off     |
whitecrush | int    |     207 |     207 | range is 0 => 255
whitecrush | int    |     127 |     127 | range is 0 => 255
uv ratio   | int    |      50 |      50 | range is 0 => 100
full luma  | bool   | off     | off     |
coring     | int    |       0 |       0 | range is 0 => 3

As you can see, "mute" is "on". I tried to change it doing:

root@zsrvvids:~#v4lctl -v 2 -c /dev/video0 setattr "mute" "off"

And the debug says at the end:

...
ioctl: VIDIOC_G_CTRL(id=9963785;value=-1208768480): ok
cmd: "setattr" "mute" "off"
ioctl: VIDIOC_S_CTRL(id=9963785;value=0): ok
v4l2: close

However the value keeps in "On".

Let me play with the "arecord" and will tell the results.

Thank you very much for your help, you are the first and only person who has
help me in 3 months of fight :(

If you need something from Caracas, Venezuela just let me know :)

Jose.

P.D.: Where are you from?

2009/1/12 Trent Piepho <xyzzy@speakeasy.org>

On Fri, 9 Jan 2009, Jose Diaz wrote:
> > I need help using Osprey 230 cards. I did a huge research but not
> success.
>
> You might try the driver at http://linuxtv.org/hg/~tap/osprey<http://linuxtv.org/hg/%7Etap/osprey>
>
> I have not updated it for 15 months so it will probably not work with a
> 2.6.28 kernel.  Probably better off with something from around 2.6.25.
>
> Some Osprey cards support multiple audio sampling rates via an extern ADC
> and some cards also have a volume control chip.  I know these features are
> supported for the 440, but I'm not sure what features the 230 has and what
> is supported on that card.
>
> > The problem is that I cant mix the video and the audio from the Osprey
> 230
> > card because the audio is not recorded. I can stream the video but not
> with
>
> Try recording the audio with arecord.  Don't worry about vlc until you have
> that working.
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
