Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55639 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256AbaHYR4u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:56:50 -0400
Received: from 85-23-164-39.bb.dnainternet.fi ([85.23.164.39] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XLyVc-0000nS-Pn
	for linux-media@vger.kernel.org; Mon, 25 Aug 2014 20:56:48 +0300
Message-ID: <53FB78E0.4020403@iki.fi>
Date: Mon, 25 Aug 2014 20:56:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Video4Linux GNU Radio plugin (gr-linuxsdr)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
For those who wants to play with Linux kernel SDR, here is GNU Radio 
plugin for it:
http://git.linuxtv.org/cgit.cgi/anttip/gr-linuxsdr.git/

It was earlier named as a gr-kernel, but I decided to rename it gr-linuxsdr.

My next plan is to implement library to cover kernel API and stream 
conversions, like libv4l2 does for webcams.

regards
Antti

-- 
http://palosaari.fi/
