Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbZETBfR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 21:35:17 -0400
Date: Tue, 19 May 2009 22:35:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Uri Shkolnik <urishk@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Recent Siano patches - testing required
Message-ID: <20090519223510.6667dca9@pedra.chehab.org>
In-Reply-To: <4A132502.6070103@kernellabs.com>
References: <492881.32224.qm@web110808.mail.gq1.yahoo.com>
	<4A132502.6070103@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 May 2009 17:30:42 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> > However any test that will be performed, will benefit all (including Siano.... :-)
> > 
> 
> Agreed. Yes, I happen to know Hauppauge very well.
> 
> I'm very happy to see that the driver is being improved but I'll be even happier 
> to see actual testers report success before any of this stuff is merged. My 
> concern is the vast amount of change coming through this list and expected to be 
> merged blindly into the kernel.
> 
> If we have no testers then, at least for Hauppauge products, we'll find some. 
> Let me know if I can help with this.
> 
> Until then nothing should be blindly merged that could regress existing product 
> support.
> 
> Mauro?

Steven,

Your concerns about testing make sense, but this were already tried in the
past, when Uri started sending their patches at the ML. So, instead of
repeating the same novel, let's merge the patches at the development tree and
ask people to test.

Yet, I'm keeping the Siano patches at the 'pending' -git tree, where I hold
very experimental work. I intend to hold it there until we have more tests and
have all the pending patches merged.

About creating an -hg tree for Siano (and for other developers), I had to nack
it in the past, since the LinuxTV server were overloaded. Now that the machine
got replaced, I think we may actually create a tree for them. 

Uri, please discuss about this in priv with me, in order to exchange the needed
information for the login account.



Cheers,
Mauro
