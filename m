Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40504 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab2GITQs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 15:16:48 -0400
Received: from dyn3-82-128-190-162.psoas.suomi.net ([82.128.190.162] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SoJRv-0001Iu-HV
	for linux-media@vger.kernel.org; Mon, 09 Jul 2012 22:16:47 +0300
Message-ID: <4FFB2E18.5020908@iki.fi>
Date: Mon, 09 Jul 2012 22:16:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: dvb_usb_pctv452e driver problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am looking problems with that driver. It is said to be buggy after 
merged to mainline Kernel.

It supports three different devices:
PCTV HDTV USB
Technotrend TT Connect S2-3600
Technotrend TT Connect S2-3650-CI

All reports are welcome even when it is working as expected.

In problem case I would like to ask if you could test that tree and 
report if it helps:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e

regards
Antti

-- 
http://palosaari.fi/

