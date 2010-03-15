Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35511 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937180Ab0COXcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 19:32:05 -0400
Subject: Re: Magic in videobuf
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
In-Reply-To: <4B9E6DC4.5010301@redhat.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C7FCA3BF@bssrvexch01.BS.local>
	 <4B9E1931.8060006@redhat.com>
	 <b320a5b9ff16d1df8ecc6272a7fe2c14.squirrel@webmail.xs4all.nl>
	 <4B9E5EF1.2000600@redhat.com>
	 <e1551c2096f8616e8b01344b1af51a51.squirrel@webmail.xs4all.nl>
	 <4B9E6DC4.5010301@redhat.com>
Content-Type: text/plain
Date: Mon, 15 Mar 2010 19:30:49 -0400
Message-Id: <1268695849.3081.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-03-15 at 14:26 -0300, Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> >> Hans Verkuil wrote:
> >>>> Pawel Osciak wrote:

> >>>>> is anyone aware of any other uses for MAGIC_CHECK()s in videobuf code
> >>>>> besides driver debugging? I intend to remove them, as we weren't able
> >>>>> to find any particular use for them when we were discussing this at
> >>>>> the memory handling meeting in Norway...
> >>>> It is a sort of paranoid check to avoid the risk of mass memory
> >>>> corruption
> >>>> if something goes deadly wrong with the video buffers.
> >>>>

> >>> What on earth does this magic check have to do with possible DMA
> >>> overruns/memory corruption? This assumes that somehow exactly these
> >>> magic
> >>> fields are overwritten and that you didn't crash because of memory
> >>> corruption elsewhere much earlier.

>  All it does is oops anyway, so it really doesn't 'avoid' a crash
> >>> (as if you could in such scenarios). And most likely the damage has been
> >>> done already in that case.
> >> It won't avoid the damage, but the error message could potentially help
> >> to track the issue. It will also likely limit the damage.
> >>
> >>> Please let us get rid of this. It makes no sense whatsoever.
> >> I don't have a strong opinion about this subject, but if this code might
> >> help
> >> to avoid propagating the damage and to track the issue, I don't see why we
> >> need to remove it, especially since it is easy to disable the entire logic
> >> by just adding a few #if's to remove this code on environments where no
> >> problem is expected.
> > 
> > It is highly unlikely that this code ever prevented these issues.
> > Especially given the places where the check is done. I think this is just
> > debug code that has been dragged along for all these years without anyone
> > bothering to remove it.

> I remember I had to re-format one disk, during that time, due to a videobuf issue.
> So, those checks help people that are touching at the videobuf code, reducing the 
> chances of damaging their disk partitions when trying to implement overlay mode and
> userptr on the videobuf implementations that misses those features, or when
> working on a different mmap() logic at the driver.


In a previous job, working on a particularly large application, I had
occasional corruption in a shared memory segment that was shared by many
writer processes and 2 readers.  A simple checksum on the data header
(and contents if appropriate) was enough to detect corrpution and avoid
dereferencing a corrupted pointer to the next data element (when walking
a data area filled with Key-Length-Value encoded data).

This "forward error detection" was inelegant to me - kind of like
putting armor on one's car instead of learning to drive properly.  I
only resorted to using the checksum because there was almost no way to
find which process was corrupting shared memory in a reasonable amount
of time.  It allowed me to change a "show stopper" bug into an annoying
data presentation bug, so the product could be released to a production
environment.

In a development environment, it would be much better to disable such
defensive coding and let the kernel Oops.  You'll never find the
problems if you keep hiding them from yourself.


Regards,
Andy

