Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:58513 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab1ENOaG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 10:30:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QLFr2-00036x-Gs
	for linux-media@vger.kernel.org; Sat, 14 May 2011 16:30:04 +0200
Received: from p57a82a0a.dip.t-dialin.net ([87.168.42.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 14 May 2011 16:30:04 +0200
Received: from o.freyermuth by p57a82a0a.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 14 May 2011 16:30:04 +0200
To: linux-media@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: az6027: Terratec S7 has no signal on S2-transponders
Date: Sat, 14 May 2011 16:26:08 +0200
Message-ID: <iqm3e1$5cg$2@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

I use a Terratec S7 MKII with dvb_usb_az6027. DVB-S channels are working
fine, but when trying to lock on DVB-S2 channels, the signal level drops
to zero.

Google and Windows told me this problem is not limited to me, and trying
out s2-liplianin, in-kernel drivers of 2.6.38 and media-build.git did
not help.

As I have this hardware and C-knowledge here, I offer any help that
might be needed in tracking down the problem. If there is something like
an USB-trace/-sniffing to do (device works fine in Windows-VM), a "RTFM"
with an URL would be fine.

Furthermore, scanning Astra S19E2 takes ~90min with w_scan, as compared
to 3-5min on Windows, so there appears to be also some problem
tuning-related for DVB-S.

-----
If this is the wrong place to ask, please ignore the message and direct
me somewhere else.
-----

All help is very much appreciated!

Thx

