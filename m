Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37497 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2GVT7e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jul 2012 15:59:34 -0400
Message-ID: <500C5B9B.8000303@iki.fi>
Date: Sun, 22 Jul 2012 22:59:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: tda18271 driver power consumption
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Michael,
I just realized tda18271 driver eats 160mA too much current after 
attach. This means, there is power management bug.

When I plug my nanoStick it eats total 240mA, after tda18271 sleep is 
called it eats only 80mA total which is reasonable. If I use Digital 
Devices tda18271c2dd driver it is total 110mA after attach, which is 
also quite OK.

regards
Antti


-- 
http://palosaari.fi/
