Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56977 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755348Ab3AMWn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 17:43:57 -0500
Message-ID: <50F3396E.2010505@iki.fi>
Date: Mon, 14 Jan 2013 00:47:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [media-ctl PATCH 0/3] Reference counting to subdev file handles and
 media bus code enumeration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset adds reference counting to subdev file handles, which
leaves it up to the user whether to keep the file handles open and thus
the devices powered.

Media bus code enumeration is added by the two latter patches of which
the second one makes the result sorted by codes.

Sakari Ailus (3):
      Count users for entities
      Implement v4l2_subdev_enum_mbus_code()
      Sort enumerated media bus codes

 src/mediactl.c   |    1 -
 src/mediactl.h   |    1 +
 src/v4l2subdev.c |  154
+++++++++++++++++++++++++++++++++++++++++++++---------
 src/v4l2subdev.h |   32 ++++++++++--
 4 files changed, 158 insertions(+), 30 deletions(-)

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
