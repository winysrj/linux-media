Return-path: <linux-media-owner@vger.kernel.org>
Received: from lucky1.263xmail.com ([211.157.147.135]:32907 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbdGCCRc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Jul 2017 22:17:32 -0400
Subject: Re: [PATCH 1/5] [media] rockchip/rga: v4l2 m2m support
To: Jacob Chen <jacobchen110@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>, linux-media@vger.kernel.org,
        mchehab@kernel.org, hans.verkuil@cisco.com
References: <1498488673-27900-1-git-send-email-jacob-chen@iotwrt.com>
 <1498492189.3710.4.camel@ndufresne.ca>
 <CAFLEztT4z81P8c5pce0zZtaJc+UDsAdXWGp8Rvmq5VL+TsWNNg@mail.gmail.com>
 <1498578582.25964.5.camel@ndufresne.ca>
From: Randy Li <randy.li@rock-chips.com>
Message-ID: <8adf331a-d466-9d2e-010a-4701cc10da56@rock-chips.com>
Date: Mon, 3 Jul 2017 10:17:13 +0800
MIME-Version: 1.0
In-Reply-To: <1498578582.25964.5.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/27/2017 11:49 PM, Nicolas Dufresne wrote:
> Le mardi 27 juin 2017 à 23:11 +0800, Jacob Chen a écrit :
>> Hi Nicolas.
>>
>> 2017-06-26 23:49 GMT+08:00 Nicolas Dufresne <nicolas@ndufresne.ca>:
>>>
>>> Le lundi 26 juin 2017 à 22:51 +0800, Jacob Chen a écrit :
>>>> Rockchip RGA is a separate 2D raster graphic acceleration unit.
>>>> It
>>>> accelerates 2D graphics operations, such as point/line drawing,
>>>> image
>>>> scaling, rotation, BitBLT, alpha blending and image
>>>> blur/sharpness.
>>>>
>>>> The drvier is mostly based on s5p-g2d v4l2 m2m driver.
>>>> And supports various operations from the rendering pipeline.
>>>>   - copy
>>>>   - fast solid color fill
>>>>   - rotation
>>>>   - flip
>>>>   - alpha blending
>>>>
>>>> The code in rga-hw.c is used to configure regs accroding to
>>>> operations.
>>>>
>>>> The code in rga-buf.c is used to create private mmu table for
>>>> RGA.
>>>> The tables is stored in a list, and be removed when buffer is
>>>> cleanup.
>>>>
>>>> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>>>> ---
>>>>   drivers/media/platform/Kconfig                |  11 +
>>>>   drivers/media/platform/Makefile               |   2 +
>>>>   drivers/media/platform/rockchip-rga/Makefile  |   3 +
>>>>   drivers/media/platform/rockchip-rga/rga-buf.c | 176 +++++
>>>>   drivers/media/platform/rockchip-rga/rga-hw.c  | 456 ++++++++++++
>>>>   drivers/media/platform/rockchip-rga/rga-hw.h  | 434 ++++++++++++
>>>>   drivers/media/platform/rockchip-rga/rga.c     | 979
>>>> ++++++++++++++++++++++++++
>>>>   drivers/media/platform/rockchip-rga/rga.h     | 133 ++++
>>>>   8 files changed, 2194 insertions(+)
>>>>   create mode 100644 drivers/media/platform/rockchip-rga/Makefile
>>>>   create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
>>>>   create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
>>>>   create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
>>>>   create mode 100644 drivers/media/platform/rockchip-rga/rga.c
>>>>   create mode 100644 drivers/media/platform/rockchip-rga/rga.h
>>>>
>>>
>>> Could be nice to generalize. We could setup a control and fill the
>>> values base on porter duff operations, then drivers can implement a
>>> subset. Right now, there is no generic way for userspace to know if
>>> a
>>> driver is just doing copies with some transformations, or if it can
>>> actually do alpha blending hence used for composting streams. Note
>>> that
>>> I haven't looked at all possibilities, Freescale IMX.6 seems to
>>> have a
>>> similar driver, which has been wrapped in GStreamer with this
>>> proposed
>>> elements:
>>>
>>> https://bugzilla.gnome.org/show_bug.cgi?id=772766
>>>
>>
>> Yeah, i also want it use a generic api.
>> "porter duff operations" looks good, i will look at it.
>>
>>>> +#define V4L2_CID_RGA_ALHPA_REG0 (V4L2_CID_USER_BASE | 0x1002)
>>>> +#define V4L2_CID_RGA_ALHPA_REG1 (V4L2_CID_USER_BASE | 0x1003)
>>>
>>> It's not obvious why there is two CID, and how this differ from
>>> existing V4L2_CID_ALPHA (the global alpha control).
>>
>> They are used to calculate factors for below formulas.
>>
>>      dst alpha = Factor1 * src alpha + Factor2 * dst alpha
>>      dst color = Factor3 * src color + Factor4 * dst color
>>
>> I have no idea how to generalize it, and there is no upstream
>> application need it,
>> so i just simply exposed the reg.
In my memory, it is is used for convert AYUV to ARGB.
> 
> Then maybe it's better to just not expose it in the public API in the
> initial patch (nothing forces you to enable everything). The idea is
> that it can be added later as needed, taking the time to figure-out a
> new API or to figure-out how this matches anything that exist.
> 
>>
>>>> +
>>>> +/* Operation values */
>>>> +#define OP_COPY 0
>>>> +#define OP_SOLID_FILL 1
>>>> +#define OP_ALPHA_BLEND 2
>>>> +
>>>> +struct rga_frame *rga_get_frame(struct rga_ctx *ctx, enum
>>>> v4l2_buf_type type);
>>>> +
>>>> +/* RGA Buffers Manage Part */
>>>> +extern const struct vb2_ops rga_qops;
>>>> +void *rga_buf_find_page(struct vb2_buffer *vb);
>>>> +void rga_buf_clean(struct rga_ctx *ctx);
>>>> +
>>>> +/* RGA Hardware Part */
>>>> +void rga_write(struct rockchip_rga *rga, u32 reg, u32 value);
>>>> +u32 rga_read(struct rockchip_rga *rga, u32 reg);
>>>> +void rga_mod(struct rockchip_rga *rga, u32 reg, u32 val, u32
>>>> mask);
>>>> +void rga_start(struct rockchip_rga *rga);
>>>> +void rga_cmd_set(struct rga_ctx *ctx, void *src_mmu_pages, void
>>>> *dst_mmu_pages);
>>>> +
>>>> +#endif

-- 
Randy Li
