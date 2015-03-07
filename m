Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39058 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbCGPay (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 10:30:54 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] media: am437x-vpfe: trivial fixes
Date: Sat,  7 Mar 2015 15:30:48 +0000
Message-Id: <1425742250-24404-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>


Lad, Prabhakar (2):
  media: am437x-vpfe: match the OF node/i2c addr instead of name
  media: am437x-vpfe: return error in case memory allocation failure

 drivers/media/platform/am437x/am437x-vpfe.c | 33 +++++++++++++++--------------
 drivers/media/platform/am437x/am437x-vpfe.h |  1 -
 2 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.1.0

