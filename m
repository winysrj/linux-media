Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35072 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752212AbeBHOXv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 09:23:51 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Florian Echtler <floe@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] sur40: add video controls for SUR40 driver
Message-ID: <5c03e7b9-dd70-6cab-12ca-87af15d1887c@xs4all.nl>
Date: Thu, 8 Feb 2018 15:23:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 273caa260035c03d89ad63d72d8cd3d9e5c5e3f1:

  media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs (2018-01-31 03:09:04 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sur40

for you to fetch changes up to cffe563fcd3400b4c399670ba455954ec427443f:

  add video control handlers using V4L2 control framework (2018-02-08 15:11:49 +0100)

----------------------------------------------------------------
Florian Echtler (4):
      add missing blob structure field for tag id
      add default settings and module parameters for video controls
      add panel register access functions
      add video control handlers using V4L2 control framework

 drivers/input/touchscreen/sur40.c | 178 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 177 insertions(+), 1 deletion(-)
