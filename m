Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm10.bullet.mail.ird.yahoo.com ([77.238.189.39]:45653 "HELO
	nm10.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751931Ab2HNXji convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 19:39:38 -0400
Message-ID: <1344987576.21425.YahooMailClassic@web29406.mail.ird.yahoo.com>
Date: Wed, 15 Aug 2012 00:39:36 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: small regression in mediatree/for_v3.7-3 - media_build
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There seems to be a small regression on mediatree/for_v3.7-3
- dmesg/klog get flooded with these:

[201145.140260] dvb_frontend_poll: 15 callbacks suppressed
[201145.586405] usb_urb_complete: 88 callbacks suppressed
[201150.587308] usb_urb_complete: 3456 callbacks suppressed

[201468.630197] usb_urb_complete: 3315 callbacks suppressed
[201473.632978] usb_urb_complete: 3529 callbacks suppressed
[201478.635400] usb_urb_complete: 3574 callbacks suppressed

It seems to be every 5 seconds, but I think that's just klog skipping repeats and collapsing duplicate entries. This does not happen the last time I tried playing with the TV stick :-).
