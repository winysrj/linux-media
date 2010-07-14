Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33094 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab0GNQUI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 12:20:08 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl PATCH 0/3] Some patches for MC testapp
Date: Wed, 14 Jul 2010 11:17:23 -0500
Message-Id: <1279124246-12187-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Here's some patches I have generated when trying to use
your app with my Zoom3 board/environment.

These are based on your git tree:

http://git.ideasonboard.org/?p=media-ctl.git;a=summary

Your comments are appreciated.

Regards,
Sergio

Sergio Aguirre (3):
  Create initial .gitignore file
  Just include kernel headers
  Be able to add more CFLAGS

 .gitignore |    4 ++++
 Makefile   |    6 ++----
 2 files changed, 6 insertions(+), 4 deletions(-)
 create mode 100644 .gitignore

