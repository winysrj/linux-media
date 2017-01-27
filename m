Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53686 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934038AbdA0LWJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 06:22:09 -0500
Subject: Re: [PATCH v2 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <HK2PR06MB05453E11C8931F881E106939C36E0@HK2PR06MB0545.apcprd06.prod.outlook.com>
 <cca1ade8-01ef-8eab-f4b1-7dd7f204fdea@xs4all.nl> <4506041.7mPt4W6j0m@avalon>
 <HK2PR06MB0545BF36C3DD2D4D1B951C3FC3670@HK2PR06MB0545.apcprd06.prod.outlook.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e96cb1cd-cd4a-60f2-cf46-dc837638d115@xs4all.nl>
Date: Fri, 27 Jan 2017 12:20:43 +0100
MIME-Version: 1.0
In-Reply-To: <HK2PR06MB0545BF36C3DD2D4D1B951C3FC3670@HK2PR06MB0545.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2017 10:31 AM, Ramesh Shanmugasundaram wrote:
> Hi Laurent,
> 
>>>>>> On Wednesday 21 Dec 2016 08:10:37 Ramesh Shanmugasundaram wrote:
>>>>>>> Add binding documentation for Renesas R-Car Digital Radio
>>>>>>> Interface
>>>>>>> (DRIF) controller.
>>>>>>>
>>>>>>> Signed-off-by: Ramesh Shanmugasundaram
>>>>>>> <ramesh.shanmugasundaram@bp.renesas.com> ---
>>>>>>>
>>>>>>>  .../devicetree/bindings/media/renesas,drif.txt     | 202
>> +++++++++++++
>>>>>>>  1 file changed, 202 insertions(+)  create mode 100644
>>>>>>>
>>>>>>> Documentation/devicetree/bindings/media/renesas,drif.txt
>>>>>>>
>>>>>>> diff --git
>>>>>>> a/Documentation/devicetree/bindings/media/renesas,drif.txt
>>>>>>> b/Documentation/devicetree/bindings/media/renesas,drif.txt new
>>>>>>> file mode 100644 index 0000000..1f3feaf
>>>>>>> --- /dev/null
>>>>>>> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
>>>>>>>
>>>>>>> +Optional properties of an internal channel when:
>>>>>>> +     - It is the only enabled channel of the bond (or)
>>>>>>> +     - If it acts as primary among enabled bonds
>>>>>>> +--------------------------------------------------------
>>>>>>> +- renesas,syncmd       : sync mode
>>>>>>> +                      0 (Frame start sync pulse mode. 1-bit
>>>>>>> +width
>>>>>>> pulse
>>>>>>> +                         indicates start of a frame)
>>>>>>> +                      1 (L/R sync or I2S mode) (default)
>>>>>>> +- renesas,lsb-first    : empty property indicates lsb bit is
>> received
>>>>>>> first.
>>>>>>> +                      When not defined msb bit is received first
>>>>>>> +(default)
>>>>>>> +- renesas,syncac-active: Indicates sync signal polarity, 0/1 for
>>>>>>> low/high
>>>
>>> Shouldn't this be 'renesas,sync-active' instead of syncac-active?
>>>
>>> I'm not sure if syncac is intended or if it is a typo.
>>>
>>>>>>> +                      respectively. The default is 1 (active high)
>>>>>>> +- renesas,dtdl         : delay between sync signal and start of
>>>>>>> reception.
>>>>>>> +                      The possible values are represented in 0.5
>> clock
>>>>>>> +                      cycle units and the range is 0 to 4. The
>> default
>>>>>>> +                      value is 2 (i.e.) 1 clock cycle delay.
>>>>>>> +- renesas,syncdl       : delay between end of reception and sync
>>>>>>> signal edge.
>>>>>>> +                      The possible values are represented in 0.5
>> clock
>>>>>>> +                      cycle units and the range is 0 to 4 & 6.
>>>>>>> + The
>>>>>>> default
>>>>>>> +                      value is 0 (i.e.) no delay.

Are these properties actually going to be used by anyone? Just curious.

>>>>>>
>>>>>> Most of these properties are pretty similar to the video bus
>>>>>> properties defined at the endpoint level in
>>>>>> Documentation/devicetree/bindings/media/video-interfaces.txt. I
>>>>>> believe it would make sense to use OF graph and try to standardize
>>>>>> these properties similarly.
>>>
>>> Other than sync-active, is there really anything else that is similar?
>>> And even the sync-active isn't a good fit since here there is only one
>>> sync signal instead of two for video (h and vsync).
>>
>> That's why I said similar, not identical :-) My point is that, if we
>> consider that we could connect multiple sources to the DRIF, using OF
>> graph would make sense, and the above properties should then be defined
>> per endpoint.
> 
> Thanks for the clarifications. I have some questions.
> 
> - Assuming two devices are interfaced with DRIF and they are represented using two endpoints, the control signal related properties of DRIF might still need to be same for both endpoints? For e.g. syncac-active cannot be different in both endpoints?

Usually that's the case, but HW designers are weird :-)

> 
> - I suppose "lsb-first", "dtdl" & "syncdl" may be defined per endpoint. However, h/w manual says same register values needs to be programmed for both the internal channels of a channel. Same with "syncmd" property.
> 
> We could still define them as per endpoint property with a note that they need to be same. But I am not sure if that is what you intended?
> 
>  If we define them per endpoint we should then also try
>> standardize the ones that are not really Renesas-specific (that's at least
>> syncac-active).
> 
> OK. I will call it "sync-active".

That's better, yes.

> 
>  For the syncmd and lsb-first properties, it could also
>> make sense to query them from the connected subdev at runtime, as they're
>> similar in purpose to formats and media bus configuration (struct
>> v4l2_mbus_config).

I consider this unlikely. I wouldn't spend time on that as this can always be
done later.

> May I know in bit more detail about what you had in mind? Please correct me if my understanding is wrong here but when I looked at the code
> 
> 1) mbus_config is part of subdev_video_ops only. I assume we don't want to support this as part of tuner subdev. The next closest is pad_ops with "struct v4l2_mbus_framefmt" but it is fully video specific config unless I come up with new MEDIA_BUS_FMT_xxxx in media-bus-format.h and use the code field? For e.g.
> 	
> #define MEDIA_BUS_FMT_SDR_I2S_PADHI_BE       0x7001
> #define MEDIA_BUS_FMT_SDR_I2S_PADHI_LE       0x7002
> 
> 2) The framework does not seem to mandate pad ops for all subdev. As the tuner can be any third party subdev, is it fair to assume that these properties can be queried from subdev?
> 
> 3) Assuming pad ops is not available on the subdev shouldn't we still need a way to define these properties on DRIF DT?
> 
>>
>> I'm not an SDR expert, so I'd like to have your opinion on this.

Neither am I :-)

I think using the endpoint idea does make sense since this helps in describing the
routing. I am not sure what properties to put in there, though.

Can you describe a bit more which properties belong to which syncmd mode? That will
help me make a decision.

Regards,

	Hans

>>
>>>>> Note that the last two properties match the those in
>>>>> Documentation/devicetree/bindings/spi/sh-msiof.txt.
>>>>> We may want to use one DRIF channel as a plain SPI slave with the
>>>>> (modified) MSIOF driver in the future.
>>>>
>>>> Should I leave it as it is or modify these as in video-interfaces.txt?
>>>> Shall we conclude on this please?
>>
> 
> Thanks,
> Ramesh
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

