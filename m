Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:47048 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1FUHjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 03:39:23 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/2] media-ctl: minor changes
Date: Tue, 21 Jun 2011 09:39:15 +0200
Message-Id: <1308641957-7805-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

These are a couple of commits that I have locally on top of your media-ctl head
which I would like to see in your rep.

Michael Jones (2):
  add Y10, Y12 formats
  try using autoconf 2.61

 configure.in |    2 +-
 src/main.c   |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

-- 
1.7.5.4


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
