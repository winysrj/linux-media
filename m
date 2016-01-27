Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:13893 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbcA0IoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 03:44:22 -0500
Subject: Re: [PATCH v1 0/3] Add VP8 deocder for rk3229 & rk3288
To: =?UTF-8?B?6LW15L+K?= <jung.zhao@rock-chips.com>,
	Enric Balletbo Serra <eballetbo@gmail.com>,
	Shawn Lin <shawn.lin@rock-chips.com>
References: <1986575881.543376.1453883667103.JavaMail.xmail@wmthree-7>
Cc: pawel <pawel@osciak.com>,
	"m.szyprowski " <m.szyprowski@samsung.com>,
	"kyungmin.park " <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-api <linux-api@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>,
	linux-rockchip <linux-rockchip@lists.infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"alpha.lin " <alpha.lin@rock-chips.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	"herman.chen " <herman.chen@rock-chips.com>,
	"linux-arm-kernel@lists.infradead.org "
	<linux-arm-kernel@lists.infradead.org>,
	linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <56A8844B.9070700@cisco.com>
Date: Wed, 27 Jan 2016 09:48:11 +0100
MIME-Version: 1.0
In-Reply-To: <1986575881.543376.1453883667103.JavaMail.xmail@wmthree-7>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please be aware that the request API was RFC code and that 1) it *will*
change (Laurent Pinchart is working on it now) and 2) it may take quite
some time before it is merged. Second half of this year, and that only
if nothing goes wrong.

I can't tell if it is possible or not, but it might be a good idea if you
can make a version with reduced functionality that does not rely on the
request API, try to get that merged and add the functionality that
depends on the request API later once that part is merged.

For the record: while the request API will change the impact on your
driver is likely to be limited, at least as things stand today.

Regards,

	Hans

On 01/27/16 09:34, 赵俊 wrote:
> Hi,
> These patches are based on Request API[1] and RK IOMMU[2].
> 
> [1]http://www.spinics.net/lists/linux-media/msg95733.html
> [2]http://www.gossamer-threads.com/lists/linux/kernel/2347458
> 
> The part for VP8 headers and controls for the V4L2 API and framework and the changes to videobuf2 were authored and written by Pawel Osciakand Tomasz Figa
> 
> Thank you for all suggestion. I will fix all the incorrect message and resend a new version.
> 
> ----- Original Message -----
> From:Enric Balletbo Serra <eballetbo@gmail.com>
> To: Shawn Lin <shawn.lin@rock-chips.com> 
> CC: Jung Zhao <jung.zhao@rock-chips.com> pawel <pawel@osciak.com> m.szyprowski <m.szyprowski@samsung.com> kyungmin.park <kyungmin.park@samsung.com> Mauro Carvalho Chehab <mchehab@osg.samsung.com> Heiko Stübner <heiko@sntech.de> Sakari Ailus <sakari.ailus@linux.intel.com> linux-api <linux-api@vger.kernel.org> linux-kernel <linux-kernel@vger.kernel.org> Benoit Parrot <bparrot@ti.com> linux-rockchip <linux-rockchip@lists.infradead.org> Antti Palosaari <crope@iki.fi> Hans Verkuil <hans.verkuil@cisco.com> alpha.lin <alpha.lin@rock-chips.com> Philipp Zabel <p.zabel@pengutronix.de> Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> herman.chen <herman.chen@rock-chips.com> linux-arm-kernel@lists.infradead.org <linux-arm-kernel@lists.infradead.org> linux-media <linux-media@vger.kernel.org> 
> Sent: 2016-01-26 22:00
> Subject: Re:Re: [PATCH v1 0/3] Add VP8 deocder for rk3229 & rk3288
> 
> Hi Jung,
> 
> 2016-01-26 10:30 GMT+01:00 Shawn Lin <shawn.lin@rock-chips.com>:
>> Hi jun,
>>
>> Where is the dt-bingding documentation about your VP8 controller?
>>
>> And would you please share some info about rk3229? I can just find
>> rk3228 in mainline, otherwise may someone think it's a misspell.
>>
>> Thanks.
>>
>>
>> On 2016/1/26 17:04, Jung Zhao wrote:
>>>
>>> From: zhaojun <jung.zhao@rock-chips.com>
>>>
>>>
>>> ====================
>>> Introduction
>>> ====================
>>>
>>> The purpose of this series is to add the driver for vp8
>>> decoder on rk3229 & rk3288 platform, and will support
>>> more formats in the future.
>>>
>>> The driver uses v4l2 framework and RK IOMMU.
>>> RK IOMMU has not yet been merged.
>>>
> 
> Can you share or specify what patches are needed, are they already
> send to upstream ? So people that want to test your series knows what
> they need to apply
> 
> I think that, at least, this patch is required:
> 
> iommu/rockchip: reconstruct to support multi slaves [1]
> 
> If this is not already accepted, maybe is a good idea include this
> patch in the patch series
> 
> [1] http://www.gossamer-threads.com/lists/linux/kernel/2347458
> 
>>>
>>>
>>> zhaojun (3):
>>>    media: v4l: Add VP8 format support in V4L2 framework
>>>    media: VPU: support Rockchip VPU
>>>    media: vcodec: rockchip: Add Rockchip VP8 decoder driver
>>>
>>>   drivers/media/platform/rockchip-vpu/Makefile       |    7 +
>>>   .../media/platform/rockchip-vpu/rkvpu_hw_vp8d.c    |  798 ++++++++++
>>>   .../platform/rockchip-vpu/rockchip_vp8d_regs.h     | 1594
>>> ++++++++++++++++++++
>>>   drivers/media/platform/rockchip-vpu/rockchip_vpu.c |  799 ++++++++++
>>>   .../platform/rockchip-vpu/rockchip_vpu_common.h    |  439 ++++++
>>>   .../media/platform/rockchip-vpu/rockchip_vpu_dec.c | 1007 +++++++++++++
>>>   .../media/platform/rockchip-vpu/rockchip_vpu_dec.h |   33 +
>>>   .../media/platform/rockchip-vpu/rockchip_vpu_hw.c  |  295 ++++
>>>   .../media/platform/rockchip-vpu/rockchip_vpu_hw.h  |  100 ++
>>>   drivers/media/v4l2-core/v4l2-ctrls.c               |   17 +-
>>>   drivers/media/v4l2-core/v4l2-ioctl.c               |    3 +
>>>   drivers/media/v4l2-core/videobuf2-dma-contig.c     |   51 +-
>>>   include/media/v4l2-ctrls.h                         |    2 +
>>>   include/media/videobuf2-dma-contig.h               |   11 +-
>>>   include/uapi/linux/v4l2-controls.h                 |   98 ++
>>>   include/uapi/linux/videodev2.h                     |    5 +
>>>   16 files changed, 5238 insertions(+), 21 deletions(-)
>>>   create mode 100644 drivers/media/platform/rockchip-vpu/Makefile
>>>   create mode 100644 drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
>>>   create mode 100644
>>> drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h
>>>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu.c
>>>   create mode 100644
>>> drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
>>>   create mode 100644
>>> drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
>>>   create mode 100644
>>> drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
>>>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
>>>   create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h
>>>
>>
>>
>> --
>> Best Regards
>> Shawn Lin
>>
> 
> Best Regards,
> Enric
> 
