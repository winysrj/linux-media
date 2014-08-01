Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40725 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754155AbaHAMnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 08:43:35 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 299FC60093
	for <linux-media@vger.kernel.org>; Fri,  1 Aug 2014 15:43:32 +0300 (EEST)
Date: Fri, 1 Aug 2014 15:42:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.17] smiapp: use unlocked control functions
Message-ID: <20140801124258.GX16460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set makes use of unlocked controls functions in the smiapp driver.
Please pull.

The following changes since commit 27dcb00d0dc1d532b0da940e35a6d020ee33bd47:

  [media] radio-miropcm20: fix sparse NULL pointer warning (2014-07-30 19:50:09 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git unlocked-ctrls

for you to fetch changes up to c2685f81e4d37ab93523a20246b95a63e47d7fcc:

  smiapp: Set 64-bit integer control using v4l2_ctrl_s_ctrl_int64() (2014-08-01 12:27:42 +0300)

----------------------------------------------------------------
Sakari Ailus (2):
      smiapp: Use unlocked __v4l2_ctrl_modify_range()
      smiapp: Set 64-bit integer control using v4l2_ctrl_s_ctrl_int64()

 drivers/media/i2c/smiapp/smiapp-core.c |   56 +++++++++++++-------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
