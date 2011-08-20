Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49393 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1HTUxW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 16:53:22 -0400
Received: from [82.128.187.213] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1QusXg-0002Eg-17
	for linux-media@vger.kernel.org; Sat, 20 Aug 2011 23:53:20 +0300
Message-ID: <4E501EBF.2090400@iki.fi>
Date: Sat, 20 Aug 2011 23:53:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: flag DVB_CA_EN50221_POLL_CAM_READY
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Why this flag is defined?

I don't see how interface driver can know CAM is ready (after plug or
reset) unless it reads that info from CAM itself. Thus, I think correct
behaviour should be move that detection functionality to the EN50221 CA
core.

Looking from existing drivers can confirm that. Those just returns that
flag when CAM is present (plugged in slot) with
DVB_CA_EN50221_POLL_CAM_PRESENT flag. OR read directly CAM memory to see
it answers and set flag according to that (which should be job of
EN50221 CA core IMHO).

regards
Antti
-- 
http://palosaari.fi/
