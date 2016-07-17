Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:36536 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbcGQQKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 12:10:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B1FA9180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 18:10:13 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] (v2) CEC fixes, vivid CEC enhancement
Message-ID: <a96ce98e-a23a-cf93-87db-08cdcfb70fba@xs4all.nl>
Date: Sun, 17 Jul 2016 18:10:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix a number of bugs in the CEC framework. These were discovered
while extending and improving the compliance tests for the CEC API.

The vivid patch adds MONITOR_ALL support.

The latest compliance tests are here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=cec-johan

The docrst needs an update as well, I'll make a separate patch for that.

Regards,

	Hans

(v2 adds patch "cec: poll should check if there is room in the tx queue")

The following changes since commit e05b1872f29a85532c2b34e3a4974a27158f1463:

  [media] cxd2841er: Reading SNR for DVB-C added (2016-07-16 07:01:31 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8l

for you to fetch changes up to ef60683220d144e3830240a1bdd962c8ac01d674:

  cec: poll should check if there is room in the tx queue (2016-07-17 18:02:44 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      cec: CEC_RECEIVE overwrote the timeout field
      cec: clear all status fields before transmit and always fill in sequence
      cec: don't set fh to NULL in CEC_TRANSMIT
      cec: zero unused msg part after msg->len
      cec: limit the size of the transmit queue
      cec: fix test for unconfigured adapter in main message loop
      vivid: support monitor all mode
      cec: poll should check if there is room in the tx queue

 drivers/media/platform/vivid/vivid-cec.c | 44 +++++++++++++++----------------------------
 drivers/staging/media/cec/cec-adap.c     | 61 +++++++++++++++++++++++++++++++++++++++---------------------
 drivers/staging/media/cec/cec-api.c      | 15 ++++++++-------
 include/media/cec.h                      | 19 ++++++++++++++-----
 4 files changed, 77 insertions(+), 62 deletions(-)
