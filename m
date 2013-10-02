Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51769 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753629Ab3JBXLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 19:11:06 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, laurent.pinchart@ideasonboard.com,
	a.hajda@samsung.com
Subject: [PATCH v2 0/4] Add MEDIA_PAD_FL_MUST_CONNECT pad flag, check it
Date: Thu,  3 Oct 2013 02:17:49 +0300
Message-Id: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the second version of the patchset that adds a new media pad flag to
denote that the pad must be connected by an enabled link for the entity to
be able to stream.

The previous version of the set is available here:

<URL:http://www.spinics.net/lists/linux-media/msg68105.html>

What has changed is

- Indentation of the pad flags for the omap3isp driver and assignment of pad
  in media_entity_pipeline_start() and

- Improved the pad flag documentation.

Laurent: unless there further comments to the patches, could you take them
to your tree as they contain changes to the Media controller framework and
the omap3isp driver?

-- 
Kind regards,
Sakari

