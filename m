Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48703 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750851AbcLHK1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 05:27:35 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] cec: fix report_current_latency
Message-ID: <b3512234-cb62-cd70-5d09-95318c812b23@xs4all.nl>
Date: Thu, 8 Dec 2016 11:27:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEC bug fix.

Regards,

	Hans

The following changes since commit 365fe4e0ce218dc5ad10df17b150a366b6015499:

   [media] mn88472: fix chip id check on probe (2016-12-01 12:47:22 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git cecfix

for you to fetch changes up to d5febd6cd89a69c4b046259cb6e66514cd353248:

   cec: fix report_current_latency (2016-12-08 11:26:31 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
       cec: fix report_current_latency

  drivers/media/cec/cec-adap.c   |  2 +-
  include/uapi/linux/cec-funcs.h | 10 +++++++---
  2 files changed, 8 insertions(+), 4 deletions(-)
