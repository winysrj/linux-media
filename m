Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7P07Vtu006487
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 20:07:32 -0400
Received: from mail1.sea5.speakeasy.net (mail1.sea5.speakeasy.net
	[69.17.117.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7P07Kxc007382
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 20:07:20 -0400
Date: Sun, 24 Aug 2008 17:07:14 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1219407994.2855.24.camel@morgan.walls.org>
Message-ID: <Pine.LNX.4.58.0808241653050.2423@shell2.speakeasy.net>
References: <200808181918.05975.jdelvare@suse.de>
	<200808202334.20872.jdelvare@suse.de>
	<Pine.LNX.4.58.0808210107110.23833@shell4.speakeasy.net>
	<200808211114.27290.jdelvare@suse.de>
	<Pine.LNX.4.58.0808211445230.23833@shell4.speakeasy.net>
	<1219407994.2855.24.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Fri, 22 Aug 2008, Andy Walls wrote:
> On Thu, 2008-08-21 at 15:50 -0700, Trent Piepho wrote:
> > And this is a pretty common way to do it.  The formula the bt878 uses is:
> > 1.0 * x(0)
>
> This is straight decimation, which is what I would think is the "real"
> way to do things - for non-video signals at least.  It limits the
> highest spatial frequency that can be accurately recovered for the
> chroma.

You have to do a low-pass filter before decimation, otherwise the high
frequencies will alias.

I think the mathematically correct filter would be a sinc function with an
infinite base, though in practice such sinc filters can produce undesirable
ringing effects.

> > That's also a perfectly valid and real formula to use, though not a
> > particularly good one.
>
> What are the measures you are using to make a good/bad declaration?  If
> only the complexity of a capture implementation is the measure, then
> straight decimation is the best, I would think.

Quality.  For example, see
http://www.glennchan.info/articles/technical/chroma/chroma1.htm

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
