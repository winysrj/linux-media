Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m812bZ95014021
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 22:37:35 -0400
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m812bLwO028679
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 22:37:22 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: ian.davidson@bigfoot.com
In-Reply-To: <1219792546.2669.17.camel@pc10.localdom.local>
References: <488C9266.7010108@blueyonder.co.uk>
	<1217364178.2699.17.camel@pc10.localdom.local>
	<4890BBE8.8000901@blueyonder.co.uk>
	<1217457895.4433.52.camel@pc10.localdom.local>
	<48921FF9.8040504@blueyonder.co.uk>
	<1217542190.3272.106.camel@pc10.localdom.local>
	<48942E42.5040207@blueyonder.co.uk>
	<1217679767.3304.30.camel@pc10.localdom.local>
	<4895D741.1020906@blueyonder.co.uk>
	<1217798899.2676.148.camel@pc10.localdom.local>
	<4898C258.4040004@blueyonder.co.uk> <489A0B01.8020901@blueyonder.co.uk>
	<1218059636.4157.21.camel@pc10.localdom.local>
	<489B6E1B.301@blueyonder.co.uk>
	<1218153337.8481.30.camel@pc10.localdom.local>
	<489D7781.8030007@blueyonder.co.uk>
	<1218474259.2676.42.camel@pc10.localdom.local>
	<48A8892F.1010900@blueyonder.co.uk>
	<1219024648.2677.20.camel@pc10.localdom.local>
	<48B44CDF.60903@blueyonder.co.uk>
	<1219792546.2669.17.camel@pc10.localdom.local>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 04:35:07 +0200
Message-Id: <1220236507.2669.117.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: KWorld DVB-T 210SE - Capture only in Black/White
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

Hi Ian,

Am Mittwoch, den 27.08.2008, 01:15 +0200 schrieb hermann pitton:
> Hi Ian,
> 
> Am Dienstag, den 26.08.2008, 19:35 +0100 schrieb Ian Davidson:
> > Arrrrgh!
> > 
> > My capture has gone back to Black and White.
> > 
> > Since being able to capture video in colour, I have been attempting to
> > install mjpegtools.  Today, having been pointed at the livna
> > repository, I have succeeded.  When I tried a video capture (for
> > regression testing purposes), I found that it was, once again, Black
> > and White.
> > 
> > Having said that, I get occasional glimpses of colour - and when I do,
> > it is the real colour of whatever the camera is pointing at.  Having
> > made a brief study, it would seem that occasional frames get colour at
> > the top half of the picture.  I have checked (broken and reconnected)
> > the connections between the camera and the computer, but is does not
> > seem to make any difference.
> > 
> > Any ideas where I go from here?
> > 
> > Ian
> > 
> 
> please excuse, but you are on some limit for random issues.
> 
> We have, within what is hidden, about two hundreds saa713x cards.
> 
> I'll pull some of my analog stuff out of the trash bin once more and
> check, but I don't like it to do it again and it will not happen
> endlessly.
> 
> You will need some companions claiming still having the same after it.
> 
> If you have a chance to test on the Philips/NXP m$ driver, fine there ?
> 
> I don't know what more to debug here and gave already all hints in all
> directions i can think about.
> 
> Maybe they have done something really not recommended, but I can't tell.
> 

as promised, I did waste my late Sunday afternoon running with a VCR
back from the trash bin and a cam over four revived machines with lots
of saa713x stuff.

There have been lots of regressions during the last kernels, mostly
fully announced previously, but not that one.

I can't confirm your issues.

Try to find others with the same.

Cheers,
Hermann



> 
> 
> 
> > 
> > 
> > 
> > hermann pitton wrote: 
> > > Hi Ian,
> > > 
> > > Am Sonntag, den 17.08.2008, 21:25 +0100 schrieb Ian Davidson:
> > >   
> > > > Hi Hermann,
> > > > 
> > > > Success.  I did nothing of any significance.  What I did do was to add 
> > > > some more lines to saa7134-cards.c (to add vmux 5, 6 and 7) - and then 
> > > > went through the make process again.
> > > > 
> > > > Then, I ran xawtv and started by selecting Composite1 - and I got a 
> > > > colour image.
> > > > 
> > > > I also ran streamer to capture the video signal (using Composite1) and 
> > > > that also captured a colour image.
> > > > 
> > > > I hope it stays that way.
> > > > 
> > > > One other question - but this is probably not the correct place to ask. 
> > > > In the 'help' for streamer, it describes the use of 'lav2wav' to strip 
> > > > the audio out of a video file (that is, to create a separate WAV file 
> > > > using the audio in a particular AVI file).  I do not seem to have 
> > > > lav2wav on my system - and it does not appear to be something that yum 
> > > > acknowledges (using Fedora repositories).  Where might I find lav2wav or 
> > > > something similar?
> > > > 
> > > > Ian
> > > > 
> > > >     
> > > 
> > > as I told you previously already, please stay on the lists.
> > > 
> > > I don't even have a minimum consense about how to submit 5 to 7 patches
> > > currently within a kernel release cycle, but I'm very sure about that I
> > > don't like to be included in 24/7 games and would expect at least kernel
> > > level agreements for contributions still valid. Mauro?
> > > 
> > > So, you are on your own to get it in and further, but people on the
> > > lists are always helpful.
> > > 
> > > Cheers,
> > > Hermannn
> > > 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
