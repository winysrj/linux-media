Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab3DZO0K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 10:26:10 -0400
Date: Fri, 26 Apr 2013 11:25:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jon Arne =?UTF-8?B?SsO4cmdlbnNlbg==?= <jonarne@jonarne.no>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/2] saa7115: add detection code for gm7113c
Message-ID: <20130426112559.7d642984@redhat.com>
In-Reply-To: <20130426134621.GC20185@localhost>
References: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
	<20130426134621.GC20185@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Apr 2013 10:46:22 -0300
Ezequiel Garcia <ezequiel.garcia@free-electrons.com> escreveu:

> Hi Mauro,
> 
> Thanks for the patch!
> 
> On Fri, Apr 26, 2013 at 09:49:15AM -0300, Mauro Carvalho Chehab wrote:
> > 
> > I didn't add there the part of your code with the gm7113c specifics,
> > as I prefer if you can rebase your patch on the top of those two,
> > of course assuming that they'll work.
> > 
> > Patches weren't test yet.
> > 
> > Jen/Ezequiel,
> > 
> > Could you please test them?
> > 
> 
> I've done some quick testing on stk1160+saa7113 and also stk1160+gm7113c,
> everything looks OK (except from the minor misname comment, see the patch 2/2).

Thanks for testing and for the comments.

Just respin a v2 fixing the pointed minor pitnicks.

> Let me do some more testing just to be sure.

Ok. I don't intend to merge it without Jon's patches.

> @Jon: Do you mind sending the standard fix for gm7113c? We need those
> to make stk1160+gm7113c work. I'll put my Tested-by so we can merge it!
> 
> FWIW, some user reported he didn't need those quirks to capture a PAL (?)
> source. But in my experience, I *do* need them, otherwise I get a noisy
> PAL-Nc output and no video capture at all on NTSC/PAL-M.
> 
> Thanks a lot for the good work!

Regards,
Mauro
