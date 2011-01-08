Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:37560 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751459Ab1AHXtL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jan 2011 18:49:11 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: [regression] DVB cards doesn't work with 2.6.37/ current git
Date: Sun, 9 Jan 2011 00:49:09 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101090049.09160.martin.dauskardt@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I tried two things:

1.)
compile media_build.git for my 2.6.32 Ubuntu Kernel. It compiles, driver loads 
without errors.
[ 8.500109] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
[ 8.981263] DVB: registering adapter 1 frontend 0 (Philips TDA10021 DVB-C)...

But when I start vdr none of my DVB cards (Cinergy 1200C and Technotrend 
1500C)  is working. After some time vdr has 100% CPU load.

2.)
install a complete 2.6.37 Ubuntu Kernel. Same result as above

An Ubuntu 2.6.36-Kernel is working.

???
