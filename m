Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50729 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750953AbeAUKqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 05:46:50 -0500
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: atomisp and g/s_parm
Message-ID: <fdb4a3df-e7fa-9197-a64a-02be81b548bd@xs4all.nl>
Date: Sun, 21 Jan 2018 11:46:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I looked a bit closer at how atomisp uses g/s_parm. They abuse the capturemode field
to select video/preview/still modes on the sensor, which actually changes the list
of supported resolutions.

The following files use this:

i2c/atomisp-gc0310.c
i2c/atomisp-gc2235.c
i2c/atomisp-ov2680.c
i2c/atomisp-ov2722.c
i2c/ov5693/atomisp-ov5693.c
pci/atomisp2/atomisp_file.c
pci/atomisp2/atomisp_tpg.c

The last two have a dummy g/s_parm implementation, so are easy to fix.
The gc0310 and 0v2680 have identical resolution lists for all three modes, so
the capturemode can just be ignored and these two drivers can be simplified.

Looking at the higher level code it turns out that this atomisp driver appears
to be in the middle of a conversion from using s_parm to a V4L2_CID_RUN_MODE
control. If the control is present, then that will be used to set the mode,
otherwise it falls back to s_parm.

So the best solution would be if Intel can convert the remaining drivers from
using s_parm to the new control and then drop all code that uses s_parm to do
this, so g/s_parm is then only used to get/set the framerate.

Is this something you or a colleague can take on?

Regards,

	Hans
