Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3599 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3FVKHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 06:07:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	Fengguang Wu <fengguang.wu@intel.com>
Subject: [RFC PATCH 0/6] wl128x: Various fixes
Date: Sat, 22 Jun 2013 12:06:49 +0200
Message-Id: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fengguang, Manjunatha,

This patch series fixes the warning when registering the video node introduced
after the patch that requires a valid v4l2_dev pointer. This driver slipped
through because it didn't set the old parent pointer either. The other patches
are improvements to the driver, fixing a number of problems.

Due to lack of hardware I can't test this myself. Can either of you test it for
me? Ideally I would like to see the output of the v4l2-compliance tool (part of
http://git.linuxtv.org/v4l-utils.git). Run with 'v4l2-compliance -r0'. I know
there will be failures because this driver combines the radio receiver and
transmitter support in one radio node, something that isn't allowed anymore.

One thing that is not included, but that I would like to add later is proper
control support for RDS_TEXT, PS_NAME and the alternate frequency for the TX
part. Right now this is done through an ugly custom write(), but there is
proper API support for such things these days.

BTW, does anyone know of a cheap devboard with this chip? It would be useful
if I could test this driver myself.

Regards,

	Hans

