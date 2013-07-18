Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51263 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab3GRBlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 21:41:55 -0400
Received: by mail-wg0-f49.google.com with SMTP id a12so2352330wgh.28
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 18:41:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA9z4LbZQ6k9cA5WziczvbSAqOjDnTt12hf+JKLKf3B2u2cERA@mail.gmail.com>
References: <CAA9z4LbZQ6k9cA5WziczvbSAqOjDnTt12hf+JKLKf3B2u2cERA@mail.gmail.com>
Date: Wed, 17 Jul 2013 21:41:54 -0400
Message-ID: <CAGoCfiz44NQyzp4u7oQTCFTrp-pWJVp1kfgJkGU3scr7q=-azQ@mail.gmail.com>
Subject: Re: [PATCH] au8522_dig: fix snr lookup table
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Lee <updatelee@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 17, 2013 at 8:30 PM, Chris Lee <updatelee@gmail.com> wrote:
> This patch fixes an if() statement that was preventing the last
> element in the table from ever being utilized, preventing the snr from
> ever displaying 27db. Also some of the gaps in the lookup table were
> filled in.
>
> Signed-off-by: Chris Lee <updatelee@gmail.com>

I don't have any specific objection to this patch, other than that I
have no idea if the values he's adding are actually correct.  I'd have
to pull out the datasheet and see what the formula looks like to
actually calculate the correct values.

This is of course assuming Chris didn't have the formula and just
picked numbers that were roughly in between the adjacent values.

The off-by-one is legit (syntactically at least - there is indeed no
value that would result in 0 being selected), although frankly I don't
know whether value 0 is supposed to be 26.0 or 27.0.  It's entirely
possible that 0=26.0 and the whole table is off by one value (this was
actually the case with the QAM256 table, except in that case it was
much worse because it was oscillating between 40.0 and 0.00).

Anyway, hard to argue this isn't an improvement and thus shouldn't be
accepted -- except for the real possibility that the patch introduces
wrong values into the table.

Acked-by:  Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
