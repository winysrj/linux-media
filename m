Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbLLNlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 08:41:01 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/6] Documentation patches for the MC next gen
Date: Sat, 12 Dec 2015 11:40:39 -0200
Message-Id: <cover.1449927561.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those patches complete the kernel-doc for the dvbdev changes and documents the
uAPI defined by the media controller next generation.

Mauro Carvalho Chehab (6):
  dvbdev: Document the new MC-related fields
  [media] DocBook: MC: add the concept of interfaces
  [media] DocBook: move data types to a separate section
  [media] Docbook: media-types.xml: update the existing tables
  [media] DocBook: add a table for Media Controller interfaces
  [media] DocBook: Document MEDIA_IOC_G_TOPOLOGY

 .../DocBook/media/v4l/media-controller.xml         |  44 ++-
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  | 104 ------
 .../DocBook/media/v4l/media-ioc-enum-links.xml     |  56 ---
 .../DocBook/media/v4l/media-ioc-g-topology.xml     | 391 +++++++++++++++++++++
 Documentation/DocBook/media/v4l/media-types.xml    | 240 +++++++++++++
 drivers/media/dvb-core/dvbdev.h                    |  12 +-
 6 files changed, 671 insertions(+), 176 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
 create mode 100644 Documentation/DocBook/media/v4l/media-types.xml

-- 
2.5.0


