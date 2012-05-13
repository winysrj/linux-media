Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56366 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2EMA36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 20:29:58 -0400
Received: by obbtb18 with SMTP id tb18so5307207obb.19
        for <linux-media@vger.kernel.org>; Sat, 12 May 2012 17:29:57 -0700 (PDT)
Message-ID: <1336868991.13856.22.camel@dcky-ubuntu64>
Subject: Re: How I must report that a driver has been broken?
From: Patrick Dickey <pdickeybeta@gmail.com>
Reply-To: pdickeybeta@gmail.com
To: Alfredo =?ISO-8859-1?Q?Jes=FAs?= Delaiti
	<alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Date: Sat, 12 May 2012 19:29:51 -0500
In-Reply-To: <4FAEB948.7080800@netscape.net>
References: <4FADE682.3090005@netscape.net> <4FAE1CA1.1010203@redhat.com>
	 <4FAEB948.7080800@netscape.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm not an expert (or anywhere near one), but I'm guessing that the
reason you didn't get a response to your two previous (actually three or
four previous) emails is because you "submitted" a patch that was
already in the kernel.

You were intending to show that the patch breaks something, yet instead
of submitting the fix for the problem, you resubmitted the patch that
was already applied.  Either that, or for some other reason, the patch
that you submitted was rejected.

My suggestion is to take what you've submitted (if it was the fix for
the problem) and resubmit it. If you were just pointing out the broken
code, then submit your fix for the issue (by creating a patch that fixes
or removes the broken code).

Also one other thing I found is that you submitted the original patches
for the card.  Or at least you submitted some patches for it around
November of last year. So my question is, do the patches that you
submitted back then work, or are they the broken code now?

Have a great day:)
Patrick.

P.S. Again, I'm not an expert here, nor do I claim to be. So if someone
else gives you an answer, I'd put more weight on theirs--as they
probably have more experience than I do.


On Sat, 2012-05-12 at 16:26 -0300, Alfredo Jesús Delaiti wrote: 
> Hi
> 
> Thanks for your response Hans and Patrick
> 
> Maybe I doing wrong this, because it reports twice:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg45199.html
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44846.html
> 
> and I have not had any response.
> 
> 
> Thanks again,
> 
> Alfredo
> 
> 
> 
> 
> 
> El 12/05/12 05:17, Hans de Goede escribió:
> > Hi
> >
> > On 05/12/2012 06:26 AM, Alfredo Jesús Delaiti wrote:
> >> Hi
> >>
> >> New features of the driver has left a card does not work.
> >> How I must report that a driver has been broken?
> >
> > Well this list would be a good place for starters, please
> > send a *detailed* bug report to this list, including
> > things like what is the last (kernel) version it worked
> > with, what is the first version it is broken.
> >
> > What did it do before breaking what know now longer works,
> > etc.
> >
> > Regards,
> >
> > Hans
> 
> 

