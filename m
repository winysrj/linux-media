Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43595 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751759AbaLOPmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 10:42:08 -0500
Date: Mon, 15 Dec 2014 17:41:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: aviv.d.greenberg@intel.com
Subject: [GIT PULL FOR v3.20] 10-bit packed raw bayer format support
Message-ID: <20141215154129.GD17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches make minor cleanups in raw bayer format documentation and
finally add a definition for 10-bit packed raw bayer formats.

Please pull.

The following changes since commit e272d95f8c0544cff55c485a10828b063c8e417c:

  [media] rcar_vin: Fix interrupt enable in progressive (2014-12-12 10:29:40 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git srggb10p

for you to fetch changes up to 84e49381d980c2188e660b684d9e1770d9154ff6:

  v4l: Add packed Bayer raw10 pixel formats (2014-12-15 17:36:19 +0200)

----------------------------------------------------------------
Aviv Greenberg (1):
      v4l: Add packed Bayer raw10 pixel formats

Sakari Ailus (2):
      DocBook: v4l: Fix raw bayer pixel format documentation wording
      DocBook: v4l: Rearrange raw bayer format definitions, remove bad comment

 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10p.xml          |   99 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml |    2 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 include/uapi/linux/videodev2.h                     |   17 ++--
 7 files changed, 113 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
