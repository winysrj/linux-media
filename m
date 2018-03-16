Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:44722 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbeCPIMe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 04:12:34 -0400
Received: by mail-wr0-f181.google.com with SMTP id v65so10715148wrc.11
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 01:12:34 -0700 (PDT)
Subject: Re: [PATCH 00/20] Add multiplexed media pads to support CSI-2 virtual
 channels
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
 <403976aa-d9e3-60a3-1a33-37cf78d7c5a3@mm-sol.com>
 <20180315231650.GO10974@bigcity.dyn.berto.se>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <726d8b45-6f32-0d29-e383-6943e3db3833@linaro.org>
Date: Fri, 16 Mar 2018 10:12:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180315231650.GO10974@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 16.03.2018 01:16, Niklas Söderlund wrote:
> Hi Todor,
> 
> On 2018-03-15 11:43:31 +0200, Todor Tomov wrote:
>> Hello,
>>
>> I'm trying to understand what is the current state of the multiple virtual
>> channel support in V4L2 and Media framework. This is the last activity
>> on this topic which I was able to find. Is anything new happened since
>> this RFC, is someone working on this or planing to work on?
> 
> I'm currently working on this but right now I'm focusing on driver 
> dependencies for my use-case, once that is done I will resume to push 
> more for the multiplexed stream support. I randomly push my latest work 
> to
> 
> git://git.ragnatech.se/linux v4l2/mux
> 
> But this is a unstable branch and contains some LOCAL patches to test my 
> work on Renesas platforms. But if you want to checkout my current status 
> that's the branch to check.
> 
> Out of curiosity what board or use-case are you interested in where 
> multiplexed streams would be useful for you?

Good to hear that you are still working on this :)
I'm working on QComm SoCs and I may need multiple virtual channel
support however the usecases are not clear yet. I'll be keeping an
eye on any activity from you then ;) or when I have more details
about my usecases I'll try to evaluate how they fit with this RFC.

Thank you.
Best regards,
Todor Tomov

