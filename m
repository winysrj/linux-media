Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59709 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbcGQPFt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:05:49 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 95A93180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 17:05:44 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] CEC fixes, vivid CEC enhancement
Message-ID: <72a1f0f3-3d3d-fda5-5891-28a15d3136c3@xs4all.nl>
Date: Sun, 17 Jul 2016 17:05:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix a number of bugs in the CEC framework. These were discovered
while extending and improving the compliance tests for the CEC API.

The final patch adds MONITOR_ALL mode to vivid.

The latest compliance tests are here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=cec-johan

The docrst needs an update as well, I'll make a separate patch for that.

Regards,

	Hans

The following changes since commit e05b1872f29a85532c2b34e3a4974a27158f1463:

  [media] cxd2841er: Reading SNR for DVB-C added (2016-07-16 07:01:31 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8l

for you to fetch changes up to 48a5d210b842e1d310071a53d8b87142a52a5c6b:

  vivid: support monitor all mode (2016-07-17 16:57:56 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      cec: CEC_RECEIVE overwrote the timeout field
      cec: clear all status fields before transmit and always fill in sequence
      cec: don't set fh to NULL in CEC_TRANSMIT
      cec: zero unused msg part after msg->len
      cec: limit the size of the transmit queue
      cec: fix test for unconfigured adapter in main message loop
      vivid: support monitor all mode

 drivers/media/platform/vivid/vivid-cec.c | 44 +++++++++++++++----------------------------
 drivers/staging/media/cec/cec-adap.c     | 61 +++++++++++++++++++++++++++++++++++++++---------------------
 drivers/staging/media/cec/cec-api.c      | 12 ++++++------
 include/media/cec.h                      | 19 ++++++++++++++-----
 4 files changed, 75 insertions(+), 61 deletions(-)
