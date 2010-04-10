Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:55957 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0DJWXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 18:23:23 -0400
Date: Sun, 11 Apr 2010 00:23:19 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Andy Walls <awalls@radix.net>
Cc: mchehab@redhat.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] Add RC6 support to ir-core
Message-ID: <20100410222319.GA10473@hardeman.nu>
References: <20100408230246.14453.97377.stgit@localhost.localdomain>
 <20100408230440.14453.36936.stgit@localhost.localdomain>
 <1270861928.3038.153.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1270861928.3038.153.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 09, 2010 at 09:12:08PM -0400, Andy Walls wrote:
> On Fri, 2010-04-09 at 01:04 +0200, David Härdeman wrote:
> > +again:
> > +	IR_dprintk(2, "RC6 decode started at state %i (%i units, %ius)\n",
> > +		   data->state, u, TO_US(duration));
> > +
> > +	if (DURATION(u) == 0 && data->state != STATE_FINISHED)
> > +		return 0;
> 
> Isn't there a better way to structure the logic to break up two adjacent
> pulse units than with goto's out of the switch back up to here?
> 
> A do {} while() loop would have been much clearer.

I just tried it, and I'm not convinced. The main problem is that you'll 
end up with:

do {
	switch(b) {
	case c:
		if (x)
			break;
		else if (y)
			continue;
while(a);

Where the break statement will affect the switch() and the continue 
statement will affect the do-while() loop which is kinda confusing.

Especially if you're so far down in the function body that the 
do-while() and switch() statements aren't visible any more.


-- 
David Härdeman
