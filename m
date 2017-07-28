Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47416 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751159AbdG1H1F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 03:27:05 -0400
To: linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] v2: Use LINUX_VERSION_CODE for media versioning
Message-ID: <472fa50d-9796-5445-912f-74d7316b6e01@xs4all.nl>
Date: Fri, 28 Jul 2017 09:27:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a little thing that always annoyed me: the driver_version shouldn't
be set in drivers.

The version number never, ever gets updated in drivers. We saw that in
the other media subsystems and now the core always sets it, not drivers.

This works much better, and also works well when backporting the media
code to an older kernel using the media_build system, where the driver
version is set to the kernel version you are backporting from.

So just set the driver_version in media_device_get_info() to
LINUX_VERSION_CODE and drop the driver_version field from struct
media_device.

In addition do the same with media_version, that too is never updated
when it should.

Regards,

	Hans

Changes since v1:

- Dropped a change to Documentation/media/uapi/v4l/extended-controls.rst
   that accidentally ended up in the previous pull request.

The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

   media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git mc-version

for you to fetch changes up to 590a9c978c0fd8a58580e58245f1187d676a6f54:

   media: drop use of MEDIA_API_VERSION (2017-07-28 09:16:51 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
       media-device: set driver_version directly
       s3c-camif: don't set driver_version
       uvc: don't set driver_version
       atomisp2: don't set driver_version
       media-device: remove driver_version
       media: drop use of MEDIA_API_VERSION

  Documentation/media/uapi/v4l/extended-controls.rst        | 26 +++++++++++++-------------
  drivers/media/media-device.c                              |  7 ++-----
  drivers/media/platform/s3c-camif/camif-core.c             |  1 -
  drivers/media/usb/uvc/uvc_driver.c                        |  1 -
  drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c |  6 +-----
  include/media/media-device.h                              |  7 -------
  include/uapi/linux/media.h                                |  5 +++--
  7 files changed, 19 insertions(+), 34 deletions(-)
