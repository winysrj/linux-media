Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:37462 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbeFBR6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 13:58:39 -0400
Received: by mail-pl0-f68.google.com with SMTP id 31-v6so7226916plc.4
        for <linux-media@vger.kernel.org>; Sat, 02 Jun 2018 10:58:39 -0700 (PDT)
Subject: Re: [PATCH v2 10/10] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
 <1527813049-3231-11-git-send-email-steve_longerbeam@mentor.com>
 <1527860665.5913.13.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <87255e12-a257-28fa-4965-b040da5043d2@gmail.com>
Date: Sat, 2 Jun 2018 10:58:35 -0700
MIME-Version: 1.0
In-Reply-To: <1527860665.5913.13.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/01/2018 06:44 AM, Philipp Zabel wrote:
> On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
>> Also add an example pipeline for unconverted capture with interweave
>> on SabreAuto.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   Documentation/media/v4l-drivers/imx.rst | 51 ++++++++++++++++++++++++---------
>>   1 file changed, 37 insertions(+), 14 deletions(-)
>>
>> diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
>> index 65d3d15..4149b76 100644
>> --- a/Documentation/media/v4l-drivers/imx.rst
>> +++ b/Documentation/media/v4l-drivers/imx.rst
>> @@ -179,9 +179,10 @@ sink pad can take UYVY2X8, but the IDMAC source pad can output YUYV2X8.
>>   If the sink pad is receiving YUV, the output at the capture device can
>>   also be converted to a planar YUV format such as YUV420.
>>   
>> -It will also perform simple de-interlace without motion compensation,
>> -which is activated if the sink pad's field type is an interlaced type,
>> -and the IDMAC source pad field type is set to none.
>> +It will also perform simple interweave without motion compensation,
>> +which is activated if the sink pad's field type is sequential top-bottom
>> +or bottom-top or alternate, and the IDMAC source pad field type is
>> +interlaced (t-b, b-t, or unqualified interlaced).
> I think sink pad alternate behaviour should be equal to sink pad top-
> bottom for PAL and sink pad bottom-top for NTSC. If we agree on this, we
> should mention that here.

Agreed.

>
>>   This subdev can generate the following event when enabling the second
>>   IDMAC source pad:
>> @@ -383,13 +384,13 @@ and CSC operations and flip/rotation controls. It will receive and
>>   process de-interlaced frames from the ipuX_vdic if ipuX_ic_prp is
>>   receiving from ipuX_vdic.
>>   
>> -Like the ipuX_csiY IDMAC source, it can perform simple de-interlace
>> +Like the ipuX_csiY IDMAC source, it can perform simple interweaving
>>   without motion compensation. However, note that if the ipuX_vdic is
>>   included in the pipeline (ipuX_ic_prp is receiving from ipuX_vdic),
>> -it's not possible to use simple de-interlace in ipuX_ic_prpvf, since
>> -the ipuX_vdic has already carried out de-interlacing (with motion
>> -compensation) and therefore the field type output from ipuX_ic_prp can
>> -only be none.
>> +it's not possible to use interweave in ipuX_ic_prpvf, since the
>> +ipuX_vdic has already carried out de-interlacing (with motion
>> +compensation) and therefore the field type output from ipuX_vdic
>> +can only be none (progressive).
>>   
>>   Capture Pipelines
>>   -----------------
>> @@ -514,10 +515,32 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
>>   parallel bus input on the internal video mux to IPU1 CSI0.
>>   
>>   The following example configures a pipeline to capture from the ADV7180
>> +video decoder, assuming NTSC 720x480 input signals, using simple
>> +interweave (unconverted and without motion compensation). The adv7180
>> +must output sequential or alternating fields (field type 'seq-tb',
>> +'seq-bt', or 'alternate'):
>> +
>> +.. code-block:: none
>> +
>> +   # Setup links
>> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
>> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>> +   # Configure pads
>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480 field:interlaced]"
> Could the example suggest using interlaced-bt to be explicit here?
> Actually, I don't think we should allow interlaced on the CSI src pads
> at all in this case. Technically it always writes either seq-tb or seq-
> bt into the smfc, never interlaced (unless the input is already
> interlaced).

Agreed, I'll make that change in v3 and update the doc.

Steve

>> +Streaming can then begin on the capture device node at
>> +"ipu1_csi0 capture". The v4l2-ctl tool can be used to select any
>> +supported YUV pixelformat on the capture device node.
>> +
>> +This example configures a pipeline to capture from the ADV7180
>>   video decoder, assuming NTSC 720x480 input signals, with Motion
>> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
>> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
>> -entity at its output pad:
>> +Compensated de-interlacing. The adv7180 must output sequential or
>> +alternating fields (field type 'seq-tb', 'seq-bt', or 'alternate').
>> +$outputfmt can be any format supported by the ipu1_ic_prpvf entity
>> +at its output pad:
>>   
>>   .. code-block:: none
>>   
>> @@ -529,9 +552,9 @@ entity at its output pad:
>>      media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
>>      media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
>>      # Configure pads
>> -   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480]"
>> -   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
>> -   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480 field:interlaced]"
>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>> +   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480]"
>>      media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480 field:none]"
>>      media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
>>      media-ctl -V "'ipu1_ic_prpvf':1 [fmt:$outputfmt field:none]"
> This looks good to me.
>
> regards
> Philipp
