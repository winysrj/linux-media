Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7G0r2Rg031619
	for <video4linux-list@redhat.com>; Fri, 15 Aug 2008 20:53:02 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7G0qmpQ019002
	for <video4linux-list@redhat.com>; Fri, 15 Aug 2008 20:52:48 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200808150805.20459.hverkuil@xs4all.nl>
References: <20080814093320.49265ec1@glory.loctelecom.ru>
	<48A4763D.8030509@hccnet.nl>
	<20080815115954.0be6c5ba@glory.loctelecom.ru>
	<200808150805.20459.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 02:44:03 +0200
Message-Id: <1218847443.2671.30.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Chehab <mchehab@infradead.org>,
	Gert Vervoort <gert.vervoort@hccnet.nl>, Mauro@xs4all.nl
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

Hans,

Am Freitag, den 15.08.2008, 08:05 +0200 schrieb Hans Verkuil:
> On Friday 15 August 2008 03:59:54 Dmitri Belimov wrote:
> > Hi All
> >
> > I found problem in v4l2-ctl. This programm can't set correct TV norm.
> > After my hack TV norm was set correct.

I'm the first time grumpy here.

> ???
> 
> $ v4l2-ctl -s secam-dk
> Standard set to 00320000
> 
> v4l2-ctl works fine for me!
> 
> Are you using the latest v4l2-ctl version from v4l-dvb? I did fix a bug 
> in SetStandard some time ago (although I think that bug didn't affect 
> this particular situation either).

We don't make jokes, but seriously report what we see.

For Dmitry this is a since months during Odyssey, only caused by us, but
he is expected to work for what he is paid for. An impossible task in
the beginning.

I did spent time too on it, the broken empress encoder first happens,
then vivid sub-norm setting on 2.6.25 was not possible anymore after
ioctl2 conversion on the saa7134, Mauro has hardware from me, and the
next was on 2.6.26 not to be able to set the tuner anymore, another
serious issue, after having a hot fix for the tuner eeprom detection at
least.

Always pointed to it from my side, as far I have hardware, but it made
it straight into released kernels and I'm tired to have to rumble there,
since previously all fuses ready, did not trigger.

Now, after facing such stuff around over months, it also makes it much
more difficult to settle the state of new cards around, not to talk
about ubuntu pleasures, you drop me from the list you might want to
reply in this case, after previously I did include you as maybe
interested?

Why?

Hermann








> Regards,
> 
> 	Hans
> 
> >
> > diff -r 42e3970c09aa v4l2-apps/util/v4l2-ctl.cpp
> > --- a/v4l2-apps/util/v4l2-ctl.cpp	Sun Jul 27 19:30:46 2008 -0300
> > +++ b/v4l2-apps/util/v4l2-ctl.cpp	Fri Aug 15 05:53:38 2008 +1000
> > @@ -1572,6 +1572,7 @@
> >  	}
> >
> >  	if (options[OptSetStandard]) {
> > +	  std = 0x320000; // durty hack for SECAM-DK
> >  		if (std & (1ULL << 63)) {
> >  			vs.index = std & 0xffff;
> >  			if (ioctl(fd, VIDIOC_ENUMSTD, &vs) >= 0) {
> >
> > I have MPEG stream with CORRECT TV data.
> > See link:
> >
> > http://debian.oshec.org/binary/tmp/mpeg02.dat
> >
> > Yahooooo!
> >
> > With my best regards, Dmitry.
> >


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
