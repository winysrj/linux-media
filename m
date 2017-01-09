Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41852 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755800AbdAINhD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 08:37:03 -0500
Subject: Re: [PATCH v2 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-7-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <11494368.ZdobxT7gGY@avalon>
 <CAMuHMdXj-xBrnBXfYu6BeXr7Gfv4wogH4z610Ddq-BSyVS=-8Q@mail.gmail.com>
 <HK2PR06MB05453E11C8931F881E106939C36E0@HK2PR06MB0545.apcprd06.prod.outlook.com>
Cc: Rob Herring <robh+dt@kernel.org>,
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
Message-ID: <cca1ade8-01ef-8eab-f4b1-7dd7f204fdea@xs4all.nl>
Date: Mon, 9 Jan 2017 14:36:55 +0100
MIME-Version: 1.0
In-Reply-To: <HK2PR06MB05453E11C8931F881E106939C36E0@HK2PR06MB0545.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 04:20 PM, Ramesh Shanmugasundaram wrote:
> Hi Laurent, Geert,
> 
> Thanks for the review comments.
> 
>>> On Wednesday 21 Dec 2016 08:10:37 Ramesh Shanmugasundaram wrote:
>>>> Add binding documentation for Renesas R-Car Digital Radio Interface
>>>> (DRIF) controller.
>>>>
>>>> Signed-off-by: Ramesh Shanmugasundaram
>>>> <ramesh.shanmugasundaram@bp.renesas.com> ---
>>>>  .../devicetree/bindings/media/renesas,drif.txt     | 202
>> ++++++++++++++++++
>>>>  1 file changed, 202 insertions(+)
>>>>  create mode 100644
>>>> Documentation/devicetree/bindings/media/renesas,drif.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
>>>> b/Documentation/devicetree/bindings/media/renesas,drif.txt new file
>>>> mode
>>>> 100644
>>>> index 0000000..1f3feaf
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
>>
>>>> +Optional properties of an internal channel when:
>>>> +     - It is the only enabled channel of the bond (or)
>>>> +     - If it acts as primary among enabled bonds
>>>> +--------------------------------------------------------
>>>> +- renesas,syncmd       : sync mode
>>>> +                      0 (Frame start sync pulse mode. 1-bit width
>> pulse
>>>> +                         indicates start of a frame)
>>>> +                      1 (L/R sync or I2S mode) (default)
>>>> +- renesas,lsb-first    : empty property indicates lsb bit is received
>>>> first.
>>>> +                      When not defined msb bit is received first
>>>> +(default)
>>>> +- renesas,syncac-active: Indicates sync signal polarity, 0/1 for
>> low/high

Shouldn't this be 'renesas,sync-active' instead of syncac-active?

I'm not sure if syncac is intended or if it is a typo.

>>>> +                      respectively. The default is 1 (active high)
>>>> +- renesas,dtdl         : delay between sync signal and start of
>> reception.
>>>> +                      The possible values are represented in 0.5 clock
>>>> +                      cycle units and the range is 0 to 4. The default
>>>> +                      value is 2 (i.e.) 1 clock cycle delay.
>>>> +- renesas,syncdl       : delay between end of reception and sync
>> signal
>>>> edge.
>>>> +                      The possible values are represented in 0.5 clock
>>>> +                      cycle units and the range is 0 to 4 & 6. The
>> default
>>>> +                      value is 0 (i.e.) no delay.
>>>
>>> Most of these properties are pretty similar to the video bus
>>> properties defined at the endpoint level in
>>> Documentation/devicetree/bindings/media/video-interfaces.txt. I
>>> believe it would make sense to use OF graph and try to standardize
>>> these properties similarly.

Other than sync-active, is there really anything else that is similar? And
even the sync-active isn't a good fit since here there is only one sync
signal instead of two for video (h and vsync).

Regards,

	Hans

>> Note that the last two properties match the those in
>> Documentation/devicetree/bindings/spi/sh-msiof.txt.
>> We may want to use one DRIF channel as a plain SPI slave with the
>> (modified) MSIOF driver in the future.
> 
> Should I leave it as it is or modify these as in video-interfaces.txt? Shall we conclude on this please?
> 
> Thanks,
> Ramesh
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 

