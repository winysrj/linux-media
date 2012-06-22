Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62931 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2FVT22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 15:28:28 -0400
Received: by obbuo13 with SMTP id uo13so2349900obb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 12:28:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE4956D.6040206@gmail.com>
References: <4FE24132.4090705@gmail.com>
	<CAGoCfixL-tEFq4SpjxChH7uc0aDZGtdoO6EqrEH3tzPzoTqK8w@mail.gmail.com>
	<4FE3A3A6.5050500@gmail.com>
	<CAGoCfiympaYxeypnq0uuX_azsHhk3OFuLu-=r0yEvOz51Eznqw@mail.gmail.com>
	<4FE4956D.6040206@gmail.com>
Date: Fri, 22 Jun 2012 15:28:27 -0400
Message-ID: <CAGoCfix-kx89NgTue_ypr=yEiXSu1SzNZHQXn0vxjo9GYKPM1A@mail.gmail.com>
Subject: Re: Chipset change for CX88_BOARD_PINNACLE_PCTV_HD_800i
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mack Stanley <mcs1937@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 22, 2012 at 11:55 AM, Mack Stanley <mcs1937@gmail.com> wrote:
> So, keeping all of the configuration settings exactly the same and
> simply using s5h1411_attach instead of s5h1409_attach works perfectly.
> Maybe the easiest path is just to have the driver try one, if it fails,
> try the other.

I actually don't have a sample of the new board, so if you wanted to
submit a patch upstream which does the following, that would be great:

1.  in cx88-dvb.c, do the dvb_attach() call against the s5h1409 just
as it was before
2.  If the dvb_attach() call returns NULL for the 1409, make the
attach call against the s5h1411.

Submit it to the linux-media mailing list to to solicit people willing
to test.  This is mostly to make sure that it doesn't break the 1409
based boards.  By doing the 1409 attach first, there is a high
likelihood that it won't cause a regression (if you did the 1411
attach first, there is greater risk that you will cause breakage for
the 1409 boards).

Be sure to include the "Signed-Off-By" line which is a requirement for
it to be accepted upstream.  I'll eyeball the patch and put a
"Reviewed-by" line on it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
