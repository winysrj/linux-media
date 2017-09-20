Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38421 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdITHiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 03:38:12 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org, hans.verkuil@cisco.com,
        sean@mess.org, andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] [media] Handle return value of kasprintf
Date: Wed, 20 Sep 2017 13:07:11 +0530
Message-Id: <1505893033-7491-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kasprintf() can fail here and we must check its return value.

Arvind Yadav (2):
  [PATCH 1/2][media] coda: Handle return value of kasprintf
  [PATCH 2/2][media] cx23885: Handle return value of kasprintf

 drivers/media/pci/cx23885/cx23885-input.c | 15 +++++++++++++--
 drivers/media/platform/coda/coda-bit.c    |  3 +++
 2 files changed, 16 insertions(+), 2 deletions(-)

-- 
1.9.1
