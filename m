Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47839 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbcFGGnN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 02:43:13 -0400
Received: from dyn3-82-128-184-205.psoas.suomi.net ([82.128.184.205] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1bAAjG-0006K2-TS
	for linux-media@vger.kernel.org; Tue, 07 Jun 2016 09:43:10 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.8] mn88473 fixes
Message-ID: <375477f1-9d8b-901f-0ed6-ee0e1d67236d@iki.fi>
Date: Tue, 7 Jun 2016 09:43:10 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6a2cf60b3e6341a3163d3cac3f4bede126c2e894:

   Merge tag 'v4.7-rc1' into patchwork (2016-05-30 18:16:14 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mn88473

for you to fetch changes up to e8af1316e5b16fb39b8b41274e66f474cc6144fd:

   mn88473: fix typo (2016-06-07 09:08:21 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       mn88473: fix error path on probe()

Julia Lawall (1):
       mn88473: fix typo

  drivers/media/dvb-frontends/mn88473.c | 7 ++++---
  1 file changed, 4 insertions(+), 3 deletions(-)

-- 
http://palosaari.fi/
