Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34823 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751613AbeEBXUD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 19:20:03 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/2] Whitespace fixes
Date: Wed,  2 May 2018 18:19:28 -0500
Message-Id: <1525303170-6303-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In intel/ipu3 and media Kconfig files there
are whitespace issues, which cause failure when
doing menuconfig on older kernels during backport
operations. The kernel rules are applied to both
Kconfigs. Initial spacing of one tab, then help is
further indented by two spaces.

Brad Love (2):
  intel-ipu3: Kconfig coding style issue
  cec: Kconfig coding style issue

 drivers/media/Kconfig                 | 12 ++++++------
 drivers/media/pci/intel/ipu3/Kconfig  | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

-- 
2.7.4
