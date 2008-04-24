Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OEW8cn016498
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:32:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OEVcCZ032700
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:31:39 -0400
Date: Thu, 24 Apr 2008 11:31:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Johan Hedlund <johan.hedlund@enea.com>
Message-ID: <20080424113125.7fd2de52@gaivota>
In-Reply-To: <1209046379.9435.5.camel@ThePenguin>
References: <1209046379.9435.5.camel@ThePenguin>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

On Thu, 24 Apr 2008 16:12:59 +0200
Johan Hedlund <johan.hedlund@enea.com> wrote:

> Hello
> 
> I am working on a application that will use V4L2 on a linux-2.6-22
> kernel. I am interested in using the format V4L2_PIX_FMT_SBGGR16 'BA82'
> for my captured images. But it seems like I only can find it the in the
> V4L2 specification and not in the mainline kernel. Is this format not a
> standard format that should be in the mainline kernel? Can I just add
> the definition to my code and use it or will it break something else?

If it isn't at mainline kernel, there's no in-kernel drivers supporting it. It
is better to use a format that is already supported by the drivers.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
