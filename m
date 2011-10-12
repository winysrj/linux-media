Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4691 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1JLIBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 04:01:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.2] auto-cluster bug fix
Date: Wed, 12 Oct 2011 10:00:57 +0200
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110121000.57301.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a small fix for a bug in the autocluster handling that was found
by Hans de Goede.

Regards,

	Hans

The following changes since commit e30528854797f057aa6ffb6dc9f890e923c467fd:

  [media] it913x-fe changes to power up and down of tuner (2011-10-08 08:03:27 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git ctrlfix

Hans Verkuil (1):
      v4l2-ctrls: if auto-cluster flags change, then send event to all.

 drivers/media/video/v4l2-ctrls.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
