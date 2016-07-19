Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39513 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbcGSHaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 03:30:11 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F14BB18021F
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2016 09:30:05 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] (v3) CEC fixes, vivid CEC enhancement
Message-ID: <f4fd6e46-59f4-9dcc-20ca-9a088c0b89ef@xs4all.nl>
Date: Tue, 19 Jul 2016 09:30:05 +0200
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

(v3 adds patch "cec: always check all_device_types and features")
(v2 adds patch "cec: poll should check if there is room in the tx queue")

The following changes since commit e05b1872f29a85532c2b34e3a4974a27158f1463:

  [media] cxd2841er: Reading SNR for DVB-C added (2016-07-16 07:01:31 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8l

for you to fetch changes up to a513478569811ad69f012d294fe2a0f74dbf9fc1:

  cec: always check all_device_types and features (2016-07-19 09:28:08 +0200)

----------------------------------------------------------------
Hans Verkuil (9):
      cec: CEC_RECEIVE overwrote the timeout field
      cec: clear all status fields before transmit and always fill in sequence
      cec: don't set fh to NULL in CEC_TRANSMIT
      cec: zero unused msg part after msg->len
      cec: limit the size of the transmit queue
      cec: fix test for unconfigured adapter in main message loop
      vivid: support monitor all mode
      cec: poll should check if there is room in the tx queue
      cec: always check all_device_types and features

 drivers/media/platform/vivid/vivid-cec.c | 44 +++++++++++-------------------
 drivers/staging/media/cec/cec-adap.c     | 87 +++++++++++++++++++++++++++++++++++++-----------------------
 drivers/staging/media/cec/cec-api.c      | 15 ++++++-----
 include/media/cec.h                      | 19 +++++++++----
 4 files changed, 91 insertions(+), 74 deletions(-)
