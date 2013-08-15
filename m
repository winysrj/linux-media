Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2484 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3HOLhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 07:37:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH 00/12] dv-timings/adv7604/ad9389b fixes
Date: Thu, 15 Aug 2013 13:36:22 +0200
Message-Id: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series builds on top of the for-v3.12 pull request:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/67690

It applies a bunch of fixes from Cisco's internal tree and it adds the
v4l2_print_dv_timings helper function.

Regards,

	Hans

