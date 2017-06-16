Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58855 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752647AbdFPNNt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 09:13:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Various fixes.
Message-ID: <dc9e9886-a4da-47a3-db8c-66921e1f21e6@xs4all.nl>
Date: Fri, 16 Jun 2017 15:13:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit acec3630155763c170c7ae6508cf973355464508:

  [media] s3c-camif: fix arguments position in a function call (2017-06-13 14:21:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.13e

for you to fetch changes up to fee3ff6aa339c9bea656a93e726ec042a0271eef:

  i2c: tc358743: remove useless variable assignment in tc358743_isr (2017-06-16 13:04:09 +0200)

----------------------------------------------------------------
Andrey Utkin (2):
      MAINTAINERS: solo6x10, tw5864: add Anton Sviridenko
      MAINTAINERS: solo6x10: update Andrey Utkin email

Christophe JAILLET (1):
      vb2: Fix error handling in '__vb2_buf_mem_alloc'

Gustavo A. R. Silva (1):
      i2c: tc358743: remove useless variable assignment in tc358743_isr

Kevin Hilman (1):
      davinci: vpif: adaptions for DT support

Lucas Stach (3):
      coda: use correct offset for mvcol buffer
      coda: first step at error recovery
      coda/imx-vdoa: always wait for job completion

 MAINTAINERS                               |  4 +++-
 drivers/media/i2c/tc358743.c              |  1 -
 drivers/media/platform/coda/coda-bit.c    | 28 ++++++++++++++++++++++++----
 drivers/media/platform/coda/coda-common.c |  3 +++
 drivers/media/platform/coda/coda.h        |  1 +
 drivers/media/platform/coda/imx-vdoa.c    | 49 +++++++++++++++++++++++++++++++++----------------
 drivers/media/platform/davinci/vpif.c     | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/v4l2-core/videobuf2-core.c  |  2 +-
 8 files changed, 121 insertions(+), 24 deletions(-)
