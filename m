Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:33075 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbbEYMES (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 08:04:18 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, modin@yuri.at,
	Florian Echtler <floe@butterbrot.org>
Subject: [PATCHv2 0/4] [sur40] minor fixes & performance improvements
Date: Mon, 25 May 2015 14:04:12 +0200
Message-Id: <1432555456-20292-1-git-send-email-floe@butterbrot.org>
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

