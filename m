Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47178
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbcGTTCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 15:02:47 -0400
Date: Wed, 20 Jul 2016 16:02:42 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Documentation issues with some MBUS flags
Message-ID: <20160720160242.00e0365e@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester/Sakari,

While checking the docs for the V4L2 framework, I noticed something weird
Related to those two flags:

#define V4L2_MBUS_FRAME_DESC_FL_LEN_MAX                (1U << 0)
#define V4L2_MBUS_FRAME_DESC_FL_BLOB           (1U << 1)

They were originally introduced by this changeset:

commit 291031192426bfc6ad4ab2eb9fa986025a926598
Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date:   Thu May 17 14:33:30 2012 -0300

    [media] V4L: Add [get/set]_frame_desc subdev callbacks
    
    Add subdev callbacks for setting up parameters of the frame on media bus
    that are not exposed to user space directly. This is just an initial,
    mostly stub implementation. struct v4l2_mbus_frame_desc is intended
    to be extended with sub-structures specific to a particular hardware media
    bus. For now these new callbacks are used only to query or specify maximum
    size of a compressed or hybrid (container) media bus frame in octets.
    
    Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

And the comments were modified by this one:

commit 174d6a39b07f51212c23a8e30a0440598d18392c
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Wed Dec 18 08:40:28 2013 -0300

    [media] v4l: V4L2_MBUS_FRAME_DESC_FL_BLOB is about 1D DMA
    
    V4L2_MBUS_FRAME_DESC_FL_BLOB intends to say the receiver must use 1D DMA to
    receive the image, as the format does not have line offsets. This typically
    includes all compressed formats.
    
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

The problem is that the description of V4L2_MBUS_FRAME_DESC_FL_LEN_MAX
says that:
	Indicates the @length field specifies maximum data length.

But the description of the @length field says otherwise:
	* @length: number of octets per frame, valid if V4L2_MBUS_FRAME_DESC_FL_BLOB

So, I decided to take a look on what the heck is that:

	$ git grep V4L2_MBUS_FRAME_DESC_FL_BLOB
	include/media/v4l2-subdev.h:#define V4L2_MBUS_FRAME_DESC_FL_BLOB                (1U << 1)
	include/media/v4l2-subdev.h: *                    %V4L2_MBUS_FRAME_DESC_FL_BLOB.
	include/media/v4l2-subdev.h: * @length: number of octets per frame, valid if V4L2_MBUS_FRAME_DESC_FL_BLOB

(nobody is using it)

And:

	$ git grep V4L2_MBUS_FRAME_DESC_FL_LEN_MAX
	drivers/media/i2c/m5mols/m5mols_core.c: fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_LEN_MAX;
	drivers/media/i2c/m5mols/m5mols_core.c: fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_LEN_MAX;
	include/media/v4l2-subdev.h:#define V4L2_MBUS_FRAME_DESC_FL_LEN_MAX             (1U << 0)

Only one driver is using it.

So, I'm thinking if are there any reason why to keep the
V4L2_MBUS_FRAME_DESC_FL_BLOB, and what's the expected behavior
when V4L2_MBUS_FRAME_DESC_FL_LEN_MAX is found.

Could you shed some light?

Thanks!
Mauro

Thanks,
Mauro
