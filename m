Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57217 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab3HTJjB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 05:39:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VBiOx-00069P-HN
	for linux-media@vger.kernel.org; Tue, 20 Aug 2013 11:38:59 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 20 Aug 2013 11:38:59 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 20 Aug 2013 11:38:59 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: OMAP3 ISP DQBUF hangs
Date: Tue, 20 Aug 2013 09:38:41 +0000 (UTC)
Message-ID: <loom.20130820T113209-509@post.gmane.org>
References: <loom.20130815T161444-925@post.gmane.org> <CALxrGmX2aZsTGG_gM6EECLa1Y9vWgWNqEg_TFoXFr=gVmsJnvw@mail.gmail.com> <loom.20130819T160758-83@post.gmane.org> <CALxrGmWE0G91KSwUysZ+Vz4807ihc9hbPDJqbjoPE4z2YEAN_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Su Jiaquan <jiaquan.lnx <at> gmail.com> writes:

Hello,

> 
> Hi Tom
> 
> 
> Well, for our practice, we QBUF before STREAMON (not on omap3 isp).
> You can try that and see what happens.
> 
> As I check the omap3 code, you sequence maybe OK. Coz there is a
> restart mechanism in the code to restart CCDC hardware after buffer
> underrun. But for you sequence, if the interrupt comes before you
> QBUF, then the hardware is running in underrun state ever from the
> STREAMON. Not sure the restart mechanism works in this scenario. Let's
> wait for answers from the professional 
> 
> Jiaquan
> 

Thanks for your reply. The hang is solved. You were right. Now I do QBUF ->
STREAMON -> DQBUF -> STREAMOFF.

My new Problem is that I receive a black image, but I think I do a new post
with the appropriate subject.

Best Regrads, Tom 

