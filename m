Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:48942 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbbEUMhQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 08:37:16 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: modin@yuri.at, Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 0/4] [sur40] minor fixes & performance improvements
Date: Thu, 21 May 2015 14:29:38 +0200
Message-Id: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds several small fixes, features & performance
improvements. Many thanks to Martin Kaltenbrunner for testing the
original driver & submitting the patches. 

Martin Kaltenbrunner (4):
  reduce poll interval to allow full 60 FPS framerate
  add frame size/frame rate query functions
  add extra debug output, remove noisy warning
  return BUF_STATE_ERROR if streaming stopped during acquisition

 drivers/input/touchscreen/sur40.c | 46 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

-- 
1.9.1

