Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:36563 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751488AbdITMXz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 08:23:55 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8KCNcrm018693
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 13:23:53 +0100
Received: from mail-pf0-f199.google.com (mail-pf0-f199.google.com [209.85.192.199])
        by mx07-00252a01.pphosted.com with ESMTP id 2d0sc0221g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 13:23:53 +0100
Received: by mail-pf0-f199.google.com with SMTP id p87so4626366pfj.4
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 05:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f4824a16-13ce-7d49-c7dd-19a11f3c01ec@cisco.com>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
 <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
 <1505834685.10076.5.camel@pengutronix.de> <20170919134930.6fa28562@recife.lan>
 <CAAoAYcNCPrpZWvxTTsCtGd4vobsQKDw-ckLhXyRst0dS++h_Ag@mail.gmail.com>
 <1505903026.7865.6.camel@pengutronix.de> <CAAoAYcN+KGSNNvF2SZVg=HnS5DC8pR26S+=ofwbaeJim5tsQaA@mail.gmail.com>
 <f4824a16-13ce-7d49-c7dd-19a11f3c01ec@cisco.com>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Wed, 20 Sep 2017 13:23:50 +0100
Message-ID: <CAAoAYcNsnBJPCsdFT1jazkJMPOHyGM387kt9hdx4h=WnERLP=w@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
To: Hans Verkuil <hansverk@cisco.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 September 2017 at 12:24, Hans Verkuil <hansverk@cisco.com> wrote:
> On 09/20/17 13:00, Dave Stevenson wrote:
>> On 20 September 2017 at 11:23, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>> Hi,
>>>
>>> On Wed, 2017-09-20 at 10:14 +0100, Dave Stevenson wrote:
>>>> Hi Mauro & Philipp
>>>>
>>>> On 19 September 2017 at 17:49, Mauro Carvalho Chehab
>>>> <mchehab@s-opensource.com> wrote:
>>>>> Em Tue, 19 Sep 2017 17:24:45 +0200
>>>>> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
>>>>>
>>>>>> Hi Dave,
>>>>>>
>>>>>> On Tue, 2017-09-19 at 14:08 +0100, Dave Stevenson wrote:
>>>>>>> The existing fixed value of 16 worked for UYVY 720P60 over
>>>>>>> 2 lanes at 594MHz, or UYVY 1080P60 over 4 lanes. (RGB888
>>>>>>> 1080P60 needs 6 lanes at 594MHz).
>>>>>>> It doesn't allow for lower resolutions to work as the FIFO
>>>>>>> underflows.
>>>>>>>
>>>>>>> Using a value of 300 works for all resolutions down to VGA60,
>>>>>>> and the increase in frame delay is <4usecs for 1080P60 UYVY
>>>>>>> (2.55usecs for RGB888).
>>>>>>>
>>>>>>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>>>>>
>>>>>> Can we increase this to 320? This would also allow
>>>>>> 720p60 at 594 Mbps / 4 lanes, according to the xls.
>>>>
>>>> Unless I've missed something then the driver would currently request
>>>> only 2 lanes for 720p60 UYVY, and that works with the existing FIFO
>>>> setting of 16. Likewise 720p60 RGB888 requests 3 lanes and also works
>>>> on a FIFO setting of 16.
>>>> How/why were you thinking we need to run all four lanes for 720p60
>>>> without other significant driver mods around lane config?
>>>
>>> The driver currently silently changes the number of active lanes
>>> depending on required data rate, with no way to communicate it to the
>>> receiver.
>>
>> It is communicated over the subdevice API - tc358743_g_mbus_config
>> reports back the appropriate number of lanes to the receiver
>> subdevice.
>> A suitable v4l2_subdev_has_op(dev->sensor, video, g_mbus_config) call
>> as you're starting streaming therefore gives you the correct
>> information. That's what I've just done for the BCM283x Unicam
>> driver[1], but admittedly I'm not using the media controller API which
>> i.MX6 is.
>
> Shouldn't this information come from the device tree? The g_mbus_config
> op is close to being deprecated or even removed. There are currently only
> two obscure V4L2 bridge drivers that call it. It dates from pre-DT times
> I rather not see it used in a new bridge driver.
>
> The problem is that contains data that belongs to the DT (hardware
> capabilities). Things that can actually change dynamically should be
> communicated via another op. We don't have that, so that should be created.
>
> I've CC-ed Sakari, he is the specialist for such things.

