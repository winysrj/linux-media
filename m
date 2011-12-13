Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:45760 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab1LMNzW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 08:55:22 -0500
Message-ID: <4EE7593C.2070901@tyldum.com>
Date: Tue, 13 Dec 2011 14:55:08 +0100
From: Vidar Tyldum <vidar@tyldum.com>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Multiple Mantis devices gives me glitches
References: <4EE6FF6F.5050901@kolumbus.fi>
In-Reply-To: <4EE6FF6F.5050901@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marko Ristola, on 13.12.2011 08:31:
> Here is a patch that went into Linus GIT this year.
> It reduces the number of DMA transfer interrupts into one third.
> Linus released 2.6.38.8 doesn't seem to have this patch yet.

Thank you very much. I did see this patch mentioned in my quest for more knowledge, but was not sure of the status.

I have patched the Ubuntu 2.6.38.8 kernel for Natty and loaded the new driver. Works fine for one card at the moment, will insert the other two later this afternoon.
If this fixes my problem, how to proceed in getting the patch accepted as soon as possible? By me filing an official bug?

I'll do some stress testing by employing all adapters at once through VDR and look for any problems caused or fixed by the patch.

-- 
Vidar Tyldum
                              vidar@tyldum.com               PGP: 0x3110AA98
