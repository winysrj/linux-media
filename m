Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m986ZUt5010896
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 02:35:30 -0400
Received: from swip.net (mailfe14.tele2.se [212.247.155.161])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m986X1S5011153
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 02:33:02 -0400
Received: from [62.113.135.118] (account mc467741@c2i.net [62.113.135.118]
	verified) by mailfe14.swip.net (CommuniGate Pro SMTP 5.2.6)
	with ESMTPA id 364372834 for video4linux-list@redhat.com;
	Wed, 08 Oct 2008 08:33:00 +0200
Content-Disposition: inline
From: Hans Petter Selasky <hselasky@c2i.net>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Wed, 8 Oct 2008 08:34:56 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810080834.57128.hselasky@c2i.net>
Subject: Fwd: Re: Video4Linux header files (and unnamed unions)
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

Would you accept the following patch to the videodev2.h file, that all unnamed 
unions are appended "MY_UNION" or something like that?

--HPS

----------  Forwarded Message  ----------

On Saturday 19 May 2007, Luigi Rizzo wrote:
> On Sat, May 19, 2007 at 11:24:34PM +0200, Hans Petter Selasky wrote:
> > On Saturday 19 May 2007 21:14, Luigi Rizzo wrote:
>
> ...
>
> > > - i don't know how problematic is this, but v4l2 headers seem to use
> > >   unnamed unions which, last time i tried, conflict with the compiler
> > >   setting used to build the kernel. While this is possibly an
> > > orthogonal problem which we may have to address at some point (as
> > > unnamed unions seem to be a common paradigm in linux headers), it is
> > > yet another hurdle.
> >
> > Unnamed unions are not so good. I suggest that we terminate unnamed
> > unions with an "u".

We can make this a compile time option:

#ifdef NOT_GCC_4X
#define MY_UNION u
#else
#define MY_UNION 
#endif

union {

} MY_UNION;

I see no problem about that. Else it will be a nightmare to port the code to 
other and especially older compilers.

>
> It is not our choice. Linux v4l2 headers use these unions,
> software is written against these headers, we can't change the
> names unless we want to make extensive changes to the sources.

We can be compatible with both!

--HPS

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
