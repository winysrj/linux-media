Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40256 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab3ADTTh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 14:19:37 -0500
Received: from dyn3-82-128-184-254.psoas.suomi.net ([82.128.184.254] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1TrCno-0008W1-8N
	for linux-media@vger.kernel.org; Fri, 04 Jan 2013 21:19:36 +0200
Message-ID: <50E72B24.3080500@iki.fi>
Date: Fri, 04 Jan 2013 21:19:00 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] dvb_usb_v2: make remote controller optional
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 16427faf28674451a7a0485ab0a929402f355ffd:

   [media] tm6000: Add parameter to keep urb bufs allocated (2012-12-04 
14:54:21 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git dvb_usb_v2_rc-pull

for you to fetch changes up to cc9aa8a2eb10cc0d5df07b8242a4ab1f500e7e23:

   dvb_usb_v2: use IS_ENABLED() macro (2013-01-04 20:25:27 +0200)

----------------------------------------------------------------
Antti Palosaari (12):
       dvb_usb_v2: make remote controller optional
       rtl28xxu: make remote controller optional
       anysee: make remote controller optional
       af9015: make remote controller optional
       af9035: make remote controller optional
       az6007: make remote controller optional
       it913x: make remote controller optional
       it913x: remove unused define and increase module version
       dvb_usb_v2: remove rc-core stub implementations
       dvb_usb_v2: use dummy function defines instead stub functions
       dvb_usb_v2: change rc polling active/deactive logic
       dvb_usb_v2: use IS_ENABLED() macro

  drivers/media/usb/dvb-usb-v2/Kconfig        |  3 ++-
  drivers/media/usb/dvb-usb-v2/af9015.c       |  4 ++++
  drivers/media/usb/dvb-usb-v2/af9035.c       |  4 ++++
  drivers/media/usb/dvb-usb-v2/anysee.c       |  4 ++++
  drivers/media/usb/dvb-usb-v2/az6007.c       | 26 
+++++++++++++++-----------
  drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  3 ++-
  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 15 ++++++++++++---
  drivers/media/usb/dvb-usb-v2/it913x.c       | 39 
+++++++++++++++++++++------------------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |  9 ++++++++-
  9 files changed, 72 insertions(+), 35 deletions(-)

-- 
http://palosaari.fi/
