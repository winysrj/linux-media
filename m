Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:34101 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750987AbeBGWTI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 17:19:08 -0500
Subject: Re: [PATCH v8 0/7] TDA1997x HDMI video reciver
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
 <c7771c44-a9ff-0207-38f6-28bcc06ccdee@xs4all.nl>
 <CAJ+vNU1oiM0Y0rO-DHi57nVOqnw60A7pn_1=h5b46-BrY7_p2Q@mail.gmail.com>
 <605fd4a8-43ab-c566-57b6-abb1c9f8f0f8@xs4all.nl>
 <7cf38465-7a79-5d81-a995-9acfbacf5023@xs4all.nl>
 <CAJ+vNU014FJZsb44YnidE3fFiqeB6o8A7kvGinJWu7=yq3_dhA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d188a172-fc00-eb46-c6f5-833a86475390@xs4all.nl>
Date: Wed, 7 Feb 2018 23:19:02 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU014FJZsb44YnidE3fFiqeB6o8A7kvGinJWu7=yq3_dhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2018 11:05 PM, Tim Harvey wrote:
> On Wed, Feb 7, 2018 at 1:09 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/07/18 09:22, Hans Verkuil wrote:
>>> On 02/07/2018 12:29 AM, Tim Harvey wrote:
>>>> Media Controller ioctls:
>>>>                 fail: v4l2-test-media.cpp(141): ent.function ==
>>>> MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
>>>
>>> Weird, this shouldn't happen. I'll look into this a bit more.
>>
>> Can you run 'mc_nextgen_test -e -i' and post the output?
>>
>> It's found in contrib/test.
>>
> 
> root@ventana:~# ./v4l-utils/contrib/test/mc_nextgen_test -e -i
> Device: imx-media (driver imx-media)
> Bus:
> version: 0
> number of entities: 24
> number of interfaces: 24
> number of pads: 48
> number of links: 50
> entity entity#1: 'unknown entity type' adv7180 2-0020, 1 pad(s), 1 source(s)
> entity entity#3: 'unknown entity type' tda19971 2-0048, 1 pad(s), 1 source(s)
> entity entity#5: 'unknown entity type' ipu1_vdic, 3 pad(s), 2 sink(s),
> 1 source(s)
> entity entity#9: 'unknown entity type' ipu2_vdic, 3 pad(s), 2 sink(s),
> 1 source(s)
> entity entity#13: 'unknown entity type' ipu1_ic_prp, 3 pad(s), 1
> sink(s), 2 source(s)
> entity entity#17: 'unknown entity type' ipu1_ic_prpenc, 2 pad(s), 1
> sink(s), 1 source(s)
> entity entity#20: 'V4L I/O' ipu1_ic_prpenc capture, 1 pad(s), 1 sink(s)
> entity entity#26: 'unknown entity type' ipu1_ic_prpvf, 2 pad(s), 1
> sink(s), 1 source(s)
> entity entity#29: 'V4L I/O' ipu1_ic_prpvf capture, 1 pad(s), 1 sink(s)
> entity entity#35: 'unknown entity type' ipu2_ic_prp, 3 pad(s), 1
> sink(s), 2 source(s)
> entity entity#39: 'unknown entity type' ipu2_ic_prpenc, 2 pad(s), 1
> sink(s), 1 source(s)
> entity entity#42: 'V4L I/O' ipu2_ic_prpenc capture, 1 pad(s), 1 sink(s)
> entity entity#48: 'unknown entity type' ipu2_ic_prpvf, 2 pad(s), 1
> sink(s), 1 source(s)
> entity entity#51: 'V4L I/O' ipu2_ic_prpvf capture, 1 pad(s), 1 sink(s)
> entity entity#57: 'unknown entity type' ipu1_csi0, 3 pad(s), 1
> sink(s), 2 source(s)
> entity entity#61: 'V4L I/O' ipu1_csi0 capture, 1 pad(s), 1 sink(s)
> entity entity#67: 'unknown entity type' ipu1_csi1, 3 pad(s), 1
> sink(s), 2 source(s)
> entity entity#71: 'V4L I/O' ipu1_csi1 capture, 1 pad(s), 1 sink(s)
> entity entity#77: 'unknown entity type' ipu2_csi0, 3 pad(s), 1
> sink(s), 2 source(s)
> entity entity#81: 'V4L I/O' ipu2_csi0 capture, 1 pad(s), 1 sink(s)
> entity entity#87: 'unknown entity type' ipu2_csi1, 3 pad(s), 1
> sink(s), 2 source(s)
> entity entity#91: 'V4L I/O' ipu2_csi1 capture, 1 pad(s), 1 sink(s)
> entity entity#97: 'unknown entity type' ipu1_csi0_mux, 3 pad(s), 2
> sink(s), 1 source(s)
> entity entity#101: 'unknown entity type' ipu2_csi1_mux, 3 pad(s), 2
> sink(s), 1 source(s)

