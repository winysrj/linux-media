Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:20161 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcF3NH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 09:07:29 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id u5UD7Oqq004192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Jun 2016 13:07:25 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT PULL FOR v4.8] CEC updates
Message-ID: <5775198C.4030704@cisco.com>
Date: Thu, 30 Jun 2016 15:07:24 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(This supersedes my previous CEC pull request)

This adds the missing rc-cec keymap module, two bugfixes, Kconfig fixes from
Arnd and it dual-licenses the headers for BSD, just as we do for videodev2.h.

I originally thought the rc-cec module was already merged in the cec topic branch,
but I later discovered that it wasn't.

Regards,

	Hans

The following changes since commit c7169ad5616229b87cabf886bc5f9cbd1fc35a5f:

  [media] DocBook/media: add CEC documentation (2016-06-28 11:45:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-topic2

for you to fetch changes up to 145d64ffd3bc3ab1798d50128c806adf56e81c45:

  cec: add RC_CORE dependency (2016-06-30 14:41:30 +0200)

----------------------------------------------------------------
Arnd Bergmann (3):
      s5p_cec: mark suspend/resume as __maybe_unused
      cec: add MEDIA_SUPPORT dependency
      cec: add RC_CORE dependency

Hans Verkuil (3):
      cec-adap: on reply, restore the tx_status value from the transmit
      cec.h/cec-funcs.h: add option to use BSD license
      cec-adap: prevent write to out-of-bounds array index

Kamil Debski (1):
      rc-cec: Add HDMI CEC keymap module

 drivers/media/rc/keymaps/Makefile       |   1 +
 drivers/media/rc/keymaps/rc-cec.c       | 182 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/cec/Kconfig       |   2 ++
 drivers/staging/media/cec/cec-adap.c    |  14 +++++---
 drivers/staging/media/s5p-cec/s5p_cec.c |   4 +--
 include/linux/cec-funcs.h               |  16 +++++++++
 include/linux/cec.h                     |  16 +++++++++
 7 files changed, 228 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c
