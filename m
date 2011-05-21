Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab1EUKnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 06:43:39 -0400
Message-ID: <4DD79752.2050605@redhat.com>
Date: Sat, 21 May 2011 07:43:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: James Huk <huk256@gmail.com>
CC: linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?St=E9phane_Elmaleh?= <stephane.elmaleh@laposte.net>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Radoslaw Warowny <radoslaww@gmail.com>,
	Alf Fahland <alf-f@gmx.de>
Subject: Re: Medion CTX1921 - why does the driver is not in the kernel yet?
References: <BANLkTi=pQ45Z=3vF1-HX=-foqHh7oJcR1A@mail.gmail.com>
In-Reply-To: <BANLkTi=pQ45Z=3vF1-HX=-foqHh7oJcR1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-05-2011 19:15, James Huk escreveu:
> Hello everybody.
> 
> First of all - this post is not meant as the flame starter, nor is it
> "I DEMAND" kind of post - I just would like to know what is the policy
> with driver patches.
> 
> I bought Medion CTX1921 USB DVB-T stick, since I saw patches for kernel 2.6.32:
> 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/19938/match=1921

Thanks for noticing it. Clearly, the last patch from Stéphane were mangled by
his emailer. Due to that, it were not caught by patchwork. He also forgot to
send us a Signed-off-by.

Yet, Alf and Randoslaw re-sent the same patch, so I dunno why this patch were
never applied, but I guess that it is because the patch become obsolete, as
more cards were added to the dib0700 driver.

> so,I thought everything above that, will support this card "out of the
> box", however I tried it on kernel 2.6.38 and it still required manual
> patching, after minor driver modification it works OK.

Thanks for pointing it to us. I've re-based the patch to move the new entry
to the end and applied it.

> 
> So... the question is, why isn't this tuner supported yet, even though
> patches were aviable nearly a year ago (and where minor)? What is the
> policy here? When can we expect support?
> 
> Thanks in advance for the answers.

Cheers,
Mauro
