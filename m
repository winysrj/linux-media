Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:40485 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbeCHJ7p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 04:59:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLEztR1XyFMS_Gf-qT7vs9OHipeBfuXQ7mXJoCBDyBSvTWUag@mail.gmail.com>
References: <1514533978-20408-1-git-send-email-zhengsq@rock-chips.com>
 <1514533978-20408-3-git-send-email-zhengsq@rock-chips.com>
 <917c22c0-773e-5fe5-5625-86678f7c8521@xs4all.nl> <CAFLEztR1XyFMS_Gf-qT7vs9OHipeBfuXQ7mXJoCBDyBSvTWUag@mail.gmail.com>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Thu, 8 Mar 2018 17:59:44 +0800
Message-ID: <CAFLEztSPXP6DsyZAiwS8j4-g4Qxjuku_9wfrOYs1o-0w=s5Wpg@mail.gmail.com>
Subject: Re: [PATCH v5 02/16] media: doc: add document for rkisp1 meta buffer format
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shunqian Zheng <zhengsq@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        Allon Huang <allon.huang@rock-chips.com>,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        robh+dt@kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Jacob Chen <jacob-chen@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2018-02-06 22:27 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 12/29/17 08:52, Shunqian Zheng wrote:
>> From: Jacob Chen <jacob2.chen@rock-chips.com>
>>
>> This commit add docuemnt for rkisp1 meta buffer format
>>
>> Signed-off-by: Jacob Chen <jacob-chen@rock-chips.com>
>> ---
>>  Documentation/media/uapi/v4l/meta-formats.rst          |  2 ++
>>  .../media/uapi/v4l/pixfmt-meta-rkisp1-params.rst       | 17 +++++++++++++++++
>>  .../media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst         | 18 ++++++++++++++++++
>>  3 files changed, 37 insertions(+)
>>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
>>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst
>>
>> diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
>> index 01e24e3..1b82814 100644
>> --- a/Documentation/media/uapi/v4l/meta-formats.rst
>> +++ b/Documentation/media/uapi/v4l/meta-formats.rst
>> @@ -14,3 +14,5 @@ These formats are used for the :ref:`metadata` interface only.
>>
>>      pixfmt-meta-vsp1-hgo
>>      pixfmt-meta-vsp1-hgt
>> +    pixfmt-meta-rkisp1-params
>> +    pixfmt-meta-rkisp1-stat
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
>> new file mode 100644
>> index 0000000..ed344d4
>> --- /dev/null
>> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
>> @@ -0,0 +1,17 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _v4l2-meta-fmt-rkisp1-params:
>> +
>> +*******************************
>> +V4L2_META_FMT_RK_ISP1_PARAMS
>> +*******************************
>> +
>> +Rockchip ISP1 Parameters Data
>> +
>> +Description
>> +===========
>> +
>> +This format describes input parameters for the Rockchip ISP1.
>> +
>> +The data use c-struct :c:type:`rkisp1_isp_params_cfg`, which is defined in
>> +the ``linux/rkisp1-config.h`` header file, See it for details.
>
> One more question: does the ISP produce a reasonable picture if it doesn't
> receive these params? If not (i.e. you always need to provide params), then
> I think you should provide a default rkisp1_isp_params_cfg struct that
> can be used as a template for application writers.
>
> Perhaps it can be part of the driver as the initial params config.
>
> I think even if the ISP does work without params it is still worthwhile
> doing this. The params are complex and having an example on how to initialize
> it would be helpful.
>

The ISP don't need a default rkisp1_isp_params_cfg to produce picture,
those params just effect image quality and stats data.

The params are not very complex.
They consist of multiple modules and each of modules can be
enabled/disable/updated individually.

> Regards,
>
>         Hans
>
>> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst
>> new file mode 100644
>> index 0000000..5ecc403
>> --- /dev/null
>> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst
>> @@ -0,0 +1,18 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _v4l2-meta-fmt-rkisp1-stat:
>> +
>> +*******************************
>> +V4L2_META_FMT_RK_ISP1_STAT_3A
>> +*******************************
>> +
>> +Rockchip ISP1 Statistics Data
>> +
>> +Description
>> +===========
>> +
>> +This format describes image color statistics information generated by the Rockchip
>> +ISP1.
>> +
>> +The data use c-struct :c:type:`rkisp1_stat_buffer`, which is defined in
>> +the ``linux/cifisp_stat.h`` header file, See it for details.
>>
>
