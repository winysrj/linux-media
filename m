Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43518 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359Ab1GDRzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 04 Jul 2011 19:54:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 0/19] s5p-fimc driver conversion to media controller and
 control framework
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

following is a third version of a patchset converting s5p-fimc driver 
to the media controller API and control framework.

Except fixing minor bugs in the sensor registration code, the first patch
adding power management support has been significantly reworked. 
There is no yet support for a per frame power gating, I'd like to add
it in 3.2 as it seem to require modfications of v4l-mem2mem framework.

I'd like to get this patchset in v3.1, unless there are any issues pointed out. 

The changeset can be pulled from (within a few hours from now, after the
repository synchronisation cron job runs):

http://git.infradead.org/users/kmpark/linux-2.6-samsung
branch: s5p-fimc-next

Changes since v2:
- reworked (runtime) power management;
- added pm_runtime_get_sync/pm_runtime_put around sensor registration
  code so the clock for sensors is enabled during host driver's probe();
- reworked try_crop operation handler to support multiple of the prescaler
  ratio relationship constraint for format at the sink pad;
- corrected fimc_md_unregister_entities() function


Below is an original cover letter of v2.

-----------------------------------------------------------------------------
In this version the ioctl handlers for format setting at the video node and
the FIMC subdev has been reworked so they use common functions for capture
data format adjustment to the hardware capabilities. This prevent trouble
from any differences in handling ioctls at the subdev and the video node
when those are used simultaneously.

Except that I have killed a few bugs that jumped out when the driver was tried
to be used as a kernel module. 

Additionally to allow the driver to be used in V4L2 video node compatibility
mode (when sensor subdev is configured by the host driver rather that directly
by the applications through /dev/v4l-subdev*) a sysfs entry is added.
All that needs to be done to disable sensors configuration from /dev/video*
node level, in order to use sub-device user space API, is to write correct
string to s5p-fimc-md platform device "subdev_conf_mode" sysfs entry, e.g.

echo sub-dev > /sys/devices/platform/s5p-fimc-md/subdev_conf_mode
or to revert:
echo vid-dev > /sys/devices/platform/s5p-fimc-md/subdev_conf_mode

The following procedure is adopted for format and crop/composition
configuration at the FIMC.{n} (capture) subdevs:

1) set format at sink pad (this will reset sink crop rectangle)
2) set crop rectangle at sink pad (optional)
3) set rotate control (optional)
4) set crop (composition) at source pad (optional). Here scaling constraints
   are checked according to whether sink pad crop has been set or not and
   whether 90/270 deg rotation is set.
5) set format at source pad
6) set format at corresponding video node

Rotation can also be changed while streaming, in this case when 90/270 deg
rotation is attempted to be set and scaling bounds are exceeded 
(max. 64x downscaling) s_ctrl returns EINVAL.

I have tried this driver with v4l-compliance and it returned only 1 fail
on S/G_PRIORITY.
								
This patch set depends on my previous s5p-fimc bugfixes, available at: 
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/s5p-fimc

as well as the control framework updates from Hans Verkuil:
http://www.spinics.net/lists/linux-media/msg33552.html
(patch 1...6, 8, 11).

Full source tree can be found at:
 http://git.infradead.org/users/kmpark/linux-2.6-samsung
 branch: s5p-fimc-next

I have skipped patch one patch in this series comparing to first version:
s5p-fimc: Add support for runtime PM in the mem-to-mem driver
This patch is available in the above git repository. 
I need to work a bit more on that one.

Comments and suggestions are welcome!
------------------------------------------------------------------------------


Thanks,
--
Sylwester Nawrocki
Samsung Poland R&D Center

