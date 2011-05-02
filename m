Return-path: <mchehab@pedra>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:29773 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1EBLTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 07:19:11 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] Fix subdev control enumeration
Date: Mon, 2 May 2011 13:19:03 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105021319.03696.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

This fix is for 2.6.39. Control enumeration for subdev device nodes is broken. 
The fix is simple and has been tested by Sakari.

Regards,

	Hans

The following changes since commit 28df73703e738d8ae7a958350f74b08b2e9fe9ed:
  Mauro Carvalho Chehab (1):
        [media] xc5000: Improve it to work better with 6MHz-spaced channels

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git ctrl-fix

Hans Verkuil (1):
      v4l2-subdev: fix broken subdev control enumeration

 drivers/media/video/v4l2-subdev.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)
