Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANMWkOP000942
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 17:32:46 -0500
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANMWVK9007409
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 17:32:32 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: kevinlux - <kevinlux@gmail.com>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <8567605f0811231027w4bca54dej414d353e31ff1e5f@mail.gmail.com>
References: <8567605f0811160257i66ea44a1i8b16a45c1580d5a9@mail.gmail.com>
	<8567605f0811231027w4bca54dej414d353e31ff1e5f@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 23:29:28 +0100
Message-Id: <1227479368.4665.42.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pinnacle 310i doesn't works very well
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

Am Sonntag, den 23.11.2008, 19:27 +0100 schrieb kevinlux -:
> Hi Guys,
> hi talked with Harmut Hackam, on his opinion "something is broken in the
> tuner callback mechanism again. this is used to control the so called
> LNA via a GPIO pin - a tricky mechanism and difficult to debug."
> Should I post also in a val4linux mailing list?? Or someone can help me here?
> I think it's a problem of all card of  << saa7133 >> with tuner  <<
> tda829x 2-004b >> (i have also tried an Asus My Cinema Dual TV Tuner
> same chips and tuner and SAME Problems. )
> Thanks in advance.
> 
> cheers
> kev
> 
> 
> 2008/11/16, kevinlux - <kevinlux@gmail.com>:
> > Hi all. I have a pinnacle card, 310i card from 3 years, but now with
> >  recent drivers (updated yesterday) it works not so good. With the my
> >  previous driver (dvb mercurial December 2007 on kernel 2.6.24)
> >  everythings was good. Infact at moment under Window OS i can see more
> >  channels respect to Linux.
> >  I also try with another usb device inlinux and i'm able to see all
> >  those channels that i can't view with my pinnacle 310i board.
> >  Someone can help me or can confirm my version??
> >
> >  Thanks in advance.
> >  Cheers
> >
> >  kev
> >

Kevin, I saw your previous post, but I can't test on something like the
310i with tda827x_config/tuner_config = 1 and I was waiting for some
confirmation. Maybe someone on the video4linux-list can test on it.

Which of the P7131 Dual cards you have. The Dual Hybrid with LNA ?

This one uses tda827x/tuner config = 2.

This configuration I can test on the recently added Asus Tiger 3in1.

We partly have heavy snowfall currently, but on the same DVB-T RF feed,
with the most critical transponder for me in upper UHF, an Asus Tiger
Revision 1 fails completely, too many errors, on a Medion Quad mplayer
starts, but picture and sound are totally distorted and unusable
currently.

On the Tiger 3in1 almost all is fine, except some rare small artifacts
from time to time. That means the LNA works for sure.

The same goes for analog TV. It is easy to recognize if the LNA is
active, since else sync issues after channel switching, a black bar
passes the screen for a while and also some slight audio issues. Others
reported sometimes flashing picture and humming noise on analog without
correctly configured LNA.

"hg head" on this machine is:

changeset:   9575:d5e211683345
tag:         tip
parent:      9573:1251a4091b89
parent:      9574:2ab0045eb27b
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Tue Nov 11 07:42:37 2008 -0200
summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-backport

We are only 4 days apart, if LNA config = 2 should be broken at all
later.

---
Few minutes later with the current v4l-dvb installed on that one.

Sorry, I seem not to be able to confirm your observation, at least the
Asus Tiger 3in1 is still fine on that critical transponder.

If I change the LNA config to 0, mplayer fails to start with only three
good and 27 bad packages. Means for me the LNA works for sure.

Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
