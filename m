Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28Ha6q0006648
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 12:36:06 -0500
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m28HZUZI010126
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 12:35:31 -0500
Message-ID: <47D2CF95.3060001@tmr.com>
Date: Sat, 08 Mar 2008 12:40:37 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: r bartlett <techwritebos@yahoo.com>
References: <47D2229A.9090300@linuxtv.org>
	<327155.1089.qm@web56415.mail.re3.yahoo.com>
In-Reply-To: <327155.1089.qm@web56415.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: WinTV-HVR-1800 help...
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

r bartlett wrote:
> 
> Michael Krufky <mkrufky@linuxtv.org> wrote:
> The digital side is 100% supported.  The analog side is not supported at all in the 2.6.24.y kernel series.  The master v4l-dvb development tree adds support for analog video with no audio.  If you pull down stoth's cx23885-video tree, you can enable the mpeg2 hardware encoder, and then you'll have analog mpeg audio and video fully working .  After some more testing and cleanups, that will eventually be merged into the master branch.
> 
> You should give digital a try -- you do not need any subscription to receive Free-To-Air ATSC broadcasts (using an antennae).  Likewise, you can also receive digital cable SDTV and Clear QAM broadcasts on your standard cable at no extra charge -- give it a try, you may be surprised 8-).
> Mike, I'd be more than happy to give digital a try but have spent almost 3 weeks (4 calls to Comcast and a guy coming out to the house to check the line) and there's _no digital_ signal on my line that's accessible without paying more and having a digital converter box.  At least, at this point it seems I know more than Comcast does about what a "tv tuner card" is and what it's capabilities are, and this is what I've figured out so far.
> 
> SDTV would be fine, Clear QAM would be fine...ATSC would be fine, but I'm fighting a Catch-22 because until I know what signal is on the line I can't set it up, and until I set it up, I can't figure out what signal is on the line.  :-)
> 
> If I start with ATSC, you're saying this is broadcast over the air...but I need an antenna?  Like on top of the roof?  Or just a pair of rabbit ears?  I'm in a spot that barely gets good radio reception half of the time...is ATSC a stronger signal?  Can I test it somehow without spending a lot of dough to put a big antenna on the top of the house?
> 
> And how do I "find" the SDTV and Clear QAM channels that are supposed to be already on this cable line?  I've got a splitter, so I should be getting both digital and analog signals at the same time...but there's nothing at all appearing at the digital side.
> 
> You're the second person to suggest using digital...and I'd be happy to, but it's just looking awfully much like I don't have any usable digital signals here.
> If indeed I do, part of the problem is identifying them, determining what's here and what's not, so I don't (for example) spend three days setting up ATSC only to find I don't get ATSC reception.
> 
> The other problem is cash.  I use Linux because I can't afford massive software expenses, and getting this card was a big investment that I justified partly because I thought it would _not_ require me to buy a different cable subscription that what I already have.
> 
> The other possibility is that the digital tuner part on my card is
> broken, which would explain why I can't get any digital love. In Windo$e
> I get about 13 analog channels and 0 digital signals...so I assumed it
> was my cable subscription or something...but that could perhaps indicate
> a broken card.
> 
> The frustrating thing is that each time I've called Comcast they
> either have no clue what I'm talking about or else they've said
> something different from the person before. The guy who came to the
> house said it's a mix of digital and analog signals, the girl I spoke to
> on the phone said it's _all_ 100% digital...and some other guy said I
> won't see any digital signals without getting a better subscription and
> a box converter.
> 
Since I use Time-Warner I can only pass on what I know generally. If you 
have a digital subscription the contents are (a) NTSC analog, (b) CATV 
digital, and (c) over the air digital. When I got my first TV with 
digital broadcast capabilities I had not upgraded the cable box in the 
bedroom, and I was getting HDTV and standard TV digital on the cable 
without a box.

Since you mention cost, at least with T-W the digital converter is the 
same price as the analog, there was no increase, or I can run with no 
converter and just get the CATV analog and/or broadcast digital at every 
cable drop in the house.

> So...Mike or anyone out there, I need a simple roadmap of what to do next.  If I want to try SDTV, for example...where do I start?  Otherwise I'm thinking I'll just put it in the box and wait for a year or two.  :-)
> 
I would check pricing very carefully, to see if you can just change to 
the digital plan and not get a box converter. Don't assume it's bundled.

Second, borrow an old set of rabbit ears and *try* the signal on digital 
broadcast. Radio is limited to 50kw max, while most TV stations run 
200kw or more, giving you at least 3db more signal. The broadcast is 
amazing, in addition to five networks[1] in NTSC and HD, I get weather 
and alternate content from most of them, and some alternative 
programming like ION network, with several levels of content.

> Again, thanks for any and all help getting this going.  It's not a massive problem if I can't figure it out, but I do greatly appreciate the help/time.  
> 
Don't assume any worst cases without testing, I was totally amazed at 
what came over the air and what was on the digital cable I didn't expect.

[1] ABC, CBS, FOX, NBC, PBS. Also ION and whatever is called C-W.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
