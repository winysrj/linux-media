Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:57809 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaFEPbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 11:31:35 -0400
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6P0043PCGM3Z50@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jun 2014 11:31:34 -0400 (EDT)
From: Thiago Santos <ts.santos@sisa.samsung.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Thiago Santos <ts.santos@sisa.samsung.com>
Subject: [PATCH/RFC 0/2] libv4l2: fix deadlock when DQBUF in block mode
Date: Thu, 05 Jun 2014 12:31:22 -0300
Message-id: <1401982284-1983-1-git-send-email-ts.santos@sisa.samsung.com>
MIME-version: 1.0
Content-type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset modifies v4l2grab to allow using 2 threads (one for qbuf and
another for dqbuf) to simulate multithreaded v4l2 usage.

This is done to show a issue when using libv4l2 in blocking mode, if a DQBUF
is issued when there are no buffers available it will block waiting for one but,
as it blocks holding the stream_lock, a QBUF will never happen and we have
a deadlock.

Thiago Santos (2):
  v4l2grab: Add threaded producer/consumer option
  libv4l2: release the lock before doing a DQBUF

 contrib/test/Makefile.am |   2 +-
 contrib/test/v4l2grab.c  | 265 +++++++++++++++++++++++++++++++++++++++--------
 lib/libv4l2/libv4l2.c    |   2 +
 3 files changed, 225 insertions(+), 44 deletions(-)

-- 
2.0.0

