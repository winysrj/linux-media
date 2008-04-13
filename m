Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3DKYgBc012967
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 16:34:42 -0400
Received: from web907.biz.mail.mud.yahoo.com (web907.biz.mail.mud.yahoo.com
	[216.252.100.93])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3DKYRv0014916
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 16:34:27 -0400
Date: Sun, 13 Apr 2008 22:34:21 +0200 (CEST)
From: Markus Rechberger <mrechberger@empiatech.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080413172207.4276a17f@areia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <529381.57396.qm@web907.biz.mail.mud.yahoo.com>
Cc: Video <video4linux-list@redhat.com>
Subject: Re: [ANNOUNCE] Videobuf improvements to allow its usage with USB
	drivers
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


--- Mauro Carvalho Chehab <mchehab@infradead.org>
schrieb:

> On Sun, 13 Apr 2008 18:17:54 +0200 (CEST)
> Markus Rechberger <mrechberger@empiatech.com> wrote:
> 
> > >        Conclusion:
> > 
> > > The time consumption to receive the stream where
> reduced from about 33.38 seconds to 0.05 seconds
> > 
> > the question is moreover what made capture_example
> go
> > up to 100% CPU in the first try and to 0% in the
> > second one.
> > I'm not sure about the old implementation in the
> > original driver, although I'm just curious about
> the
> > details here. xawtv usually uses very little
> cputime
> > at all. 
> > If I use 
> > "$ time mplayer tv:// -tv driver=v4l2" it shows up
> 
> > 
> > real 0m40.972s
> > user 0m0.230s
> > sys  0m0.050s
> > 
> > your benchmark is a bit unclear.
> 
> The advantage of using capture_example for benchmark
> tests is that it is a very
> simple mmap loop, without multi-thread, and just
> discarding the return. With
> this, you're timing just the minimal requirements
> for receiving frames.
> 
> A TV application will also need to use the video
> adapter to present images, and
> may do some other tasks, like running DSP algorithms
> for de-interlacing. It may
> also discard frames, if there's not enough CPU to
> work will all of them. So,
> you will never know how much of those times are due
> to V4L kernelspace part.
> 
> On the tests I did here with TV applications, the
> amount of performance,
> reported by "top" also indicated that the previous
> approach were worse.
> 
> For example, on the same centino machine @1.5 GHZ,
> mplayer with "-tv driver=v4l2"
> were ranging from 30% to 75% of CPU. With videobuf,
> the CPU consumption were
> close to 23%, without much variation.
> 

my eeePC shows up 0-5% CPU usage with mplayer
fullscreen without videobuf, seems more like
something's broken in your testapplication or
somewhere else?

mplayer uses the memory mapped interface for this.

Also the command 
"$ mplayer -benchmark tv:// -tv driver=v4l2"

CPU Intel 620 Mhz

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
