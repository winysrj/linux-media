Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34311 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751895AbbA0Kgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 05:36:52 -0500
Date: Tue, 27 Jan 2015 12:36:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [GIT FIXES FOR v3.19] smiapp compile fix for non-OF configuration
Message-ID: <20150127103649.GI17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The recent smiapp OF support patches contained a small issue related to
reading 64-bit numbers from the device tree, such that the compilation fails
if CONFIG_OF is undefined.

This patch provides a temporary fix to the matter. The proper one is to use
of_property_read_u64_array(), but that's currently not exported. I've
submitted a patch for that.

Please pull.


The following changes since commit e32b31ae45c18679c186e67aa41d0e2318cae487:

  [media] mb86a20s: remove unused debug modprobe parameter (2015-01-26 10:08:29 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-of-compile

for you to fetch changes up to 45fe24236dd638b170a7ca91a3aa0e9b2b153889:

  smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined (2015-01-27 12:18:49 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined

 drivers/media/i2c/smiapp/smiapp-core.c |    4 ++++
 1 file changed, 4 insertions(+)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
