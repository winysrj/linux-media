Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAP2CIq6008646
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 21:12:18 -0500
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAP2C2hf020410
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 21:12:02 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: kevinlux - <kevinlux@gmail.com>
In-Reply-To: <8567605f0811241156xc855543p82e5d455fc84256@mail.gmail.com>
References: <8567605f0811160257i66ea44a1i8b16a45c1580d5a9@mail.gmail.com>
	<8567605f0811231027w4bca54dej414d353e31ff1e5f@mail.gmail.com>
	<1227479368.4665.42.camel@pc10.localdom.local>
	<8567605f0811241156xc855543p82e5d455fc84256@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 03:08:43 +0100
Message-Id: <1227578923.4289.13.camel@pc10.localdom.local>
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

Am Montag, den 24.11.2008, 20:56 +0100 schrieb kevinlux -:
> Hi all,
> i'm talking about this tv tuner card : My Cinema-P7131 Hybrid
> http://www.asus.com/products.aspx?l1=18&l2=83&l3=252&l4=0&model=547&modelmenu=1

did you notice that on the enlarged picture that current revision seems
to have a firmware eeprom again in opposite to yours?

Might come more.

> I'm sorry but i have to confirm that both cards (the asus  p7131 and
> pinnacle 310i ) stilii not working correctly with the last mercurial
> (also in analog mode).
> Otherwise i also have an usb Pinnacle dvb stick that works perfecty
> under win and linux (with the driver em28xx from mcentral.de
> (http://mcentral.de/hg/~mrec/v4l-dvb-kernel)). If there's something
> that i can do (testing and something like that) don't esitate to
> ask... you will be welcome.
> Best regards and thanks
> 
> kev
> 

Hmm, sounds slightly strange at the moment, since the exact same LNA
config on the Tiger 3in1 works for me, but fails on your P7131 Dual
Hybrid LNA.

If we don't get confirmation from others, to live on the saa7134 was not
always easy during the last kernel releases, and you can confirm that
the P7131 Dual hybrid is fine for you on a 2.6.24 too, then I firstly
try to repeat my testing on the Tiger 3in1, but definitely should fail
if I try to implement DVB-T LNA support for it on a 2.6.24 I guess ...

Cheers,
Hermann

> 2008/11/23, hermann pitton <hermann-pitton@arcor.de>:
> 
> >
> > Kevin, I saw your previous post, but I can't test on something like the
> >  310i with tda827x_config/tuner_config = 1 and I was waiting for some
> >  confirmation. Maybe someone on the video4linux-list can test on it.
> >
> >  Which of the P7131 Dual cards you have. The Dual Hybrid with LNA ?
> >
> >  This one uses tda827x/tuner config = 2.
> >
> >  This configuration I can test on the recently added Asus Tiger 3in1.
> >
> >  We partly have heavy snowfall currently, but on the same DVB-T RF feed,
> >  with the most critical transponder for me in upper UHF, an Asus Tiger
> >  Revision 1 fails completely, too many errors, on a Medion Quad mplayer
> >  starts, but picture and sound are totally distorted and unusable
> >  currently.
> >
> >  On the Tiger 3in1 almost all is fine, except some rare small artifacts
> >  from time to time. That means the LNA works for sure.
> >
> >  The same goes for analog TV. It is easy to recognize if the LNA is
> >  active, since else sync issues after channel switching, a black bar
> >  passes the screen for a while and also some slight audio issues. Others
> >  reported sometimes flashing picture and humming noise on analog without
> >  correctly configured LNA.
> >
> >  "hg head" on this machine is:
> >
> >  changeset:   9575:d5e211683345
> >  tag:         tip
> >  parent:      9573:1251a4091b89
> >  parent:      9574:2ab0045eb27b
> >  user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> >  date:        Tue Nov 11 07:42:37 2008 -0200
> >  summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-backport
> >
> >  We are only 4 days apart, if LNA config = 2 should be broken at all
> >  later.
> >
> >  ---
> >  Few minutes later with the current v4l-dvb installed on that one.
> >
> >  Sorry, I seem not to be able to confirm your observation, at least the
> >  Asus Tiger 3in1 is still fine on that critical transponder.
> >
> >  If I change the LNA config to 0, mplayer fails to start with only three
> >  good and 27 bad packages. Means for me the LNA works for sure.
> >
> >  Cheers,
> >
> > Hermann
> >

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
