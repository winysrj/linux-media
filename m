Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3066 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3HLNOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 09:14:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: scott.jiang.linux@gmail.com,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: [RFC PATCH 0/3] Add adv7842 and adv7511 drivers.
Date: Mon, 12 Aug 2013 15:13:56 +0200
Message-Id: <1376313239-19921-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for the adv7842 video receiver and for the
adv7511 video transmitter.

These drivers have been in the cisco internal repository for way too long, and
it is time to get them merged.

A note regarding the adv7511 driver: there is also a drm driver floating around,
but the driver in this patch series is a v4l driver. As of today it is not
possible to have one driver that can be used by both v4l and drm subsystems. The
hope is that the work done by Laurent Pinchart on the Common Display Framework
will actually make this possible. When that happens the driver will have to be
adapted for that.

The two drivers in this patch series have been in use for some time now in
our products, so they have been tested.

This is an RFC since the driver code will change once a pending pull request has
been merged. That pull request simplifies DV_TIMINGS handling by adding
additional helper functions and moving all DV_TIMINGS support to a new
v4l2-dv-timings module.

See this branch for those upcoming features:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/for-v3.12

Regards,

	Hans

