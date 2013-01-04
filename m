Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51564 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3ADODM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 09:03:12 -0500
Received: from dyn3-82-128-184-254.psoas.suomi.net ([82.128.184.254] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Tr7rb-0005jX-CP
	for linux-media@vger.kernel.org; Fri, 04 Jan 2013 16:03:11 +0200
Message-ID: <50E6E0FC.7060903@iki.fi>
Date: Fri, 04 Jan 2013 16:02:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: RFC run time configuration parameter checks in subdriver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would like to discuss if there is idea to validate subdriver 
parameters explicitly at run-time when subdriver module is load.

There is configuration parameters for about every driver like:
* I2C address
* clock frequency

Nowadays, when main driver loads subdriver, it passes those static 
compile-time parameters to the subdriver, those parameters are not 
mainly validated at all. That could lead situation device is not 
working, instead it is will fail with some error, like I/O as I2C 
address is wrong.

As these parameters are set compile time, this situation affects only 
developers which are adding support for new hardware.

regards
Antti

-- 
http://palosaari.fi/
