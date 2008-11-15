Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFM8kSe014221
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 17:08:46 -0500
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAFM845w026834
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 17:08:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sat, 15 Nov 2008 23:07:58 +0100
References: <491CB0A6.9080509@personnelware.com>
	<491F3840.4030301@personnelware.com>
In-Reply-To: <491F3840.4030301@personnelware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811152307.58719.hverkuil@xs4all.nl>
Cc: 
Subject: Re: minimum v4l2 api - framework
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

On Saturday 15 November 2008 21:59:44 Carl Karsten wrote:
> Tomorrow (Nov 16) I will be at a Linuxfest, where I am going to try
> to find someone up for writing this driver.
>
> I am assuming there is some code they should use as a starting point.
> Either
> A) "This is the generic/abstract code that can be extended to make a
> specific/concrete driver" (what I would call a framework)
> B) "driver foo.c is a good example of how a V4L2 driver should be
> written; copy it and swap out the hardware specific code."
> C) "vivi.c is close enough.  you should really just work on fixing
> it."
>
> I am hoping the correct answer is:
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/file/6292505ca617/linu
>x/Documentation/video4linux/v4l2-framework.txt

Hopefully this will be the correct answer in the near future, but now it 
refers to structs that do not yet exist. I've reserved next weekend to 
continue work on this.

It's probably a good idea for me to create a template driver that can be 
used as a proper starting point, however nothing will be available soon 
enough for you. I don't think we have a 'perfect' driver right now. All 
drivers have their own problems. It's one of the main reasons I'm 
working on a better framework.

In any case, I don't think vivi is a good example, it's not written as a 
template driver, that was never the intention of vivi.

Regards,

	Hans

>
> If someone can give me a rough stub to start with, that would make
> tomorrow's work more promising.
>
> Carl K
>
> Carl Karsten wrote:
> > Apparently vivi is messed up enough that maybe it makes sense to
> > write a new test driver.
> >
> > What is the minimum interface a v4l2 driver could have?
> >
> > Something like: it registers itself as /dev/videoN, and
> > QueryCaps returns nothing.
> > It does not return any image. (yeah ?)
> > It can be unloaded.
> >
> > and anything else that someone thinks is required for a well
> > behaved driver that follows the spec.
> >
> > The plan is to start with that, get it and my tester working in
> > harmony, then start adding things to both sides of the fence.  I am
> > thinking additional features will be enabled via module parameters,
> > so that it can always be dumbed down back to it's minimum.
> >
> > Carl K
> >
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe
> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
