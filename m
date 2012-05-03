Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33204 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab2ECOoH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 10:44:07 -0400
Received: from dyn2-212-50-134-8.psoas.suomi.net ([212.50.134.8] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <Antti.Palosaari@iki.fi>)
	id 1SPwrK-0003vy-GV
	for linux-media@vger.kernel.org; Thu, 03 May 2012 17:18:18 +0300
Message-ID: <4FA293AA.5000601@iki.fi>
Date: Thu, 03 May 2012 17:18:18 +0300
From: Antti Palosaari <Antti.Palosaari@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: common DVB USB issues we has currently
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
Here we are, that's the first part I am going to fix as a GSoC project. 
Work is planned to start after two weeks but better to discuss beforehand.

And wish-list is now open!

I see two big DVB USB issues including multiple small issues;

1)
Current static structure is too limited as devices are more dynamics 
nowadays. Driver should be able to probe/read from eeprom device 
configuration.

Fixing all of those means rather much work - I think new version of DVB 
USB is needed.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg44996.html


2)
Suspend/resume is not supported and crashes Kernel. I have no idea what 
is wrong here and what is needed. But as it has been long term known 
problem I suspect it is not trivial.

http://www.spinics.net/lists/linux-media/msg10293.html


regards
Antti
