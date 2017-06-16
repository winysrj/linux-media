Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52276 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753933AbdFPOGL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 10:06:11 -0400
Subject: Re: [RFC 2/2] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera
 interface
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
 <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl>
 <CAAoAYcNPk==5=sNZRuVvShPv+ky=ewdg7O7G4xGp6qLFaMTvYQ@mail.gmail.com>
 <38437cd7-5703-11bb-ce3f-01c6315746ff@xs4all.nl>
 <CAAoAYcPwPEifHBqcK-gBi2pPfPiTfC66UU-HRLDtZJUA+8mDTw@mail.gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <799abe44-cc1c-8b2c-84e5-adb3f695ee52@xs4all.nl>
Date: Fri, 16 Jun 2017 16:05:58 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcPwPEifHBqcK-gBi2pPfPiTfC66UU-HRLDtZJUA+8mDTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/17 17:11, Dave Stevenson wrote:
> On 15 June 2017 at 15:14, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 06/15/17 15:38, Dave Stevenson wrote:
>>> Hi Hans.
>>>
>>> "On 15 June 2017 at 08:12, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> Hi Dave,
>>>>
>>>> Here is a quick review of this driver. Once a v2 is posted I'll do a more
>>>> thorough
>>>> check.
>>>
>>> Thank you. I wasn't expecting such a quick response.
>>>
>>>> On 06/14/2017 05:15 PM, Dave Stevenson wrote:
>>>>>
>>>>> Add driver for the Unicam camera receiver block on
>>>>> BCM283x processors.
>>>>>
>>>>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>>>> ---
>>>>>   drivers/media/platform/Kconfig                   |    1 +
>>>>>   drivers/media/platform/Makefile                  |    2 +
>>>>>   drivers/media/platform/bcm2835/Kconfig           |   14 +
>>>>>   drivers/media/platform/bcm2835/Makefile          |    3 +
>>>>>   drivers/media/platform/bcm2835/bcm2835-unicam.c  | 2100
>>>>> ++++++++++++++++++++++
>>>>>   drivers/media/platform/bcm2835/vc4-regs-unicam.h |  257 +++
>>>>>   6 files changed, 2377 insertions(+)
>>>>>   create mode 100644 drivers/media/platform/bcm2835/Kconfig
>>>>>   create mode 100644 drivers/media/platform/bcm2835/Makefile
>>>>>   create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>>>>>   create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
>>>>>
>>>>> +static int unicam_s_input(struct file *file, void *priv, unsigned int i)
>>>>> +{
>>>>> +       struct unicam_device *dev = video_drvdata(file);
>>>>> +       int ret;
>>>>> +
>>>>> +       if (v4l2_subdev_has_op(dev->sensor, video, s_routing))
>>>>> +               ret =  v4l2_subdev_call(dev->sensor, video, s_routing, i,
>>>>> 0, 0);
>>>>> +       else
>>>>> +               ret = -EINVAL;  /* v4l2-compliance insists on -EINVAL */
>>>>
>>>>
>>>> Drop this if-else entirely. s_routing makes really no sense when using a
>>>> device
>>>> tree. In this particular case there really is just one input, period.
>>>
>>> I added this due to the ADV7282-M analogue to CSI bridge chip (uses
>>> adv7180.c driver). It uses s_routing to select the physical input /
>>> input type.
>>> If this is dropped, what is the correct mechanism for selecting the
>>> input? Unless I've missed it, s_routing is not a call that is exposed
>>> to userspace, so we're stuck with composite input 1.
>>>
>>> I had asked this question in previously [1], and whilst Sakari had
>>> kindly replied with "s_routing() video op as it stands now is awful, I
>>> hope no-one uses it", the fact is that it is used.
>>>
>>> [1] http://www.spinics.net/lists/linux-media/msg115550.html
>>
>> s_routing was developed for USB and PCI(e) devices and predates the device tree.
>> Basically USB and PCI drivers will have card definitions where USB/PCI card IDs
>> are mapped to card descriptions, and that includes information on the various
>> inputs (composite, S-Video, etc) that are available on the backplane and how those
>> physical connectors are hooked up to the pins on the video ICs.
>>
>> The enum/s/g_input ioctls all show the end-user view, i.e. they enumerate the
>> inputs on the backpanel of the product. The s_routing op was created to map
>> such inputs to actual pins on the ICs.
>>
>> For platform devices we would do this in the device tree today, but some of
>> the necessary bindings are still missing. Specifically those for connectors,
>> AFAIK those are not yet defined. It's been discussed, but never finalized.
>>
>> So if this was done correctly you would use the connector endpoints in the
>> device tree to enumerate the inputs and use how they are connected to the
>> other blocks as the routing information (i.e. pad number).
>>
>> I would say that is the advanced course and to do this later.
> 
> Certainly the advanced course, but I'm still not seeing how that all
> hangs together.
> 
> To me that all sounds like stuff that ought to be within the ADV
> driver? From my perspective as the CSI-2 receiver I only have one
> input.

As a csi receiver, yes. But the adv has a mux (or at least the adv7180
does) where it can switch between multiple Composite or S-Video inputs.
s_routing controls the mux.

But the end-user knows nothing about the internal routing, he only knows
about the connectors on the board. So with VIDIOC_ENUMINPUTS you can
see which inputs there are to choose from with names corresponding to
the labels on the backplane or in the user manual. With VIDIOC_S_INPUT
he can select an input, and the device tree then has to provide the
necessary information on how an input connector is hooked up to the adv.

> So how does the application select between those inputs?
> 
> Having had a bit of a grep I think the tvp5150 driver is doing what
> you're suggesting. However that appears to force you into using the
> media controller API. Is that not overkill particularly from an
> application perspective?

Ah, nice. There are actually already connector bindings. I'd forgotten
those went in.

Anyway, the tvp5150 is used in two situations:

either as part of the USB non-MC device, or as part of a platform MC device.

You have a platform non-MC device. The tvp5150 doesn't support that, but
if it did, then the DT parsing could wouldn't be under CONFIG_MEDIA_CONTROLLER.

It should really be under CONFIG_OF since it is (mostly) unrelated to the MC.

But we're missing support for this scenario. For USB/PCI boards we have
card descriptions whose information is used in s_routing, for MC-devices
we leave it up to the user to set the routing (tvp5150_link_setup). But
we don't have anything for a non-MC device that use the device tree.

All the information is there, but we're missing infrastructure to
give the connector information to the main V4L2 driver so it can implement
the input ioctls, and to tell the subdev driver how to program the mux.

> 
> You also say above that enum/s/g_input is all about switching between
> physical connectors, and that's what I'm doing. I'm now getting lost
> as to what is intended

Physical connectors as in connectors that users related to: Composite
inputs, S-Video, HDMI, etc. Not pins on a chip. How those connectors
are routed to pins on a chip is something that differs per board, so
that information belongs in the device tree.

I hope this clarifies it a bit.

Regards,

	Hans

> 
>> Do you even have hardware where you can switch between inputs?
> 
> I have an ADV7282-M eval board [1] sitting in front of me, with the
> I2C and CSI-2 output hooked up to a butchered Pi camera board.
> 6 phono inputs set up as 2 single-ended composite inputs, and 2 pairs
> of differentital composite inputs. It can be reconfigured to take
> s-video, or component (although it needs a couple of surface mount
> resistors changed to do component).
> 1 CSI-2 (single lane) output going to the Pi.
> 
> I haven't got it producing CSI data that the Pi is happy with yet, but
> hopefully that is only a matter of time.
> The I2C comms is all working.
> With the driver as it stands I can use the s_input ioctl to send the
> I2C for the relevant input. It was a few weeks ago I last played with
> it, but IIRC it did appear to be detecting the incoming video standard
> correctly on each of composite 1 and composite 2 (I haven't got
> s-video or differential hooked up).
> 
>   Dave
> 
> [1] http://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/EVAL-ADV7282MEBZ.html
> 
