Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:42722 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZGJPQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 11:16:07 -0400
Received: by yxe14 with SMTP id 14so828530yxe.33
        for <linux-media@vger.kernel.org>; Fri, 10 Jul 2009 08:16:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A572F7E.6010701@iki.fi>
References: <4A4481AC.4050302@powercraft.nl> <4A4D34B3.8050605@iki.fi>
	 <4A4E2B45.8080607@powercraft.nl>
	 <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>
	 <4A572F7E.6010701@iki.fi>
Date: Fri, 10 Jul 2009 11:16:05 -0400
Message-ID: <829197380907100816o4a3daa22k78a424da5bebed1e@mail.gmail.com>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 10, 2009 at 8:09 AM, Antti Palosaari<crope@iki.fi> wrote:
> af9013 is correct in my mind. af9013 will return -EINVAL (error invalid
> value) in case of first garbage value met (maybe better to switch auto mode
> when garbage value meet and print debug log?).
>
> Of course there should be at least debug printing to inform that... but fix
> you suggest is better for compatibility. You can do that, it is ok for me.

>From a purist standpoint, I agree that the application at fault, and
if it were some no-name application I would just say "fix the broken
application".  Except it's not a no-name application - it's mplayer.

Are you familiar with Postel's Law?

http://en.wikipedia.org/wiki/Postel%27s_Law

Saying "this demod is not going to work properly with all versions of
one of the most popular applications", especially when other demods
handle the condition gracefully, is the sort of thing that causes real
problems for the Linux community.

I'm not the maintainer for this demod, so I'm not the best person to
make such a fix.  I spent four hours and debugged the issue as a favor
to Jelle de Jong since he loaned me some hardware a couple of months
ago.  I guess I can make the fix, but it's just going to take away
from time better spent on things I am more qualified to work on.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
