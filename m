Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA5CFe8f014406
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 07:15:40 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA5CFRfT007086
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 07:15:27 -0500
From: Andy Walls <awalls@radix.net>
To: Carl Karsten <carl@personnelware.com>
In-Reply-To: <4911414E.2050801@personnelware.com>
References: <47C90994.8040304@personnelware.com>
	<20080304113834.0140884d@gaivota> <490E468A.6090200@personnelware.com>
	<1225675203.3116.12.camel@palomino.walls.org>
	<490E6EC3.7030408@personnelware.com>
	<1225762470.3198.23.camel@palomino.walls.org>
	<4911414E.2050801@personnelware.com>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 07:17:14 -0500
Message-Id: <1225887434.3122.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: v4l2 api compliance test
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

On Wed, 2008-11-05 at 00:46 -0600, Carl Karsten wrote:
> Andy Walls wrote:
> > On Sun, 2008-11-02 at 21:23 -0600, Carl Karsten wrote:
> >> Andy Walls wrote:
> >>> On Sun, 2008-11-02 at 18:32 -0600, Carl Karsten wrote:
> >>>> Mauro Carvalho Chehab wrote:
> >>>>> On Sat, 01 Mar 2008 01:45:24 -0600
> >>>>> Carl Karsten <carl@personnelware.com> wrote:
> >>>>>
> >>>>>

> > 
> > Perhaps you could look at /proc/meminfo between runs and see if
> > something is gradually being exhausted.  Vmalloc address space
> > exhaustion is what I'd look for.
> > 
> 
> I forgot to sort it - now I see:
> 
> HighFree go from 72608 to 252
> VmallocUsed from 6440 to 109724
> VmallocChunk from 103620 to 336
> 
> I hope this sheds some light on where to look.

The driver is leaking kernel vmalloc address space.  Since the
VIDIOC_QBUF ioctl() calls are happening in a loop for --userp, many may
be succeeding before you get the notification of one failing.

There are also likely other leaks over vmalloc space in the driver since
--read and --mmap make things worse.

Regards,
Andy

> Carl K
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