Yuck. So nobody in imx (and adv7180!) is setting a valid function.
And I see the mc_nextgen_test.c doesn't know all the latest functions
anyway.

That's what happens when you don't have compliance tests, nobody bothers
to fill stuff like that in. Anyway, that explains the v4l2-compliance error
you got (although I should improve the error to also mentioned the entity
in question). In other words, it's not you, it's them :-)

Regards,

	Hans

> interface intf_devnode#21: video /dev/video0
> interface intf_devnode#30: video /dev/video1
> interface intf_devnode#43: video /dev/video2
> interface intf_devnode#52: video /dev/video3
> interface intf_devnode#62: video /dev/video4
> interface intf_devnode#72: video /dev/video5
> interface intf_devnode#82: video /dev/video6
> interface intf_devnode#92: video /dev/video7
> interface intf_devnode#141: v4l2-subdev /dev/v4l-subdev0
> interface intf_devnode#143: v4l2-subdev /dev/v4l-subdev1
> interface intf_devnode#145: v4l2-subdev /dev/v4l-subdev2
> interface intf_devnode#147: v4l2-subdev /dev/v4l-subdev3
> interface intf_devnode#149: v4l2-subdev /dev/v4l-subdev4
> interface intf_devnode#151: v4l2-subdev /dev/v4l-subdev5
> interface intf_devnode#153: v4l2-subdev /dev/v4l-subdev6
> interface intf_devnode#155: v4l2-subdev /dev/v4l-subdev7
> interface intf_devnode#157: v4l2-subdev /dev/v4l-subdev8
> interface intf_devnode#159: v4l2-subdev /dev/v4l-subdev9
> interface intf_devnode#161: v4l2-subdev /dev/v4l-subdev10
> interface intf_devnode#163: v4l2-subdev /dev/v4l-subdev11
> interface intf_devnode#165: v4l2-subdev /dev/v4l-subdev12
> interface intf_devnode#167: v4l2-subdev /dev/v4l-subdev13
> interface intf_devnode#169: v4l2-subdev /dev/v4l-subdev14
> interface intf_devnode#171: v4l2-subdev /dev/v4l-subdev15
> 
> I updated v4l2-compliance and ran again:
> root@ventana:~# v4l2-compliance -m0 -M
> v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
> Media Driver Info:
>         Driver name      : imx-media
>         Model            : imx-media
>         Serial           :
>         Bus info         :
>         Media version    : 4.15.0
>         Hardware revision: 0x00000000 (0)
>         Driver version   : 4.15.0
> 
> Compliance test for device /dev/media0:
> 
> Required ioctls:
>         test MEDIA_IOC_DEVICE_INFO: OK
> 
> Allow for multiple opens:
>         test second /dev/media0 open: OK
>         test MEDIA_IOC_DEVICE_INFO: OK
>         test for unlimited opens: OK
> 
> Media Controller ioctls:
>                 fail: v4l2-test-media.cpp(94): function ==
> MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
>                 fail: v4l2-test-media.cpp(156):
> checkFunction(ent.function, true)
>         test MEDIA_IOC_G_TOPOLOGY: FAIL
>                 fail: v4l2-test-media.cpp(275): num_data_links != num_links
>         test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
>         test MEDIA_IOC_SETUP_LINK: OK
> 
> Total: 7, Succeeded: 5, Failed: 2, Warnings: 0
> 
> Regards,
> 
> Tim
> 
