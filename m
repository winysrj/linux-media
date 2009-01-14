Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EMnI1m023004
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 17:49:18 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0EMldjV029166
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 17:47:39 -0500
Received: by wf-out-1314.google.com with SMTP id 25so804822wfc.6
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 14:47:38 -0800 (PST)
Message-ID: <b101ebb80901141447h14bd205bj702436a63d3e282e@mail.gmail.com>
Date: Thu, 15 Jan 2009 18:17:38 +1930
From: "Jose Diaz" <xt4mhz@gmail.com>
To: "Etienne Noreau-Hebert" <admin@deepunder.org>
In-Reply-To: <496E1797.50404@deepunder.org>
MIME-Version: 1.0
References: <b101ebb80901081906i5343bf1dl21020c2e89fdfdf0@mail.gmail.com>
	<Pine.LNX.4.58.0901110356290.1626@shell2.speakeasy.net>
	<b101ebb80901111410i7d2202fewa482263ffc343655@mail.gmail.com>
	<496E1797.50404@deepunder.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Trent Piepho <xyzzy@speakeasy.org>
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

Hi Etienne.

I havent recorded any audio from Osprey 230 card.

I have two cards and they are referenced:

/dev/dsp1

and

/dev/dsp2

It has been very frustrating for me.

A friend of mine told me to check the IRQ used for the cards.

I'll keep testing and praying :-)

Please, let me know if you record any audio.

In the other hand, you wrote Osprey 230 cards works in which version of
Linux ?

I could change my OS just to make them work and try to compare with Debian
Etch installation.

Thanks a lot!

Jos=E9 Gregorio.

2009/1/15 Etienne Noreau-Hebert <admin@deepunder.org>

> Hi Jose, hi Trent,
>
> I'm also having sound capture issues with the Osprey 230 cards.
>
> I've been trying with the snd-bt87x driver included in the RHEL5U2
> kernel (2.6.18-92 x86_64) and with snd-bt87x and btaudio from
> http://linuxtv.org/hg/~tap/osprey <http://linuxtv.org/hg/%7Etap/osprey> .
> With snd-bt87x, the card is properly detected and "arecord -l" reports :
>
> card 0: Bt878 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
> Subdevices: 1/1
> Subdevice #0: subdevice #0
> card 0: Bt878 [Brooktree Bt878], device 1: Bt87x Analog [Bt87x Analog]
> Subdevices: 1/1
> Subdevice #0: subdevice #0
>
> But when recording with "arecord -D plughw:Bt878,1 -f S16_LE sample.wav"
> only silence is captured from the Analog device, even though I have
> audio signals coming in the XLR and RCA inputs.
>
> Have you guys been able to record something?
>
> Attempts with the btaudio drivers have also been unsuccessful, as
> recording attempts with sox and gstreamer osssrc are blocking, not even
> recording silence and yielding an empty file with headers. My next step
> is to track down whats going on with the btaudio driver, as I've been
> successfully capturing sound with a previous version of it under RHEL4U4
> (2.6.9-42).
>
> Thanks,
>
> Etienne
>
> Jose Diaz wrote:
> > Hi Trent.
> >
> > Right now I have no access where the PC with the Osprey 230 cards are b=
ut
> I
> > did some tests with arecord.
> >
> > The "arecord -l" command shows:
> >
> > root@zsrvvids:/proc/asound/card2/pcm1c/sub0# arecord -l
> > **** List of CAPTURE Hardware Devices ****
> > card 0: CMI8738 [C-Media CMI8738], device 0: CMI8738-MC6 [C-Media PCI
> > DAC/ADC]
> >   Subdevices: 1/1
> >   Subdevice #0: subdevice #0
> > card 0: CMI8738 [C-Media CMI8738], device 2: CMI8738-MC6 [C-Media PCI
> > IEC958]
> >   Subdevices: 1/1
> >   Subdevice #0: subdevice #0
> > card 1: default [USB  AUDIO  ], device 0: USB Audio [USB Audio]
> >   Subdevices: 1/1
> >   Subdevice #0: subdevice #0
> > card 2: Bt878 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital=
]
> >   Subdevices: 1/1
> >   Subdevice #0: subdevice #0
> > card 2: Bt878 [Brooktree Bt878], device 1: Bt87x Analog [Bt87x Analog]
> >   Subdevices: 1/1
> >   Subdevice #0: subdevice #0
> > card 3: Bt878_1 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x
> Digital]
> >   Subdevices: 1/1
> >   Subdevice #0: subdevice #0
> > card 3: Bt878_1 [Brooktree Bt878], device 1: Bt87x Analog [Bt87x Analog=
]
> >   Subdevices: 1/1
> >   Subdevice #0: subdevice #0
> >
> > I did:
> >
> > arecord -D plughw:Bt878,1 -f S16_LE xxx.wav
> >
> > It created a file about 11MB before I "ctrl+c".
> >
> > During the creation of the file .wav file checked:
> >
> > root@zsrvvids:/proc/asound/card2/pcm1c/sub0# cat status
> > state: RUNNING
> > trigger_time: 1231710873.654398475
> > tstamp      : 1231710903.575688298
> > delay       : 0
> > avail       : 0
> > avail_max   : 2046
> > -----
> > hw_ptr      : 3823974
> > appl_ptr    : 3823974
> >
> > root@zsrvvids:/proc/asound/card2/pcm1c/sub0# cat status
> > state: RUNNING
> > trigger_time: 1231710873.654398475
> > tstamp      : 1231711014.243391671
> > delay       : 0
> > avail       : 0
> > avail_max   : 2046
> > -----
> > hw_ptr      : 17970018
> > appl_ptr    : 17970018
> >
> > The tstamp variable changed. Does it means that osprey 230 card is
> capturing
> > and recording?
> >
> > I brought to my PC via scp the xxx.wav file (about 11Mb) and try to pla=
y
> it
> > with "play" command. It was a silence as I espected because there is
> nothing
> > connected right now to the RCA input of the Osprey card.
> >
> > Monday morning I will go to test in place the recordings.
> >
> > What do you think until now ?
> >
> > Thanks a lot!
> >
> > Jose.
> >
> > 2009/1/12 Trent Piepho <xyzzy@speakeasy.org>
> >
> >
> >> On Fri, 9 Jan 2009, Jose Diaz wrote:
> >>
> >>> I need help using Osprey 230 cards. I did a huge research but not
> >>>
> >> success.
> >>
> >> You might try the driver at http://linuxtv.org/hg/~tap/osprey<http://l=
inuxtv.org/hg/%7Etap/osprey>
> <http://linuxtv.org/hg/%7Etap/osprey>
> >>
> >> I have not updated it for 15 months so it will probably not work with =
a
> >> 2.6.28 kernel.  Probably better off with something from around 2.6.25.
> >>
> >> Some Osprey cards support multiple audio sampling rates via an extern
> ADC
> >> and some cards also have a volume control chip.  I know these features
> are
> >> supported for the 440, but I'm not sure what features the 230 has and
> what
> >> is supported on that card.
> >>
> >>
> >>> The problem is that I cant mix the video and the audio from the Ospre=
y
> >>>
> >> 230
> >>
> >>> card because the audio is not recorded. I can stream the video but no=
t
> >>>
> >> with
> >>
> >> Try recording the audio with arecord.  Don't worry about vlc until you
> have
> >> that working.
> >>
> >>
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com
> ?subject=3Dunsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
