Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OHMSX5027824
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 13:22:29 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3OHMDUu024388
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 13:22:13 -0400
Date: Thu, 24 Apr 2008 19:22:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Steven Whitehouse <steve@chygwyn.com>
In-Reply-To: <20080424143825.GA31993@fogou.chygwyn.com>
Message-ID: <Pine.LNX.4.64.0804241919270.7642@axis700.grange>
References: <1209046379.9435.5.camel@ThePenguin>
	<20080424113125.7fd2de52@gaivota>
	<1209047735.9435.8.camel@ThePenguin>
	<20080424141513.GA31623@fogou.chygwyn.com>
	<20080424114424.52471e2c@gaivota>
	<20080424143825.GA31993@fogou.chygwyn.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Johan Hedlund <johan.hedlund@enea.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Thu, 24 Apr 2008, Steven Whitehouse wrote:

> Btw, the V4L spec claims that it exists already:
> http://v4l2spec.bytesex.org/spec/r3796.htm
> 
> Guennadi Liakhovetski submitted a driver which uses this too so
> thats why I'd thought it was already included. I hadn't looked
> to see what stage his driver was at recently.
> 
> Somehow my patch got mangled up with some other stuff too, because
> I saw this thread:
> http://lists.zerezo.com/video4linux/msg21484.html
> 
> but my original patch did nothing but add the two new pix formats
> so I've no idea why I was being credited with various extra
> changes as well, which were nothing to do with me.

Right, there was a merge problem at some point, but it has been resolved, 
and now your patch in its original undamaged form in the v4l git tree 
waiting to be submitted into the mainline.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
