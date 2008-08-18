Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I1wiLu010027
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 21:58:44 -0400
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I1wSso032484
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 21:58:29 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: ian.davidson@bigfoot.com, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <48A8892F.1010900@blueyonder.co.uk>
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
Content-Type: text/plain
Date: Mon, 18 Aug 2008 03:57:28 +0200
Message-Id: <1219024648.2677.20.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
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

Am Sonntag, den 17.08.2008, 21:25 +0100 schrieb Ian Davidson:
> Hi Hermann,
> 
> Success.  I did nothing of any significance.  What I did do was to add 
> some more lines to saa7134-cards.c (to add vmux 5, 6 and 7) - and then 
> went through the make process again.
> 
> Then, I ran xawtv and started by selecting Composite1 - and I got a 
> colour image.
> 
> I also ran streamer to capture the video signal (using Composite1) and 
> that also captured a colour image.
> 
> I hope it stays that way.
> 
> One other question - but this is probably not the correct place to ask. 
> In the 'help' for streamer, it describes the use of 'lav2wav' to strip 
> the audio out of a video file (that is, to create a separate WAV file 
> using the audio in a particular AVI file).  I do not seem to have 
> lav2wav on my system - and it does not appear to be something that yum 
> acknowledges (using Fedora repositories).  Where might I find lav2wav or 
> something similar?
> 
> Ian
> 

as I told you previously already, please stay on the lists.

I don't even have a minimum consense about how to submit 5 to 7 patches
currently within a kernel release cycle, but I'm very sure about that I
don't like to be included in 24/7 games and would expect at least kernel
level agreements for contributions still valid. Mauro?

So, you are on your own to get it in and further, but people on the
lists are always helpful.

Cheers,
Hermannn


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
