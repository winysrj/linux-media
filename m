Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50025 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1EVDLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 23:11:33 -0400
Received: by eyx24 with SMTP id 24so1496517eyx.19
        for <linux-media@vger.kernel.org>; Sat, 21 May 2011 20:11:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimQGYqS=PRNJSEtL5Wu0rP3YdEOVg@mail.gmail.com>
References: <BANLkTin=Fs-ugm13yT89PtT4bds4WobszA@mail.gmail.com>
	<BANLkTi=poXh2q+4N6Q9iMJxoW=9txLjt4w@mail.gmail.com>
	<BANLkTimQGYqS=PRNJSEtL5Wu0rP3YdEOVg@mail.gmail.com>
Date: Sat, 21 May 2011 23:11:31 -0400
Message-ID: <BANLkTimOUFgBKx5Y4VE+v08SMVB+Ms5RBg@mail.gmail.com>
Subject: Re: Connexant cx25821 help
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Roman Gaufman <hackeron@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, May 21, 2011 at 10:25 PM, Roman Gaufman <hackeron@gmail.com> wrote:
> I figured as much, but what can I do now?

Your options at this point are:

1.  Find some developer who cares enough to take a free board just for
the fun of making it work.
2.  If you're a commercial entity, hire somebody to do the work
(Kernel Labs does this sort of work)
3.  Learn enough about driver development to add the support yourself.

The reality is that the LinuxTV project is grossly understaffed
already, and if you're a regular user who wants a working product,
your best bet is to just buy something that is already supported.  All
other options require either a considerable investment in money (to
pay someone to do the work), or time (to learn how to do it yourself).

Developers who care enough to contribute to the project typically have
no shortage of boards at their disposal, and they tend to focus their
energy on where you get the most bang for the buck.  This tends to
favor products that are more popular, which is why the cx25821 driver
has gotten almost zero attention (since there are almost no actual
products using it other than Conexant reference designs).

> Should I take some high resolution pictures of the board?
> Any other details I can provide to help developers add support for this board?
> Is there anyone in particularly I should contact?
> Anywhere I can post any information I collect on this board?

You can create an entry on the LinuxTV wiki with the board details.
Of course no guarantee that anybody will do anything with it (in fact,
the less popular the board, the less likely for this to be the case).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
