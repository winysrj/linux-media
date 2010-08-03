Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail179.messagelabs.com ([85.158.139.35]:22004 "HELO
	mail179.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755125Ab0HCITB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 04:19:01 -0400
From: mats.randgaard@tandberg.com
To: linux-media@vger.kernel.org
Cc: sudhakar.raj@ti.com, Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [PATCH 0/2] Patches for TVP7002
Date: Tue,  3 Aug 2010 10:18:02 +0200
Message-Id: <1280823484-21664-1-git-send-email-mats.randgaard@tandberg.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <mats.randgaard@tandberg.com>

The patch "TVP7002: Changed register values" depends on http://www.mail-archive.com/linux-media@vger.kernel.org/msg20769.html

Mats Randgaard (2):
  TVP7002: Return V4L2_DV_INVALID if any of the errors occur.
  TVP7002: Changed register values.

 drivers/media/video/tvp7002.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

