Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44355 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZKYQnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 11:43:24 -0500
Received: by fxm5 with SMTP id 5so7180343fxm.28
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 08:43:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259105973.3069.14.camel@palomino.walls.org>
References: <1257913905.28958.32.camel@palomino.walls.org>
	 <829197380911221904uedc18e5qbc9a37cfcee23b5d@mail.gmail.com>
	 <1258978370.3058.25.camel@palomino.walls.org>
	 <829197380911230909u27f6df33icbbc52c5268a1658@mail.gmail.com>
	 <1259027346.3871.76.camel@palomino.walls.org>
	 <829197380911240957t5bc93f3esb85bea7a5a12bf04@mail.gmail.com>
	 <1259105973.3069.14.camel@palomino.walls.org>
Date: Wed, 25 Nov 2009 11:43:29 -0500
Message-ID: <829197380911250843v7693ede8n26a972122f7c669c@mail.gmail.com>
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 24, 2009 at 6:39 PM, Andy Walls <awalls@radix.net> wrote:
> BTW, I did a quick skim of your cx18-alsa stuff.  I noticed two things:
>
> 1.  A memory leak in an error path:
>
> http://www.kernellabs.com/hg/~dheitmueller/hvr-1600-alsa-2/rev/cb267593943f#l85
>
>
> 2.  Technically open_id should probably be changed to an atomic type and
> atomic_inc() used:
>
> http://www.kernellabs.com/hg/~dheitmueller/hvr-1600-alsa-2/rev/cb267593943f#l80
>
> Under normal use it will likely never matter though, but perhaps someone
> could use it as a possible exploit.
>
>
>
> I'll try and give the code a good review and test sometime this weekend.
> I just wanted to let you know about those minor bugs before I forgot.

Thanks for taking the time to review.  I will make both of those
changes early next week.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
