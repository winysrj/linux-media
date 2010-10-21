Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:34577 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab0JUR1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 13:27:16 -0400
Date: Thu, 21 Oct 2010 11:27:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] ov7670: allow configuration of image size, clock
 speed, and I/O method
Message-ID: <20101021112714.4c56b1d2@bike.lwn.net>
In-Reply-To: <20101019212405.85C279D401B@zog.reactivated.net>
References: <20101019212405.85C279D401B@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 19 Oct 2010 22:24:05 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> These parameters need to be configurable based on the host system.
> They can now be communicated through the s_config call.
> 
> The old CONFIG_OLPC_XO_1 selector was not correct; this kind of
> arrangement wouldn't allow for a universal kernel that would work on both
> laptops.
> 
> Certain parts of the probe routine had to be moved later (into s_config),
> because we can't do any I/O until we know which I/O method has been
> selected through this mechanism.

OK, I've had a look at this.  I'm OK with it to go in as it is, but,
for the record, I'll note that I would have done it a bit differently.

There are three different things (minimum size, clock speed, I/O
method) being dealt with here; it might have been nice to separate them
out.  Yes, they're all part of the s_config() call, I know...

I dislike deferring the probe of the sensor, it strikes me as something
that could create timing problems.  Maybe I'm overly nervous about
this and it's not really a problem.

My biggest issue, though, is this: SMBUS I/O is actually never the
right thing to do with the ov7670.  This isn't something I knew when I
wrote the Cafe driver (suffice to say the ov7670 seems to hold more
than its share of mysteries and surprises).  What I *should* have done
- and what should be done now - is to forget the built-in Cafe SMBUS
mode and do a straight bit-banging i2c driver.  As I recall, the Cafe
controller does provide that level of access for those who want it.

That's a bigger fix, of course.  I have it on my list, but my list is,
well, you know.  So I won't try to hold up this patch, which works
around my initial screwup, on the promise of a proper fix one of these
days.  Sometime when I have a few hours I will take a crack at it,
though.

Thanks,

jon
