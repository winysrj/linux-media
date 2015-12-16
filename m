Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60581 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753894AbbLPNes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:48 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v3 00/23] Unrestricted media entity ID range support
Date: Wed, 16 Dec 2015 15:32:15 +0200
Message-Id: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

This is the third version of the unrestricted media entity ID range
support set. I've taken Mauro's comments into account and fixed a number
of bugs as well (omap3isp memory leak and omap4iss stream start).

The more specific changes since v2 are here:

- Renamed struct media_entity_enum "entities" as ent_enum.

- Renamed struct media_entity_enum.e as bmap.

- Fix KernelDoc documentation

- Remove pre-allocated bitmap from entity enumerations. This is done in a
  separate patch due to API changes it necessitates. (Init may fail.)

- Drop MEDIA_ENTITY_ENUM_STACK_ALLOC. Move MEDIA_ENTITY_MAX_PADS to
  media-entity.c.

- Replace BUG_ON() in media_entity_pipeline_stop() by WARN_ON().

- Fix enumeration and graph walk init / cleanup in iss_video_streamon() in
  omap4iss driver.

v2 is available here:

<URL:http://www.spinics.net/lists/linux-media/msg95150.html>

The documentation remains unchanged so far.

-- 
Kind regards,
Sakari

