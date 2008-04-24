Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OEiv5B027669
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:44:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OEijMV013213
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:44:45 -0400
Date: Thu, 24 Apr 2008 11:44:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Whitehouse <steve@chygwyn.com>
Message-ID: <20080424114424.52471e2c@gaivota>
In-Reply-To: <20080424141513.GA31623@fogou.chygwyn.com>
References: <1209046379.9435.5.camel@ThePenguin>
	<20080424113125.7fd2de52@gaivota>
	<1209047735.9435.8.camel@ThePenguin>
	<20080424141513.GA31623@fogou.chygwyn.com>
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

On Thu, 24 Apr 2008 15:15:13 +0100
Steven Whitehouse <steve@chygwyn.com> wrote:

> Hi,
> 
> On Thu, Apr 24, 2008 at 04:35:35PM +0200, Johan Hedlund wrote:
> > I am developing my own capture drivers for our own developed hardware
> > based on a driver that does not exist in mainline. This driver used a
> > uyuv format, but since we want to use the raw bayer format with 10-bit
> > color resolution I need to change the format.
> > 
> > /Johan
> > 
> >
> Also I sent a patch for this a little while back... I thought it had
> been added, and I rather lost track of what has happend to it,

Hi Steve,

It seems that I lost your patches adding this new standard and adding a driver
using it. Could you please send those to me again?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
