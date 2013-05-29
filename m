Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3014 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab3E2Hzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 03:55:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: leo@lumanate.com
Subject: [REVIEWv2 PATCH 0/3] hdpvr: various fixes
Date: Wed, 29 May 2013 09:55:12 +0200
Message-Id: <1369814115-12174-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch fixes a bug in querystd: if there is no signal, then
querystd should return V4L2_STD_UNKNOWN. There are more drivers that
return the wrong value here, I have a patch series pending to fix that
and also to improve the spec.

The second does a code cleanup that improves readability, but it doesn't
change the logic.

The third patch is based on a patch from Mauro and a patch from Leo:

https://patchwork.linuxtv.org/patch/18573/
https://linuxtv.org/patch/18399/

This improves the error handling in case usb_control_msg() returns an
error.

Changes since v1:

- Also return the low-level usb_control_msg error in the vidioc_g_fmt_vid_cap
  case.

Regards,

        Hans

