Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7GNDAIa010432
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 19:13:10 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7GNCsVk030815
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 19:12:54 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200808161137.33278.hverkuil@xs4all.nl>
References: <20080814093320.49265ec1@glory.loctelecom.ru>
	<200808150805.20459.hverkuil@xs4all.nl>
	<1218847443.2671.30.camel@pc10.localdom.local>
	<200808161137.33278.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 17 Aug 2008 01:04:13 +0200
Message-Id: <1218927853.5376.30.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
	Gert Vervoort <gert.vervoort@hccnet.nl>
Subject: Re: MPEG stream work
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

Hi Hans,

Am Samstag, den 16.08.2008, 11:37 +0200 schrieb Hans Verkuil:
> Hermann,
> 
> I did not remove you from the CC list. You were not on it when I 
> received the message. I think it is because of the way Mauro's address 
> is being formatted by Dmitri's mailer.
> 
> Dmitri, I think you have Mauro's mail address formatted something like:
> 
> Chehab <mchehab@infradead.org>, Mauro
> 
> When that is send out some ISPs get confused and it ends up as e.g.:
> 
> Chehab <mchehab@infradead.org>, Mauro@xs4all.nl
> 
> In my case my xs4all ISP thinks 'Mauro' refers to a local user and adds 
> the local domain to it. I also suspect it probably strips off one or 
> more additional CC addresses, which is why Hermann's email disappeared 
> in the mail that I received.
> 
> The correct format is: Mauro Carvalho Chehab <mchehab@infradead.org> (no 
> comma in between). Can you change it to prevent this unfortunate event 
> from happening?
> 
> Hermann, if I ever gave the impression that I thought this was a joke, 
> then I apologize profusely since I know very well that Dmitri has a 
> difficult task to take on. Having a driver in such a poor state is 
> definitely no joking matter. I am also helping out Dmitri as well as I 
> can, but sadly I do not have as much time as I would like to have due 
> to a range of other commitments.
> 
> Regards,
> 
> 	Hans

Sorry! I obviously got it wrong and better should have slept a night
over it.

I previously tried to have your opinion about the FQ1236 MK4 and why we
don't have the tda9887 for it in tuner-types.c and did _not_ post
directly to you as well. You likely never saw it. It was added for ivtv
once.

Trying to make it better this time, but being stripped from the
responses, intrigued me into you might have enough with other stuff and
prefer to live without more reports.

This would be your free choice as well, but luckily even the opposite is
the case.

I have two of my older machines with enough PCI slots up and running
again, but I'm not through with all tests yet and also face some other
minor oddities with them. (Fans and need to crimp some new network
cables)

For sure is for now, that on a 2.6.18 a TCL2002MB-1F on my old
FlyVideo3000, card=2 has no problems with changing freq. and standard
with Gerd's old v4lctl during xawtv/tvtime/mplayer are running.

The even better is, v4l2-ctl compiled on so far latest on a other x86
machine, has no problems too and is even fully backward compatible.

Why the FMD1216ME hybrid MK3 immediately loses picture and sound after
an ioctl is touched during a running capture, not using any empress for
now, and if it is the same for the FM1216ME/I MK3s and when it starts, I
don't know yet.

Since Dmitry has a solution now and is not blocked by utilities, sorry
for the noise again.

I report back if I have more.

Cheers,
Hermann

> On Saturday 16 August 2008 02:44:03 hermann pitton wrote:
> > Hans,
> >
> > Am Freitag, den 15.08.2008, 08:05 +0200 schrieb Hans Verkuil:
> > > On Friday 15 August 2008 03:59:54 Dmitri Belimov wrote:
> > > > Hi All
> > > >
> > > > I found problem in v4l2-ctl. This programm can't set correct TV
> > > > norm. After my hack TV norm was set correct.
> >
> > I'm the first time grumpy here.
> >
> > > ???
> > >
> > > $ v4l2-ctl -s secam-dk
> > > Standard set to 00320000
> > >
> > > v4l2-ctl works fine for me!
> > >
> > > Are you using the latest v4l2-ctl version from v4l-dvb? I did fix a
> > > bug in SetStandard some time ago (although I think that bug didn't
> > > affect this particular situation either).
> >
> > We don't make jokes, but seriously report what we see.
> >
> > For Dmitry this is a since months during Odyssey, only caused by us,
> > but he is expected to work for what he is paid for. An impossible
> > task in the beginning.
> >
> > I did spent time too on it, the broken empress encoder first happens,
> > then vivid sub-norm setting on 2.6.25 was not possible anymore after
> > ioctl2 conversion on the saa7134, Mauro has hardware from me, and the
> > next was on 2.6.26 not to be able to set the tuner anymore, another
> > serious issue, after having a hot fix for the tuner eeprom detection
> > at least.
> >
> > Always pointed to it from my side, as far I have hardware, but it
> > made it straight into released kernels and I'm tired to have to
> > rumble there, since previously all fuses ready, did not trigger.
> >
> > Now, after facing such stuff around over months, it also makes it
> > much more difficult to settle the state of new cards around, not to
> > talk about ubuntu pleasures, you drop me from the list you might want
> > to reply in this case, after previously I did include you as maybe
> > interested?
> >
> > Why?
> >
> > Hermann
> >
> > > Regards,
> > >
> > > 	Hans
> > >
> > > > diff -r 42e3970c09aa v4l2-apps/util/v4l2-ctl.cpp
> > > > --- a/v4l2-apps/util/v4l2-ctl.cpp	Sun Jul 27 19:30:46 2008 -0300
> > > > +++ b/v4l2-apps/util/v4l2-ctl.cpp	Fri Aug 15 05:53:38 2008 +1000
> > > > @@ -1572,6 +1572,7 @@
> > > >  	}
> > > >
> > > >  	if (options[OptSetStandard]) {
> > > > +	  std = 0x320000; // durty hack for SECAM-DK
> > > >  		if (std & (1ULL << 63)) {
> > > >  			vs.index = std & 0xffff;
> > > >  			if (ioctl(fd, VIDIOC_ENUMSTD, &vs) >= 0) {
> > > >
> > > > I have MPEG stream with CORRECT TV data.
> > > > See link:
> > > >
> > > > http://debian.oshec.org/binary/tmp/mpeg02.dat
> > > >
> > > > Yahooooo!
> > > >
> > > > With my best regards, Dmitry.
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
