Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67JiuV0017446
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:44:56 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67JiQT0000543
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:44:29 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: D <therealisttruest@gmail.com>
In-Reply-To: <48716CED.6010608@gmail.com>
References: <486FF148.2060506@gmail.com>
	<1215298086.3237.19.camel@pc10.localdom.local>
	<48700079.6000209@gmail.com> <48701944.2040200@gmail.com>
	<1215343839.2852.14.camel@pc10.localdom.local>
	<48716CED.6010608@gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 21:41:07 +0200
Message-Id: <1215459667.3762.35.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Help with Chinese card
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


Am Sonntag, den 06.07.2008, 17:10 -0800 schrieb D:
> 
> > "garbled video" can mean lots of different things.
> > Black and white only would be simplest, since indicating some wrong
> > vmux.
> > 
> >   
> When I added card 145, I did have one of the 8 cameras that are set up
> showing grainy, black and white video with a very bad jitter to
> it(this was using ntsc, not pal). This was with vmux=2 I believe. I
> tried 0,1, and 3 as well just to see if it was a bit off, but only
> ended up with black output. The other videos were black as well, even
> though there should have been video in at least one or two others.
> > > > [44494.080206] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> > > > Capture
> > > > [44494.080210] saa7130[0]: subsystem: 1131:0000, board: 
> > > > UNKNOWN/GENERIC [card=0,autodetected]
> > > > [44494.080220] saa7130[0]: board init: gpio is c013ef0
> > > >       
> > ^^^^^^^^^^^^^^^
> > 
> > In such a case, this is the only indication if it might have been seen
> > already previously. 
> > 
> > If this is after a boot prior to mess around with other card entries or
> > trying something yourself on gpios, it looks like this device was not
> > seen yet then.
> > 
> >   
> > > > [44494.807913] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
> > > > Capture
> > > > [44494.807917] saa7130[7]: subsystem: 1131:0000, board: 
> > > > UNKNOWN/GENERIC [card=0,autodetected]
> > > > [44494.807930] saa7130[7]: board init: gpio is 10000
> > > >       
> > ^^^^^^^^^^              ^^^^^^^^^^^^^
> > Seems to be still unique here.
> >   
> As far as autodetection goes, when I originally started working on
> this, it was card number 0, by default. What I did above to get it
> back to that point was modprobe saa7134, without the 'card=' argument,
> so that tells me it doesn't autodetect it correctly or recognize it.
> As I said before card number 145 is my own, but it's not correct
> either. Do you have any tips on what I can do next. I know this card
> is not yet supported as is, but would like to get it working and
> perhaps get support added to it for other users in the future.  My
> idea was to change the gpio values, but it sounds like that could be a
> problem unless I can find what the correct values are. Any ideas? I'm
> willing to do what I can, but I need some guidance on this one.
> 

A valid input for composite video is also vmux = 4 and is used by
several manufactures. Higher vmux inputs are for s-video.
For composite over s-video vmux = 0 is usually used.

If you thing gpios are in use for some switching, regspy.exe might be
your friend (DScaler - deinterlace.sf.net) to investigate the other
driver and software.

Still don't know which device it exactly is, but they seem to use a PLX
PCI bridge. Identifying that device and getting the datasheet might give
you some further hints too.
http://www.plxtech.com

Good Luck,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
