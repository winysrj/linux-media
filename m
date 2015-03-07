Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34011 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751445AbbCGX3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 18:29:09 -0500
Date: Sun, 8 Mar 2015 01:29:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [GIT PULL v2 for v4.1] smiapp DT u64 property workaround removal
Message-ID: <20150307232906.GG6539@valkosipuli.retiisi.org.uk>
References: <20150307220634.GD6539@valkosipuli.retiisi.org.uk>
 <1573085.ZVIDUf0yP4@avalon>
 <20150307232040.GF6539@valkosipuli.retiisi.org.uk>
 <2889029.OECMz0WOKz@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2889029.OECMz0WOKz@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request reverts the smiapp driver's u64 array DT property read
workaround, and uses of_property_read_u64_array() which is the correct API
function for reading u64 arrays from DT.

since v1:

Based on a discussion with Laurent, I merged the two patches. The commit
message of the second patch remains the same while it includes the revert.

Please pull.


The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/smiapp-dt-2

for you to fetch changes up to e70a7fb677087253b83119ec3033e58a5720f97a:

  smiapp: Use of_property_read_u64_array() to read a 64-bit number array (2015-03-08 01:22:48 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      smiapp: Use of_property_read_u64_array() to read a 64-bit number array

 drivers/media/i2c/smiapp/smiapp-core.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
