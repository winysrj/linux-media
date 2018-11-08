Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:41825 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbeKHU7k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 15:59:40 -0500
Subject: Re: [PATCH v4 3/4] media: i2c: Add MAX9286 driver
To: jacopo mondi <jacopo@jmondi.org>
Cc: kieran.bingham+renesas@ideasonboard.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@iki.fi,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
References: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
 <20181102154723.23662-4-kieran.bingham@ideasonboard.com>
 <bfae74db-aa54-32b3-966b-b8d17f2e366b@ideasonboard.com>
 <898b4698-c3c3-9d38-e117-6a4274ba2ca4@lucaceresoli.net>
 <20181108101101.GE24024@w540>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <71bc438b-321e-cecc-120c-a95ff12642f2@lucaceresoli.net>
Date: Thu, 8 Nov 2018 12:24:23 +0100
MIME-Version: 1.0
In-Reply-To: <20181108101101.GE24024@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 08/11/18 11:11, jacopo mondi wrote:
> Hi Luca, Kieran,
>     sorry to jump up, but I feel this should be clarified.
> 
> On Wed, Nov 07, 2018 at 06:24:18PM +0100, Luca Ceresoli wrote:
>> Hi Kieran,
>>
>> thanks for the clarification. One additional note below.
>>
>> On 07/11/18 16:06, Kieran Bingham wrote:
>>> Hi Luca
>>>
>>> <Top posting for new topic>
>>>
>>>> <lucaceresoli> kbingham: hi, I'm looking at your GMSL v4 patches
>>>> <lucaceresoli> kbingham: jmondi helped me in understanding parts of it, but I still have a question
>>>> <lucaceresoli> kbingham: are the drivers waiting for the established link before the remote chips are accessed? where?
>>>
>>> I'm replying here rather than spam the IRC channel with a big paste.
>>> It's also a useful description to the probe sequence, so I've kept it
>>> with the driver posting.
>>>
>>> I hope the following helps illustrate the sequences which are involved:
>>>
>>> max9286_probe()
>>>  - max9286_i2c_mux_close() # Disable all links
>>>  - max9286_configure_i2c # Configure early communication settings
>>>  - max9286_init():
>>>    - regulator_enable() # Power up all cameras
>>>    - max9286_setup() # Most link setup is done here.
>>>    ... Set up v4l2/async/media-controller endpoints
>>>    - max9286_i2c_mux_init() # Start configuring cameras:
>>>      - i2c_mux_alloc() # Create our mux device
>>>      - for_each_source(dev, source)
>>>            i2c_mux_add_adapter() # This is where sensors get probed.
>>>
>>> So yes sensors are only communicated with once the link is brought up as
>>> much as possible.
>>
>> For the records, an additional bit of explanation I got from Kieran via IRC.
>>
>> The fact that link is already up when the sensors are probed is due to
>> the fact that the power regulator has a delay of *8 seconds*. This is
>> intended, because there's an MCU on the camera modules that talks on the
>> I2C bus during that time, and thus the drivers need to wait after it's done.
> 
> The 8sec delay is due to the fact an integrated MCU on the remote
> camera module programs the local sensor and the serializer intgrated
> in the module in to some default configuration state. At power up, we
> just want to let it finish, with all reverse channels closed
> (camera module -> SoC direction) not to have the MCU transmitted
> messages repeated to the local side (our remote serializer does repeat
> messages not directed to it on it's remote side, as our local
> deserialier does).
> 
> The "link up" thing is fairly more complicated for GMSL than just
> having a binary "on" or "off" mode. This technology defines two different
> "channels", a 'configuration-channel' for transmitting control messages
> on the serial link (i2c messages for the deserializer/serializer pair
> this patches support) and a 'video-channel' for transmission of
> high-speed data, such as, no surprise, video and images :)
> 
> GMSL also defines two "link modes": a clock-less "configuration link"
> and an high-speed "video link". The "configuration link" is available a
> few msec after power up (roughly), while the "video link" needs a pixel
> clock to be supplied to the serializer for it to enter this mode and
> be able to lock the status between itself and the deserializer. Then it can
> begin serializing video data.
> 
> The 'control channel' is available both when the link is in
> 'configuration' and 'video' mode, while the 'video' channel is
> available only when the link is in 'video' mode (or, to put it more
> simply: you can send i2c configuration messages while the link is
> serializing video).
> 
> Our implementation uses the link in 'configuration mode' during the
> remote side programming phase, at 'max9286_i2c_mux_init()' time, with
> the 'max9286_i2c_mux_select()' function enabling selectively the
> 'configuration link' of each single remote end. It probes the remote device
> by instantiating a new i2c_adapter connected to the mux, one for each
> remote end, and performs the device configuration by initially using its
> default power up i2c address (it is safe to do so, all other links are
> closed), then changes the remote devices address to an unique one
> (as our devices allows us to do so, otherwise you should use the
> deserializer address translation feature to mask and translate the
> remote addresses).
> 
> Now all remote devices have an unique i2c address, and we can operate
> with all 'configuration links' open with no risk of i2c addresses
> collisions.
> 
> At this point when we want to start the video stream, we send a
> control message to the remote device, which enables the pixel clock
> output from the image sensor, and activate the 'video channel' on the
> remote serializer. The local deserializer makes sure all 'video links'
> are locked (see 'max9286_check_video_links()') and at this point we
> can begin serializing/deserializing video data.
> 
> As you can see, the initial delay only plays a role in avoiding
> collision before we properly configure the channels and the i2c
> addresses. The link setup phase is instead an integral part of the
> system configuration, and there are no un-necessary delays used to
> work around it setup procedure.
> 
> Does this help clarifying the system startup procedure?

Yes, that's very informative, thank you very much.

Given the complexity of the driver and the non-obviousness of some
workarounds to "unfortunate hardware design choices", I think [some of]
this explanation should be committed together with the driver, in order
to make it more understandable to other people. Even more since you've
already taken time to write it.

Thanks,
-- 
Luca
