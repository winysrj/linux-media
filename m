Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35038 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaLDSBg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Dec 2014 13:01:36 -0500
Message-ID: <5480A17E.1070502@iki.fi>
Date: Thu, 04 Dec 2014 20:01:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Benjamin Larsson <benjamin@southpole.se>
Subject: [GIT PULL 3.19 or 3.20] rtl2832 i2c binding
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That set fixes issue, which happens when mn88472 slave demod from 
staging is used. Fix itself is done for drivers that has been in-kernel 
ages, but bug happens only when staging demod is used.

So make decision to pull that for 3.19, or if not, then 3.20.

Antti

The following changes since commit 9a4ea5a98652f602d4ec16957f64fd666e862b09:

   [media] MAINTAINERS: Add myself as img-ir maintainer (2014-12-04 
15:42:21 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git astrometa

for you to fetch changes up to 51e8ac292e856fbdacfc2b2e362553cc7db7d1da:

   rtl28xxu: change module unregister order (2014-12-04 19:50:18 +0200)

----------------------------------------------------------------
Antti Palosaari (3):
       rtl2832: convert driver to I2C binding
       rtl28xxu: switch rtl2832 demod attach to I2C binding
       rtl28xxu: change module unregister order

  drivers/media/dvb-frontends/rtl2832.c      | 108 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/dvb-frontends/rtl2832.h      |  10 ++++++++++
  drivers/media/dvb-frontends/rtl2832_priv.h |   1 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |  92 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h    |   1 +
  5 files changed, 184 insertions(+), 28 deletions(-)

-- 
http://palosaari.fi/
