Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44610 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab3JNRtb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 13:49:31 -0400
Received: from dyn3-82-128-185-216.psoas.suomi.net ([82.128.185.216] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VVmGn-0004SM-KJ
	for linux-media@vger.kernel.org; Mon, 14 Oct 2013 20:49:29 +0300
Message-ID: <525C2EA9.2090008@iki.fi>
Date: Mon, 14 Oct 2013 20:49:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [RFC] general I2C RF-tuner model
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there is multiple tuner models used withing V4L and DVB, most 
notably DVB tuners, analog tuners and hybrid tuners that implements both 
internal APIs.

Now I need some more low level tuner properties for SDR usage. One 
possibility is to add new needed callbacks to analog and dvb tuners, but 
I think those drivers goes even more messy. So I have started to 
thinking idea about one genral tuner model which fits the all. Drop all 
relations to DVB and V4L API and offer just plain tuner API without any 
realtions to existings TV APIs.

What you think?

regards
Antti

-- 
http://palosaari.fi/
