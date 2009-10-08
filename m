Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39714 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbZJHT6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 15:58:46 -0400
Received: by bwz6 with SMTP id 6so1109524bwz.37
        for <linux-media@vger.kernel.org>; Thu, 08 Oct 2009 12:58:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACE41AE.7070008@pragl.cz>
References: <2D9D466571BB4CCEB9FD981D65F8FBFC@MirekPNB>
	 <829197380910080736g4b30e0e8m21f1d3b876a15ce6@mail.gmail.com>
	 <C3EF2005C0C34F008FA0B59B48782D75@MirekPNB>
	 <829197380910081204r6b8c779dsf32c61b718df77f0@mail.gmail.com>
	 <4ACE41AE.7070008@pragl.cz>
Date: Thu, 8 Oct 2009 15:58:09 -0400
Message-ID: <829197380910081258n2212a7a6wd9701688a1b05451@mail.gmail.com>
Subject: Re: Pinnace 320e (PCTV Hybrid Pro Stick) support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Miroslav Pragl - mailing lists <lists.subscriber@pragl.cz>
Cc: SebaX75 <sebax75@yahoo.it>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 8, 2009 at 3:46 PM, Miroslav Pragl - mailing lists
<lists.subscriber@pragl.cz> wrote:
> GREAT, works perfectly! Thanks a lot!
>
> MP

Yeah, that's what I figured.  However, that's not really a good long
term fix.  Basically the problem is we should hardware reset the
zl10353 when we startup in digital mode so the chip is in a known
state.  However, that same code is also being called whenever we start
streaming, which puts the demod in an inconsistent state when
performing every tuning attempt after the first one (because the
zl10353 init routine does to not get re-run after the reset).

I'll have to play with it a bit and figure out what the *correct* fix
is, but that should be good enough to get you up and running for now.

It turns up I wasn't seeing this when I did the original debugging
because I was using a DVB generator and thus my scan file only had one
entry in it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
