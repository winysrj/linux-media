Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39377 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab0GIM0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jul 2010 08:26:48 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OXCfE-0006Np-LM
	for linux-media@vger.kernel.org; Fri, 09 Jul 2010 14:26:44 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 14:26:44 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 14:26:44 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] Mantis DMA transfer cleanup, fixes data corruption and a race, improves performance. (signed-off this time)
Date: Fri, 09 Jul 2010 14:26:33 +0200
Message-ID: <87tyo8u9hi.fsf@nemi.mork.no>
References: <4C360E10.3070002@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marko Ristola <marko.ristola@kolumbus.fi> writes:

> This is a resend of the exactly same patch
> than I sent 2010-06-20, to sign off it.
>
> Signed-off-by: Marko M Ristola <marko.ristola@kolumbus.fi>

I have successfully used this patch with a "Terratec Cinergy C PCI HD"
since Marko posted it on 2010-06-20.  My impression is that it does
improve driver stability, although I do not have any hard numbers to
support that.

Anyway, if it helps review, feel free to add

Tested-by: Bjørn Mork <bjorn@mork.no>

to the patch.


BTW, I have imported this patch in a local git repository for my own
use, together with a few other mantis patches currently under review.
Please let me know if any of you would want to pull from there to make
the process easier.  The repository is currently based on 
git://linuxtv.org/v4l-dvb.git devel/for_v2.6.36


Bjørn

