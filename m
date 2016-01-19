Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:54776 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbcASSds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 13:33:48 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] media: au0828 fix compile warns
Date: Tue, 19 Jan 2016 11:33:42 -0700
Message-Id: <cover.1453223886.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix compile warns for the MEDIA_CONTROLLER disabled
case introduced in the patch series for Sharing media
resources across ALSA and au0828 drivers:

https://lkml.org/lkml/2016/1/6/668

Shuah Khan (2):
  media: au0828 fix enable/disable source compile warns
  media: au0828 fix au0828_media_device_register warn

 drivers/media/usb/au0828/au0828-core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

-- 
2.5.0

