Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2087 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3FXIyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 04:54:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Samsung i2c subdev drivers that set sd->name
Date: Mon, 24 Jun 2013 10:54:11 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306241054.11604.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

It came to my attention that several i2c subdev drivers overwrite the sd->name
as set by v4l2_i2c_subdev_init with a custom name.

This is wrong if it is possible that there are multiple identical sensors in
the system. The sd->name must be unique since it is used to prefix kernel
messages etc, so you have to be able to tell the sensor devices apart.

It concerns the following Samsung-contributed drivers:

drivers/media/i2c/s5k4ecgx.c:   strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strcpy(oif_sd->name, "S5C73M3-OIF");
drivers/media/i2c/sr030pc30.c:  strcpy(sd->name, MODULE_NAME);
drivers/media/i2c/noon010pc30.c:        strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
drivers/media/i2c/m5mols/m5mols_core.c: strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
drivers/media/i2c/s5k6aa.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));

If there can be only one sensor (because it is integrated in the SoC),
then there is no problem with doing this. But it is not obvious to me
which of these drivers are for integrated systems, and which aren't.

I can make patches for those that need to be fixed if you can tell me
which drivers are affected.

Regards,

	Hans
