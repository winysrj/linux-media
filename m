Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1896 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3FJMtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 08:49:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>
Subject: [REVIEW PATCH 0/9] Use v4l2_dev instead of parent.
Date: Mon, 10 Jun 2013 14:48:29 +0200
Message-Id: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts the last set of drivers still using the parent
field of video_device to using v4l2_dev instead and at the end the parent
field is removed altogether.

A proper pointer to v4l2_dev is necessary otherwise the advanced debugging
ioctls will not work when addressing sub-devices.

I have been steadily converting drivers to set the v4l2_dev pointer correctly,
and this patch series finishes that work.

Guennadi, the first patch replaces the broken version I posted earlier as part
of the 'current_norm' removal patch series. I've tested it with my renesas
board.

Note that this patch series sits on top of my for_v3.11 branch.

Regards,

	Hans

