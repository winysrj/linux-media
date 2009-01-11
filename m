Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0BMBECJ006682
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 17:11:14 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0BMAv5G022148
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 17:10:57 -0500
Received: by rv-out-0506.google.com with SMTP id f6so11294671rvb.51
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 14:10:57 -0800 (PST)
Message-ID: <b101ebb80901111410i7d2202fewa482263ffc343655@mail.gmail.com>
Date: Mon, 12 Jan 2009 17:40:57 +1930
From: "Jose Diaz" <xt4mhz@gmail.com>
To: "Trent Piepho" <xyzzy@speakeasy.org>
In-Reply-To: <Pine.LNX.4.58.0901110356290.1626@shell2.speakeasy.net>
MIME-Version: 1.0
References: <b101ebb80901081906i5343bf1dl21020c2e89fdfdf0@mail.gmail.com>
	<Pine.LNX.4.58.0901110356290.1626@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Help with Osprey 230 cards - no sound.
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

Hi Trent.

Right now I have no access where the PC with the Osprey 230 cards are but I
did some tests with arecord.

The "arecord -l" command shows:

root@zsrvvids:/proc/asound/card2/pcm1c/sub0# arecord -l
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

I did:

arecord -D plughw:Bt878,1 -f S16_LE xxx.wav

It created a file about 11MB before I "ctrl+c".

During the creation of the file .wav file checked:

root@zsrvvids:/proc/asound/card2/pcm1c/sub0# cat status
state: RUNNING
trigger_time: 1231710873.654398475
tstamp      : 1231710903.575688298
delay       : 0
avail       : 0
avail_max   : 2046
-----
hw_ptr      : 3823974
appl_ptr    : 3823974

root@zsrvvids:/proc/asound/card2/pcm1c/sub0# cat status
state: RUNNING
trigger_time: 1231710873.654398475
tstamp      : 1231711014.243391671
delay       : 0
avail       : 0
avail_max   : 2046
-----
hw_ptr      : 17970018
appl_ptr    : 17970018

The tstamp variable changed. Does it means that osprey 230 card is capturing
and recording?

I brought to my PC via scp the xxx.wav file (about 11Mb) and try to play it
with "play" command. It was a silence as I espected because there is nothing
connected right now to the RCA input of the Osprey card.

Monday morning I will go to test in place the recordings.

What do you think until now ?

Thanks a lot!

Jose.

2009/1/12 Trent Piepho <xyzzy@speakeasy.org>

> On Fri, 9 Jan 2009, Jose Diaz wrote:
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
