Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1370 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaITKgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 06:36:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: matrandg@cisco.com, marbugge@cisco.com
Subject: [PATCHv2 0/2] adv7604/7842 timing fixes
Date: Sat, 20 Sep 2014 12:36:37 +0200
Message-Id: <1411209399-24478-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series supercedes https://patchwork.linuxtv.org/patch/25954/.
After working on it a bit more I realized that that patch didn't really
address the core issues.

Besides the il_vbackporch typo there was a too strict check in
v4l2_valid_dv_timings() where it checked for compatible standards. But
that only works if both sides have filled in that field, otherwise it
should just accept it. When detecting timings you often do not know which
standard it is so the driver will just set it to 0.

The other issue was that adv7842 never zeroed the timings struct, leaving
several fields undefined, again breaking v4l2_valid_dv_timings().

Regards,

	Hans

