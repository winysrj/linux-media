Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37669 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaKDBKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 20:10:17 -0500
Received: from dyn3-82-128-186-135.psoas.suomi.net ([82.128.186.135] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XlSdU-0005fg-1n
	for linux-media@vger.kernel.org; Tue, 04 Nov 2014 03:10:16 +0200
Message-ID: <54582777.5070603@iki.fi>
Date: Tue, 04 Nov 2014 03:10:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.19] AF9033 DVBv3 signal strength and SNR changes
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f4df95bcbb7b142bdb4cf201f5e1bd3985f8c804:

   [media] m88ds3103: add support for the demod of M88RS6000 (2014-11-03 
18:24:15 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9033

for you to fetch changes up to b297b9912ae771f797ad89cc0dade0e6dfcb59ef:

   af9033: continue polling unless critical IO error (2014-11-04 
03:01:56 +0200)

----------------------------------------------------------------
Antti Palosaari (4):
       af9033: fix AF9033 DVBv3 signal strength measurement
       af9033: improve read_signal_strength error handling slightly
       af9033: return 0.1 dB DVBv3 SNR for AF9030 family
       af9033: continue polling unless critical IO error

Bimow Chen (2):
       af9033: fix DVBv3 signal strength value not correct issue
       af9033: fix DVBv3 snr value not correct issue

  drivers/media/dvb-frontends/af9033.c      | 117 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
  drivers/media/dvb-frontends/af9033_priv.h |  11 ++++++++++-
  2 files changed, 116 insertions(+), 12 deletions(-)

-- 
http://palosaari.fi/
