Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40309 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab2ITBQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 21:16:31 -0400
Message-ID: <505A6E5A.4010707@iki.fi>
Date: Thu, 20 Sep 2012 04:16:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: em28xx + drx-k fw download crash Kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found again that em28xx driver is crashing. I suspect it is bug in 
DRX-K firmware downloading. It crashed two times. When it did not crash, 
there was very often I2C communication failure towards tda18271 tuner 
that is behind of drx-k. That makes PCTV 520e device unusable. It seems 
to work fine when I comment out firmware and the chip internal firmware 
is used.

I am not sure if it is really DRX-K issue as em28xx has also quite long 
history of this kind of bugs. It is still suspect number one as I see 
some drx-k fw routine names printed to crash dump.

Here is two different oops pictures:
http://palosaari.fi/linux/v4l-dvb/em28xx_drxk_crash/


regards
Antti

-- 
http://palosaari.fi/
