Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:43913 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727381AbeJDWL1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 18:11:27 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        jacopo mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
Date: Thu, 4 Oct 2018 15:17:21 +0000
Message-ID: <23425d71-bc72-b32b-f63e-fd481053529e@st.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <b3bac06f-f4d6-7620-2c3d-f8a852920f56@st.com>
 <20180928160507.4jerbp4dqgz6l4qu@flea>
 <56139505-6e5c-6d7f-027d-54b51c70b179@st.com>
 <20181004150402.uqqmkwbzvmotaq6r@flea>
In-Reply-To: <20181004150402.uqqmkwbzvmotaq6r@flea>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <873DCBC6E0954044A8902A3485F37BC3@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On 10/04/2018 05:04 PM, Maxime Ripard wrote:
> Hi!
> 
> On Mon, Oct 01, 2018 at 02:12:31PM +0000, Hugues FRUCHET wrote:
>>>> This is working perfectly fine on my parallel setup and allows me to
>>>> well support VGA@30fps (instead 27) and also support XGA(1024x768)@15fps
>>>> that I never seen working before.
>>>> So at least for the parallel setup, this serie is working fine for all
>>>> the discrete resolutions and framerate exposed by the driver for the moment:
>>>> * QCIF 176x144 15/30fps
>>>> * QVGA 320x240 15/30fps
>>>> * VGA 640x480 15/30fps
>>>> * 480p 720x480 15/30fps
>>>> * XGA 1024x768 15/30fps
>>>> * 720p 1280x720 15/30fps
>>>> * 1080p 1920x1080 15/30fps
>>>> * 5Mp 2592x1944 15fps
>>>
>>> I'm glad this is working for you as well. I guess I'll resubmit these
>>> patches, but this time making sure someone with a CSI setup tests
>>> before merging. I crtainly don't want to repeat the previous disaster.
>>>
>>> Do you have those patches rebased somewhere? I'm not quite sure how to
>>> fix the conflict with the v4l2_find_nearest_size addition.
>>>
>>>> Moreover I'm not clear on relationship between rate and pixel clock
>>>> frequency.
>>>> I've understood that to DVP_PCLK_DIVIDER (0x3824) register
>>>> and VFIFO_CTRL0C (0x460c) affects the effective pixel clock frequency.
>>>> All the resolutions up to 720x576 are forcing a manual value of 2 for
>>>> divider (0x460c=0x22), but including 720p and more, the divider value is
>>>> controlled by "auto-mode" (0x460c=0x20)... from what I measured and
>>>> understood, for those resolutions, the divider must be set to 1 in order
>>>> that your rate computation match the effective pixel clock on output,
>>>> see [2].
>>>>
>>>> So I wonder if this PCLK divider register should be included
>>>> or not into your rate computation, what do you think ?
>>>
>>> Have you tried change the PCLK divider while in auto-mode? IIRC, I did
>>> that and it was affecting the PCLK rate on my scope, but I wouldn't be
>>> definitive about it.
>>
>> I have tested to change PCLK divider while in auto mode but no effect.
>>
>>> Can we always set the mode to auto and divider to 1, even for the
>>> lower resolutions?
>>
>> This is breaking 176x144@30fps on my side, because of pixel clock too
>> high (112MHz vs 70 MHz max).
> 
> Ok.
> 
>> Instead of using auto mode, my proposal was the inverse: use manual mode
>> with the proper divider to fit the max pixel clock constraint.
> 
> Oh. That would work for me too yeah. How do you want to deal with it?
> Should I send your rebased patches, and you add that change as a
> subsequent patch?

Yes, this is the best option, and we can then ask people having CSI 
setup to check for non-regression after having applied this important 
clock serie patch.
Hoping that this will also work on their setup so that we can move 
forward on next OV5640 improvements.

> 
> Thanks!
> Maxime
> 

BR,
Hugues.
