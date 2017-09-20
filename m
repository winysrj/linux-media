Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:3473 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdITNMF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 09:12:05 -0400
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
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
 <20170920125023.p4u3fi3itsgx456v@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <df9bd5db-6d89-6dfa-3754-5de14470c92a@cisco.com>
Date: Wed, 20 Sep 2017 15:12:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170920125023.p4u3fi3itsgx456v@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/17 14:50, Sakari Ailus wrote:
> Hi Hans and others,
> 
> On Wed, Sep 20, 2017 at 01:24:02PM +0200, Hans Verkuil wrote:
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
> 
> The DT tells how many lanes are connected in hardware, but up to now that's
> also been the number of lanes actually used.
> 
> The g_mbus_config() is there, and I'd like to replace that with the more
> generic frame descriptors, with CSI-2 virtual channel and data type
> support. They're however not quite ready yet nor I've recently worked on
> them.
> 
> I think using g_mbus_config() for the purpose right now is entirely
> acceptable, we can rework that later on when adding support for frame
> descriptors.
> 

I don't like it :-)

Currently g_mbus_config returns (and I quote from v4l2-mediabus.h): "How
many lanes the client can use". I.e. the capabilities of the HW.

If we are going to use this to communicate how many lines are currently
in use, then I would propose that we add a lane mask, i.e. something like
this:

/* Number of lanes in use, 0 == use all available lanes (default) */
#define V4L2_MBUS_CSI2_LANE_MASK                (3 << 10)

And add comments along the lines that this is a temporary fix.

I would feel a lot happier (or a lot less unhappy) if we'd do it this way.
Rather than re-interpreting bits that are not quite what they should be.

I'd also add a comment that all other flags must be 0 if the device tree is
used. This to avoid mixing the two.

Regards,

	Hans
