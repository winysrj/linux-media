Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39454 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbdAIXJT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 18:09:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
Subject: Re: [PATCH v2 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
Date: Tue, 10 Jan 2017 01:09:28 +0200
Message-ID: <4506041.7mPt4W6j0m@avalon>
In-Reply-To: <cca1ade8-01ef-8eab-f4b1-7dd7f204fdea@xs4all.nl>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <HK2PR06MB05453E11C8931F881E106939C36E0@HK2PR06MB0545.apcprd06.prod.outlook.com> <cca1ade8-01ef-8eab-f4b1-7dd7f204fdea@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Monday 09 Jan 2017 14:36:55 Hans Verkuil wrote:
> On 01/03/2017 04:20 PM, Ramesh Shanmugasundaram wrote:
> >>> On Wednesday 21 Dec 2016 08:10:37 Ramesh Shanmugasundaram wrote:
> >>>> Add binding documentation for Renesas R-Car Digital Radio Interface
> >>>> (DRIF) controller.
> >>>> 
> >>>> Signed-off-by: Ramesh Shanmugasundaram
> >>>> <ramesh.shanmugasundaram@bp.renesas.com> ---
> >>>> 
> >>>>  .../devicetree/bindings/media/renesas,drif.txt     | 202 +++++++++++++
> >>>>  1 file changed, 202 insertions(+)
> >>>>  create mode 100644
> >>>> 
> >>>> Documentation/devicetree/bindings/media/renesas,drif.txt
> >>>> 
> >>>> diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
> >>>> b/Documentation/devicetree/bindings/media/renesas,drif.txt new file
> >>>> mode 100644
> >>>> index 0000000..1f3feaf
> >>>> --- /dev/null
> >>>> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> >>>> 
> >>>> +Optional properties of an internal channel when:
> >>>> +     - It is the only enabled channel of the bond (or)
> >>>> +     - If it acts as primary among enabled bonds
> >>>> +--------------------------------------------------------
> >>>> +- renesas,syncmd       : sync mode
> >>>> +                      0 (Frame start sync pulse mode. 1-bit width
> >>>> pulse
> >>>> +                         indicates start of a frame)
> >>>> +                      1 (L/R sync or I2S mode) (default)
> >>>> +- renesas,lsb-first    : empty property indicates lsb bit is received
> >>>> first.
> >>>> +                      When not defined msb bit is received first
> >>>> +(default)
> >>>> +- renesas,syncac-active: Indicates sync signal polarity, 0/1 for
> >>>> low/high
> 
> Shouldn't this be 'renesas,sync-active' instead of syncac-active?
> 
> I'm not sure if syncac is intended or if it is a typo.
> 
> >>>> +                      respectively. The default is 1 (active high)
> >>>> +- renesas,dtdl         : delay between sync signal and start of
> >>>> reception.
> >>>> +                      The possible values are represented in 0.5 clock
> >>>> +                      cycle units and the range is 0 to 4. The default
> >>>> +                      value is 2 (i.e.) 1 clock cycle delay.
> >>>> +- renesas,syncdl       : delay between end of reception and sync
> >>>> signal edge.
> >>>> +                      The possible values are represented in 0.5 clock
> >>>> +                      cycle units and the range is 0 to 4 & 6. The
> >>>> default
> >>>> +                      value is 0 (i.e.) no delay.
> >>> 
> >>> Most of these properties are pretty similar to the video bus
> >>> properties defined at the endpoint level in
> >>> Documentation/devicetree/bindings/media/video-interfaces.txt. I
> >>> believe it would make sense to use OF graph and try to standardize
> >>> these properties similarly.
> 
> Other than sync-active, is there really anything else that is similar? And
> even the sync-active isn't a good fit since here there is only one sync
> signal instead of two for video (h and vsync).

That's why I said similar, not identical :-) My point is that, if we consider 
that we could connect multiple sources to the DRIF, using OF graph would make 
sense, and the above properties should then be defined per endpoint. If we 
define them per endpoint we should then also try standardize the ones that are 
not really Renesas-specific (that's at least syncac-active). For the syncmd 
and lsb-first properties, it could also make sense to query them from the 
connected subdev at runtime, as they're similar in purpose to formats and 
media bus configuration (struct v4l2_mbus_config).

I'm not an SDR expert, so I'd like to have your opinion on this.

> >> Note that the last two properties match the those in
> >> Documentation/devicetree/bindings/spi/sh-msiof.txt.
> >> We may want to use one DRIF channel as a plain SPI slave with the
> >> (modified) MSIOF driver in the future.
> > 
> > Should I leave it as it is or modify these as in video-interfaces.txt?
> > Shall we conclude on this please?

-- 
Regards,

Laurent Pinchart

