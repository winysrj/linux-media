Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJCTprZ022684
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 07:29:51 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBJCTWYD032504
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 07:29:32 -0500
Date: Fri, 19 Dec 2008 13:29:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
In-Reply-To: <44440.83878.qm@web32104.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0812191319090.4536@axis700.grange>
References: <44440.83878.qm@web32104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: soc-camera: current stack
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

On Fri, 19 Dec 2008, Agustin wrote:

> Hi Guennadi, 
> 
> On Tue, 18/12/08, Guennadi Liakhovetski wrote:
> > ... My current stack is at
> > 
> > http://gross-embedded.homelinux.org/~lyakh/v4l-20081217/
> > ...
> 
> I was about to try this stack on my Phytec i.MX31 system when I found 
> there is no mx3_camera driver in it. Too bad!

Well, sorry, no, i.MX31 is not in that patchset. It depends on other 
drivers, that are still in review, and this patchset represents what I'm 
pushing upstream _now_.

> I still haven't been able to retrieve a VGA sized dummy image from my 
> FPGA on a Phytec dev-kit, stuck at "select timeout". I was hoping that 
> this new stack could have some important stuff that your previous (from 
> November) didn't.
> 
> I can't tell if I am having a hardware issue... Do you have any 
> modification or fix in your Phytec i.MX31 dev-kit?

Nothing ground-breaking. The snapshot I uploaded for you in November 
worked for me and it should work for you too. By "select timeout" I 
suspect you're not getting any interrupts at all, right? That's your first 
task - to get your setup generate at least one interrupt, then it'll be 
easier:-) You say "haven't been able to retrieve a VGA sized dummy image" 
- does it mean you can retrieve other (smaller) sizes? If not, I would 
check signalling. Check the master clock, whether the pixel clock is 
generated. You're using master mode, right? If both clocks are ok, check 
syncs. You said before your logic analyser showed a plausible picture... 
Are you doing 8 or 16 bits? Check output of /proc/interrupts _while_ a 
task is waiting in select, you should be getting irq #167 - one per frame.

Good luck
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
