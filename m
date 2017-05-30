Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36157 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdE3NkB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 09:40:01 -0400
Date: Tue, 30 May 2017 14:39:59 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] RC race condition
Message-ID: <20170530133959.GA14769@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just a fix for an issue which the 0day robot found. I think the bug has always
been present.

Thanks
Sean

The following changes since commit dd8245f445f5e751b38126140b6ba1723f06c60b:

  [media] atomisp: don't treat warnings as errors (2017-05-18 05:44:00 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.12f

for you to fetch changes up to e19c5c0b6f4a46e0d489a9134c3b96f93d669be2:

  [media] rc-core: race condition during ir_raw_event_register() (2017-05-30 14:31:39 +0100)

----------------------------------------------------------------
Sean Young (1):
      [media] rc-core: race condition during ir_raw_event_register()

 drivers/media/rc/rc-ir-raw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)
