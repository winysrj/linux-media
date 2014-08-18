Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:43463 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaHRHN2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 03:13:28 -0400
Received: from [IPv6:2a02:8109:9f00:1a1c:beae:c5ff:fe2c:b8a3] ([2a02:8109:9f00:1a1c:beae:c5ff:fe2c:b8a3])
	by smtp.strato.de (RZmta 35.8 AUTH)
	with ESMTPSA id N012d2q7I77DHyr
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-media@vger.kernel.org>;
	Mon, 18 Aug 2014 09:07:13 +0200 (CEST)
Message-ID: <53F1A621.7050409@stefanringel.de>
Date: Mon, 18 Aug 2014 09:07:13 +0200
From: Stefan Ringel <linuxtv@stefanringel.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dtv-scan-tables dvbv5 tables
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i have problems dtv-scan-tables dvbv5 part.

1. better a new subdirectory to equalant to dvb (i.e. dvbv5)
2. the block names must add a index number (format BerlinX -> X is a 
number, i.e. first block: Berlin1, second block: Berlin2 etc. not first 
block: Berlin, second block: Berlin), because software can have problems 
by reading edge block (seeing only the first block or using setting from 
the next block), all setting must add to edge block (incl. auto-setting 
parameters)
