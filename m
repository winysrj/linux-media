Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OEcPrZ021331
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:38:25 -0400
Received: from fogou.chygwyn.com (fogou.chygwyn.com [195.171.2.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OEcC7I006796
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:38:13 -0400
Date: Thu, 24 Apr 2008 15:15:13 +0100
From: Steven Whitehouse <steve@chygwyn.com>
To: Johan Hedlund <johan.hedlund@enea.com>
Message-ID: <20080424141513.GA31623@fogou.chygwyn.com>
References: <1209046379.9435.5.camel@ThePenguin>
	<20080424113125.7fd2de52@gaivota>
	<1209047735.9435.8.camel@ThePenguin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209047735.9435.8.camel@ThePenguin>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
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

Hi,

On Thu, Apr 24, 2008 at 04:35:35PM +0200, Johan Hedlund wrote:
> I am developing my own capture drivers for our own developed hardware
> based on a driver that does not exist in mainline. This driver used a
> uyuv format, but since we want to use the raw bayer format with 10-bit
> color resolution I need to change the format.
> 
> /Johan
> 
>
Also I sent a patch for this a little while back... I thought it had
been added, and I rather lost track of what has happend to it,

Steve.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
