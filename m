Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39968 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393AbbERULN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 16:11:13 -0400
Received: from dyn3-82-128-184-18.psoas.suomi.net ([82.128.184.18] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1YuRNX-0005D8-ET
	for linux-media@vger.kernel.org; Mon, 18 May 2015 23:11:11 +0300
Message-ID: <555A475E.30203@iki.fi>
Date: Mon, 18 May 2015 23:11:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 4.2] e4000 changes
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 9cae84b32dd52768cf2fd2fcb214c3f570676c4b:

   [media] DocBook/media: fix syntax error (2015-05-18 16:27:31 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git e4000_pull

for you to fetch changes up to 75cc72378f9ee9dcd9ecc99edd87e795438f0455:

   e4000: implement V4L2 subdevice tuner and core ops (2015-05-18 
23:07:31 +0300)

----------------------------------------------------------------
Antti Palosaari (3):
       e4000: revise synthesizer calculation
       e4000: various small changes
       e4000: implement V4L2 subdevice tuner and core ops

  drivers/media/tuners/e4000.c      | 592 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------
  drivers/media/tuners/e4000.h      |   1 -
  drivers/media/tuners/e4000_priv.h |  11 ++--
  3 files changed, 380 insertions(+), 224 deletions(-)

-- 
http://palosaari.fi/
