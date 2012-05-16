Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45994 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966987Ab2EPKoU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 06:44:20 -0400
Received: by weyu7 with SMTP id u7so341289wey.19
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 03:44:19 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 0/2] media_build: fix compilation on old kernels (<2.6.34)
Date: Wed, 16 May 2012 12:44:08 +0200
Message-Id: <1337165050-31638-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patches fix compilation of the media_build tree on kernels older than 2.6.34.

Tested on kernel 2.6.32 (Ubuntu 10.04).

Gianluca Gennari (2):
  media_build: add SET_SYSTEM_SLEEP_PM_OPS definition to compat.h
  media_build: disable VIDEO_SMIAPP driver on kernels older than 2.6.34

 v4l/compat.h                      |   14 ++++++++++++++
 v4l/scripts/make_config_compat.pl |    1 +
 v4l/versions.txt                  |    2 ++
 3 files changed, 17 insertions(+), 0 deletions(-)

