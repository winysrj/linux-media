Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:25895 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdITMha (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 08:37:30 -0400
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
 <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
 <1505834685.10076.5.camel@pengutronix.de>
 <20170919134930.6fa28562@recife.lan>
 <CAAoAYcNCPrpZWvxTTsCtGd4vobsQKDw-ckLhXyRst0dS++h_Ag@mail.gmail.com>
 <1505903026.7865.6.camel@pengutronix.de>
 <CAAoAYcN+KGSNNvF2SZVg=HnS5DC8pR26S+=ofwbaeJim5tsQaA@mail.gmail.com>
 <f4824a16-13ce-7d49-c7dd-19a11f3c01ec@cisco.com>
 <CAAoAYcNsnBJPCsdFT1jazkJMPOHyGM387kt9hdx4h=WnERLP=w@mail.gmail.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <0e4f60bc-1c1d-c71d-0a57-4b2227512617@cisco.com>
Date: Wed, 20 Sep 2017 14:37:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcNsnBJPCsdFT1jazkJMPOHyGM387kt9hdx4h=WnERLP=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/17 14:23, Dave Stevenson wrote:
> On 20 September 2017 at 12:24, Hans Verkuil <hansverk@cisco.com> wrote:
>> On 09/20/17 13:00, Dave Stevenson wrote:
>>> On 20 September 2017 at 11:23, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>>> Hi,
>>>>
>>>> On Wed, 2017-09-20 at 10:14 +0100, Dave Stevenson wrote:
>>>>> Hi Mauro & Philipp
>>>>>
>>>>> On 19 September 2017 at 17:49, Mauro Carvalho Chehab
>>>>> <mchehab@s-opensource.com> wrote:
>>>>>> Em Tue, 19 Sep 2017 17:24:45 +0200
>>>>>> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
>>>>>>
>>>>>>> Hi Dave,
>>>>>>>
>>>>>>> On Tue, 2017-09-19 at 14:08 +0100, Dave Stevenson wrote:
>>>>>>>> The existing fixed value of 16 worked for UYVY 720P60 over
>>>>>>>> 2 lanes at 594MHz, or UYVY 1080P60 over 4 lanes. (RGB888
>>>>>>>> 1080P60 needs 6 lanes at 594MHz).
>>>>>>>> It doesn't allow for lower resolutions to work as the FIFO
>>>>>>>> underflows.
>>>>>>>>
>>>>>>>> Using a value of 300 works for all resolutions down to VGA60,
>>>>>>>> and the increase in frame delay is <4usecs for 1080P60 UYVY
>>>>>>>> (2.55usecs for RGB888).
>>>>>>>>
>>>>>>>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>>>>>>
>>>>>>> Can we increase this to 320? This would also allow
>>>>>>> 720p60 at 594 Mbps / 4 lanes, according to the xls.
>>>>>
>>>>> Unless I've missed something then the driver would currently request
>>>>> only 2 lanes for 720p60 UYVY, and that works with the existing FIFO
>>>>> setting of 16. Likewise 720p60 RGB888 requests 3 lanes and also works
>>>>> on a FIFO setting of 16.
>>>>> How/why were you thinking we need to run all four lanes for 720p60
>>>>> without other significant driver mods around lane config?
>>>>
>>>> The driver currently silently changes the number of active lanes
>>>> depending on required data rate, with no way to communicate it to the
>>>> receiver.
>>>
>>> It is communicated over the subdevice API - tc358743_g_mbus_config
>>> reports back the appropriate number of lanes to the receiver
>>> subdevice.
>>> A suitable v4l2_subdev_has_op(dev->sensor, video, g_mbus_config) call
>>> as you're starting streaming therefore gives you the correct
>>> information. That's what I've just done for the BCM283x Unicam
>>> driver[1], but admittedly I'm not using the media controller API which
>>> i.MX6 is.
>>
>> Shouldn't this information come from the device tree? The g_mbus_config
>> op is close to being deprecated or even removed. There are currently only
>> two obscure V4L2 bridge drivers that call it. It dates from pre-DT times
>> I rather not see it used in a new bridge driver.
>>
>> The problem is that contains data that belongs to the DT (hardware
>> capabilities). Things that can actually change dynamically should be
>> communicated via another op. We don't have that, so that should be created.
>>
>> I've CC-ed Sakari, he is the specialist for such things.
> 
> You've reminded me that I asked that same question earlier in the
> year, and Sakari had replied -
> http://www.spinics.net/lists/linux-media/msg115550.html
> 
> Is it specifically device tree related? Just because the lanes are
> physically there doesn't necessarily mean they have to be used.

The DT should tell how many lanes are connected.

g/s_mbus_config was really doing the job that the device tree does today,
but it does so badly.

My recommendation is that you don't use it at all. Instead look at the
DT for the number of lanes.

*If* it becomes clear that you need to communicate the actual number of
lanes in use, then we need to make a new op or whatever.

> 
> A quick test with the spreadsheet appears to say that 1080p24 UYVY
> over 4 lanes at 594Mbps needs a FIFO setting >=480 (the max is 511). I
> would anticipate that to be one of the worst situations as we're
> dealing with a FIFO underflow herewhen there is a significantly faster
> CSI rate than HDMI.
> It can't be supported with a 972Mbps link frequency over 4 lanes
> (needs >=667), and 2 lanes needs a FIFO setting >=374.
> 
> I'll see what numbers fall out of the new spreadsheet for all standard
> modes. If there are some modes that can't be supported over 4 lanes
> then there is an absolute requirement for communicating the number of
> lanes to use.
> 
> Seeing as Cisco have kit shipping with this chip and driver, can I ask
> how they are managing the choice over number of lanes in use?

It's using g_mbus_config since it runs on an old pre-DT kernel.

I personally would be perfectly happy with a simple new op to just
communicate the number of lanes in use, but there may be more things
that should be passed on to the bridge driver. Sakari knows this better
than I do.

But g_mbus_config shouldn't be used here. No way you could have known
that, we really need to clarify that in v4l2-subdev.h.

Hmm, it DOES say that for s_mbus_config, but not for g_mbus_config.

Regards,

	Hans
