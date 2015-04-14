Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46621 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbDNTo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2015 15:44:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-api@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
Date: Tue, 14 Apr 2015 22:44:47 +0300
Message-Id: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The v4l2_plane data_offset field has been introduced at the same time as the
the multiplane API to convey header size information between kernelspace and
userspace.

The API then became slightly controversial, both because different developers
understood the purpose of the field differently (resulting for instance in an
out-of-tree driver abusing the field for a different purpose), and because of
competing proposals (see for instance "[RFC] Multi format stream support" at
http://www.spinics.net/lists/linux-media/msg69130.html).

Furthermore, the data_offset field isn't used by any mainline driver except
vivid (for testing purpose).

I need a different data offset in planes to allow data capture to or data
output from a userspace-selected offset within a buffer (mainly for the
DMABUF and MMAP memory types). As the data_offset field already has the
right name, is unused, and ill-defined, I propose repurposing it. This is what
this RFC is about.

If the proposal is accepted I'll add another patch to update data_offset usage
in the vivid driver.

Laurent Pinchart (2):
  v4l: Repurpose the v4l2_plane data_offset field
  videobuf2: Repurpose the v4l2_plane data_offset field

 Documentation/DocBook/media/v4l/io.xml   | 19 +++++++------
 drivers/media/v4l2-core/videobuf2-core.c | 46 +++++++++++++++++++++++---------
 include/media/videobuf2-core.h           |  4 +++
 include/media/videobuf2-dma-contig.h     |  2 +-
 include/uapi/linux/videodev2.h           |  6 +++--
 5 files changed, 54 insertions(+), 23 deletions(-)

-- 
Regards,

Laurent Pinchart

