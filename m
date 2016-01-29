Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36326 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752537AbcA2WWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 17:22:48 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id EAAC5600A1
	for <linux-media@vger.kernel.org>; Sat, 30 Jan 2016 00:22:44 +0200 (EET)
Date: Sat, 30 Jan 2016 00:22:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.6] v4l2-common.h header license change
Message-ID: <20160129222214.GM14876@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the license change for v4l2-common.h. No other patches.

Please pull.


The following changes since commit 768acf46e1320d6c41ed1b7c4952bab41c1cde79:

  [media] rc: sunxi-cir: Initialize the spinlock properly (2015-12-23 15:51:40 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-common-copyright

for you to fetch changes up to dae5aa705b397e1023173f2290a3807f448259ac:

  media: v4l: Dual license v4l2-common.h under GPL v2 and BSD licenses (2016-01-14 12:50:58 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      media: v4l: Dual license v4l2-common.h under GPL v2 and BSD licenses

 include/uapi/linux/v4l2-common.h | 46 ++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
