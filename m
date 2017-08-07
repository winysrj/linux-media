Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:36493 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751857AbdHGNb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 09:31:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sean Young <sean@mess.org>
Subject: [PATCH 0/2] cec: improve RC passthrough behavior
Date: Mon,  7 Aug 2017 15:31:22 +0200
Message-Id: <20170807133124.30682-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC remote control passthrough behavior was not correct in the case
of the 'Press and Hold' auto-repeat feature.

This patch series fixes this.

The first patch teaches rc about the CEC protocol keypress timeout (550 ms).

The second improves the cec rc code so that it creates the correct behavior
as required by CEC.

Regards,

	Hans

Hans Verkuil (2):
  rc-main: support CEC protocol keypress timeout
  cec: fix remote control passthrough

 drivers/media/cec/cec-adap.c | 56 ++++++++++++++++++++++++++++++++++++++++----
 drivers/media/cec/cec-core.c | 13 ++++++++++
 drivers/media/rc/rc-main.c   | 17 ++++++++++++--
 include/media/cec.h          |  5 ++++
 4 files changed, 84 insertions(+), 7 deletions(-)

-- 
2.13.2
