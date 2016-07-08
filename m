Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52285 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331AbcGHJ74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 05:59:56 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id ABD7818006A
	for <linux-media@vger.kernel.org>; Fri,  8 Jul 2016 11:59:29 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] (v4) cec updates
Message-ID: <35d77591-87f7-81cd-202c-f129941d2843@xs4all.nl>
Date: Fri, 8 Jul 2016 11:59:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(This supersedes my previous three CEC pull request)

This adds the missing rc-cec keymap module, two bugfixes, three cec-funcs.h
improvements, Kconfig fixes from Arnd and it dual-licenses the headers for BSD,
just as we do for videodev2.h.

I originally thought the rc-cec module was already merged in the cec topic branch,
but I later discovered that it wasn't.

Regards,

	Hans

The following changes since commit c7169ad5616229b87cabf886bc5f9cbd1fc35a5f:

  [media] DocBook/media: add CEC documentation (2016-06-28 11:45:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-topic2

for you to fetch changes up to 7cd64ba7d9b1c49b5a1f8b0101384b43ba79bc18:

  cec-funcs.h: add missing 'reply' for short audio descriptor (2016-07-08 11:57:06 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      s5p_cec: mark suspend/resume as __maybe_unused
      cec: add MEDIA_SUPPORT dependency

Hans Verkuil (7):
      cec-adap: on reply, restore the tx_status value from the transmit
      cec.h/cec-funcs.h: add option to use BSD license
      cec-adap: prevent write to out-of-bounds array index
      cec: fix Kconfig dependency problems
      cec-funcs.h: add length checks
      cec-funcs.h: add missing const modifier
      cec-funcs.h: add missing 'reply' for short audio descriptor

Kamil Debski (1):
      rc-cec: Add HDMI CEC keymap module

 drivers/media/Kconfig                   |   2 +-
 drivers/media/Makefile                  |   4 +-
 drivers/media/rc/keymaps/Makefile       |   1 +
 drivers/media/rc/keymaps/rc-cec.c       | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/cec/Kconfig       |   3 +-
 drivers/staging/media/cec/Makefile      |   4 +-
 drivers/staging/media/cec/TODO          |   5 ++
 drivers/staging/media/cec/cec-adap.c    |  18 +++---
 drivers/staging/media/cec/cec-core.c    |  10 ++--
 drivers/staging/media/s5p-cec/s5p_cec.c |   4 +-
 include/linux/cec-funcs.h               |  64 +++++++++++++--------
 include/linux/cec.h                     |  16 ++++++
 12 files changed, 272 insertions(+), 41 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c
