Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43947 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751224AbaLGXXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 18:23:43 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: aviv.d.greenberg@intel.com
Subject: [REVIEW PATCH v2 0/3] Packed raw bayer pixel format definition
Date: Mon,  8 Dec 2014 01:22:19 +0200
Message-Id: <1417994542-25826-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This set is actually just a patch from the previous set titled "data_offset
for single plane buffers, packed raw10", but as it appears, two clean-up
patches were needed before adding the format definition.

Since v1 the format definition has been cleaned up, especially there's no
mention of little endian and the order of lower order bits in the fifth byte
has been exactly specified.

-- 
Kind regards,
Sakari

