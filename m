Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m66D5WeW014462
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 09:05:32 -0400
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m66D5KGp004171
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 09:05:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Sun, 6 Jul 2008 15:05:02 +0200
References: <200807032352.54746.hverkuil@xs4all.nl>
	<1215349114.3184.30.camel@palomino.walls.org>
In-Reply-To: <1215349114.3184.30.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807061505.02224.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [linux-dvb] RFC: remove support from v4l-dvb for kernels <
	2.6.16
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

On Sunday 06 July 2008 14:58:34 Andy Walls wrote:
> On Thu, 2008-07-03 at 23:52 +0200, Hans Verkuil wrote:
> > RFC: remove support from v4l-dvb for kernels < 2.6.16
> >
> > After spending some time trying to get v4l-dvb to compile on older
> > kernels I discovered that:
> >
> > - it is OK for kernels >= 2.6.19
> >
> > - it does not compile at the moment for kernels >= 2.6.16 and <
> > 2.6.19, but that this can be fixed.
> >
> > - that it can be made to compile for kernels >= 2.6.12 and <
> > 2.6.16, although quite a few drivers had to be disabled and looking
> > at the type of compile warnings emitted the result would likely
> > crash, especially the closer one gets to 2.6.12.
> >
> > - that I no longer can compile against older kernels since
> > gcc-4.1.2 no longer accepts some constructions used in those kernel
> > sources.
>
> But a user can have an old kernel version and an old tool chain.  IMO
> I don't think gcc's version is a valid criterion, as that makes an
> assumption about what the user is using to build his very old kernel.

It's not a valid criterium, but the combination with the nasty compile 
warnings I get when compiling for kernels 2.6.12-2.6.15 does make it an 
additional consideration. Not to mention the additional effort required 
to keep it all running.

> I know Fedora 5 used to include a gcc-3.2.3 (in the compat-gcc-32
> package) for compiling older stuff.  I guess there was a major shift
> in gcc after that point.  (I use gcc-3.2.3 in building the
> x86_64-mips cross compiler tool chain for building the linux v2.4.20
> firmware for my router.)
>
> > I did a few scans and of the approximately 932 KERNEL_VERSION
> > checks only 268 remain if we drop support for anything below
> > 2.6.26. That's a major cleanup.
    ^^^^^^

I meant 2.6.16. Sorry, typo.

> >
> > Since it is now simply broken for anything below 2.6.19 I think it
> > is a good solution to on the one hand do a major cleanup at the
> > expense of making it unlikely that we will ever support kernels
> > below 2.6.16, and on the other hand at least start to support
> > 2.6.16 and up.
>
> Only supporting 2.6.26 onward would prompt a surge of questions
> regarding compilation problems for users who are only a few kernel
> versions behind.  I think your suggestion of supporting a few kernels
> back (2.6.16 or 2.6.19) is preferable.
>
> My $0.02
>
> -Andy


Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
