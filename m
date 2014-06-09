Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:45627 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaFINwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 09:52:10 -0400
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6W00HMIMIWB540@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jun 2014 09:52:08 -0400 (EDT)
From: Thiago Santos <ts.santos@sisa.samsung.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Thiago Santos <ts.santos@sisa.samsung.com>
Subject: [PATCH/RFC v2 0/2] libv4l2: fix deadlock when DQBUF in block mode
Date: Mon, 09 Jun 2014 10:51:54 -0300
Message-id: <1402321916-22111-1-git-send-email-ts.santos@sisa.samsung.com>
MIME-version: 1.0
Content-type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

thanks for the reviews and comments. I updated the example as suggested by
Mauro and reimplemented the deadlock fix as suggested by Hans. Here is the
second version of those patches.

Thiago Santos (2):
  v4l2grab: Add threaded producer/consumer option
  libv4l2: release the lock before doing a DQBUF

 contrib/test/Makefile.am   |   2 +-
 contrib/test/v4l2grab.c    | 261 +++++++++++++++++++++++++++++++++++++--------
 lib/libv4l2/libv4l2-priv.h |   1 +
 lib/libv4l2/libv4l2.c      |  13 ++-
 4 files changed, 232 insertions(+), 45 deletions(-)

-- 
2.0.0

