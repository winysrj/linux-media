Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36062 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3GRB6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 21:58:52 -0400
Received: by mail-wi0-f181.google.com with SMTP id hq4so2658408wib.8
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 18:58:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
References: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
Date: Wed, 17 Jul 2013 21:58:51 -0400
Message-ID: <CAGoCfizDcOPKiCo54rsoZJyXU3m-_v8jE0aTagxTyjB3QZrZXg@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Fix interrupt storm that happens in some cards
 when IR is enabled.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Luis Alves <ljalvs@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org, crope@iki.fi,
	awalls@md.metrocast.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 17, 2013 at 9:33 PM, Luis Alves <ljalvs@gmail.com> wrote:
> Hi,
>
> This i2c init should stop the interrupt storm that happens in some cards when the IR receiver in enabled.
> It works perfectly in my TBS6981.

What is at I2C address 0x4c?  Might be useful to have a comment in
there explaining what this patch actually does.  This assumes you
know/understand what it does - if you don't then a comment saying "I
don't know why this is needed but my board doesn't work right without
it" is just as valuable.

> It would be good to test in other problematic cards.
>
> In this patch I've added the IR init to the TeVii S470/S471 (and some others that fall in the same case statment).
> Other cards but these that suffer the same issue should also be tested.

Without fully understanding the nature of this patch and what cards
that it actually effects, it may make sense to move your board into a
separate case statement.  Generally it's bad form to make changes like
against other cards without any testing against those cards (otherwise
you can introduce regressions).  Stick it in its own case statement,
and users of the other boards can move their cards into that case
statement *after* it's actually validated.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
