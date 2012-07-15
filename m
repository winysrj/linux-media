Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mlbassoc.com ([65.100.170.105]:40850 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GOUYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 16:24:32 -0400
Message-ID: <500326FE.7050705@mlbassoc.com>
Date: Sun, 15 Jul 2012 14:24:30 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Sergio Aguirre <sergio.a.aguirre@gmail.com>
CC: Chris Lalancette <clalancette@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Discussion <linux-media@vger.kernel.org>
Subject: Re: OMAP4 support
References: <4FFC3109.3080204@mlbassoc.com> <CABMb9GtV_CZ=ZFoqXD_u3dmZQoD5CmsptYkgwwecO7Ch9v3AAw@mail.gmail.com> <4FFC82F9.2090004@mlbassoc.com> <CAC-OdnBfxJar83+WFm1N-C0=+MivOvfAiWaEP-O3iCkYKxktbA@mail.gmail.com> <4FFFF74F.4020802@mlbassoc.com> <CAC-OdnCN8+nVch+Di9MQHZjGGG3dmYA6tDRkY8nt-mtyA1UOgQ@mail.gmail.com>
In-Reply-To: <CAC-OdnCN8+nVch+Di9MQHZjGGG3dmYA6tDRkY8nt-mtyA1UOgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-07-15 08:31, Sergio Aguirre wrote:
> Hi Gary,
>
> On Fri, Jul 13, 2012 at 5:24 AM, Gary Thomas <gary@mlbassoc.com> wrote:
>> On 2012-07-12 20:30, Sergio Aguirre wrote:
>>>
>>> Hi Gary,
>>>
>>> On Tue, Jul 10, 2012 at 2:31 PM, Gary Thomas <gary@mlbassoc.com> wrote:
>>>>
>>>> On 2012-07-10 11:05, Chris Lalancette wrote:
>>>>>
>>>>>
>>>>> On Tue, Jul 10, 2012 at 9:41 AM, Gary Thomas <gary@mlbassoc.com> wrote:
>>>>>>
>>>>>>
>>>>>> I'm looking for video support on OMAP4 platforms.  I've found the
>>>>>> PandaBoard camera project
>>>>>> (http://www.omappedia.org/wiki/PandaBoard_Camera_Support)
>>>>>> and this is starting to work.  That said, I'm having some
>>>>>> issues with setting up the pipeline, etc.
>>>>>>
>>>>>> Can this list help out?
>>>>>
>>>>>
>>>>>
>>>>> I'm not sure exactly what kind of cameras you want to get working, but
>>>>> if you are looking to get CSI2 cameras going through the ISS, Sergio
>>>>> Aguirre has been working on support.  He also works on the media-ctl
>>>>> tool, which is used for configuring the media framework pipeline.  The
>>>>> latest versions that I am aware of are here:
>>>>>
>>>>> git://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera.git
>>>>
>>>>
>>>>
>>>> Yes, this is the tree I've been working with (pointed to by the page I
>>>> mentioned).
>>>>
>>>> My kernel can see the camera OV5650 and set up the pipeline.  I am able
>>>> to
>>>> grab
>>>> the raw SGRBG10 data but I'd like to get the ISS to convert this to a
>>>> more
>>>> usable
>>>> UYVY format.  Here's what I tried:
>>>>     media-ctl -r
>>>>     media-ctl -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS ISP IPIPEIF":0 [1]'
>>>>     media-ctl -l '"OMAP4 ISS ISP IPIPEIF":1 -> "OMAP4 ISS ISP IPIPEIF
>>>> output":0 [1]'
>>>>     media-ctl -f '"ov5650 3-0036":0 [SGRBG10 2592x1944]'
>>>>     media-ctl -f '"OMAP4 ISS CSI2a":0 [SGRBG10 2592x1944]'
>>>>     media-ctl -f '"OMAP4 ISS ISP IPIPEIF":0 [SGRBG10 2592x1944]','"OMAP4
>>>> ISS
>>>> ISP IPIPEIF":1 [UYVY 2592x1944]'
>>>>
>>>> Sadly, I can't get the IPIPEIF element to take SGRGB10 in and put UYVY
>>>> out
>>>> (my reading
>>>> of the manual implies that this _should_ be possible).  I always see this
>>>> pipeline setup:
>>>> - entity 5: OMAP4 ISS ISP IPIPEIF (3 pads, 4 links)
>>>>               type V4L2 subdev subtype Unknown
>>>>               device node name /dev/v4l-subdev2
>>>>           pad0: Input [SGRBG10 2592x1944]
>>>>                   <- 'OMAP4 ISS CSI2a':pad1 [ACTIVE]
>>>>                   <- 'OMAP4 ISS CSI2b':pad1 []
>>>>           pad1: Output [SGRBG10 2592x1944]
>>>>                   -> 'OMAP4 ISS ISP IPIPEIF output':pad0 [ACTIVE]
>>>>           pad2: Output [SGRBG10 2592x1944]
>>>>                   -> 'OMAP4 ISS ISP resizer':pad0 []
>>>>
>>>> Am I missing something?  How can I make this conversion in the ISS?
>>>
>>>
>>> The core problem is that, i haven't published any support for
>>> RAW10->YUV conversion,
>>> which is part of the IPIPE module (not the IPIPEIF, like you mention). I
>>> had
>>> some patches, but sadly it is unfinished work. :/
>>>
>>> Now, there's a main non-technical problem... I no longer work at TI
>>> since end of June
>>> this year, and I don't have the right HW setup available anymore.
>>> Those sensors were
>>> company's asset, and I couldn't keep any.
>>>
>>> Now, we can make this work with cooperation of someone who has the right
>>> setup,
>>> and me sharing my patches and some advice on my experience.
>>>
>>> What do you think?
>>>
>>>>
>>>> Note: if this is not the appropriate place to ask these questions, please
>>>> redirect me (hopefully to a useful list :-)
>>>
>>>
>>> As I'm the main person who has been actively developing this, I'm your
>>> guy to ask questions :).
>>>
>>> By the way, this development has been my initiative the whole time,
>>> and not an official
>>> TI objective, so, to be honest, asking TI for official support won't
>>> help much right now.
>>
>>
>> Tell me how I can help make this happen.  I'll be glad to apply patches,
>> figure out bugs, etc, I just need a little help with getting started.
>> I have access to the hardware and it's really important that I make some
>> progress on this soon.
>>
>> Can you share your RAW10->YUV patches and some guidance on how to proceed?
>
> Sure. I just pushed an internal branch I had, named: "devel-ISPSUPPORT-IPIPE",
> please take that as a base.
>
> And please try these commands:
>
> media-ctl -r -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS ISP IPIPEIF":0
> [1]','"OMAP4 ISS ISP IPIPEIF":2 -> "OMAP4 ISS ISP IPIPE":0
> [1]','"OMAP4 ISS ISP IPIPE":1 -> "OMAP4 ISS ISP resizer":0
> [1]','"OMAP4 ISS ISP resizer":1 -> "OMAP4 ISS ISP resizer a output":0
> [1]'
>
> media-ctl -f '"ov5650 3-0036":0 [SGRBG10 2592x1944]','"OMAP4 ISS
> CSI2a":0 [SGRBG10 2592x1944]','"OMAP4 ISS ISP IPIPEIF":0 [SGRBG10
> 2592x1944]','"OMAP4 ISS ISP IPIPE":0 [SGRBG10 2592x1944]','"OMAP4 ISS
> ISP resizer":0 [UYVY 2592x1944]'
>
> yavta /dev/video3 -c4 -n1 -s2592x1944 -fUYVY -Fov5650_2592x1944_UYVY_8bpp.yuv

