Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55849 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0CDIZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Mar 2010 03:25:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nn6Mi-00020r-1C
	for linux-media@vger.kernel.org; Thu, 04 Mar 2010 09:25:04 +0100
Received: from q65.ip3.netikka.fi ([85.157.68.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 04 Mar 2010 09:25:04 +0100
Received: from perlun by q65.ip3.netikka.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 04 Mar 2010 09:25:04 +0100
To: linux-media@vger.kernel.org
From: Per Lundberg <perlun@gmail.com>
Subject: TBS 6980 Dual DVB-S2 PCIe card
Date: Thu, 4 Mar 2010 08:19:14 +0000 (UTC)
Message-ID: <loom.20100304T091408-554@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I read the old thread about this card, at
http://www.mail-archive.com/linux-media@vger.kernel.org/msg12753.html. I've also
tried downloading the vendor-provided drivers from
http://www.buydvb.net/download2/TBS6980/tbs6980linuxdriver2.6.32.rar

As someone has already indicated, it seems like TBS (TurboSight) have made their
own fork of v4l where the drivers for this card is included. I've also
understood that the card works fine, which is nice (I down own it yet but am
considering getting one).

Has anyone done any attempt at contacting TBS to see if they can release their
changes under the GPLv2? Ideally, they would provide a patch themselves, but it
should be fairly simple to diff the linux/ trees from their provided
linux-s2api-tbs6980.tar.bz2 file with the stock Linux 2.6.32 code... in fact, it
could be that their patch is so trivial that we could just include it in the
stock Linux kernel without asking them for license clarifications... but
obviously, if we can get a green sign from them, it would be even better.
--
Best regards,
Per Lundberg

