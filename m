Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49668 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663AbbCVL6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 07:58:31 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id BE93C60093
	for <linux-media@vger.kernel.org>; Sun, 22 Mar 2015 13:58:27 +0200 (EET)
Date: Sun, 22 Mar 2015 13:58:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.1] smiapp OF fixes
Message-ID: <20150322115827.GL16613@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The three patches contain first two cleanups and finally move the
reading of link-frequencies property from the endpoint node where it is
actually located.

I've left the patch that adds link-frequencies reading to the V4L2 OF code
out for it isn't necessary to get it in now. There will most likely be a few
more versions of that.

Please pull.


The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-of-fix

for you to fetch changes up to 88458f8114b33627c23ef5e4b664b412d1db1591:

  smiapp: Read link-frequencies property from the endpoint node (2015-03-22 13:50:11 +0200)

----------------------------------------------------------------
Sakari Ailus (3):
      smiapp: Use of_property_read_u64_array() to read a 64-bit number array
      smiapp: Clean up smiapp_get_pdata()
      smiapp: Read link-frequencies property from the endpoint node

 drivers/media/i2c/smiapp/smiapp-core.c |   36 +++++++-------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
