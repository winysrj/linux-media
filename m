Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45810 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaLJKGg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 05:06:36 -0500
Received: from dyn3-82-128-190-178.psoas.suomi.net ([82.128.190.178] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XyeAE-0008Qj-Cc
	for linux-media@vger.kernel.org; Wed, 10 Dec 2014 12:06:34 +0200
Message-ID: <54881B2A.5070700@iki.fi>
Date: Wed, 10 Dec 2014 12:06:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] SiLabs improvements
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are mostly small improvements, having very small functionality 
changes.

regards
Antti

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

   [media] mn88473: One function call less in mn88473_init() after error 
(2014-12-04 16:00:47 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git

for you to fetch changes up to ade964f4a620194de8ae5c6f0719dd2ae7681b96:

   si2157: change firmware variable name and type (2014-12-06 23:32:14 
+0200)

----------------------------------------------------------------
Antti Palosaari (22):
       si2168: define symbol rate limits
       si2168: rename device state variable from 's' to 'dev'
       si2168: carry pointer to client instead of state
       si2168: get rid of own struct i2c_client pointer
       si2168: simplify si2168_cmd_execute() error path
       si2168: rename few things
       si2168: change firmware version print from debug to info
       si2168: change stream id debug log formatter
       si2168: add own goto label for kzalloc failure
       si2168: enhance firmware download routine
       si2168: remove unneeded fw variable initialization
       si2168: print chip version
       si2168: change firmware variable name and type
       si2157: rename device state variable from 's' to 'dev'
       si2157: simplify si2157_cmd_execute() error path
       si2157: carry pointer to client instead of state in tuner_priv
       si2157: change firmware download error handling
       si2157: trivial ID table changes
       si2157: add own goto label for kfree() on probe error
       si2157: print firmware version
       si2157: print chip version
       si2157: change firmware variable name and type

  drivers/media/dvb-frontends/si2168.c      | 308 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------------------
  drivers/media/dvb-frontends/si2168.h      |   6 ++--
  drivers/media/dvb-frontends/si2168_priv.h |   3 +-
  drivers/media/tuners/si2157.c             | 189 
+++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
  drivers/media/tuners/si2157_priv.h        |   3 +-
  5 files changed, 247 insertions(+), 262 deletions(-)

-- 
http://palosaari.fi/
