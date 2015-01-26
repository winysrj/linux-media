Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbbAZMr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 07:47:27 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Media controller changes to support DVB
Date: Mon, 26 Jan 2015 10:47:09 -0200
Message-Id: <cover.1422273497.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series change the media controller API to allow adding
support for DVB media controller support.

I removed the actual implementation from this series, in order to
better identify the API bits required to add media controller support
to DVB. They'll be sent o a separate patch series, after we agree
with the API needs.

If this gets accepted, the other patches will be basically the ones
already sent at:
	https://www.mail-archive.com/linux-media@vger.kernel.org/msg83895.html

With one small change at the patch that adds media controller support
at dvbdev, replacing "info.dvb" by "info.dev", due to a change at the
media controller's representation for all devnodes.

As a reference, a typical analog/digital TV hardware looks like:
	http://linuxtv.org/downloads/presentations/typical_hybrid_hardware.png

And the media controller representation for it is:
	http://linuxtv.org/downloads/presentations/cx231xx.dot
	http://linuxtv.org/downloads/presentations/cx231xx.ps

The full patch series with the DVB controller implementation is at:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=dvb-media-ctl

Mauro Carvalho Chehab (3):
  media: Fix ALSA and DVB representation at media controller API
  media: add new types for DVB devnodes
  media: add a subdev type for tuner

 drivers/media/v4l2-core/v4l2-dev.c    |  4 ++--
 drivers/media/v4l2-core/v4l2-device.c |  4 ++--
 include/media/media-entity.h          | 12 +-----------
 include/uapi/linux/media.h            | 26 +++++++++++++++++++++++++-
 4 files changed, 30 insertions(+), 16 deletions(-)

-- 
2.1.0

