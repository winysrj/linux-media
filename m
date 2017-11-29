Return-path: <linux-media-owner@vger.kernel.org>
Received: from PrakOutbound.VEHosting.nl ([85.17.51.155]:59693 "EHLO
        Prakkezator.VEHosting.nl" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933240AbdK2Pg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 10:36:26 -0500
From: Thomas van Kleef <thomas@vitsch.nl>
Subject: Re: [linux-sunxi] Cedrus driver
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1511969761-6608110782.e622897b62@prakkezator.vehosting.nl>
Message-ID: <cc728978-e723-289c-ec85-d2d27e937083@vitsch.nl>
Date: Wed, 29 Nov 2017 16:36:01 +0100
MIME-Version: 1.0
In-Reply-To: <20171128153533.ncqe4lkgjdzjiyuw@flea.home>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,
> 
> So there's a couple of issues with those patches (the pull request
> itself is fine though :))
> 
> I'll try to break them down as much as possible.
> 
> A) If you want to have proper commit logs, you will usually do two
>    things: first create a commit title, which is what appears in the
>    above summary. That commit title should not be longer than 72
>    characters, and it should explain roughly what you're trying to
>    do. The actual description should be in the commit log itself, and
>    you should document what is the issue you're trying to fix /
>    improve, how you're doing it and why you've done it that way.
Ah, so the pull-request commits are not proper, I will try do that from
now on. these last ones are quite bad.
> 
>    The final line of that commit log shoud be your Signed-off-by,
>    which is your agreement to the Developer Certificate of Origin
>    (DCO), that you'll find documented here:
>    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n429
> 
> B) Please base your work on a known release (4.14) and not the middle
>    of Linus' branch.
Should be fixed now.
> 
> C) I'm not sure what you tried to do with the application of the
>    request API patches (such as e1ca861c168f) but we want to have the
>    whole commits in there, and not a patch adding all of them. This
>    will make the work so much easier to rebase to a later version when
>    some patches wouldn't have been merged and some would have.
> 
> D) Rebase :)
Thank you. Giulio asked before if I could add a repo and commit the 
patches so that is what I did. I will push a different code where the
full history is present in commits.

So, I got it setup. As I did test it before on the slightly newer branch,
I did not verify, again, if the video-decoder worked on this specific 
state of the linux kernel, 4.14. But it should x:
If you rather wait for me to tell if it work let me know, but we could do
a pull request then again anyway.

So here is the new pull-request
The following changes since commit bebc6082da0a9f5d47a1ea2edc099bf671058bd4:

  Linux 4.14 (2017-11-12 10:46:13 -0800)

are available in the git repository at:

  https://github.com/thomas-vitsch/linux-a20-cedrus.git linux-sunxi-cedrus

for you to fetch changes up to 26701eca67a07ab002c7fd18038fa299b9589939:

  Fix the sun5i and sun8i dts files (2017-11-29 15:18:05 +0100)

----------------------------------------------------------------
Bob Ham (1):
      sunxi-cedrus: Fix compilation errors from bad types under GCC 6.2

Florent Revest (8):
      Both mainline and cedrus had added their own formats with both are added.
      v4l: Add MPEG2 low-level decoder API control
      v4l: Add MPEG4 low-level decoder API control
      media: platform: Add Sunxi Cedrus decoder driver
      sunxi-cedrus: Add a MPEG 2 codec
      sunxi-cedrus: Add a MPEG 4 codec
      sunxi-cedrus: Add device tree binding document
      ARM: dts: sun5i: Use video-engine node

Hans Verkuil (15):
      videodev2.h: add max_reqs to struct v4l2_query_ext_ctrl
      videodev2.h: add request to v4l2_ext_controls
      videodev2.h: add request field to v4l2_buffer.
      vb2: add allow_requests flag
      v4l2-ctrls: add request support
      v4l2-ctrls: add function to apply a request.
      v4l2-ctrls: implement delete request(s)
      v4l2-ctrls: add VIDIOC_REQUEST_CMD
      v4l2: add initial V4L2_REQ_CMD_QUEUE support
      vb2: add helper function to queue request-specific buffer.
      v4l2-device: keep track of registered video_devices
      v4l2-device: add v4l2_device_req_queue
      vivid: add request support for video capture.
      v4l2-ctrls: add REQ_KEEP flag
      Documentation: add v4l2-requests.txt

Icenowy Zheng (2):
      sunxi-cedrus: add syscon support
      ARM: dts: sun8i: add video engine support for A33

Thomas van Kleef (4):
      Merged requests2 into linux 4.14
      Fix merge error
      Remove reject file from merge
      Fix the sun5i and sun8i dts files

 .../devicetree/bindings/media/sunxi-cedrus.txt     |  44 ++
 Documentation/video4linux/v4l2-requests.txt        | 233 ++++++++
 arch/arm/boot/dts/sun5i-a13-difrnce-dit4350.dts    |  50 --
 arch/arm/boot/dts/sun5i-a13.dtsi                   |  30 ++
 arch/arm/boot/dts/sun8i-a33.dtsi                   |  39 ++
 drivers/media/platform/Kconfig                     |  13 +
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/sunxi-cedrus/Makefile       |   4 +
 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c | 285 ++++++++++
 .../platform/sunxi-cedrus/sunxi_cedrus_common.h    | 104 ++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c | 588 +++++++++++++++++++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.h |  33 ++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.c  | 180 +++++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |  39 ++
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c     | 152 ++++++
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c     | 140 +++++
 .../platform/sunxi-cedrus/sunxi_cedrus_regs.h      | 170 ++++++
 drivers/media/platform/vivid/vivid-core.c          |   2 +
 drivers/media/platform/vivid/vivid-ctrls.c         |   4 +
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   2 +
 drivers/media/usb/cpia2/cpia2_v4l.c                |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               | 460 ++++++++++++++--
 drivers/media/v4l2-core/v4l2-dev.c                 |   9 +
 drivers/media/v4l2-core/v4l2-device.c              |  28 +
 drivers/media/v4l2-core/v4l2-ioctl.c               | 121 ++++-
 drivers/media/v4l2-core/v4l2-subdev.c              |  78 ++-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  28 +
 include/media/v4l2-ctrls.h                         |  45 +-
 include/media/v4l2-dev.h                           |   3 +
 include/media/v4l2-device.h                        |   6 +
 include/media/v4l2-fh.h                            |   4 +
 include/media/videobuf2-core.h                     |   3 +
 include/media/videobuf2-v4l2.h                     |   3 +
 include/uapi/linux/v4l2-controls.h                 |  68 +++
 include/uapi/linux/videodev2.h                     |  41 +-
 36 files changed, 2883 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt
 create mode 100644 Documentation/video4linux/v4l2-requests.txt
 delete mode 100644 arch/arm/boot/dts/sun5i-a13-difrnce-dit4350.dts
 create mode 100644 drivers/media/platform/sunxi-cedrus/Makefile
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_regs.h

> 
> Thanks!
> Maxime
> 



Thomas van Kleef
Vitsch Electronics
http://Vitsch.nl/
http://VitschVPN.nl/
tel: +31-(0)40-7113051
KvK nr: 17174380
BTW nr: NL142748201B01
-- 
Machines en netwerken op afstand beheren? Vitsch VPN oplossing!
Kijk voor meer informatie op: http://www.VitschVPN.nl/
