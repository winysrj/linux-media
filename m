Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:11922 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708Ab1AJNYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 08:24:11 -0500
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Andy Walls <awalls@md.metrocast.net>
To: Lawrence Rust <lawrence@softsystem.co.uk>
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1294664187.3340.9.camel@gagarin>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
	 <1294488550.9475.20.camel@gagarin>  <1294496528.2443.85.camel@localhost>
	 <1294512347.16924.28.camel@gagarin>
	 <1294663149.2084.41.camel@morgan.silverblock.net>
	 <1294664187.3340.9.camel@gagarin>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 08:24:05 -0500
Message-ID: <1294665845.4456.15.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-10 at 13:56 +0100, Lawrence Rust wrote:
> On Mon, 2011-01-10 at 07:39 -0500, Andy Walls wrote:

> You know what, life's too short.  I've spent far too long on this at the
> expense of far more interesting projects.  Every time I put some effort
> in someone says just one more thing...  I get the message.

With all due respect, I don't think that you do.

The message is *not*

"Lawrence we don't won't your patches here , because we're an exclusive
club"

nor

"Lawrence, we don't find your time and talent valuable"


All of my comments stem from *one* high level requirement:

Don't break the code for existing boards - especially popular ones for
which I have some level of maintenance responsibility.

How you satisfy that requirement is up to you.

Just as you don't have a lot of time to do all the analysis and testing
to ensure that requirement is met; I don't have time to clean up every
patch that doesn't meet that requirement.  The time and effort you don't
expend gets pushed off to me or someone else.

I have tried to provide you with constructive criticism and guidance.  I
will not do your work for you.

Regards,
Andy

