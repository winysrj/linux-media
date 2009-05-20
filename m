Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:44109 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbZETCFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 22:05:19 -0400
Received: by pxi29 with SMTP id 29so123283pxi.33
        for <linux-media@vger.kernel.org>; Tue, 19 May 2009 19:05:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090519223510.6667dca9@pedra.chehab.org>
References: <492881.32224.qm@web110808.mail.gq1.yahoo.com>
	 <4A132502.6070103@kernellabs.com>
	 <20090519223510.6667dca9@pedra.chehab.org>
Date: Tue, 19 May 2009 22:05:19 -0400
Message-ID: <829197380905191905s4e65915kc0c37429b2cd0ebe@mail.gmail.com>
Subject: Re: Recent Siano patches - testing required
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@kernellabs.com>,
	Uri Shkolnik <urishk@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2009 at 9:35 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Steven,
>
> Your concerns about testing make sense, but this were already tried in the
> past, when Uri started sending their patches at the ML. So, instead of
> repeating the same novel, let's merge the patches at the development tree and
> ask people to test.
>
> Yet, I'm keeping the Siano patches at the 'pending' -git tree, where I hold
> very experimental work. I intend to hold it there until we have more tests and
> have all the pending patches merged.
>
> About creating an -hg tree for Siano (and for other developers), I had to nack
> it in the past, since the LinuxTV server were overloaded. Now that the machine
> got replaced, I think we may actually create a tree for them.
>
> Uri, please discuss about this in priv with me, in order to exchange the needed
> information for the login account.
>
>
>
> Cheers,
> Mauro

Mauro,

If I recall, a ton of patches were sent to the mailing list, but there
was never a test tree on linuxtv.org.  Were you expecting interested
parties to hand-apply all those patches?

It's not clear to me why you are putting this code that is untested by
the community into the v4l-dvb tree.  In all other cases where linuxtv
developers want to submit large sets of changes, you expect them to
create a private tree so testers can be solicited *before* it goes
into v4l-dvb.  Why would this case be any different?

You have no personal knowledge as to whether the code actually works,
and there are parties who have expressed a very clear concern about
some of the patches causing regressions in existing hardware.  Doesn't
the safer approach seem to be to setup a ~mchehab/siano-patches tree
so that people can do some testing, and *then* merge to the mainline?
If everything works, then great - it's one command to merge the fold
the tree back into the mainline...

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
