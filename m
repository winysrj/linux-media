Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:64361 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752813AbcCNJEe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 05:04:34 -0400
Message-ID: <1457946267.16701.6.camel@mtksdaap41>
Subject: Re: FW: [PATCH v5 0/8] Add MT8173 Video Encoder Driver and VPU
 Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 14 Mar 2016 17:04:27 +0800
In-Reply-To: <56E66672.9030307@xs4all.nl>
References: <D706F7FE148A8A429434F78C46336826048E7053@mtkmbs02n1>
	 <1457939579.32502.10.camel@mtksdaap41> <56E66672.9030307@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-03-14 at 08:21 +0100, Hans Verkuil wrote:
> On 03/14/2016 08:12 AM, tiffany lin wrote:
> > Hi Hans,
> > 
> > After change to use "v4l-utils.git master branch", "V4l2-compliance
> > -d /dev/video1" fail on "fail: v4l2-test-buffers.cpp(555):
> > check_0(crbufs.reserved, sizeof(crbufs.reserved))".
> > 
> > Check the source code and found
> > 
> > 	memset(&crbufs, 0xff, sizeof(crbufs));   -> crbufs to 0xff
> >         node->g_fmt(crbufs.format, i);
> >         crbufs.count = 0;
> >         crbufs.memory = m;
> >         fail_on_test(doioctl(node, VIDIOC_CREATE_BUFS, &crbufs));   
> >         fail_on_test(check_0(crbufs.reserved, sizeof(crbufs.reserved)));
> >         fail_on_test(crbufs.index != q.g_buffers());
> > 
> > crbufs is initialized to fill with 0xff and after VIDIOC_CREATE_BUFS,
> > crbufs.reserved field should be 0x0. But v4l2_m2m_create_bufs and
> > vb2_create_bufs do not process reserved filed.
> > Do we really need to check reserved filed filled with 0x0? Or we need to
> > change vb2_create_bufs to fix this issue?
> 
> The reserved field is zeroed in v4l_create_bufs() in v4l2-ioctl.c, so even before
> vb2_create_bufs et al is called.
> 
> The fact that it is no longer zeroed afterwards suggests that someone is messing
> with the reserved field.
> 
> You'll have to do a bit more digging, I'm afraid.
> 
Hi Hans,

Thanks for your information.
I found the root cause is in "put_v4l2_create32".
It do not copy reserved field from kernel space to user space.
After modification,"test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK"

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index f38c076..109f687 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -280,7 +280,8 @@ static int put_v4l2_format32(struct v4l2_format *kp,
struct v4l2_format32 __user
 static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct
v4l2_create_buffers32 __user *up)
 {
        if (!access_ok(VERIFY_WRITE, up, sizeof(struct
v4l2_create_buffers32)) ||
-           copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32,
format)))
+           copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32,
format)) ||
+           copy_to_user(up->reserved, kp->reserved,
sizeof(kp->reserved)))
                return -EFAULT;
        return __put_v4l2_format32(&kp->format, &up->format);
 }

best regards,
Tiffany

> Regards,
> 
> 	Hans


