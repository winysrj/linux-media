Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53088 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753430AbaLIAEt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 19:04:49 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com
Subject: [REVIEW PATCH v3 00/12] smiapp OF support
Date: Tue,  9 Dec 2014 02:04:08 +0200
Message-Id: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patchset adds support for Device tree in the smiapp driver. Platform
data support is retained as well. The actual DT related changes are
prepended by a few simple cleanups.

A new link-frequency property is defined in video-interfaces.txt, as this is
hardly something which is specific to the SMIA compliant sensors.

since v2:

- patch 8 (now 9) "of: smiapp: Add documentation":

	- Cleanups                                                                      

	- Removed clock-names property documentation

	- Port node documentation was really endpoint node documentation

	- Added remote-endpoint as mandatory endpoint node properties

	- Rename link-frequency property as link-frequencies

	- Removed clock-names property from the DT example

	- Fix clock property documentation

- Use struct smiapp_sensor pointer as an argument to many functions, instead
  of struct v4l2_subdev pointer. This modifies patch "smiapp: Fully probe
  the device in probe".

- smiapp_subdev_{init,cleanup} renamed as smiapp_{init,cleanup} (same patch)

- Remove redundant sub-device name change, patch "smiapp: Don't give the
  source sub-device a temporary name" added to the set.

since v1:

- Only use dev->of_node to determine whether the OF node is there.

- Add clock-lanes and data-lanes properties to mandatory properties list in
  documentation.

- Add a patch to include include/uapi/linux/smiapp.h in MAINTAINERS section
  for the smiapp driver.

-- 
Kind regards,
Sakari

