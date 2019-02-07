Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8AEC282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33EB72080A
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfBGLt7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:49:59 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47737 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbfBGLtw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 06:49:52 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id riBggvrMUNR5yriBhg1Jlt; Thu, 07 Feb 2019 12:49:50 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [RFC PATCH 0/8] cec/mc/vb2/dvb: fix epoll support
Date:   Thu,  7 Feb 2019 12:49:40 +0100
Message-Id: <20190207114948.37750-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfEiePhVJVg4gVkpx4rn8cwFm9GXweq0Bm9PHG20cjJAVw0PWeTWNnvjElmt11l3ppcqMSDvl6rAYAVgBF3rIFLu5WmNWi3wi1tfVmlMtYnc5wl/zUAhb
 aJTstGC/JGSgahUEagKUZnNyLmVYyLgPx7p/B7otD/jBc3Sk05ZutpX7ueJWwRbx1phBi+pYuPCMmyPqLSomE6b66UD3chKZdWARWPg8NznAq1eocW7FlaP/
 bVpY3j8d2MOgocDNXtUFCHGmAZvW9pg/+eHxvTS7lt2gelm15Lq6BueS51OuDA0U
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

As was reported by Yi Qingliang (http://lkml.iu.edu/hypermail/linux/kernel/1812.3/02144.html)
the epoll support in v4l2 is broken.

After researching this some more it turns out that we never
really understood when poll_wait() should be called, and that in
fact it is broken in quite a few places in our media tree, and not
just v4l2.

The select() call is fairly simplistic: it calls the poll fop
first, then waits for an event if the poll fop returned 0.

The epoll() call is more complicated: epoll_ctl(EPOLL_CTL_ADD) will
call the poll fop which calls poll_wait in turn.

But epoll_wait() just waits for events to arrive on the registered
waitqueues, and does not call the poll fop until it is woken up.

So not calling poll_wait() in the poll fop will cause epoll_wait()
to wait forever (or until the timeout is reached).

This patch series just calls poll_wait() regardless of whether there
is an event pending.

It does this for all the various frameworks that did this wrong.

Note that there is also an extra mem2mem patch that adds a check for
q->error, which I noticed was missing.

I have not tested the videobuf and esp. the dvb-core changes. They
look sane, but it doesn't hurt to give those extra attention.

There are also older drivers that call poll_wait themselves. While
I have some patches for those (look in
https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=poll), they
need more review. I prefer to do the core frameworks first.

Several of the patches in this series should probably be CC-ed to
stable. I'll take a look at that once this RFC series gets the
green light.

Regards,

	Hans

Hans Verkuil (8):
  cec: fix epoll() by calling poll_wait first
  media-request: fix epoll() by calling poll_wait first
  vb2: fix epoll() by calling poll_wait first
  v4l2-ctrls.c: fix epoll() by calling poll_wait first
  v4l2-mem2mem: fix epoll() by calling poll_wait first
  v4l2-mem2mem: add q->error check to v4l2_m2m_poll()
  videobuf: fix epoll() by calling poll_wait first
  dvb-core: fix epoll() by calling poll_wait first

 drivers/media/cec/cec-api.c                   |  2 +-
 .../media/common/videobuf2/videobuf2-core.c   |  4 +--
 .../media/common/videobuf2/videobuf2-v4l2.c   |  4 +--
 drivers/media/dvb-core/dmxdev.c               |  8 +++---
 drivers/media/dvb-core/dvb_ca_en50221.c       |  5 ++--
 drivers/media/media-request.c                 |  3 +--
 drivers/media/v4l2-core/v4l2-ctrls.c          |  2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 25 ++++++++-----------
 drivers/media/v4l2-core/videobuf-core.c       |  6 ++---
 9 files changed, 26 insertions(+), 33 deletions(-)

-- 
2.20.1

