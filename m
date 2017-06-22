Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57142 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752272AbdFVOeR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 10:34:17 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 61BEB600B8
        for <linux-media@vger.kernel.org>; Thu, 22 Jun 2017 17:34:07 +0300 (EEST)
Date: Thu, 22 Jun 2017 17:27:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4.13] ov772x SCCB fix
Message-ID: <20170622142722.GH12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just a single patch --- the ov772x sensor uses SCCB, not plain I²C. Fix
this.

Please pull.

The following changes since commit 76724b30f222067faf00874dc277f6c99d03d800:

  [media] media: venus: enable building with COMPILE_TEST (2017-06-20 10:57:08 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.13-2

for you to fetch changes up to 9d2974697cd05d5a407f0dd0c5b6e47135b88cea:

  media: i2c: ov772x: Force use of SCCB protocol (2017-06-22 15:32:43 +0300)

----------------------------------------------------------------
Jacopo Mondi (1):
      media: i2c: ov772x: Force use of SCCB protocol

 drivers/media/i2c/soc_camera/ov772x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
