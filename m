Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:46578 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751757AbdFPPzc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 11:55:32 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5GFqqOJ014674
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 16:55:31 +0100
Received: from mail-pf0-f199.google.com (mail-pf0-f199.google.com [209.85.192.199])
        by mx07-00252a01.pphosted.com with ESMTP id 2b065yu39m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 16:55:30 +0100
Received: by mail-pf0-f199.google.com with SMTP id p4so40542498pfk.15
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 08:55:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <799abe44-cc1c-8b2c-84e5-adb3f695ee52@xs4all.nl>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
 <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl> <CAAoAYcNPk==5=sNZRuVvShPv+ky=ewdg7O7G4xGp6qLFaMTvYQ@mail.gmail.com>
 <38437cd7-5703-11bb-ce3f-01c6315746ff@xs4all.nl> <CAAoAYcPwPEifHBqcK-gBi2pPfPiTfC66UU-HRLDtZJUA+8mDTw@mail.gmail.com>
 <799abe44-cc1c-8b2c-84e5-adb3f695ee52@xs4all.nl>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 16 Jun 2017 16:55:27 +0100
Message-ID: <CAAoAYcOQg5dN6M2cBo+0AkxGuiAv9VDqPscCtqAUFLNS++MHKw@mail.gmail.com>
Subject: Re: [RFC 2/2] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 June 2017 at 15:05, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 06/15/17 17:11, Dave Stevenson wrote:
>> On 15 June 2017 at 15:14, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 06/15/17 15:38, Dave Stevenson wrote:
>>>> Hi Hans.
>>>>
>>>> "On 15 June 2017 at 08:12, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>> Hi Dave,
>>>>>
>>>>> Here is a quick review of this driver. Once a v2 is posted I'll do a more
>>>>> thorough
>>>>> check.
>>>>
>>>> Thank you. I wasn't expecting such a quick response.
>>>>
>>>>> On 06/14/2017 05:15 PM, Dave Stevenson wrote:
>>>>>>
>>>>>> Add driver for the Unicam camera receiver block on
>>>>>> BCM283x processors.
>>>>>>
>>>>>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>>>>> ---
>>>>>>   drivers/media/platform/Kconfig                   |    1 +
>>>>>>   drivers/media/platform/Makefile                  |    2 +
>>>>>>   drivers/media/platform/bcm2835/Kconfig           |   14 +
>>>>>>   drivers/media/platform/bcm2835/Makefile          |    3 +
>>>>>>   drivers/media/platform/bcm2835/bcm2835-unicam.c  | 2100
>>>>>> ++++++++++++++++++++++
>>>>>>   drivers/media/platform/bcm2835/vc4-regs-unicam.h |  257 +++
>>>>>>   6 files changed, 2377 insertions(+)
>>>>>>   create mode 100644 drivers/media/platform/bcm2835/Kconfig
>>>>>>   create mode 100644 drivers/media/platform/bcm2835/Makefile
>>>>>>   create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>>>>>>   create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
>>>>>>
>>>>>> +static int unicam_s_input(struct file *file, void *priv, unsigned int i)
>>>>>> +{
>>>>>> +       struct unicam_device *dev = video_drvdata(file);
>>>>>> +       int ret;
>>>>>> +
>>>>>> +       if (v4l2_subdev_has_op(dev->sensor, video, s_routing))
>>>>>> +               ret =  v4l2_subdev_call(dev->sensor, video, s_routing, i,
>>>>>> 0, 0);
>>>>>> +       else
>>>>>> +               ret = -EINVAL;  /* v4l2-compliance insists on -EINVAL */
>>>>>
>>>>>
>>>>> Drop this if-else entirely. s_routing makes really no sense when using a
>>>>> device
>>>>> tree. In this particular case there really is just one input, period.
>>>>
>>>> I added this due to the ADV7282-M analogue to CSI bridge chip (uses
>>>> adv7180.c driver). It uses s_routing to select the physical input /
>>>> input type.
>>>> If this is dropped, what is the correct mechanism for selecting the
>>>> input? Unless I've missed it, s_routing is not a call that is exposed
>>>> to userspace, so we're stuck with composite input 1.
>>>>
>>>> I had asked this question in previously [1], and whilst Sakari had
>>>> kindly replied with "s_routing() video op as it stands now is awful, I
>>>> hope no-one uses it", the fact is that it is used.
>>>>
>>>> [1] http://www.spinics.net/lists/linux-media/msg115550.html
>>>
>>> s_routing was developed for USB and PCI(e) devices and predates the device tree.
>>> Basically USB and PCI drivers will have card definitions where USB/PCI card IDs
>>> are mapped to card descriptions, and that includes information on the various
>>> inputs (composite, S-Video, etc) that are available on the backplane and how those
>>> physical connectors are hooked up to the pins on the video ICs.
>>>
>>> The enum/s/g_input ioctls all show the end-user view, i.e. they enumerate the
>>> inputs on the backpanel of the product. The s_routing op was created to map
>>> such inputs to actual pins on the ICs.
>>>
>>> For platform devices we would do this in the device tree today, but some of
>>> the necessary bindings are still missing. Specifically those for connectors,
>>> AFAIK those are not yet defined. It's been discussed, but never finalized.
>>>
>>> So if this was done correctly you would use the connector endpoints in the
>>> device tree to enumerate the inputs and use how they are connected to the
>>> other blocks as the routing information (i.e. pad number).
>>>
>>> I would say that is the advanced course and to do this later.
>>
>> Certainly the advanced course, but I'm still not seeing how that all
>> hangs together.
>>
>> To me that all sounds like stuff that ought to be within the ADV
>> driver? From my perspective as the CSI-2 receiver I only have one
>> input.
>
> As a csi receiver, yes. But the adv has a mux (or at least the adv7180
> does) where it can switch between multiple Composite or S-Video inputs.
> s_routing controls the mux.
>
> But the end-user knows nothing about the internal routing, he only knows
> about the connectors on the board. So with VIDIOC_ENUMINPUTS you can
> see which inputs there are to choose from with names corresponding to
> the labels on the backplane or in the user manual. With VIDIOC_S_INPUT
> he can select an input, and the device tree then has to provide the
> necessary information on how an input connector is hooked up to the adv.
>
>> So how does the application select between those inputs?
>>
>> Having had a bit of a grep I think the tvp5150 driver is doing what
>> you're suggesting. However that appears to force you into using the
>> media controller API. Is that not overkill particularly from an
>> application perspective?
>
> Ah, nice. There are actually already connector bindings. I'd forgotten
> those went in.
>
> Anyway, the tvp5150 is used in two situations:
>
> either as part of the USB non-MC device, or as part of a platform MC device.
>
> You have a platform non-MC device. The tvp5150 doesn't support that, but
> if it did, then the DT parsing could wouldn't be under CONFIG_MEDIA_CONTROLLER.
>
> It should really be under CONFIG_OF since it is (mostly) unrelated to the MC.
>
> But we're missing support for this scenario. For USB/PCI boards we have
> card descriptions whose information is used in s_routing, for MC-devices
> we leave it up to the user to set the routing (tvp5150_link_setup). But
> we don't have anything for a non-MC device that use the device tree.
>
> All the information is there, but we're missing infrastructure to
> give the connector information to the main V4L2 driver so it can implement
> the input ioctls, and to tell the subdev driver how to program the mux.

That's the bit that I was stumbling over - there is a bit of
infrastructure missing.

So I'm reading that as the adv driver is incorrect in that it is just
exposing all the potential input configurations. It really needs the
DT connectors bit adding to refine the input selection down to the
actually available connectors on the physical board.
In my eval board case, DT should describe input connectors for 4
inputs, corresponding to CVBS_AIN1, CVBS_AIN2, DIFF_CVBS_AIN3_AIN4,
and DIFF_CVBS_AIN7_AIN8. The fact that I could externally connect
adapters to combine AIN1 and AIN2 to become s-video isn't relevant (or
at least secondary).

