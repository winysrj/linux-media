Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FM8xtJ003420
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 18:08:59 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8FM8sxf031640
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 18:08:55 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: stuart <stuart@xnet.com>
In-Reply-To: <48CEC847.8030404@xnet.com>
References: <48CD6F11.8020900@xnet.com>
	<1221431625.4566.5.camel@pc10.localdom.local>
	<48CEC847.8030404@xnet.com>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 00:04:56 +0200
Message-Id: <1221516296.2715.52.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Dwaine Garden <dwainegarden@rogers.com>, video4linux-list@redhat.com
Subject: Re: KWorld 120 IR control?
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

Am Montag, den 15.09.2008, 15:40 -0500 schrieb stuart:
> 
> hermann pitton wrote:
> > Hi Stuart,
> > 
> > Am Sonntag, den 14.09.2008, 15:07 -0500 schrieb stuart:
> >> Hi...
> >>
> >> This is my monthly (humm, more like quarterly) bump to see if anyone has 
> >> looked at (or can tell me what to do with) the KWorld 120 video4linux 
> >> drivers when it comes to getting the IR hardware to work.
> >>
> >> I would think, by now, there are a lot of these cards out there.  Were 
> >> not the KWorld 110 and 115 ATSC tuners popular here?  And haven't they 
> >> been replaced by the KWorld 120?  If so, what are people doing for IR?
> >>
> >> ...thanks
> >>
> > 
> > Mauro, better we all of course, need to review Brian Rogers latest patch
> > from Thursday on this to get it in.
> > 
> > Based on this, likely Dwaine Garden is the one who can further proceed
> > for the Kworld stuff too.
> > 
> > Cheers,
> > Hermann
> 
> Hey, thanks to all who have contributed to the KWorld-120 v4l driver! 
> If it wasn't obvious, I've been enjoying the sound and video from my v4l 
> driven KWorld-120 for months now.
> 
> So, are these IR remote control patches in Staging (the v4l somewhat 
> stable pre-release version).  I've pulled and compiled from that repo 
> before - no problem if that's where the new IR code is.
> 
> ...thanks
> 

there have been patches on the lists for KS003 and KS007 i2c driven
remotes, but nothing is in yet.

Brian Rogers current version likely will make it in now for the saa7134
MSI TV@nywhere, based on Henry Wong's old patch.

Mauro will have a look at it again next week after Portland.

It likely can provide the base for other cards and drivers too then.

Cheers,
Hermann









--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
