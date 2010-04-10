Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:27069 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab0DJMdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 08:33:51 -0400
Subject: Re: [RFC3] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jon Smirl <jonsmirl@gmail.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <4BC06AC9.4060203@infradead.org>
References: <20100408113910.GA17104@hardeman.nu>
	 <1270812351.3764.66.camel@palomino.walls.org>
	 <s2o9e4733911004090531we8ff39b4r570e32fdafa04204@mail.gmail.com>
	 <4BBF3309.6020909@infradead.org>  <20100410064801.GA2667@hardeman.nu>
	 <1270900579.3034.25.camel@palomino.walls.org>
	 <4BC06AC9.4060203@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 08:34:13 -0400
Message-Id: <1270902853.3034.53.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-10 at 09:10 -0300, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
> > On Sat, 2010-04-10 at 08:48 +0200, David Härdeman wrote:
> >> On Fri, Apr 09, 2010 at 11:00:41AM -0300, Mauro Carvalho Chehab wrote:
> >>> struct {
> >>> 	unsigned mark : 1;
> >>> 	unsigned duration :31;
> >>> }
> >>>
> >>> There's no memory spend at all: it will use just one unsigned int and it is
> >>> clearly indicated what's mark and what's duration.
> >> If all three of you agree on this approch, I'll write a patch to convert 
> >> ir-core to use it instead.
> > 
> > I'm OK with it.
> > 
> > I haven't been paying close attention,so I must ask: What will the units
> > of duration be?
> > 
> > a. If we use nanoseconds the max duration is 2.147 seconds.
> > 
> > If passing pulse measurments out to LIRC, there are cases where irrecord
> > and lircd want the duration of the long silence between the
> > transmissions from the remote. Do any remotes have silence periods
> > longer than 2.1 seconds?
> > 
> > b. If we use microseconds, the max duration is 214.7 seconds or 3.6
> > minutes.  That's too high to be useful.
> > 
> > c.  Something in between, like 1/8 (or 1/2, 1/4, or 1/10) of a
> > microsecond?  1/8 gives a max duration of 26.8 seconds and a little
> > extra precision.
> 
> (c) is really ugly.
>
> (b) max limit is too high. Currently, the core assumes that everything longer
> than one second is enough to re-start the state machine. So, I think (a)
> is the better option.
> 
> Another way to see it: it is not reasonable for someone to press a key and wait
> for 2.1 seconds to see one bit of the key to be recognized.

True enough.


> So, IMHO, let's just use nanoseconds with 31 bits. the sampling event function
> should check for ktime value: if bigger than 2^32-1, then assume it is a
> long event, resetting the state machine.

Sounds OK to me.  Thanks for the reply.

Regards,
Andy

> Cheers,
> Mauro


