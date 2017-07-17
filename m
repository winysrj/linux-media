Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56794 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751257AbdGQHaO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 03:30:14 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Three cec patches for 4.13.
Message-ID: <b20d6a4a-61d1-90b9-cf30-09e4078bfc55@xs4all.nl>
Date: Mon, 17 Jul 2017 09:30:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Here are three small CEC patches that should go to 4.13.

Regards,

	Hans

The following changes since commit 2748e76ddb2967c4030171342ebdd3faa6a5e8e8:

  media: staging: cxd2099: Activate cxd2099 buffer mode (2017-06-26 08:19:13 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-fix

for you to fetch changes up to 839865a4345ffbf1f23e701ab9c51372bcbec436:

  cec-notifier: small improvements (2017-07-17 09:27:24 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      cec: cec_transmit_attempt_done: ignore CEC_TX_STATUS_MAX_RETRIES
      pulse8-cec: persistent_config should be off by default
      cec-notifier: small improvements

 drivers/media/cec/cec-adap.c              |  2 +-
 drivers/media/cec/cec-notifier.c          |  6 ++++++
 drivers/media/usb/pulse8-cec/pulse8-cec.c |  2 +-
 include/media/cec-notifier.h              | 15 +++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)
