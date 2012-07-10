Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57332 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab2GJQUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 12:20:23 -0400
Received: from dyn3-82-128-190-162.psoas.suomi.net ([82.128.190.162] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SodAj-0006QO-JY
	for linux-media@vger.kernel.org; Tue, 10 Jul 2012 19:20:21 +0300
Message-ID: <4FFC563E.4070501@iki.fi>
Date: Tue, 10 Jul 2012 19:20:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: comments for DVB LNA API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am looking how to implement LNA support for the DVB API.

What we need to be configurable at least is: OFF, ON, AUTO.

There is LNAs that support variable gain and likely those will be sooner 
or later. Actually I think there is already LNAs integrated to the 
RF-tuner that offers adjustable gain. Also looking to NXP catalog and 
you will see there is digital TV LNAs with adjustable gain.

Coming from that requirements are:
adjustable gain 0-xxx dB
LNA OFF
LNA ON
LNA AUTO

Setting LNA is easy but how to query capabilities of supported LNA 
values? eg. this device has LNA which supports Gain=5dB, Gain=8dB, LNA auto?

LNA ON (bypass) could be replaced with Gain=0 and LNA ON with Gain>0, 
Gain=-1 is for auto example.



regards
Antti

-- 
http://palosaari.fi/

