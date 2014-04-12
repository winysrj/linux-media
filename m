Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43312 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaDLFU1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 01:20:27 -0400
Received: from dyn3-82-128-185-186.psoas.suomi.net ([82.128.185.186] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WYqMb-0001fE-4d
	for linux-media@vger.kernel.org; Sat, 12 Apr 2014 08:20:25 +0300
Message-ID: <5348CD18.6030004@iki.fi>
Date: Sat, 12 Apr 2014 08:20:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL stable] fc2580: fix tuning failure on 32-bit arch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:

   [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 
08:02:16 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git fc2580_32bit_calc_overflow

for you to fetch changes up to b9a87259efe859447ea6bf6dfa90cd70ee0b947f:

   fc2580: fix tuning failure on 32-bit arch (2014-04-11 22:56:55 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       fc2580: fix tuning failure on 32-bit arch

  drivers/media/tuners/fc2580.c      | 6 +++---
  drivers/media/tuners/fc2580_priv.h | 1 +
  2 files changed, 4 insertions(+), 3 deletions(-)

-- 
http://palosaari.fi/
