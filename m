Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53785 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbbKLRU1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 12:20:27 -0500
Date: Thu, 12 Nov 2015 15:20:22 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Alberto Mardegan <mardy@users.sourceforge.net>
Cc: linux-media@vger.kernel.org
Subject: Re:
Message-ID: <20151112152022.4f212b97@recife.lan>
In-Reply-To: <5644AD42.4060904@users.sourceforge.net>
References: <CABUpJt8ofQphD47-sVYmVjSbqJ91vEDyZk_hdnhc_RL+f95iog@mail.gmail.com>
	<5644AD42.4060904@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 12 Nov 2015 18:16:18 +0300
Alberto Mardegan <mardy@users.sourceforge.net> escreveu:

> On 11/12/2015 06:25 AM, Walter Cheuk wrote:
> > I sent a patch named "[PATCH] tv tuner max2165 driver: extend
> > frequency range" two weeks ago (22/10). Is it being reviewed? Thank
> > you.
> 
> Since such reminders seem to help, I also sent a patch on 27/10:
> "[PATCH] [media] em28xx: add Terratec Cinergy T XS (MT2060)"
> 
> It's not urgent, given that people have been surviving without support 
> for this device for years, but I'd just like to make sure that it won't 
> be forgotten.

Complaining doesn't help at all. We don't read the mailing list to
check for new patches. Instead, we look for them at:
	https://patchwork.linuxtv.org/project/linux-media/list/

All patches that goes to the ML are automatically stored there, and will be
handled by one of the (sub-)maintainers.

If your patch is stored there, you only need to worry when you receive
an status update. If accepted, it will soon be on my tree. Otherwise,
some action would likely be required from you, and you should likely
have received some e-mail from the (sub-)maintainer that reviewed your
patch with further instructions (except when the issue was already
fixed by some other patch).

However, if the emailer breaks the patch (with was the case of the
"tv tuner max2165..." patch), patchwork won't recognize it as a
patch, and we'll only see the e-mail by accident.

In the case of the em28xx patch, it is there:
	https://patchwork.linuxtv.org/project/linux-media/list/?submitter=Alberto

So, we'll handle it.

Regards,
Mauro
