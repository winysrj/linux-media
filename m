Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:44635 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966019AbeEXVd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 17:33:56 -0400
Received: by mail-pf0-f170.google.com with SMTP id q22-v6so1504211pff.11
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 14:33:56 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
From: Steve Longerbeam <slongerbeam@gmail.com>
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
References: <m37eobudmo.fsf@t19.piap.pl>
 <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com> <m3tvresqfw.fsf@t19.piap.pl>
 <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com> <m3fu2oswjh.fsf@t19.piap.pl>
 <m3603hsa4o.fsf@t19.piap.pl> <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
 <m3h8mxqc7t.fsf@t19.piap.pl> <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
 <aad7c874-ee05-ef9b-733c-609b6928fc3c@gmail.com>
Message-ID: <f327c8f9-5aa2-b945-a356-f86ca488f6fc@gmail.com>
Date: Thu, 24 May 2018 14:33:53 -0700
MIME-Version: 1.0
In-Reply-To: <aad7c874-ee05-ef9b-733c-609b6928fc3c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof, Philipp,

And I can confirm that capturing planar 4:2:0 (YU12, YV12, or NV12),
is broken because of the call to ipu_cpmem_skip_odd_chroma_rows().
YU12 or NV12 images look correct again when commenting out that
call. Commits

14330d7f08 ("media: imx: csi: enable double write reduction")
b54a5c2dc8 ("media: imx: prpencvf: enable double write reduction")

should be reverted for now, until the behavior of this bit is better 
understood.

Steve

