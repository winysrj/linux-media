Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53870 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbcFROud (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 10:50:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: [PATCH 0/2] input: add support for HDMI CEC
Date: Sat, 18 Jun 2016 16:50:26 +0200
Message-Id: <1466261428-12616-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi Dmitry,

This patch series adds input support for the HDMI CEC bus through which
remote control keys can be passed from one HDMI device to another.

This has been posted before as part of the HDMI CEC patch series. We are
going to merge that in linux-media for 4.8, but these two patches have to
go through linux-input.

Only the rc-cec keymap file depends on this, and we will take care of that
dependency (we'll postpone merging that until both these input patches and
our own CEC patches have been merged in mainline).

Regards,

	Hans

Hans Verkuil (1):
  input.h: add BUS_CEC type

Kamil Debski (1):
  HID: add HDMI CEC specific keycodes

 include/uapi/linux/input-event-codes.h | 31 +++++++++++++++++++++++++++++++
 include/uapi/linux/input.h             |  1 +
 2 files changed, 32 insertions(+)

-- 
2.8.1

