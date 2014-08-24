Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41728 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbaHXRBX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Aug 2014 13:01:23 -0400
Message-ID: <53FA1A5A.8090100@iki.fi>
Date: Sun, 24 Aug 2014 20:01:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Jeff Mahoney <jeffm@suse.com>
Subject: [GIT PULL 3.17] FIX: remove SPI select from Kconfig
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, that should go to *3.17*.

Antti


The following changes since commit 1baa466e84975a595b2c3cd10af1100c807ebab5:

   [media] media: ttpci: fix av7110 build to be compatible with 
CONFIG_INPUT_EVDEV (2014-08-15 21:26:26 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git spi_kconfig

for you to fetch changes up to 4bc2dcd2937b2a05e744e8842fd16a9dce31812b:

   Kconfig: do not select SPI bus on sub-driver auto-select (2014-08-22 
19:45:05 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       Kconfig: do not select SPI bus on sub-driver auto-select

  drivers/media/Kconfig | 1 -
  1 file changed, 1 deletion(-)

-- 
http://palosaari.fi/
