Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56726 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab1IIAVF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Sep 2011 20:21:05 -0400
Received: from [82.128.187.213] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1R1hYe-0004Xk-Mq
	for linux-media@vger.kernel.org; Thu, 08 Sep 2011 19:34:32 +0300
Message-ID: <4E68EE98.90201@iki.fi>
Date: Thu, 08 Sep 2011 19:34:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: recursive locking problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am working with AF9015 I2C-adapter lock. I need lock I2C-bus since 
there is two tuners having same I2C address on same bus, demod I2C gate 
is used to select correct tuner.

I am trapping demod .i2c_gate_ctrl() calls and locking bus according to 
that.

Is there any lock can do recursive locking but unlock frees all locks?

Like that:
gate_open
+gate_open
+gate_close
== lock is free

AFAIK mutex can do only simple lock() + unlock(). Semaphore can do 
recursive locking, like lock() + lock() + unlock() + unlock(). But how I 
can do lock() + lock() + unlock() == free.


Antti
-- 
http://palosaari.fi/
