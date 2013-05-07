Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay02.ispgateway.de ([80.67.18.44]:41340 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3EGX01 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 19:26:27 -0400
Received: from [77.10.85.141] (helo=dct.mine.nu)
	by smtprelay02.ispgateway.de with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.68)
	(envelope-from <karsten@dct.mine.nu>)
	id 1UZr3V-00035S-Sn
	for linux-media@vger.kernel.org; Wed, 08 May 2013 01:12:21 +0200
Received: from pc10 ([192.168.1.10])
	by dct.mine.nu with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <karsten@dct.mine.nu>)
	id 1UZr3N-0004Lp-2t
	for linux-media@vger.kernel.org; Wed, 08 May 2013 01:12:13 +0200
Message-ID: <51898A55.8050005@dct.mine.nu>
Date: Wed, 08 May 2013 01:12:21 +0200
From: Karsten Malcher <debian@dct.mine.nu>
Reply-To: debian@dct.mine.nu
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Support of RTL2832U+R820T
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

i want to ask how i can get the DVB-T RTL2832U with the new R820T Tuner supported?

First i found this GitHub that i could compile, but it does not support the new Tuner.
https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0

Here i found the tuner supported, but i don't know how to integrate this stuff into the driver?
http://sdr.osmocom.org/trac/wiki/rtl-sdr

Can you help?

Best Regards
Karsten
