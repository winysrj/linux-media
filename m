Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45541 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbaICKNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 06:13:38 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XP7ZG-0005p4-5Z
	for linux-media@vger.kernel.org; Wed, 03 Sep 2014 13:13:34 +0300
Message-ID: <5406E9CC.8060907@iki.fi>
Date: Wed, 03 Sep 2014 13:13:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.18] m88ts2022 changes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6c1c423a54b5b3a6c9c9561c7ef32aee0fda7253:

   [media] vivid: comment the unused g_edid/s_edid functions (2014-09-02 
18:01:05 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git dtv_misc_3.18v2

for you to fetch changes up to b4e20e50dbf37d1ebbed11e40810b09756dd0404:

   m88ts2022: change parameter type of m88ts2022_cmd (2014-09-03 
13:06:44 +0300)

----------------------------------------------------------------
Antti Palosaari (4):
       m88ts2022: rename device state (priv => dev)
       m88ts2022: clean up logging
       m88ts2022: convert to RegMap I2C API
       m88ts2022: change parameter type of m88ts2022_cmd

  drivers/media/tuners/Kconfig          |   1 +
  drivers/media/tuners/m88ts2022.c      | 347 
+++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------
  drivers/media/tuners/m88ts2022_priv.h |   5 +-
  3 files changed, 126 insertions(+), 227 deletions(-)

-- 
http://palosaari.fi/
