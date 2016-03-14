Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47263 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951AbcCNHVv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 03:21:51 -0400
Subject: Re: FW: [PATCH v5 0/8] Add MT8173 Video Encoder Driver and VPU Driver
To: tiffany lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>
References: <D706F7FE148A8A429434F78C46336826048E7053@mtkmbs02n1>
 <1457939579.32502.10.camel@mtksdaap41>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E66672.9030307@xs4all.nl>
Date: Mon, 14 Mar 2016 08:21:22 +0100
MIME-Version: 1.0
In-Reply-To: <1457939579.32502.10.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/14/2016 08:12 AM, tiffany lin wrote:
> Hi Hans,
> 
> After change to use "v4l-utils.git master branch", "V4l2-compliance
> -d /dev/video1" fail on "fail: v4l2-test-buffers.cpp(555):
> check_0(crbufs.reserved, sizeof(crbufs.reserved))".
> 
> Check the source code and found
> 
> 	memset(&crbufs, 0xff, sizeof(crbufs));   -> crbufs to 0xff
>         node->g_fmt(crbufs.format, i);
>         crbufs.count = 0;
>         crbufs.memory = m;
>         fail_on_test(doioctl(node, VIDIOC_CREATE_BUFS, &crbufs));   
>         fail_on_test(check_0(crbufs.reserved, sizeof(crbufs.reserved)));
>         fail_on_test(crbufs.index != q.g_buffers());
> 
> crbufs is initialized to fill with 0xff and after VIDIOC_CREATE_BUFS,
> crbufs.reserved field should be 0x0. But v4l2_m2m_create_bufs and
> vb2_create_bufs do not process reserved filed.
> Do we really need to check reserved filed filled with 0x0? Or we need to
> change vb2_create_bufs to fix this issue?

The reserved field is zeroed in v4l_create_bufs() in v4l2-ioctl.c, so even before
vb2_create_bufs et al is called.

The fact that it is no longer zeroed afterwards suggests that someone is messing
with the reserved field.

You'll have to do a bit more digging, I'm afraid.

Regards,

	Hans