> 
>>
>> Best regards,
>> Todor Tomov
>>
>> On 11.08.2017 12:56, Niklas Söderlund wrote:
>>> Hi,
>>>
>>> This series is a RFC for how I think one could add CSI-2 virtual channel 
>>> support to the V4L2 framework. The problem is that there is no way to in 
>>> the media framework describe and control links between subdevices which 
>>> carry more then one video stream, for example a CSI-2 bus which can have 
>>> 4 virtual channels carrying different video streams.
>>>
>>> This series adds a new pad flag which would indicate that a pad carries 
>>> multiplexed streams, adds a new s_stream() operation to the pad 
>>> operations structure which takes a new argument 'stream'. This new 
>>> s_stream() operation then is both pad and stream aware. It also extends 
>>> struct v4l2_mbus_frame_desc_entry with a new sub-struct to describe how 
>>> a CSI-2 link multiplexes virtual channels. I also include one 
>>> implementation based on Renesas R-Car which makes use of these patches 
>>> as I think they help with understanding but they have no impact on the 
>>> RFC feature itself.
>>>
>>> The idea is that on both sides of the multiplexed media link there are 
>>> one multiplexer subdevice and one demultiplexer subdevice. These two 
>>> subdevices can't do any format conversions, there sole purpose is to 
>>> (de)multiplex the CSI-2 link. If there is hardware which can do both 
>>> CSI-2 multiplexing and format conversions they can be modeled as two 
>>> subdevices from the same device driver and using the still pending 
>>> incremental async mechanism to connect the external pads. The reason 
>>> there is no format conversion is important as the multiplexed pads can't 
>>> have a format in the current V4L2 model, get/set_fmt are not aware of 
>>> streams.
>>>
>>>         +------------------+              +------------------+
>>>      +-------+  subdev 1   |              |  subdev 2   +-------+
>>>   +--+ Pad 1 |             |              |             | Pad 3 +---+
>>>      +--+----+   +---------+---+      +---+---------+   +----+--+
>>>         |        | Muxed pad A +------+ Muxed pad B |        |
>>>      +--+----+   +---------+---+      +---+---------+   +----+--+
>>>   +--+ Pad 2 |             |              |             | Pad 4 +---+
>>>      +-------+             |              |             +-------+
>>>         +------------------+              +------------------+
>>>
>>> In the simple example above Pad 1 is routed to Pad 3 and Pad 2 to Pad 4, 
>>> and the video data for both of them travels the link between pad A and 
>>> B. One shortcoming of this RFC is that there currently are no way to 
>>> express to user-space which pad is routed to which stream of the 
>>> multiplexed link. But inside the kernel this is known and format 
>>> validation is done by comparing the format of Pad 1 to Pad 3 and Pad 2 
>>> to Pad 4 by the V4L2 framework. But it would be nice for the user to 
>>> also be able to get this information while setting up the MC graph in 
>>> user-space.
>>>
>>> Obviously there are things that are not perfect in this RFC, one is the 
>>> above mentioned lack of user-space visibility of that Pad 1 is in fact 
>>> routed to Pad 3. Others are lack of Documentation/ work and I'm sure 
>>> there are error path shortcuts which are not fully thought out. One big 
>>> question is also if the s_stream() operation added to ops structure 
>>> should be a compliment to the existing ones in video and audio ops or 
>>> aim to replace the one in video ops. I'm also unsure of the CSI2 flag of 
>>> struct v4l2_mbus_frame_desc_entry don't really belong in struct 
>>> v4l2_mbus_frame_desc. And I'm sure there are lots of other stuff that's 
>>> why this is a RFC...
>>>
>>> A big thanks to Laurent and Sakari for being really nice and taking time 
>>> helping me grasp all the possibilities and issues with this problem, all 
>>> cred to them and all blame to me for misunderstanding there guidance :-)
>>>
>>> This series based on the latest R-Car CSI-2 and VIN patches which can be 
>>> found at [1], but that is a dependency only for the driver specific
>>> implementation which acts as an example of implementation. For the V4L2 
>>> framework patches the media-tree is the base.
>>>
>>> 1. https://git.ragnatech.se/linux#rcar-vin-elinux-v12
>>>
>>> Niklas Söderlund (20):
>>>   media.h: add MEDIA_PAD_FL_MUXED flag
>>>   v4l2-subdev.h: add pad and stream aware s_stream
>>>   v4l2-subdev.h: add CSI-2 bus description to struct
>>>     v4l2_mbus_frame_desc_entry
>>>   v4l2-core: check that both pads in a link are muxed if one are
>>>   v4l2-core: verify all streams formats on multiplexed links
>>>   rcar-vin: use the pad and stream aware s_stream
>>>   rcar-csi2: declare sink pad as multiplexed
>>>   rcar-csi2: switch to pad and stream aware s_stream
>>>   rcar-csi2: figure out remote pad and stream which are starting
>>>   rcar-csi2: count usage for each source pad
>>>   rcar-csi2: when starting CSI-2 receiver use frame descriptor
>>>     information
>>>   rcar-csi2: only allow formats on source pads
>>>   rcar-csi2: implement get_frame_desc
>>>   adv748x: add module param for virtual channel
>>>   adv748x: declare source pad as multiplexed
>>>   adv748x: add translation from pixelcode to CSI-2 datatype
>>>   adv748x: implement get_frame_desc
>>>   adv748x: switch to pad and stream aware s_stream
>>>   adv748x: only allow formats on sink pads
>>>   arm64: dts: renesas: salvator: use VC1 for CVBS
>>>
>>>  arch/arm64/boot/dts/renesas/salvator-common.dtsi |   2 +-
>>>  drivers/media/i2c/adv748x/adv748x-core.c         |  10 +
>>>  drivers/media/i2c/adv748x/adv748x-csi2.c         |  78 +++++++-
>>>  drivers/media/i2c/adv748x/adv748x.h              |   1 +
>>>  drivers/media/platform/rcar-vin/rcar-csi2.c      | 239 ++++++++++++++++-------
>>>  drivers/media/platform/rcar-vin/rcar-dma.c       |   6 +-
>>>  drivers/media/v4l2-core/v4l2-subdev.c            |  65 ++++++
>>>  include/media/v4l2-subdev.h                      |  16 ++
>>>  include/uapi/linux/media.h                       |   1 +
>>>  9 files changed, 341 insertions(+), 77 deletions(-)
>>>
>>
>> -- 
>> Best regards,
>> Todor Tomov
> 

-- 
Best regards,
Todor Tomov
