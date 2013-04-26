Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:37319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab3DZNqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 09:46:30 -0400
Date: Fri, 26 Apr 2013 10:46:22 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/2] saa7115: add detection code for gm7113c
Message-ID: <20130426134621.GC20185@localhost>
References: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch!

On Fri, Apr 26, 2013 at 09:49:15AM -0300, Mauro Carvalho Chehab wrote:
> 
> I didn't add there the part of your code with the gm7113c specifics,
> as I prefer if you can rebase your patch on the top of those two,
> of course assuming that they'll work.
> 
> Patches weren't test yet.
> 
> Jen/Ezequiel,
> 
> Could you please test them?
> 

I've done some quick testing on stk1160+saa7113 and also stk1160+gm7113c,
everything looks OK (except from the minor misname comment, see the patch 2/2).

Let me do some more testing just to be sure.

@Jon: Do you mind sending the standard fix for gm7113c? We need those
to make stk1160+gm7113c work. I'll put my Tested-by so we can merge it!

FWIW, some user reported he didn't need those quirks to capture a PAL (?)
source. But in my experience, I *do* need them, otherwise I get a noisy
PAL-Nc output and no video capture at all on NTSC/PAL-M.

Thanks a lot for the good work!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
