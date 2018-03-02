Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45622 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1425043AbeCBJec (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 04:34:32 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.16] tegra-cec: reset rx_buf_cnt when start bit
 detected
Message-ID: <d23b235b-6e24-8096-c6f0-a271ed384e96@xs4all.nl>
Date: Fri, 2 Mar 2018 10:34:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix for 4.16 with CC to stable for 4.15.

Regards,

	Hans

The following changes since commit e3e389f931a14ddf43089c7db92fc5d74edf93a4:

  media: rc: fix race condition in ir_raw_event_store_edge() handling (2018-02-27 08:16:09 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.16g

for you to fetch changes up to 21bc63372793a0e66d46f95cd9c395204a80fd24:

  tegra-cec: reset rx_buf_cnt when start bit detected (2018-03-02 10:33:18 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      tegra-cec: reset rx_buf_cnt when start bit detected

 drivers/media/platform/tegra-cec/tegra_cec.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)
