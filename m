Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34335 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbF3QZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 12:25:36 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2 0/2] v4l: vsp1: Fix Suspend-to-RAM
Date: Wed,  1 Jul 2015 01:25:04 +0900
Message-Id: <1435681506-24296-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series fixes Suspend-to-RAM to make VSP1 driver continue working
after resuming.
This series includes two patches:
- fix simple ref_count bug
- add stop/restart the video stream

Sei Fumizono (1):
  v4l: vsp1: Fix Suspend-to-RAM

Yoshihiro Kaneko (1):
  v4l: vsp1: Fix ref_count bug

 drivers/media/platform/vsp1/vsp1_drv.c   | 11 +++--
 drivers/media/platform/vsp1/vsp1_video.c | 69 +++++++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.h |  5 ++-
 3 files changed, 80 insertions(+), 5 deletions(-)

v2 [Yoshihiro Kaneko]
* compile tested only
* As suggested by Laurent Pinchart
  - separate a patch into two patches
  - add stop/restart the video stream code to vsp1_pipelines_suspend() and
    vsp1_pipelines_resume() function in vsp1_video.c.

-- 
1.9.1

