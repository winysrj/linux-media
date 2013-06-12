Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4317 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3FLPBx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:01:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>
Subject: [REVIEWv2 PATCH 00/11] Use v4l2_dev instead of parent
Date: Wed, 12 Jun 2013 17:00:50 +0200
Message-Id: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts the last set of drivers still using the parent
field of video_device to using v4l2_dev instead and at the end the parent
field is renamed to dev_parent and used again in cx88.

A proper pointer to v4l2_dev is necessary otherwise the advanced debugging
ioctls will not work when addressing sub-devices.

I have been steadily converting drivers to set the v4l2_dev pointer correctly,
and this patch series finishes that work.

Guennadi, the first patch replaces the broken version I posted earlier as part
of the 'current_norm' removal patch series. I've tested it with my renesas
board.

Note that this patch series sits on top of my for_v3.11 branch.

Regarding the cx88 change: I discovered after posting the first version of
this patch series that there is one real use case of the parent pointer: that
is if there is one v4l2_device, but there are multiple parent PCI busses.
In the case of cx88 the video1 node has a different PCI bus parent than the
other nodes. This is the only driver that behaves like that to my knowledge.

The parent pointer used to be set correctly, but it was accidentally removed
in kernel 3.6. This patch series corrects that, and now the sysfs hierarchy of
cx88 is OK again (tested with my cx88 blackbird card).

So this patch series no longer removed the parent field, it just renames it
so I can be sure the compiler catches any remaining usages of the parent field,
both for in and out-of-kernel drivers.

Regards,

        Hans

Changes since v1:

- Add check so v4l2_device_unregister will just return if it was already
  unregistered or was never registered in the first place.
- Call unregister as well in the error path of sn9c102, saa7164, f_uvc and
  omap24xxcam.
- Rename parent to dev_parent instead of removing it altogether.
- Set correct dev_parent in cx88.
- Update v4l2-framework.txt.

