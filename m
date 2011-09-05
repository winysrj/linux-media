Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56164 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1IEWjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 18:39:19 -0400
Received: from [82.128.187.213] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1R0hox-0004ci-Mq
	for linux-media@vger.kernel.org; Tue, 06 Sep 2011 01:39:15 +0300
Message-ID: <4E654F93.9060506@iki.fi>
Date: Tue, 06 Sep 2011 01:39:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: checkpatch.pl WARNING: Do not use whitespace before Signed-off-by:
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am almost sure this have been working earlier, but now it seems like 
nothing is acceptable for checkpatch.pl! I did surely about 20 --amend 
and tried to remove everything, without luck. Could someone point out 
whats new acceptable logging format for checkpatch.pl ?

[crope@localhost linux]$ git show 
1b19e42952963ae2a09a655f487de15b7c81c5b7 |./scripts/checkpatch.pl -
WARNING: Do not use whitespace before Signed-off-by:
#10:
     Signed-off-by: Joe Perches <joe@perches.com>

WARNING: Do not use whitespace before Signed-off-by:
#11:
     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

total: 0 errors, 2 warnings, 48 lines checked

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


Antti
-- 
http://palosaari.fi/
