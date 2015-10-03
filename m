Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:30853 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbbJCOoe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2015 10:44:34 -0400
Date: Sat, 3 Oct 2015 16:44:28 +0200
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: gspca/ov534 gets two failures with v4l2-compliance
Message-Id: <20151003164428.1dbf4e95936e6e4e62aabb37@ao2.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I tried running v4l2-compliance with the PS3 Eye and I got these two
failures:

...
Test input 0:
        ...
        Format ioctls:
                fail: v4l2-test-formats.cpp(122): found frame intervals for invalid size 321x240
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: v4l2-test-formats.cpp(425): unknown pixelformat 56595559 for buftype 1
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK (Not Supported)
                test Composing: OK (Not Supported)
                test Scaling: OK

About the first failure: by looking at the kernel code in gspca.c it
looks like the supported frame sizes are declared as
V4L2_FRMSIZE_TYPE_DISCRETE in vidioc_enum_framesizes(), but then the
driver accepts invalid ones when listing frameintervals trying to find
the "closest" size for width and height using wxh_to_mode().

Can this discrepancy be what makes v4l2-compliance fail?

If you think it's OK to change the gspca behavior to be stricter about
what frame sizes are considered valid, I may take a shot at it.

By looking at the v4l2-compliance code I think the second failure will
go away once the first one is fixed: node->buftype_pixfmts does not get
populated because of the first failure.

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
