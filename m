Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44263 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeADTri (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 14:47:38 -0500
Received: by mail-pg0-f67.google.com with SMTP id i5so1084918pgq.11
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 11:47:38 -0800 (PST)
Subject: Re: IMX6 interlaced capture
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU1mRdxbfhEJY+n+U75cWW_op1Z+AzHOG=To8ooPzt9SJA@mail.gmail.com>
 <76a1cd63-7338-7f23-6228-5dc4db276b23@gmail.com>
 <CAJ+vNU1EivRc3t2JUvB-bdahm2HXukGNjQSG7BJ3ekO+9-ErSg@mail.gmail.com>
 <1e23ff8f-582b-800a-f586-c88705fc326e@gmail.com>
Message-ID: <a6566753-90a7-a9f0-18ce-c8a99774635f@gmail.com>
Date: Thu, 4 Jan 2018 11:47:34 -0800
MIME-Version: 1.0
In-Reply-To: <1e23ff8f-582b-800a-f586-c88705fc326e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/04/2018 10:51 AM, Steve Longerbeam wrote:
>
>
> On 01/04/2018 09:57 AM, Tim Harvey wrote:
>> <snip>
>>
>>> Try this hack as an experiment: modify is_parallel_16bit_bus() in
>>> imx-media-csi.c to simply return false, and see if the above pipeline
>>> works.
>> I'm currently on 4.15-rc1 which doesn't have a
>> 'is_parallel_16bit_bus()' but if I comment out the check we are
>> talking about in csi_link_validate as such:
>>
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -999,6 +999,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
>>          is_csi2 = (sensor_ep->bus_type == V4L2_MBUS_CSI2);
>>          incc = priv->cc[CSI_SINK_PAD];
>>
>> +/*
>>          if (priv->dest != IPU_CSI_DEST_IDMAC &&
>>              (incc->bayer || (!is_csi2 &&
>> sensor_ep->bus.parallel.bus_width >= 16))) {
>> @@ -1007,6 +1008,7 @@ static int csi_link_validate(struct v4l2_subdev 
>> *sd,
>>                  ret = -EINVAL;
>>                  goto out;
>>          }
>> +*/
>>
>>          if (is_csi2) {
>>                  int vc_num = 0;
>>
>> I get a pipeline start failure for ipu1_ic_prpvf:
>>
>> root@ventana:~# v4l2-ctl -d /dev/video1 --stream-mmap --stream-skip=1
>> --stream-to=/tmp/x.raw --stream-count=1
>> [  909.993353] tda1997x 2-0048: tda1997x_get_pad_format
>> [  909.998342] tda1997x 2-0048: tda1997x_fill_format
>> ^^^^ my tda1997x driver debug messages
>> [  910.004483] ipu1_ic_prpvf: pipeline start failed with -32
>> VIDIOC_STREAMON: failed: Broken pipe
>
> The driver doesn't really support V4L2_FIELD_ALTERNATE, the CSI subdev
> attempts to translate this to sequential-top-bottom or 
> sequential-bottom-top
> at the CSI output pads, since alternate holds no info about field 
> order. I doubt
> alternate is correct for the TDA19971 anyway, so that should be fixed 
> in the
> tda19971 driver. Until then, set to "seq-bt" downstream from the CSI, 
> as in:
>
> media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080]
> media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080 
> field:alternate]
> media-ctl --set-v4l2 'ipu1_csi0':1[fmt:UYVY8_1X16/1920x1080 
> field:alternate]
> media-ctl --set-v4l2 'ipu1_vdic':2[fmt:UYVY8_1X16/1920x1080 field:seq-bt]
> media-ctl --set-v4l2 'ipu1_ic_prp':2[fmt:UYVY8_1X16/1920x1080 field:none]
> media-ctl --set-v4l2 'ipu1_ic_prpvf':1[fmt:UYVY8_1X16/1920x1080 
> field:none]

Actually just noticed another problem with the original pipeline, the 
ipu1_vdic output
pad is always progressive/non-interlaced. The output pad enforces 
progressive, but
to be technically correct this should be:

media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080]
media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080 
field:alternate]
media-ctl --set-v4l2 'ipu1_csi0':1[fmt:UYVY8_1X16/1920x1080 
field:alternate]
media-ctl --set-v4l2 'ipu1_vdic':2[fmt:UYVY8_1X16/1920x1080 field:none]
media-ctl --set-v4l2 'ipu1_ic_prp':2[fmt:UYVY8_1X16/1920x1080 field:none]
media-ctl --set-v4l2 'ipu1_ic_prpvf':1[fmt:UYVY8_1X16/1920x1080 field:none]


But as said in my last email, if the tda19971 supports one of the 
sequential field
types that explicitly specifies field order, it would be better to start 
with that right
up front:

media-ctl --set-v4l2 'tda19971 2-0048':0[fmt:UYVY8_1X16/1920x1080 
field:seq-tb]
media-ctl --set-v4l2 'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080 
field:seq-tb]
media-ctl --set-v4l2 'ipu1_csi0':1[fmt:AYUV32/1920x1080 field:seq-tb]
media-ctl --set-v4l2 'ipu1_vdic':2[fmt:AYUV32/1920x1080 field:none]
media-ctl --set-v4l2 'ipu1_ic_prp':2[fmt:AYUV32/1920x1080 field:none]
media-ctl --set-v4l2 'ipu1_ic_prpvf':1[fmt:UYVY8_1X16/1920x1080 field:none]

Note also the IPU-internal pixel formats should be AYUV32.

Steve
