Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35587 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaI1RZb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 13:25:31 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XYIDx-0005hk-6x
	for linux-media@vger.kernel.org; Sun, 28 Sep 2014 20:25:29 +0300
Message-ID: <54284488.60404@iki.fi>
Date: Sun, 28 Sep 2014 20:25:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: em28xx: Too many ISO frames scheduled when starting stream
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I want raise that bug:
Too many ISO frames scheduled when starting stream
https://bugzilla.kernel.org/show_bug.cgi?id=72891

Is there anyone who cares to study it? It looks like em28xx driver bug 
or USB host controller driver or both.

According to comments bug appeared on kernel 3.13.

Is there anyone knowing em28xx internals who wants (non surely really 
want, but hates less to start examine) to look it?

It is very near I will fork em28xx to DVB only driver and move devices 
there. Current em28xx is too complex for my taste and has had more bugs 
than any other DVB driver I have ever seen.

regards
Antti

-- 
http://palosaari.fi/
