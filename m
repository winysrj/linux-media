Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7G9c0HC025034
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 05:38:00 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7G9bjhs013547
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 05:37:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: hermann pitton <hermann-pitton@arcor.de>,
	Dmitri Belimov <d.belimov@gmail.com>
Date: Sat, 16 Aug 2008 11:37:33 +0200
References: <20080814093320.49265ec1@glory.loctelecom.ru>
	<200808150805.20459.hverkuil@xs4all.nl>
	<1218847443.2671.30.camel@pc10.localdom.local>
In-Reply-To: <1218847443.2671.30.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808161137.33278.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Gert Vervoort <gert.vervoort@hccnet.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

Hermann,

I did not remove you from the CC list. You were not on it when I 
received the message. I think it is because of the way Mauro's address 
is being formatted by Dmitri's mailer.

Dmitri, I think you have Mauro's mail address formatted something like:

Chehab <mchehab@infradead.org>, Mauro

When that is send out some ISPs get confused and it ends up as e.g.:

Chehab <mchehab@infradead.org>, Mauro@xs4all.nl

In my case my xs4all ISP thinks 'Mauro' refers to a local user and adds 
the local domain to it. I also suspect it probably strips off one or 
more additional CC addresses, which is why Hermann's email disappeared 
in the mail that I received.

The correct format is: Mauro Carvalho Chehab <mchehab@infradead.org> (no 
comma in between). Can you change it to prevent this unfortunate event 
from happening?

Hermann, if I ever gave the impression that I thought this was a joke, 
then I apologize profusely since I know very well that Dmitri has a 
difficult task to take on. Having a driver in such a poor state is 
definitely no joking matter. I am also helping out Dmitri as well as I 
can, but sadly I do not have as much time as I would like to have due 
to a range of other commitments.

Regards,

	Hans

On Saturday 16 August 2008 02:44:03 hermann pitton wrote:
> Hans,
>
> Am Freitag, den 15.08.2008, 08:05 +0200 schrieb Hans Verkuil:
> > On Friday 15 August 2008 03:59:54 Dmitri Belimov wrote:
> > > Hi All
> > >
> > > I found problem in v4l2-ctl. This programm can't set correct TV
> > > norm. After my hack TV norm was set correct.
>
> I'm the first time grumpy here.
>
> > ???
> >
> > $ v4l2-ctl -s secam-dk
> > Standard set to 00320000
> >
> > v4l2-ctl works fine for me!
> >
> > Are you using the latest v4l2-ctl version from v4l-dvb? I did fix a
> > bug in SetStandard some time ago (although I think that bug didn't
> > affect this particular situation either).
>
> We don't make jokes, but seriously report what we see.
>
> For Dmitry this is a since months during Odyssey, only caused by us,
> but he is expected to work for what he is paid for. An impossible
> task in the beginning.
>
> I did spent time too on it, the broken empress encoder first happens,
> then vivid sub-norm setting on 2.6.25 was not possible anymore after
> ioctl2 conversion on the saa7134, Mauro has hardware from me, and the
> next was on 2.6.26 not to be able to set the tuner anymore, another
> serious issue, after having a hot fix for the tuner eeprom detection
> at least.
>
> Always pointed to it from my side, as far I have hardware, but it
> made it straight into released kernels and I'm tired to have to
> rumble there, since previously all fuses ready, did not trigger.
>
> Now, after facing such stuff around over months, it also makes it
> much more difficult to settle the state of new cards around, not to
> talk about ubuntu pleasures, you drop me from the list you might want
> to reply in this case, after previously I did include you as maybe
> interested?
>
> Why?
>
> Hermann
>
> > Regards,
> >
> > 	Hans
> >
> > > diff -r 42e3970c09aa v4l2-apps/util/v4l2-ctl.cpp
> > > --- a/v4l2-apps/util/v4l2-ctl.cpp	Sun Jul 27 19:30:46 2008 -0300
> > > +++ b/v4l2-apps/util/v4l2-ctl.cpp	Fri Aug 15 05:53:38 2008 +1000
> > > @@ -1572,6 +1572,7 @@
> > >  	}
> > >
> > >  	if (options[OptSetStandard]) {
> > > +	  std = 0x320000; // durty hack for SECAM-DK
> > >  		if (std & (1ULL << 63)) {
> > >  			vs.index = std & 0xffff;
> > >  			if (ioctl(fd, VIDIOC_ENUMSTD, &vs) >= 0) {
> > >
> > > I have MPEG stream with CORRECT TV data.
> > > See link:
> > >
> > > http://debian.oshec.org/binary/tmp/mpeg02.dat
> > >
> > > Yahooooo!
> > >
> > > With my best regards, Dmitry.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
