Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39062 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751692AbbDPXUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 19:20:18 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 6C2E160093
	for <linux-media@vger.kernel.org>; Fri, 17 Apr 2015 02:20:14 +0300 (EEST)
Date: Fri, 17 Apr 2015 02:20:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.2] Improved V4L2 of endpoint interface with
 link-frequencies
Message-ID: <20150416232013.GJ27451@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are patches to

- add a new interface for parsing variable sized property arrays (the old
  v4l2_of_parse_endpoint() could be removed later on),
- parse the link-frequencies endpoint property and
- use the above in the smiapp driver.

Please pull.

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-of-array

for you to fetch changes up to 4df51de61c33aa3e739230704d18eb08415b739e:

  smiapp: Use v4l2_of_alloc_parse_endpoint() (2015-04-17 00:36:27 +0300)

----------------------------------------------------------------
Sakari Ailus (4):
      v4l: of: Remove the head field in struct v4l2_of_endpoint
      v4l: of: Instead of zeroing bus_type and bus field separately, unify this
      v4l: of: Parse variable length properties --- link-frequencies
      smiapp: Use v4l2_of_alloc_parse_endpoint()

 drivers/media/i2c/smiapp/smiapp-core.c |   38 +++++++------
 drivers/media/v4l2-core/v4l2-of.c      |   92 +++++++++++++++++++++++++++++++-
 include/media/v4l2-of.h                |   20 ++++++-
 3 files changed, 126 insertions(+), 24 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
