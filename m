Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48607 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753051AbdCTJSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 05:18:24 -0400
Date: Mon, 20 Mar 2017 09:18:22 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4l-utils] rc fixes
Message-ID: <20170320091821.GA16786@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Just musl compile fixes and a fix for streamzap keymap not loading.

Thanks,
Sean

The following changes since commit 646bb9c368a8b65cdea6d934c9022067541d13a9:

  cec-follower: don't Feature Abort msgs from Unregistered (2017-02-28 14:14:31 +0100)

are available in the git repository at:

  git://linuxtv.org/syoung/v4l-utils.git rc-fixes

for you to fetch changes up to c7c589aae4a86189537de03239d886f1b085fdc3:

  ir-ctl: add optional copy of TEMP_FAILURE_RETRY macro (fix musl compile) (2017-03-20 09:08:04 +0000)

----------------------------------------------------------------
Peter Seiderer (2):
      ir-ctl: use strndup instead of strndupa (fixes musl compile)
      ir-ctl: add optional copy of TEMP_FAILURE_RETRY macro (fix musl compile)

Sean Young (1):
      ir-keytable: be more permissive on protocol name

 utils/ir-ctl/ir-ctl.c     | 12 +++++++++++-
 utils/keytable/keytable.c | 21 ++++++++++++++++-----
 2 files changed, 27 insertions(+), 6 deletions(-)
