Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OGUQR0021961
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 12:30:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OGUBqd013278
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 12:30:11 -0400
Date: Thu, 24 Apr 2008 13:29:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Whitehouse <steve@chygwyn.com>
Message-ID: <20080424132953.418c5556@gaivota>
In-Reply-To: <20080424143825.GA31993@fogou.chygwyn.com>
References: <1209046379.9435.5.camel@ThePenguin>
	<20080424113125.7fd2de52@gaivota>
	<1209047735.9435.8.camel@ThePenguin>
	<20080424141513.GA31623@fogou.chygwyn.com>
	<20080424114424.52471e2c@gaivota>
	<20080424143825.GA31993@fogou.chygwyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Johan Hedlund <johan.hedlund@enea.com>
Subject: Re: V4L2_PIX_FMT_SBGGR16 not in kernel
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

On Thu, 24 Apr 2008 15:38:25 +0100
Steven Whitehouse <steve@chygwyn.com> wrote:

> Btw, the V4L spec claims that it exists already:
> http://v4l2spec.bytesex.org/spec/r3796.htm
> 
> Guennadi Liakhovetski submitted a driver which uses this too so
> thats why I'd thought it was already included. I hadn't looked
> to see what stage his driver was at recently.

It isn't already at mainstream, but it will be soon. I'm finishing to prepare
its submission.

> I do have a (not yet submitted driver) which uses it, and the hold up
> has been basically that the various subsystems that I was using were
> in a state of flux. I hope that when the current merge window is
> complete I'll be able to take another look at it, and get it ready.
> 
> I hadn't bothered to follow up on the patch since my driver wasn't
> ready yet, but nonetheless I didn't receive any feedback at the time
> to suggest that it was a prerequsite.

It makes no sense to change the API for something that is not used ;)

> There are a lot of sensors though that use this format. Pretty much
> all the Omnivision sensors and the Micron sensors all have 10 bit
> interfaces, even though some manufacturers only choose to use the
> upper 8 bits, so it will be something that it of general use to
> lots of people,

Good.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
