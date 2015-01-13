Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:55147 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbbAMC5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 21:57:07 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com,
	dheitmueller@kernellabs.com, prabhakar.csengg@gmail.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	ttmesterr@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] media: fix au0828 compile error from au0828_boards initialization
Date: Mon, 12 Jan 2015 19:56:55 -0700
Message-Id: <61a7298a0767084d7b8b335bbe2116c287f72459.1421115389.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1421115389.git.shuahkh@osg.samsung.com>
References: <cover.1421115389.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1421115389.git.shuahkh@osg.samsung.com>
References: <cover.1421115389.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828 picked up UNSET from videobuf-core.h and fails to compile
if videobuf-core.h isn't included. Change it to use -1U instead
to fix the problem.

    drivers/media/usb/au0828/au0828-cards.c:47:17: error: ‘UNSET’ undeclared here (not in a function)
       .tuner_type = UNSET,

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index da87f1c..edc2735 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -44,7 +44,7 @@ static void hvr950q_cs5340_audio(void *priv, int enable)
 struct au0828_board au0828_boards[] = {
 	[AU0828_BOARD_UNKNOWN] = {
 		.name	= "Unknown board",
-		.tuner_type = UNSET,
+		.tuner_type = -1U,
 		.tuner_addr = ADDR_UNSET,
 	},
 	[AU0828_BOARD_HAUPPAUGE_HVR850] = {
-- 
2.1.0

