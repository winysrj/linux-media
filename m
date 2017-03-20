Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53255 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755111AbdCTN5U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 09:57:20 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <9b3311a8-34a7-2b5b-9bc7-836371e1e0a4@gmail.com>
 <179aca0a-deb5-7937-f955-26cc6d93afba@xs4all.nl>
 <20170320132930.GJ21222@n2100.armlinux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d0e2a9c2-5e94-d810-7ef4-ae089a6b25f5@xs4all.nl>
Date: Mon, 20 Mar 2017 14:57:03 +0100
MIME-Version: 1.0
In-Reply-To: <20170320132930.GJ21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/20/2017 02:29 PM, Russell King - ARM Linux wrote:
> On Mon, Mar 20, 2017 at 02:01:58PM +0100, Hans Verkuil wrote:
>> On 03/19/2017 06:54 PM, Steve Longerbeam wrote:
>>>
>>>
>>> On 03/19/2017 03:38 AM, Russell King - ARM Linux wrote:
>>>> What did you do with:
>>>>
>>>> ioctl(3, VIDIOC_REQBUFS, {count=0, type=0 /* V4L2_BUF_TYPE_??? */, memory=0 /* V4L2_MEMORY_??? */}) = -1 EINVAL (Invalid argument)
>>>>                  test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>>> ioctl(3, VIDIOC_EXPBUF, 0xbef405bc)     = -1 EINVAL (Invalid argument)
>>>>                  fail: v4l2-test-buffers.cpp(571): q.has_expbuf(node)
>>
>> This is really a knock-on effect from an earlier issue where the compliance test
>> didn't detect support for MEMORY_MMAP.
> 
> So why does it succeed when I fix the compliance errors with VIDIOC_G_FMT?
> With that fixed, I now get:
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> The reason is, if you look at the code, VIDIOC_G_FMT populates a list
> of possible buffer formats "node->valid_buftypes".  If the VIDIOC_G_FMT
> test fails, then node->valid_buftypes is zero.
> 
> This causes testReqBufs() to only check for the all-zeroed VIDIOC_REQBUFS
> and declare it conformant, without creating any buffers (it can't, it
> doesn't know which formats are supported.)
> 
> This causes node->valid_memorytype to be zero.

It should fail on this and return a more understandable error message.

> 
> We then go on to testExpBuf(), and valid_memorytype zero, claiming (falsely)
> that MMAP is not supported.  The reality is that it _is_ supported, but
> it's just the non-compliant VICIOC_G_FMT call (due to the colorspace
> issue) causes the sequence of tests to fail.

Yeah, you're not the first to complain about this. I plan on fixing this this
week.

> 
>> Always build from the master repo. 1.10 is pretty old.
> 
> It's what I have - remember, not everyone is happy to constantly replace
> their distro packages with random new stuff.

This is a compliance test, which is continuously developed in tandem with
new kernel versions. If you are working with an upstream kernel, then you
should also use the corresponding v4l2-compliance test. What's the point
of using an old one?

I will not support driver developers that use an old version of the
compliance test, that's a waste of my time.

> 
>>>> In any case, it doesn't look like the buffer management is being
>>>> tested at all by v4l2-compliance - we know that gstreamer works, so
>>>> buffers _can_ be allocated, and I've also used dmabufs with gstreamer,
>>>> so I also know that VIDIOC_EXPBUF works there.
>>
>> To test actual streaming you need to provide the -s option.
>>
>> Note: v4l2-compliance has been developed for 'regular' video devices,
>> not MC devices. It may or may not work with the -s option.
> 
> Right, and it exists to verify that the establised v4l2 API is correctly
> implemented.  If the v4l2 API is being offered to user applications,
> then it must be conformant, otherwise it's not offering the v4l2 API.
> (That's very much a definition statement in itself.)
> 
> So, are we really going to say MC devices do not offer the v4l2 API to
> userspace, but something that might work?  We've already seen today
> one user say that they're not going to use mainline because of the
> crud surrounding MC.
> 

Actually, my understanding was that he was stuck on the old kernel code.

In the case of v4l2-compliance, I never had the time to make it work with
MC devices. Same for that matter of certain memory to memory devices.

Just like MC devices these too behave differently. They are partially
supported in v4l2-compliance, but not fully.

Why? NO TIME.

Be glad there *is* a v4l2-compliance test at all! It's really, really useful
already, but it took *years* to develop, little bit by little bit. And yes,
I would really like to update it to fully support codecs and MC devices.
And with a bit of luck I hope to get permission from my boss to work on
this (among others) later in the year.

Complaining about this really won't help. We know it's a problem and unless
someone (me perhaps?) manages to get paid to work on this it's unlikely to
change for now.

Regards,

	Hans
