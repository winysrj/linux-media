Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58678 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756133AbdCULFc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 07:05:32 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <9b3311a8-34a7-2b5b-9bc7-836371e1e0a4@gmail.com>
 <179aca0a-deb5-7937-f955-26cc6d93afba@xs4all.nl>
 <20170320132930.GJ21222@n2100.armlinux.org.uk>
 <d0e2a9c2-5e94-d810-7ef4-ae089a6b25f5@xs4all.nl>
 <20170320141158.GK21222@n2100.armlinux.org.uk>
 <40e08d05-58cd-a295-3174-123147ee2ac5@xs4all.nl>
 <20170321104212.GC3784@bigcity.dyn.berto.se>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7fe51907-311d-e1cd-3e4c-dd3dc4af7d78@xs4all.nl>
Date: Tue, 21 Mar 2017 11:59:02 +0100
MIME-Version: 1.0
In-Reply-To: <20170321104212.GC3784@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/17 11:42, Niklas Söderlund wrote:
> On 2017-03-20 16:57:54 +0100, Hans Verkuil wrote:
>> On 03/20/2017 03:11 PM, Russell King - ARM Linux wrote:
>>> On Mon, Mar 20, 2017 at 02:57:03PM +0100, Hans Verkuil wrote:
>>>> On 03/20/2017 02:29 PM, Russell King - ARM Linux wrote:
>>>>> It's what I have - remember, not everyone is happy to constantly replace
>>>>> their distro packages with random new stuff.
>>>>
>>>> This is a compliance test, which is continuously developed in tandem with
>>>> new kernel versions. If you are working with an upstream kernel, then you
>>>> should also use the corresponding v4l2-compliance test. What's the point
>>>> of using an old one?
>>>>
>>>> I will not support driver developers that use an old version of the
>>>> compliance test, that's a waste of my time.
>>>
>>> The reason that people may _not_ wish to constantly update v4l-utils
>>> is that it changes the libraries installed on their systems.
>>>
>>> So, the solution to that is not to complain about developers not using
>>> the latest version, but instead to de-couple it from the rest of the
>>> package, and provide it as a separate, stand-alone package that doesn't
>>> come with all the extra baggage.
>>>
>>> Now, there's two possible answers to that:
>>>
>>> 1. it depends on the libv4l2 version.  If that's so, then you are
>>>    insisting that people constantly move to the latest libv4l2 because
>>>    of API changes, and those API changes may upset applications they're
>>>    using.  So this isn't really on.
>>>
>>> 2. it doesn't depend on libv4l2 version, in which case there's no reason
>>>    for it to be packaged with v4l-utils.
>>
>> Run configure with --disable-v4l2-compliance-libv4l.
>>
>> This avoids linking with libv4l and allows you to build it stand-alone.
>>
>> Perhaps I should invert this option since in most cases you don't want to
>> run v4l2-compliance with libv4l (it's off by default unless you pass the
>> -w option to v4l2-compliance).
>>
>>>
>>> The reality is that v4l2-compliance links with libv4l2, so I'm not sure
>>> which it is.  What I am sure of is that I don't want to upgrade libv4l2
>>> on an ad-hoc basis, potentially causing issues with applications.
>>>
>>>>>> To test actual streaming you need to provide the -s option.
>>>>>>
>>>>>> Note: v4l2-compliance has been developed for 'regular' video devices,
>>>>>> not MC devices. It may or may not work with the -s option.
>>>>>
>>>>> Right, and it exists to verify that the establised v4l2 API is correctly
>>>>> implemented.  If the v4l2 API is being offered to user applications,
>>>>> then it must be conformant, otherwise it's not offering the v4l2 API.
>>>>> (That's very much a definition statement in itself.)
>>>>>
>>>>> So, are we really going to say MC devices do not offer the v4l2 API to
>>>>> userspace, but something that might work?  We've already seen today
>>>>> one user say that they're not going to use mainline because of the
>>>>> crud surrounding MC.
>>>>>
>>>>
>>>> Actually, my understanding was that he was stuck on the old kernel code.
>>>
>>> Err, sorry, I really don't follow.  Who is "he"?
>>
>> "one user say that they're not going to use mainline because of the
>> crud surrounding MC."
>>
>>>
>>> _I_ was the one who reported the EXPBUF problem.  Your comment makes no
>>> sense.
>>>
>>>> In the case of v4l2-compliance, I never had the time to make it work with
>>>> MC devices. Same for that matter of certain memory to memory devices.
>>>>
>>>> Just like MC devices these too behave differently. They are partially
>>>> supported in v4l2-compliance, but not fully.
>>>
>>> It seems you saying that the API provided by /dev/video* for a MC device
>>> breaks the v4l2-compliance tests?
>>
>> There may be tests in the compliance suite that do not apply for MC devices
>> and for which I never check. The compliance suite was never written with MC
>> devices in mind, and it certainly hasn't been tested much with such devices.
>>
>> It's only very recent that I even got hardware that has MC support...
>>
>> From what I can tell from the feedback I got it seems to be OKish, but I
>> just can't guarantee that the compliance utility is correct for such devices.
>>
>> In particular I doubt the streaming tests (-s, -f, etc.) will work. The -s
>> test *might* work if the pipeline is configured correctly before running
>> v4l2-compliance. I can't imagine that the -f option would work at all since
>> I would expect pipeline validation errors.
> 
> I successfully use v4l2-compliance with the -s option to test the 
> Renesas R-Car Gen3 driver which uses MC, I first have to setup the 
> pipeline using media-ctl. I have had much use of the tool and it have 
> helped me catch many errors in the rcar-vin driver both on Gen2 (no MC 
> involved) and Gen3. And yes the -f option is only usable on Gen2 where 
> MC is not used.

Ah, good to hear that -s works with MC. I was not sure about that.
Thanks for the feedback!

Regards,

	Hans
