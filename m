Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OF1l99010611
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 11:01:47 -0400
Received: from fogou.chygwyn.com (fogou.chygwyn.com [195.171.2.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OF1OCo027609
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 11:01:24 -0400
Date: Thu, 24 Apr 2008 15:38:25 +0100
From: Steven Whitehouse <steve@chygwyn.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080424143825.GA31993@fogou.chygwyn.com>
References: <1209046379.9435.5.camel@ThePenguin>
	<20080424113125.7fd2de52@gaivota>
	<1209047735.9435.8.camel@ThePenguin>
	<20080424141513.GA31623@fogou.chygwyn.com>
	<20080424114424.52471e2c@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424114424.52471e2c@gaivota>
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

Hi,

On Thu, Apr 24, 2008 at 11:44:24AM -0300, Mauro Carvalho Chehab wrote:
> On Thu, 24 Apr 2008 15:15:13 +0100
> Steven Whitehouse <steve@chygwyn.com> wrote:
> 
> > Hi,
> > 
> > On Thu, Apr 24, 2008 at 04:35:35PM +0200, Johan Hedlund wrote:
> > > I am developing my own capture drivers for our own developed hardware
> > > based on a driver that does not exist in mainline. This driver used a
> > > uyuv format, but since we want to use the raw bayer format with 10-bit
> > > color resolution I need to change the format.
> > > 
> > > /Johan
> > > 
> > >
> > Also I sent a patch for this a little while back... I thought it had
> > been added, and I rather lost track of what has happend to it,
> 
> Hi Steve,
> 
> It seems that I lost your patches adding this new standard and adding a driver
> using it. Could you please send those to me again?
> 
> Cheers,
> Mauro

Btw, the V4L spec claims that it exists already:
http://v4l2spec.bytesex.org/spec/r3796.htm

Guennadi Liakhovetski submitted a driver which uses this too so
thats why I'd thought it was already included. I hadn't looked
to see what stage his driver was at recently.

Somehow my patch got mangled up with some other stuff too, because
I saw this thread:
http://lists.zerezo.com/video4linux/msg21484.html

but my original patch did nothing but add the two new pix formats
so I've no idea why I was being credited with various extra
changes as well, which were nothing to do with me.

Btw, here was the original patch:
http://www.archivum.info/video4linux-list@redhat.com/2008-01/msg00059.html

I do have a (not yet submitted driver) which uses it, and the hold up
has been basically that the various subsystems that I was using were
in a state of flux. I hope that when the current merge window is
complete I'll be able to take another look at it, and get it ready.

I hadn't bothered to follow up on the patch since my driver wasn't
ready yet, but nonetheless I didn't receive any feedback at the time
to suggest that it was a prerequsite.

There are a lot of sensors though that use this format. Pretty much
all the Omnivision sensors and the Micron sensors all have 10 bit
interfaces, even though some manufacturers only choose to use the
upper 8 bits, so it will be something that it of general use to
lots of people,

Steve.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
