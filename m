Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33426 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967589AbeBNNDB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 08:03:01 -0500
Subject: Re: exposing a large-ish calibration table through V4L2?
To: Florian Echtler <floe@butterbrot.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3b8e61f5-df31-8556-c9d1-2ab06c76bfab@butterbrot.org>
 <5c3a596e-df46-488e-4a15-c847dc699815@xs4all.nl>
 <43eab066-0025-501d-60d9-beb20204ebdd@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8021c6bf-2b24-6515-b6e2-af257e1606f5@xs4all.nl>
Date: Wed, 14 Feb 2018 14:03:00 +0100
MIME-Version: 1.0
In-Reply-To: <43eab066-0025-501d-60d9-beb20204ebdd@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/02/18 13:27, Florian Echtler wrote:
> Hello Hans,
> 
> On 14.02.2018 13:13, Hans Verkuil wrote:
>>
>> On 14/02/18 13:09, Florian Echtler wrote:
>>>
>>> The internal device memory contains a table with two bytes for each sensor pixel
>>> (i.e. 960x540x2 = 1036800 bytes) that basically provide individual black and
>>> white levels per-pixel that are used in preprocessing. The table can either be
>>> set externally, or the sensor can be covered with a black/white surface and a
>>> custom command triggers an internal calibration.
>>>
>>> AFAICT the usual V4L2 controls are unsuitable for this sort of data; do you have
>>> any suggestions on how to approach this? Maybe something like a custom IOCTL?
>>
>> So the table has a fixed size?
>> You can use array controls for that, a V4L2_CTRL_TYPE_U16 in a two-dimensional array
>> would do it.
> 
> Good to know, thanks.
> 
>> See https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-queryctrl.html for more
>> information on how this works.
> 
> This means I have to implement QUERY_EXT_CTRL, G_EXT_CTRLS and S_EXT_CTRLS,
> correct? Will this work in parallel to the "regular" controls that use the
> control framework?

No, just use the control framework. You need to make a custom control that is
specific to your driver

So reserve a range for your driver in include/uapi/linux/v4l2-controls.h
(search for 'USER-class private control IDs'). Then you can define a control
ID. The next step is to configure the control:

static const struct v4l2_ctrl_config cal_table_control = {
        .ops = &cal_ctrl_ops,
        .id = V4L2_CID_SUR40_CAL_TABLE,
        .name = "Calibration Table",
        .type = V4L2_CTRL_TYPE_U16,
        .max = 0xffff,
        .step = 1,
        .def = 0,
        .dims = { 960, 540 },
};

And register it with a control handler:

v4l2_ctrl_new_custom(hdl, &cal_table_control, NULL);

See e.g. drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c and the DETECT_MD controls.

Regards,

	Hans
