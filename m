Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MCS75B008490
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 08:28:07 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MCS50B003533
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 08:28:05 -0400
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <Pine.LNX.4.58.0808211445230.23833@shell4.speakeasy.net>
References: <200808181918.05975.jdelvare@suse.de>
	<200808202334.20872.jdelvare@suse.de>
	<Pine.LNX.4.58.0808210107110.23833@shell4.speakeasy.net>
	<200808211114.27290.jdelvare@suse.de>
	<Pine.LNX.4.58.0808211445230.23833@shell4.speakeasy.net>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 08:26:34 -0400
Message-Id: <1219407994.2855.24.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Jean Delvare <jdelvare@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] bttv driver errors
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

On Thu, 2008-08-21 at 15:50 -0700, Trent Piepho wrote:
> On Thu, 21 Aug 2008, Jean Delvare wrote:
> > Le jeudi 21 aot 2008, Trent Piepho a crit:
> > > On Wed, 20 Aug 2008, Jean Delvare wrote:

> > > 4:2:0 YUV is achieved by setting the chip to 4:2:2 mode and then dropping
> > > "every other" chroma line with RISC DMA program.
> >
> > OK. So you agree with me that this is approximative and not "real"
> > vertical subsampling. I'm curious if more recent video chips are

Strictly speaking subsampling happens at the A to D conversion.  Follow
on processes are filtering and, in this case, decimation.


> Depends on what you mean by "real".  Think of the top line of the chroma as
> x(0), the line below it as x(1), the next line x(2) and so on.  The line
> above would be x(-1), then x(-2), etc.
> 
> It sounds like you think the formula for the subsampled chroma should be:
> 0.5 * x(0) + 0.5 * x(1)

That's a short moving average (low pass) filter on the 4:2:2 subsampled
chroma prior to decimation.  It may have the effect of removing the
higher spatial frequencies in the chroma, but so does the decimation
(with the required anti-aliasing filter after re interpolation later).

>From a signal processing perspective, I wouldn't expect a low pass
filter (i.e. the anti-alias filter) to be employed until after the
interpolation to reconstruct the chroma signals for display.



> And this is a pretty common way to do it.  The formula the bt878 uses is:
> 1.0 * x(0)

This is straight decimation, which is what I would think is the "real"
way to do things - for non-video signals at least.  It limits the
highest spatial frequency that can be accurately recovered for the
chroma.


> That's also a perfectly valid and real formula to use, though not a
> particularly good one.

What are the measures you are using to make a good/bad declaration?  If
only the complexity of a capture implementation is the measure, then
straight decimation is the best, I would think.


>   You could also use something like:
> 0.125 * x(-1) + 0.375 * x(0) + 0.375 * x(1) + 0.125 * x(2)

(Another type of moving average filter before decimation.)


What are the benefits of using the moving average filters before
decimation?  


Regards,
Andy


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
