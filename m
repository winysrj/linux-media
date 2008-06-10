Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5A0O8ks023622
	for <video4linux-list@redhat.com>; Mon, 9 Jun 2008 20:24:08 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5A0NtCM013927
	for <video4linux-list@redhat.com>; Mon, 9 Jun 2008 20:23:55 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: timf <timf@iinet.net.au>, video4linux-list@redhat.com
In-Reply-To: <484CA13F.20900@iinet.net.au>
References: <48498964.10301@iinet.net.au>
	<1212785950.16279.17.camel@pc10.localdom.local>
	<20080606183617.5c2b6398@gaivota>	<484A1441.6070400@iinet.net.au>
	<484A1FC7.6070707@iinet.net.au>
	<1212886803.25974.44.camel@pc10.localdom.local>
	<20080608073836.233e801a@gaivota> <484C9E0A.1030909@iinet.net.au>
	<484CA13F.20900@iinet.net.au>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 02:22:44 +0200
Message-Id: <1213057364.3997.42.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [linux-dvb] Problem with latest v4l-dvb hg -extra question -
	saa7133[0]: board init: gpio
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

Hi,

Am Montag, den 09.06.2008, 11:19 +0800 schrieb timf:
> timf wrote:
> > Mauro Carvalho Chehab wrote:
> >   
> >> On Sun, 08 Jun 2008 03:00:03 +0200
> >> hermann pitton <hermann-pitton@arcor.de> wrote:
> >>
> >>   
> >>     
> >>> Am Samstag, den 07.06.2008, 13:42 +0800 schrieb timf:
> >>>     
> >>>       
> >>>> timf wrote:
> >>>>       
> >>>>         
> >>>>> Mauro Carvalho Chehab wrote:
> >>>>>   
> >>>>>         
> >>>>>           
> >>>>>> On Fri, 06 Jun 2008 22:59:10 +0200
> >>>>>> hermann pitton <hermann-pitton@arcor.de> wrote:
> >>>>>>
> >>>>>>   
> >>>>>>     
> >>>>>>           
> >>>>>>             
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> Am Samstag, den 07.06.2008, 03:00 +0800 schrieb timf:
> >>>>>>>     
> >>>>>>>       
> >>>>>>>             
> >>>>>>>               
> >>>> <snip>
> >>>>
> >>>>       
> >>>>         
> > <snip>
> >   
> >> There's another possibility. It might be possible that Viro's patches broke
> >> firmware load. Did firmware load worked before (with the same version you're using)?
> >>
> >> Cheers,
> >> Mauro
> >>
> >>   
> >>     
> > Hi all,
> >   
> Further question, I noticed that
> 
> saa7133[0]: board init: gpio is xxxxxx
> 
> for both cards keeps changing. Is that normal?
> 
> > Regards,
> > Timf
> >
> >   

yes, at least to some extend, if all is known.

There is no clean up on exit or something.

If you used the radio last it will come up with 0x0200000 on next load.
To suppress that is no help, see a little later.

If you tried other cards, it will show what you have last taken ...

However, within this hybrid device stuff, even better with multiple
tuners, multiple DVB-S/DVB-T channel decoders and also analog IF
demodulators, almost all have some gpio/port pins too, the manufacturers
have reach choices how to do all sort of switching on such a card and
can easily deviate from already known solutions.

A card might be wired also like that, that if for example a remote IR
receiver is plugged it, a gpio pin changes to output and keypresses can
be sampled from there. Also cards which do host mode switching between
DVB TS parallel interface and mpeg interface for an mpeg encoder show
internally changes of the gpio configuration.

Even an LowNoiseAmplifier might depend on gpio switching, AGC switching
between analog and digital tuning and more. The first 8 pins of the 28
gpio pins of the saa713x chips do transmit the TS or mpeg encoder data
and permanently change when in operation.

We are not much further else and have been there already.

Since I can't reproduce it, and I'm for sure not the firmware expert,
since never in trouble, find others and try to reach the original
contributors of the card, that you can get some confirmation to come out
of this random for you alone.

Confirm that you have no second firmware eeprom, as I already asked for.
If present and not functional it could be already a reason for the
trouble.

Take this up with the LNA, disable it in saa7134-dvb for your card and
see what happens. If it has an impact, noticeable worse or even no
tuning on DVB-T anymore, you should have config_tuner = 2 in your
saa7134-cards.c entry too for proper switching.

Or to disable it might even improve all, how can one know without
reports of what it does and just have it there with "three more cards
added" ;)

If you are running with private patches, include a hg diff > my.patch.

Anyone else in problems with loading tda10046 firmware on saa713x from
file?

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
