Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53001 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753799AbcLLIhe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 03:37:34 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] CEC bug fixes
Message-ID: <f510e2d1-115f-4260-c55f-76fdaf12b396@xs4all.nl>
Date: Mon, 12 Dec 2016 09:37:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request combines this patch series:

https://www.spinics.net/lists/linux-media/msg109011.html

and this patch:

https://www.spinics.net/lists/linux-media/msg108808.html

All bug fixes that should go into 4.10.

Regards,

	Hans

This patch series fixes a number of bug in the CEC framework.

The following changes since commit 365fe4e0ce218dc5ad10df17b150a366b6015499:

   [media] mn88472: fix chip id check on probe (2016-12-01 12:47:22 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git cecfix

for you to fetch changes up to ce88a2a92fc9428455b011a1c48622605b529b8d:

   cec: fix race between configuring and unconfiguring (2016-12-10 
10:30:09 +0100)

----------------------------------------------------------------
Hans Verkuil (7):
       cec: fix report_current_latency
       cec: when canceling a message, don't overwrite old status info
       cec: CEC_MSG_GIVE_FEATURES should abort for CEC version < 2
       cec: update log_addr[] before finishing configuration
       cec: replace cec_report_features by cec_fill_msg_report_features
       cec: move cec_report_phys_addr into cec_config_thread_func
       cec: fix race between configuring and unconfiguring

  drivers/media/cec/cec-adap.c   | 103 
++++++++++++++++++++++++++++++++++++------------------------------------
  include/uapi/linux/cec-funcs.h |  10 ++++---
  2 files changed, 59 insertions(+), 54 deletions(-)
