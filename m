Return-path: <mchehab@pedra>
Received: from smtp22.services.sfr.fr ([93.17.128.10]:7497 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab1DHPWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:22:33 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2219.sfr.fr (SMTP Server) with ESMTP id 07E9B7000097
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2011 17:22:30 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (unknown [93.14.171.92])
	by msfrf2219.sfr.fr (SMTP Server) with SMTP id B38BF7000093
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2011 17:22:29 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.14.171.92] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 17:22:28 +0200
Subject: Re: [PATCH] Fix cx88 remote control input
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin>
	 <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 17:22:27 +0200
Message-ID: <1302276147.1749.46.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2011-04-08 at 10:41 -0400, Jarod Wilson wrote:
> On Apr 8, 2011, at 8:50 AM, Lawrence Rust wrote:
> 
> > This patch restores remote control input for cx2388x based boards on
> > Linux kernels >= 2.6.38.
> > 
> > After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
> > control input of my Hauppauge Nova-S plus was no longer functioning.  
> > I posted a question on this newsgroup and Mauro Carvalho Chehab gave
> > some helpful pointers as to the likely cause.
> > 
> > Turns out that there are 2 problems:
> ...
> > 2. The RC5 decoder appends the system code to the scancode and passes
> > the combination to rc_keydown().  Unfortunately, the combined value is
> > then forwarded to input_event() which then fails to recognise a valid
> > scancode and hence no input events are generated.
> 
> Just to clarify on this one, you're missing a step. We get the scancode,
> and its passed to rc_keydown. rc_keydown then looks for a match in the
> loaded keytable, then passes the *keycode* that matches the scancode
> along to input_event. If you fix the keytable to contain system and
> command, everything should work just fine again. Throwing away data is
> a no-no though -- take a look at recent changes to ir-kdb-i2c, which
> actually just recently made it start *including* system. :)

Don't shoot the messenger.

I'm just reporting what I had to do to fix a clumsy hack by someone 6
months ago who didn't test their changes.  This patch _restores_ the
operation of a subsystem broken by those changes

Perhaps those responsible for commit
2997137be8eba5bf9c07a24d5fda1f4225f9ca7d:

    Signed-off-by: David Härdeman <david@hardeman.nu>
    Acked-by: Jarod Wilson <jarod@redhat.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

should fix the keytable.  In the meantime (next year) I'll be using this
patch.

-- 
Lawrence