With the new branch, I am able to set up the pipeline for UYVY.  That part's good.

However, just like before, with either RAW10 or UYVY, the grab process does not
start more times than it does (it only starts about 1 out of 10 tries).  If I
just ^C and try again, it may start, it may not.

The single time I was able to get the UYVY capture to work, I got an error after
the first frame:

# grab-uyvy
Device /dev/video3 opened.
Device `OMAP4 ISS ISP resizer a output' on `media' is a video capture device.
Video format set: UYVY (59565955) 2592x1944 buffer size 10077696
Video format: UYVY (59565955) 2592x1944 buffer size 10077696
[  622.039733] omap4iss omap4iss: dma_alloc_coherent of size 10077696 failed
1 buffers requested.
length: 10077696 offset: 0
Buffer 0 mapped at address 0xb64a2000.
0 (0) [-] 0 1007[  623.131347] omap4iss omap4iss: RSZ Err: FIFO_IN_BLK:0, FIFO_OVF:1,
7696 bytes 623.118776 1342383344.713594 0.001 fps
[  623.297790] omap4iss omap4iss: RSZ Err: FIFO_IN_BLK:1, FIFO_OVF:0,

What can I look at to figure out why the capture is hanging?  I already enabled
a debug print in the ISR and see that only fires when it works.  There are no
interrupts from the CSI2a when it fails.

Any hints as to where & what to check (print registers, etc) would be a big help.

Thanks

>
>>
>> I have been able to capture RAW10 data, but often the whole thing just sits
>> there (hangs).  Restarting the process sometimes works, sometimes not.
>> Looking
>> at the registers and the actual signals on a scope do not show any
>> difference
>> that we can find.  Any ideas what might cause this?  Have you seen it as
>> well?
>
> Can you please try again with the before mentioned branch? The branch you
> were using didn't have some changes, so maybe this new one would take
> care of that.
>
>>
>> Thanks for the help - Please let me know how I can get this working...
>
> Well, thanks for the patience!
>
> Regards,
> Sergio

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------


