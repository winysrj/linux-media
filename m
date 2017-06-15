Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:60632 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751016AbdFOOPF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 10:15:05 -0400
Subject: Re: [RFC 2/2] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera
 interface
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
 <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl>
 <CAAoAYcNPk==5=sNZRuVvShPv+ky=ewdg7O7G4xGp6qLFaMTvYQ@mail.gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <38437cd7-5703-11bb-ce3f-01c6315746ff@xs4all.nl>
Date: Thu, 15 Jun 2017 16:14:59 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcNPk==5=sNZRuVvShPv+ky=ewdg7O7G4xGp6qLFaMTvYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/17 15:38, Dave Stevenson wrote:
> Hi Hans.
> 
> "On 15 June 2017 at 08:12, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Dave,
>>
>> Here is a quick review of this driver. Once a v2 is posted I'll do a more
>> thorough
>> check.
> 
> Thank you. I wasn't expecting such a quick response.
> 
>> On 06/14/2017 05:15 PM, Dave Stevenson wrote:
>>>
>>> Add driver for the Unicam camera receiver block on
>>> BCM283x processors.
>>>
>>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>> ---
>>>   drivers/media/platform/Kconfig                   |    1 +
>>>   drivers/media/platform/Makefile                  |    2 +
>>>   drivers/media/platform/bcm2835/Kconfig           |   14 +
>>>   drivers/media/platform/bcm2835/Makefile          |    3 +
>>>   drivers/media/platform/bcm2835/bcm2835-unicam.c  | 2100
>>> ++++++++++++++++++++++
>>>   drivers/media/platform/bcm2835/vc4-regs-unicam.h |  257 +++
>>>   6 files changed, 2377 insertions(+)
>>>   create mode 100644 drivers/media/platform/bcm2835/Kconfig
>>>   create mode 100644 drivers/media/platform/bcm2835/Makefile
>>>   create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>>>   create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
>>>
>>> +static int unicam_s_input(struct file *file, void *priv, unsigned int i)
>>> +{
>>> +       struct unicam_device *dev = video_drvdata(file);
>>> +       int ret;
>>> +
>>> +       if (v4l2_subdev_has_op(dev->sensor, video, s_routing))
>>> +               ret =  v4l2_subdev_call(dev->sensor, video, s_routing, i,
>>> 0, 0);
>>> +       else
>>> +               ret = -EINVAL;  /* v4l2-compliance insists on -EINVAL */
>>
>>
>> Drop this if-else entirely. s_routing makes really no sense when using a
>> device
>> tree. In this particular case there really is just one input, period.
> 
> I added this due to the ADV7282-M analogue to CSI bridge chip (uses
> adv7180.c driver). It uses s_routing to select the physical input /
> input type.
> If this is dropped, what is the correct mechanism for selecting the
> input? Unless I've missed it, s_routing is not a call that is exposed
> to userspace, so we're stuck with composite input 1.
> 
> I had asked this question in previously [1], and whilst Sakari had
> kindly replied with "s_routing() video op as it stands now is awful, I
> hope no-one uses it", the fact is that it is used.
> 
> [1] http://www.spinics.net/lists/linux-media/msg115550.html

s_routing was developed for USB and PCI(e) devices and predates the device tree.
Basically USB and PCI drivers will have card definitions where USB/PCI card IDs
are mapped to card descriptions, and that includes information on the various
inputs (composite, S-Video, etc) that are available on the backplane and how those
physical connectors are hooked up to the pins on the video ICs.

The enum/s/g_input ioctls all show the end-user view, i.e. they enumerate the
inputs on the backpanel of the product. The s_routing op was created to map
such inputs to actual pins on the ICs.

For platform devices we would do this in the device tree today, but some of
the necessary bindings are still missing. Specifically those for connectors,
AFAIK those are not yet defined. It's been discussed, but never finalized.

So if this was done correctly you would use the connector endpoints in the
device tree to enumerate the inputs and use how they are connected to the
other blocks as the routing information (i.e. pad number).

I would say that is the advanced course and to do this later.

Do you even have hardware where you can switch between inputs?

Regards,

	Hans