On 05/24/2018 01:48 PM, Steve Longerbeam wrote:
> Hi Krzysztof,
>
> Sorry I did find a bug. Please try this patch:
>
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -631,7 +631,6 @@ static int csi_setup(struct csi_priv *priv)
>  {
>         struct v4l2_mbus_framefmt *infmt, *outfmt;
>         struct v4l2_mbus_config mbus_cfg;
> -       struct v4l2_mbus_framefmt if_fmt;
>
>         infmt = &priv->format_mbus[CSI_SINK_PAD];
>         outfmt = &priv->format_mbus[priv->active_output_pad];
> @@ -642,20 +641,13 @@ static int csi_setup(struct csi_priv *priv)
>                 priv->upstream_ep.bus.mipi_csi2.flags :
>                 priv->upstream_ep.bus.parallel.flags;
>
> -       /*
> -        * we need to pass input frame to CSI interface, but
> -        * with translated field type from output format
> -        */
> -       if_fmt = *infmt;
> -       if_fmt.field = outfmt->field;
> -
>         ipu_csi_set_window(priv->csi, &priv->crop);
>
>         ipu_csi_set_downsize(priv->csi,
>                              priv->crop.width == 2 * priv->compose.width,
>                              priv->crop.height == 2 * 
> priv->compose.height);
>
> -       ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
> +       ipu_csi_init_interface(priv->csi, &mbus_cfg, infmt);
>
>         ipu_csi_set_dest(priv->csi, priv->dest);
>
>
> (the removed code was meant to deal with field type at sink pad being
> "alternate", which ipu_csi_init_interface() doesn't currently 
> recognize, but
> that should be dealt with in IPUv3 driver).
>
> With that you should be able to set pad ipu2_csi1:2 to field type 
> "none", e.g.
> set pipeline to:
>
> media-ctl -V '"adv7180 2-0020":0[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1_mux":1[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1_mux":2[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1":0[fmt:UYVY2X8 720x480 field:interlaced]'
> media-ctl -V '"ipu2_csi1":2[fmt:UYVY2X8 720x480 field:none]'
>
> With the above patch, capture from ipu1_csi0:2 is fixed for me on 
> SabreAuto.
>
> You may also want to try adding a ~500 msec delay after adv7180 power on
> as I explained earlier:
>
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -503,6 +503,9 @@ static int adv7180_set_power(struct adv7180_state 
> *state, bool on)
>                 }
>         }
>
> +       if (on)
> +               msleep(500);
> +
>         return 0;
>  }
>
>
> Steve
>
>
> On 05/24/2018 11:12 AM, Steve Longerbeam wrote:
>> Hi Krzysztof,
>>
>>
>> On 05/24/2018 08:56 AM, Krzysztof Hałasa wrote:
>>> Hi,
>>>
>>> I've experimented with the ADV7180 a bit and this is what I found.
>>>
>>> First, I'm using (with a NTSC camera but I guess PAL won't be much
>>> different):
>>> media-ctl -V '"adv7180 2-0020":0[fmt:UYVY2X8 720x480 field:interlaced]'
>>> media-ctl -V '"ipu2_csi1_mux":1[fmt:UYVY2X8 720x480 field:interlaced]'
>>> media-ctl -V '"ipu2_csi1_mux":2[fmt:UYVY2X8 720x480 field:interlaced]'
>>> media-ctl -V '"ipu2_csi1":0[fmt:UYVY2X8 720x480 field:interlaced]'
>>> media-ctl -V '"ipu2_csi1":2[fmt:UYVY2X8 720x480 field:interlaced]'
>>>
>>> IOW I set all of the parts to interlaced mode. If i set the last 
>>> element
>>> to "none", the CSI is not set for interlaced input, and nothing 
>>> works at
>>> the low level.
>>
>> This is what I don't understand. By setting pad ipu2_csi1:2 to
>> "none", the if statement below should be true (sink pad field
>> is "interlaced" and the capture field is propagated from ipu2_csi1:2
>> field so it is "none", thus ipu_cpmem_interlaced_scan() will be called.
>>
>> And yes you are correct, ipu_cpmem_interlaced_scan() must be
>> called to enable IDMAC interweave, which is what you want.
>>
>>>
>>> This requires a quick temporary hack:
>>> --- a/drivers/staging/media/imx/imx-media-csi.c
>>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>>> @@ -474,8 +474,8 @@ static int csi_idmac_setup_channel(struct 
>>> csi_priv *priv)
>>>         ipu_smfc_set_burstsize(priv->smfc, burst_size);
>>>   -    if (image.pix.field == V4L2_FIELD_NONE &&
>>> -        V4L2_FIELD_HAS_BOTH(infmt->field))
>>> +    if (1 || (image.pix.field == V4L2_FIELD_NONE &&
>>> +          V4L2_FIELD_HAS_BOTH(infmt->field)))
>>>           ipu_cpmem_interlaced_scan(priv->idmac_ch,
>>>                         image.pix.bytesperline);
>>>
>>> I.e., I need to set CPMEM to interlaced mode when I operate CSI in
>>> interlaced mode. The original code is a bit unclear to me in fact.
>>
>> No the code above is not unclear at all. The if statement is saying
>> that if the user wants progressive output (V4L2_FIELD_NONE), and
>> the input contains fields, then turn on interweave in the IDMAC
>> channel.
>>
>> This might be a good time to bring up the fact that the ADV7180 
>> driver is wrong
>> to set output to "interlaced". The ADV7180 does not transmit top 
>> lines interlaced
>> with bottom lines. It transmits all top lines followed by all bottom 
>> lines (or
>> vice-versa), i.e. it should be either V4L2_FIELD_SEQ_TB or 
>> V4L2_FIELD_SEQ_BT.
>> It can also be set to V4L2_FIELD_ALTERNATE, and then it is left up to 
>> downstream
>> elements to determine field order (TB or BT).
>>
>> I've previously sent a patch to fix this at 
>> https://patchwork.linuxtv.org/patch/36193/
>> but it got lost. Niklas has said he will pick this up again.
>>
>>>
>>> The following is required as well. Now the question is why we can't 
>>> skip
>>> writing those odd UV rows. Anyway, with these 2 changes, I get a stable
>>> NTSC (and probably PAL) interlaced video stream.
>>>
>>> The manual says: Reduce Double Read or Writes (RDRW):
>>> This bit is relevant for YUV4:2:0 formats. For write channels:
>>> U and V components are not written to odd rows.
>>>
>>> How could it be so? With YUV420, are they normally written?
>>
>> Well, given that this bit exists, and assuming I understand it 
>> correctly (1),
>> I guess the U and V components for odd rows normally are placed on the
>> AXI bus. Which is a total waste of bus bandwidth because in 4:2:0,
>> the U and V components are the same for odd and even rows.
>>
>> In other words for writing 4:2:0 to memory, this bit should _always_ 
>> be set.
>>
>> (1) OTOH I don't really understand what this bit is trying to say.
>> Whether this bit is set or not, the data in memory is correct
>> for planar 4:2:0: y plane buffer followed by U plane of 1/4 size
>> (decimated by 2 in width and height), followed by Y plane of 1/4
>> size.
>>
>> So I assume it is saying that the IPU normally places U/V components
>> on the AXI bus for odd rows, that are identical to the even row values.
>> IOW somehow those identical odd rows are dropped before writing to
>> the U/V planes in memory.
>>
>> Philipp please chime in if you have something to add here.
>>
>> Steve
>>
>>> OTOH it seems that not only UV is broken with this bit set.
>>> Y is broken as well.
>>>
>>> --- a/drivers/staging/media/imx/imx-media-csi.c
>>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>>> @@ -413,14 +413,12 @@ static int csi_idmac_setup_channel(struct 
>>> csi_priv *priv)
>>>           passthrough_bits = 16;
>>>           break;
>>>       case V4L2_PIX_FMT_YUV420:
>>>       case V4L2_PIX_FMT_NV12:
>>>           burst_size = (image.pix.width & 0x3f) ?
>>>                    ((image.pix.width & 0x1f) ?
>>>                     ((image.pix.width & 0xf) ? 8 : 16) : 32) : 64;
>>>           passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
>>>           passthrough_bits = 16;
>>> -        /* Skip writing U and V components to odd rows */
>>> -        ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
>>>           break;
>>>       case V4L2_PIX_FMT_YUYV:
>>>       case V4L2_PIX_FMT_UYVY:
>>
>