If we have a bit of infrastructure missing, what is the correct way
forward for this driver right now?
I was comparing against the am437x-vfpe, davinci/vpif_capture, and
blackfin/bfin_capture drivers. All of them in some shape or form take
VIDIOC_S_INPUT and end up calling s_routing. It may be incorrect, but
that is how several platforms are using it. Is it acceptable to adopt
this incorrect behaviour until the infrastructure changes are all
done?

As a relative mainline kernel newbie I'm slightly reluctant to
volunteer to implement the missing infrastructure, but with some
guidance in advance I'm willing to put together a patchset for
discussion, and adapt the adv driver to use DT connectors.

Then again the dtbindings for connectors in tvp5150 got reverted
although the driver didn't:
31e717d [media] Revert "[media] tvp5150: document input connectors DT bindings"
   "There are still ongoing discussions about how the input connectors
    will be supported by the Media Controller framework so until that
    is settled, it is better to revert the connectors portion of the
    bindings to avoid known to be broken bindings docs to hit mainline."

Did things ever get settled [1], or did it slip through the cracks?
There don't appear to be any input connector bindings described
anywhere I can find them.
This sounds like a topic to be discussed in a new thread rather than
hidden within a patch review.

[1] http://www.spinics.net/lists/linux-media/msg97792.html

>>
>> You also say above that enum/s/g_input is all about switching between
>> physical connectors, and that's what I'm doing. I'm now getting lost
>> as to what is intended
>
> Physical connectors as in connectors that users related to: Composite
> inputs, S-Video, HDMI, etc. Not pins on a chip. How those connectors
> are routed to pins on a chip is something that differs per board, so
> that information belongs in the device tree.
>
> I hope this clarifies it a bit.

The waters are still a little murky, but getting clearer. Thanks for
taking the time to try and clarify it.

I've been distracted by other things today, and combined with these
ongoing discissions I'm afraid V2 is going to be delayed until Monday
or Tuesday. Sorry about that.

Cheers.
  Dave
