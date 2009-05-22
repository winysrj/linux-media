Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:58020 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbZEVVse (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 17:48:34 -0400
Message-ID: <4A1719DE.4060009@unsolicited.net>
Date: Fri, 22 May 2009 22:32:14 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked down
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I reported this DVB-S card breaking between 2.6.26 and 2.6.27. I've
finally had time to do some digging, and the regression is caused by:

    b963801164618e25fbdc0cd452ce49c3628b46c8 USB: ehci-hcd unlink speedups

..that was introduced in 2.6.27. Reverting this change in 2.6.29-rc5
makes the card work happily again.

I don't know enough about USB protocols to speculate on whether there
may be a better fix, but hopefully someone cleverer than me can get to
the bottom of the problem?

Cheers
David



