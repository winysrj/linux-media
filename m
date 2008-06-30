Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yoshi314@gmail.com>) id 1KDKvx-0002bE-14
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 17:04:49 +0200
Received: by ug-out-1314.google.com with SMTP id m3so253949uge.20
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 08:04:45 -0700 (PDT)
Date: Mon, 30 Jun 2008 17:04:13 +0200
From: marcin kowalski <yoshi314@gmail.com>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Message-ID: <20080630150413.GA7486@watanabe>
References: <51029ae90806300203p2d5fbf6bo7a28391b59553599@mail.gmail.com>
	<4868A644.5030806@onelan.co.uk>
	<51029ae90806300304s106305u36be341e80b69b2a@mail.gmail.com>
	<4868B148.2030300@onelan.co.uk>
	<51029ae90806300536g734d5d24x84ed8cc84260266a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51029ae90806300536g734d5d24x84ed8cc84260266a@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr-1300 analog audio question
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 14:36 Mon 30 Jun     , yoshi watanabe wrote:
> sorry, seems that's the way gmail works by default. that was not intended.
> i'll post results in 3-4 hours time when i'm home.
> 
> On Mon, Jun 30, 2008 at 12:11 PM, Simon Farnsworth
> <simon.farnsworth@onelan.co.uk> wrote:
> > Please don't drop the cc when replying - I'm passing on my own experiences
> > with an unrelated card, in the hope that it helps you.
> >
> > Someone else on the list may look at this and have an "aha!" moment,
> > answering your question for you.
> >
> > Note that the increased buffering is important for the SAA7134 - it seems to
> > only be prepared to transfer audio data in blanking time, so if there's not
> > enough buffering available, it just drops samples.
> >
> > yoshi watanabe wrote:
> >>
> >> i tried 32000 before when using arecord | aplay combo but the arecord
> >> insisted on 48000 audio rate. will try again and report later, thanks.
> >>
> >> On Mon, Jun 30, 2008 at 11:24 AM, Simon Farnsworth
> >> <simon.farnsworth@onelan.co.uk> wrote:
> >>>
> >>> yoshi watanabe wrote:
> >>>>
> >>>> hello.
> >>>>
> >>>> i'm using hauppauge hvr-1300 to receive video signal from playstation2
> >>>> console, pal model. video is just fine, but i'm having strange audio
> >>>> issues, but judging by some searching i did - that's pretty common
> >>>> with this card , although people have varied experience with the card.
> >>>>
> >>> I've had similar issues with SAA7134 based cards, which were resolved by
> >>>  changing audio parameters.
> >>>
> >>> If your problem is the same as mine was, try:
> >>> arecord --format=S16 \
> >>>       --rate=32000 \
> >>>       --period-size=8192 \
> >>>       --buffer-size=524288 | aplay
> >>>
> >>> This forces 32kHz sampling, and gives the card lots of buffer space to
> >>> play
> >>> with.
> >>> --
> >>> Simon Farnsworth
> >>>
> >>>
> >>
> >>
> >>
> >
> >
> > --
> > Simon Farnsworth
> > Software Engineer
> >
> > ONELAN Limited
> > 1st Floor Andersen House
> > Newtown Road
> > Henley-on-Thames, OXON
> > RG9 1HG
> > United Kingdom
> >
> > Tel:    +44(0)1491 411400
> > Fax:    +44(0)1491 579254
> > Support:+44(0)1491 845282
> >
> > www.onelan.co.uk
> >
> >
i just got white noise on audio. seems like this doesn't do the trick. i'll have to come up with something else. 

this message is really confusing :

arecord -D hw:1 -c 2 --format=S16 --rate=32000 --period-size=8192 --buffer-size=524288 | aplay -

Recording WAVE 'stdin' : Signed 16 bit Little Endian, Rate 32000 Hz, Stereo
Warning: rate is not accurate (requested = 32000Hz, got = 48000Hz)
         please, try the plug plugin

does it mean it didn't work as expected?
also during playback i get numerous copies of this line in my dmesg (during recording) : 

cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*

what does that mean?

some extra info about my hardware: 

my audio devices : 
**** List of CAPTURE Hardware Devices ****
card 0: CK804 [NVidia CK804], device 0: Intel ICH [NVidia CK804]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: CK804 [NVidia CK804], device 1: Intel ICH - MIC ADC [NVidia CK804 - MIC ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: CX8811 [Conexant CX8811], device 0: CX88 Digital [CX88 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
**** List of PLAYBACK Hardware Devices ****
card 0: CK804 [NVidia CK804], device 0: Intel ICH [NVidia CK804]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: CK804 [NVidia CK804], device 2: Intel ICH - IEC958 [NVidia CK804 - IEC958]
  Subdevices: 1/1
  Subdevice #0: subdevice #0


lspci -n shows that the card should work fine with cx88-alsa (which i have loaded).

01:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
01:07.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
01:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)

01:07.0 0400: 14f1:8800 (rev 05)
01:07.1 0480: 14f1:8811 (rev 05)
01:07.2 0480: 14f1:8802 (rev 05)

those ids are said to be supported. i have no ideas atm what else to try. trying 48000 sampling rate with bigger buffer 
also produces noise.

i guess i'll dig the mailing list archive once again. 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
