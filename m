Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m93EMV6P018490
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 10:22:31 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m93EMJEu008197
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 10:22:19 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200810031431.23882.hverkuil@xs4all.nl>
References: <200810031313.36607.hverkuil@xs4all.nl>
	<1223035626.3121.38.camel@palomino.walls.org>
	<200810031431.23882.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 10:23:46 -0400
Message-Id: <1223043826.9691.54.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: RFC: move zoran/core/i2c drivers to separate directories
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

On Fri, 2008-10-03 at 14:31 +0200, Hans Verkuil wrote:
> On Friday 03 October 2008 14:07:06 Andy Walls wrote:
> > On Fri, 2008-10-03 at 13:13 +0200, Hans Verkuil wrote:

> > How about media/video/ancillary or media/common/ancillary to cover
> > ancillary support chips and functions that are otherwise unclassified
> > in the directory structure/taxonomy?
> >
> > </thinking out loud>
> 
> Hmm, ancillary is a bit long.

I'm not in love with it either.  I encounter the term a lot though when
looking at communications systems.  All of the power amplifiers,
diplexers, lna's, switches, are ancillary equipment to support the
receiver-transmitter unit.  The system can't work without the
ancillaries, but they are secondary in nature to the
receiver-transmitter.

The hardware devices supporting the main/host chip on a video card
struck me as being in the same role.



And now, since I, for some strange reason, love to argue semantics
despite how non-productive it can be:

>  What about clients? Since these are all 
> (i2c) clients on a (usually i2c) bus.

"Clients" comes from a software command/control vs hardware support
perspective.  That's certainly valid, but I think the term "client" is
overloaded semantically.  I'm inclined to think first in terms of
clients making requests from a "server" vs. a "host" pushing data and
commands to a client.  Being a client driver of the kernel i2c
infrastructure doesn't readily leap to my mind either.

The standard I2C terminology in the I2C specification was "master" and
"slaves", IIRC.  Maybe "slaves"? 

>  Besides, I'll be introducing a 
> struct media_client soon that all these drivers will support. 'struct 
> media_ancillary' sounds weird to me.

'media_ancillary' sounds weird to me too, and so does 'media_slave'.
But I did not expect you to tie the name of a structure definition to a
directory name.  Were you going to use "media_i2c' with your proposed
'i2c' name for the directory? :)

What would sound good with 'media_'?  'helper'? 'support_device'?  Maybe
'clients' is the only good word given that constraint.



> > To bring it up a level, you have identified a requirement to simplify
> > something and have an implicit measure of complexity (logically
> > unrelated files in the host driver directory?) that you'd like to
> > reduce.  So what does it take to meet that requirement without
> > increasing some other undesirable measure: the count of directories
> > under linux/drivers/media or how many files do my "grep -R" searches
> > have to wade through now? :)
> 
> 1) Moving zoran sources into a zoran directory reflects current 
> practice.

Yup.  Good idea. 


> 2) We could prefix all core files with a common prefix (v4l2_) as an 
> alternative. But I think it is cleaner to have a core directory 
> instead.

Agree, don't do the prefix.  A core directory is better.


> 3) Ditto for all i2c drivers, but there are so many that I think these 
> really should be moved to their own directory.

Agree.  The name is not all that important either (although easy to
argue about).

One cost I'd like to avoid is in terms of recursive descent searches and
diff's.  Don't move the files up out of media/video without good reason,
to keep the file count for lazy searches (grep -R 'foo' video ) the
same.  But you said that was your plan anyway.



I assume the goal here is to ease maintenance for the primary
maintainer(s) of the v4l infrastructure.  Since you're probably one of
those guys, you're in a better position to measure what is easiest more
accurately than I. :)

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