You've reminded me that I asked that same question earlier in the
year, and Sakari had replied -
http://www.spinics.net/lists/linux-media/msg115550.html

Is it specifically device tree related? Just because the lanes are
physically there doesn't necessarily mean they have to be used.

A quick test with the spreadsheet appears to say that 1080p24 UYVY
over 4 lanes at 594Mbps needs a FIFO setting >=480 (the max is 511). I
would anticipate that to be one of the worst situations as we're
dealing with a FIFO underflow herewhen there is a significantly faster
CSI rate than HDMI.
It can't be supported with a 972Mbps link frequency over 4 lanes
(needs >=667), and 2 lanes needs a FIFO setting >=374.

I'll see what numbers fall out of the new spreadsheet for all standard
modes. If there are some modes that can't be supported over 4 lanes
then there is an absolute requirement for communicating the number of
lanes to use.

Seeing as Cisco have kit shipping with this chip and driver, can I ask
how they are managing the choice over number of lanes in use?


As for this patch it sounds like we need to crank the FIFO setting up
to the maximum of 511, and potentially a second patch that removes
g_mbus_config and only reads DT if that is the desired behaviour.

>>
>> [1] http://www.spinics.net/lists/linux-media/msg121813.html, as part
>> of the unicam_start_streaming function.
>>
>>> The i.MX6 MIPI CSI-2 receiver driver can't cope with that, as it always
>>> activates all four lanes that are configured in the device tree. I can
>>> work around that with the following patch:
>>
>> It can't cope running at less than 4 lanes, or it can't cope with a change?
>>
>>> ----------8<----------
>>> Subject: [PATCH] [media] tc358743: do not dynamically reduce number of lanes
>>>
>>> Dynamic lane number reduction does not work with receivers that
>>> configure a fixed lane number according to the device tree settings.
>>> To allow 720p60 at 594 Mbit/s on 4 lanes, increase the fifo_level
>>> and tclk_trailcnt settings.
>>>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> ---
>>>  drivers/media/i2c/tc358743.c | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
>>> index 64f504542a819..70a9435928cdb 100644
>>> --- a/drivers/media/i2c/tc358743.c
>>> +++ b/drivers/media/i2c/tc358743.c
>>> @@ -683,7 +683,7 @@ static void tc358743_set_csi(struct v4l2_subdev *sd)
>>>  {
>>>         struct tc358743_state *state = to_state(sd);
>>>         struct tc358743_platform_data *pdata = &state->pdata;
>>> -       unsigned lanes = tc358743_num_csi_lanes_needed(sd);
>>> +       unsigned lanes = state->bus.num_data_lanes;
>>>
>>>         v4l2_dbg(3, debug, sd, "%s:\n", __func__);
>>>
>>> @@ -1906,7 +1906,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
>>>         state->pdata.ddc5v_delay = DDC5V_DELAY_100_MS;
>>>         state->pdata.enable_hdcp = false;
>>>         /* A FIFO level of 16 should be enough for 2-lane 720p60 at 594 MHz. */
>>> -       state->pdata.fifo_level = 16;
>>> +       state->pdata.fifo_level = 320;
>>>         /*
>>>          * The PLL input clock is obtained by dividing refclk by pll_prd.
>>>          * It must be between 6 MHz and 40 MHz, lower frequency is better.
>>> @@ -1948,7 +1948,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
>>>         state->pdata.lptxtimecnt = 0x003;
>>>         /* tclk-preparecnt: 3, tclk-zerocnt: 20 */
>>>         state->pdata.tclk_headercnt = 0x1403;
>>> -       state->pdata.tclk_trailcnt = 0x00;
>>> +       state->pdata.tclk_trailcnt = 0x01;
>>>         /* ths-preparecnt: 3, ths-zerocnt: 1 */
>>>         state->pdata.ths_headercnt = 0x0103;
>>>         state->pdata.twakeup = 0x4882;
>>> --
>>> 2.11.0
>>> ---------->8----------
>>>
>>> Just adding the same heuristic as tc358743_num_csi_lanes_needed in the
>>> imx6-mipi-csi2 driver doesn't work, as the heuristic is specific to the
>>> Toshiba chip. There are MIPI CSI-2 sensors that only support a fixed
>>> number of lanes, for example.
>>>
>>> I'd need a way to communicate the number of active MIPI CSI-2 lanes
>>> between transmitting and receiving subdevice driver.
>>>
>>>> Once I've got a v3 done on the Unicam driver I'll bash through the
>>>> standard HDMI modes and check what value they need - I can see a big
>>>> spreadsheet coming on.
>>>
>>> Oh dear. Unless the point you make below can be resolved, I think we
>>> have no other choice.
>>>
>>>> I'll ignore interlaced modes as I can't see any support for it in the
>>>> driver. Receiving the fields on different CSI-2 data types is
>>>> something I know the Unicam hardware won't handle nicely, and I
>>>> suspect it'd be an issue for many other platforms too.
>>>
>>> Yes, let's pretend interlacing doesn't exist as long as possible.
>>>
>>>>> Hmm... if this is dependent on the resolution and frame rate,
>>>>> wouldn't
>>>>> it be better to dynamically adjust it accordingly?
>>>>
>>>> It's setting up the FIFO matching the incoming HDMI data rate and
>>>> outgoing CSI rate. That means it's dependent on the incoming pixel
>>>> clock, blanking, colour format and resolution, and output CSI link
>>>> frequency, number of lanes, and colour format.
>>>> Whilst it could be set dynamically based on all those parameters, is
>>>> there a significant enough gain in doing so?
>>>
>>> Ideally there would be no need to maintain a timing database with -
>>> worst case - (number of link frequencies * number of HDMI modes) entries
>>> in the driver ...
>>>
>>>> The value of 300 works for all cases I've tried, and referencing back
>>>> it is also the value that Hans said Cisco use via platform data on
>>>> their hardware [1]. Generally I'm seeing that values of 0-130 are
>>>> required, so 300 is giving a fair safety margin.
>>>
>>> It does not work for 720p60 on 4 lanes at 594 Mbit/s, as the spreadsheet
>>> warns, and testing shows.
>>
>> If it doesn't work with 720p60, then I guess it has no hope with many
>> other resolutions.
>> It sounds like confirming whether g_mbus_config is a potential
>> solution for i.MX6 (sorry I'm not familiar enough with that code to do
>> my own quick search), but otherwise cranking it up to 320 is
>> reasonable, and I'll see what other numbers fall out of the
>> spreadsheet.
>>
>>>> Second question is does anyone have a suitable relationship with
>>>> Toshiba to get permission to release details of these register
>>>> calculations? The datasheet and value spreadsheet are marked as
>>>> confidential, and probably under NDA in almost all cases. Whilst they
>>>> can't object to drivers containing values to make them work, they
>>>> might over releasing significant details.
>>>
>>> Unfortunately, I don't.
>>
>> I'm guessing Cisco may be in the best position to try pushing that.
>> Certainly all our info is under NDA, and we don't really have a
>> significant working relationship with them.
>
> I think we tried at the time, but no luck.

Thanks.
So unless someone else has a relationship with Toshiba then it has to
be some fixed value - no real option for calculating it dynamically.
(That also means my intent to support arbitrary link frequencies won't
fly as that would require publishing details of how to compute
lineinintcnt, lptxtimecnt, etc. Oh well.)

  Dave
