Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41469 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaLVNZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 08:25:58 -0500
Date: Mon, 22 Dec 2014 11:25:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
Message-ID: <20141222112550.5f5e80c7@concha.lan.sisa.samsung.com>
In-Reply-To: <54972866.3030101@gentoo.org>
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
	<54972866.3030101@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 21 Dec 2014 21:07:02 +0100
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> Hi!
> 
> Should the commit message directly point to the breaking commit
> 36efec48e2e6016e05364906720a0ec350a5d768?

Yes, if this fixes an issue that happened on a previous commit, then
you should add the original commit there.

That likely means that this is a regression fix, right? So, you should
c/c the patch to stable, adding a comment msg telling to what Kernel
version it applies (assuming that the patch was merged on 3.18).
Also, please add "PATCH FIX" to the subject, as this patch should be
sent to 3.19 as well.

> 
> This commit hopefully reverts the problematic attach for the Starburst
> card. I kept the GPIO-part in common, but I can split this also if
> necessary.

Keep the GPIO part in common is better, if the GPIOs are the same.
> 
> Regards
> Matthias
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
