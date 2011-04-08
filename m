Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42805 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1DHOlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 10:41:46 -0400
Received: by qyk7 with SMTP id 7so4016699qyk.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 07:41:46 -0700 (PDT)
References: <1302267045.1749.38.camel@gagarin>
In-Reply-To: <1302267045.1749.38.camel@gagarin>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH] Fix cx88 remote control input
Date: Fri, 8 Apr 2011 10:41:56 -0400
To: Lawrence Rust <lawrence@softsystem.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Apr 8, 2011, at 8:50 AM, Lawrence Rust wrote:

> This patch restores remote control input for cx2388x based boards on
> Linux kernels >= 2.6.38.
> 
> After upgrading from Linux 2.6.37 to 2.6.38 I found that the remote
> control input of my Hauppauge Nova-S plus was no longer functioning.  
> I posted a question on this newsgroup and Mauro Carvalho Chehab gave
> some helpful pointers as to the likely cause.
> 
> Turns out that there are 2 problems:
...
> 2. The RC5 decoder appends the system code to the scancode and passes
> the combination to rc_keydown().  Unfortunately, the combined value is
> then forwarded to input_event() which then fails to recognise a valid
> scancode and hence no input events are generated.

Just to clarify on this one, you're missing a step. We get the scancode,
and its passed to rc_keydown. rc_keydown then looks for a match in the
loaded keytable, then passes the *keycode* that matches the scancode
along to input_event. If you fix the keytable to contain system and
command, everything should work just fine again. Throwing away data is
a no-no though -- take a look at recent changes to ir-kdb-i2c, which
actually just recently made it start *including* system. :)

-- 
Jarod Wilson
jarod@wilsonet.com



