Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52941 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753389AbaKHXFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:05:17 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 0/3] Add V4L2_SEL_TGT_NATIVE_SIZE target
Date: Sun,  9 Nov 2014 01:04:29 +0200
Message-Id: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This small set cleans up sub-device format documentation --- the
documentation noted the source format is used to configure scaling, which
was contradicting what was said right after on the selections on
sub-devices. This part was written before the selections interface.

The two latter patches create a V4L2_SEL_TGT_NATIVE_SIZE target which is
used in the smiapp driver. The CROP_BOUNDS target is still supported as
compatibility means.

-- 
Kind regards,
Sakari
