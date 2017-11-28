Return-path: <linux-media-owner@vger.kernel.org>
Received: from PrakOutbound.VEHosting.nl ([85.17.51.155]:62661 "EHLO
        Prakkezator.VEHosting.nl" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751982AbdK1Ov2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 09:51:28 -0500
Subject: Re: [linux-sunxi] Cedrus driver
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1511880674-3399460038.fc60fb9a7b@prakkezator.vehosting.nl>
From: Thomas van Kleef <thomas@vitsch.nl>
Message-ID: <54da46c6-48d1-544c-1379-d8e4d1aad089@vitsch.nl>
Date: Tue, 28 Nov 2017 15:51:14 +0100
MIME-Version: 1.0
In-Reply-To: <20171128122648.akxe7ro2mxmliedw@flea.home>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28-11-17 13:26, Maxime Ripard wrote:
> On Tue, Nov 28, 2017 at 12:20:59PM +0100, Thomas van Kleef wrote:
>>> So, I have been rebasing to 4.14.0 and have the cedrus driver working.
>> I have pulled linux-mainline 4.14.0. Then pulled the requests2 branch from Hans
>> Verkuil's media_tree. I have a patch available of the merge between these 2
>> branches.
>> After this I pulled the sunxi-cedrus repository from Florent Revests github. I
>> believe this one is the same as the ones you are cloning right now.
>> I have merged this and have a patch available for this as well.
>>
>> So to summarize:
>>  o pulled linux 4.14 from:
>>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>  o pulled requests2 from:
>>     https://git.linuxtv.org/hverkuil/media_tree.git?h=requests2
>>     will be replaced with the work, when it is done, in:
>>      https://git.linuxtv.org/hverkuil/media_tree.git?h=ctrl-req-v2
>>  o pulled linux-sunxi-cedrus from:
>>     https://github.com/FlorentRevest/linux-sunxi-cedrus
>>
>>  o merged and made patch between linux4.14 and requests2
>>  o merged and made patch with linux-sunxi-cedrus
>>  o Verified that the video-engine is decofing mpeg-2 on the Allwinner A20.
>>
>> So maybe if someone is interested in this, I could place the patches somewhere?
>> Just let me know.
> 
> Please create a pull request on the github repo. The point we set it
> up was to share code. Forking repos and so on is kind of pointless.
> 
So, I started with linux-mainline 4.14 and created a pull request with that commit.
Never made one before so if I did something wrong tell me.

The following changes since commit e1d1ea549b57790a3d8cf6300e6ef86118d692a3:

  Merge tag 'fbdev-v4.15' of git://github.com/bzolnier/linux (2017-11-20 21:50:24 -1000)

are available in the git repository at:

  https://github.com/thomas-vitsch/linux-a20-cedrus.git 

for you to fetch changes up to 508ad12eb737fde07f4a25446ed941a01480d6dc:

  Merge branch 'master' of https://github.com/thomas-vitsch/linux-a20-cedrus into linux-sunxi-cedrus-a20 (2017-11-28 15:28:18 +0100)

----------------------------------------------------------------
Bob Ham (1):
      sunxi-cedrus: Fix compilation errors from bad types under GCC 6.2

Florent Revest (8):
      cherry-pick sunxi_cedrus
      cherry-pick sunxi_cedrus
      v4l: Add MPEG4 low-level decoder API control
      media: platform: Add Sunxi Cedrus decoder driver
      sunxi-cedrus: Add a MPEG 2 codec
      sunxi-cedrus: Add a MPEG 4 codec
      sunxi-cedrus: Add device tree binding document
      cherry-pick sunxi_cedrus

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
      cherry-pick sunxi_cedrus

Thomas van Kleef (11):
      Appears that the requests2 API is currently based on linux 3.9 :(. Made some changes that needed to be merged manually, let's hope I did not make to many errors
      Fixed last missing calls for a buildable kernel with the requests2 API. Tested with a mock mem2mem device which selects the VIDEOBUF2_CORE.
      Kconfig option used to enable the VIDEOBUF2_CORE
      Fix sun5i-a13 merge errors. Mainline has moved some device nodes which resulted in nodes existing multiple times in device trees.
      o Added reserved memory region for the video-engine.     o Added device node for the video engine.
      style commit
      Apply patch which adds requests2 branch from media-tree:     https://git.linuxtv.org/hverkuil/media_tree.git?h=requests2
      Apply patch which adds linux-sunxi-cedrus from: https://github.com/FlorentRevest/sunxi-cedrus-drv-video
      Add reserved region and video-engine node to sun7i.dtsi
      Merge branch 'master' of https://github.com/thomas-vitsch/linux-a20-cedrus into linux-a20-cedrus
      Merge branch 'master' of https://github.com/thomas-vitsch/linux-a20-cedrus into linux-sunxi-cedrus-a20

Vitsch Electronics (1):
      Update README

 .../devicetree/bindings/media/sunxi-cedrus.txt     |   44 +
 Documentation/video4linux/v4l2-requests.txt        |  233 ++
 README                                             |   18 +-
 arch/arm/boot/dts/sun5i-a13-difrnce-dit4350.dts    |   50 -
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   30 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   44 +
 arch/arm/boot/dts/sun8i-a33.dtsi                   |   45 +-
 arch/arm/configs/xpo_player_v1_defconfig           | 3507 ++++++++++++++++++++
 drivers/media/platform/Kconfig                     |   13 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/sunxi-cedrus/Makefile       |    4 +
 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c |  285 ++
 .../platform/sunxi-cedrus/sunxi_cedrus_common.h    |  104 +
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c |  588 ++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.h |   33 +
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.c  |  180 +
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |   39 +
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c     |  152 +
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg4.c     |  140 +
 .../platform/sunxi-cedrus/sunxi_cedrus_regs.h      |  170 +
 drivers/media/platform/vivid/vivid-core.c          |    2 +
 drivers/media/platform/vivid/vivid-ctrls.c         |    4 +
 drivers/media/platform/vivid/vivid-kthread-cap.c   |    2 +
 drivers/media/usb/cpia2/cpia2_v4l.c                |    1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |    4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  460 ++-
 drivers/media/v4l2-core/v4l2-dev.c                 |    9 +
 drivers/media/v4l2-core/v4l2-device.c              |   26 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |  121 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   78 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   28 +
 include/media/v4l2-ctrls.h                         |   35 +-
 include/media/v4l2-dev.h                           |    3 +
 include/media/v4l2-device.h                        |    6 +
 include/media/v4l2-fh.h                            |    4 +
 include/media/videobuf2-core.h                     |    3 +
 include/media/videobuf2-v4l2.h                     |    4 +
 include/uapi/linux/v4l2-controls.h                 |   68 +
 include/uapi/linux/videodev2.h                     |   43 +-
 39 files changed, 6438 insertions(+), 143 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt
 create mode 100644 Documentation/video4linux/v4l2-requests.txt
 delete mode 100644 arch/arm/boot/dts/sun5i-a13-difrnce-dit4350.dts
 create mode 100644 arch/arm/configs/xpo_player_v1_defconfig
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


>> It would be nice to be able to play a file, so I would have to prepare our
>> custom player and make a patch between the current sunxi-cedrus-drv-video and
>> the one on https://github.com/FlorentRevest/sunxi-cedrus-drv-video.
>> So I will start with this if there is any interest.
>>
>> Should I be working in sunxi-next I wonder?
> 
> I'd rather stick on 4.14. sunxi-next wouldn't bring any benefit, and
> we want to provide something that works first, and always merging next
> will always distract us from the actual code.
> 
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
