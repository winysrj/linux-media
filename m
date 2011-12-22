Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55823 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1LVV3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 16:29:13 -0500
Received: from dyn2-212-50-134-3.psoas.suomi.net ([212.50.134.3] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1RdqCM-0001qP-Tn
	for linux-media@vger.kernel.org; Thu, 22 Dec 2011 23:29:10 +0200
Message-ID: <4EF3A126.4070805@iki.fi>
Date: Thu, 22 Dec 2011 23:29:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [RFCv1] add DTMB support for DVB API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1. I renamed it to the DTMB. I looked very many research papers and CTTB 
was very, very rare. DTMB seems to exists almost all documents even very 
recent.

2. added new values needed for the existing parameters.

3. new parameter u32 interleaving
DTMB supports 240 and 720 interleavers. I added interleaving as a 
general parameter instead of DTMB, since there could be likely be some 
other modulations too that have same param. Actually ISDB-T already 
have. Let the 0 be AUTO or N/A.

4. new parameter u32 carrier
DTMB supports two sub-carrier modes. 1, single carrier, or 3780, which 
is called multi-carrier. Same reasons applies here as for the interleaving.



Antti Palosaari (1):
   add DTMB support for DVB API

  drivers/media/dvb/dvb-core/dvb_frontend.c |   19 ++++++++++++++++++-
  drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
  include/linux/dvb/frontend.h              |   13 +++++++++++--
  include/linux/dvb/version.h               |    2 +-
  4 files changed, 33 insertions(+), 4 deletions(-)

-- 
1.7.4.4
---


-- 
http://palosaari.fi/


