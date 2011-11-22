Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1KVF0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 00:26:53 -0500
Received: by iage36 with SMTP id e36so8242144iag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 21:26:52 -0800 (PST)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: mingchen@quicinc.com, hverkuil@xs4all.nl,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH/RFC v1 0/2] app_offset field for plane format
Date: Mon, 21 Nov 2011 21:26:35 -0800
Message-Id: <1321939597-6239-1-git-send-email-pawel@osciak.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
At the Media Workshop during the Linux Kernel Summit we discussed the need for an additional field in the plane format struct, which we named the 'app_offset'.
This field is intended to allow userspace to reserve a piece of memory at the very beginning of the plane that would be guaranteed not to be touched by kernel or hardware (apart from zeroing it out on allocation, if done by the kernel). This field could be used to store information that would be useful after the buffer has been processed, for example if the buffer were to be passed to another thread/process/module or to different hardware (in pipelines).
There already exists a similar field in the plane format struct - data_offset, which should not be confused with this field. Memory reserved using data_offset can be filled by both userspace (for OUTPUT buffers) and driver/hardware (for CAPTURE buffers) and is intended to contain metadata related to the image data stored in the buffer and generated together with it, such as headers, etc. Memory reserved using app_offset, on the other hand, is intended for use solely by userspace and is a way to attach additional information to be read/passed along after the buffer is dequeued and there is no difference in its handling for OUTPUT and CAPTURE types (i.e. just passing it to the driver so it can skip enough memory at the beginning of the buffer).
app_offset is to be added to the data_offset, i.e. each plane looks like this:

|<-- app_offset -->|<-- data_offset -->|<-- image data -->|

Regards,
Pawel Osciak

Pawel Osciak (2):
  media: Add app_offset field to the v4l2_plane structure
  vb2: add support for app_offset field of the v4l2_plane struct

 Documentation/DocBook/media/v4l/io.xml    |   21 ++++++++++++++++++++-
 drivers/media/video/v4l2-compat-ioctl32.c |   11 ++++++++---
 drivers/media/video/v4l2-ioctl.c          |   10 ++++++----
 drivers/media/video/videobuf2-core.c      |    5 +++++
 include/linux/videodev2.h                 |   18 ++++++++++++++++--
 5 files changed, 55 insertions(+), 10 deletions(-)

-- 
1.7.7.3

