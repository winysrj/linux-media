Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34170 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752561AbeAKJSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 04:18:41 -0500
Date: Thu, 11 Jan 2018 11:18:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Yong Deng <yong.deng@magewell.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Message-ID: <20180111091837.dznauzkdztx3crlf@valkosipuli.retiisi.org.uk>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
 <20180110153724.l77zpdgxfbzkznuf@flea>
 <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
 <20180110222508.4x5kimanevttmqis@valkosipuli.retiisi.org.uk>
 <6661b493-5f2a-b201-390d-e3452e6873a0@st.com>
 <20180111081912.curkvpguof6ul555@valkosipuli.retiisi.org.uk>
 <40f2e25e-3662-fce9-549b-360bbafad623@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f2e25e-3662-fce9-549b-360bbafad623@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 11, 2018 at 08:25:41AM +0000, Hugues FRUCHET wrote:
> On 01/11/2018 09:19 AM, Sakari Ailus wrote:
> > On Thu, Jan 11, 2018 at 08:12:11AM +0000, Hugues FRUCHET wrote:
> >> Hi Sakari,
> >>
> >> On 01/10/2018 11:25 PM, Sakari Ailus wrote:
> >>> Hi Hugues,
> >>>
> >>> On Wed, Jan 10, 2018 at 03:51:07PM +0000, Hugues FRUCHET wrote:
> >>>> Good news Maxime !
> >>>>
> >>>> Have you seen that you can adapt the polarities through devicetree ?
> >>>>
> >>>> +                       /* Parallel bus endpoint */
> >>>> +                       ov5640_to_parallel: endpoint {
> >>>> [...]
> >>>> +                               hsync-active = <0>;
> >>>> +                               vsync-active = <0>;
> >>>> +                               pclk-sample = <1>;
> >>>> +                       };
> >>>>
> >>>> Doing so you can adapt to your SoC/board setup easily.
> >>>>
> >>>> If you don't put those lines in devicetree, the ov5640 default init
> >>>> sequence is used which set the polarity as defined in below comment:
> >>>> ov5640_set_stream_dvp()
> >>>> [...]
> >>>> +        * Control lines polarity can be configured through
> >>>> +        * devicetree endpoint control lines properties.
> >>>> +        * If no endpoint control lines properties are set,
> >>>> +        * polarity will be as below:
> >>>> +        * - VSYNC:     active high
> >>>> +        * - HREF:      active low
> >>>> +        * - PCLK:      active low
> >>>> +        */
> >>>> [...]
> >>>
> >>> The properties are at the moment documented as mandatory in DT binding
> >>> documentation.
> >>>
> >> of course, it was just to ask Maxime to check the devicetree on its
> >> side, the symptom observed by Maxime with hsync/vsync inversed is the
> >> same than the one observed if we stick to just default init sequence.
> > 
> > I wonder if the driver should be changed to require hsync and vsync. These
> > signals won't be there at all in Bt.656 mode.
> > 
> I will revisit this when pushing Bt.656 mode.

That may lead to a situation where DT source which currently intends to use
parallel bus with sync signals will automatically switch to Bt.656. That
could be an issue for the receiver.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
