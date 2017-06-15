Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43907 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751623AbdFOMbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 08:31:04 -0400
Subject: Re: [RFC 0/2] BCM283x Camera Receiver driver
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <eef29bfb-3336-4f65-c188-975d3937cb67@xs4all.nl>
 <CAAoAYcN67=d1DyqeAEYpeZDTuMh9p1eaiAzt7RJdcpYOwShVgw@mail.gmail.com>
 <38a9b418-f320-3c98-9536-7e85c00211e4@xs4all.nl>
 <CAAoAYcNMwXJeHQkX1nFVqpf8uJc2R+ECXak8r99-5p_SS4qVZw@mail.gmail.com>
 <22ebb6e2-52d9-b055-c702-e3e0497d60a9@xs4all.nl>
 <CAAoAYcMpc=84qFT8ekzWo9g3isA++8e2k5kHocXSx74_QzYT9g@mail.gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b07ea902-220b-425d-fe8e-c58d4177010d@xs4all.nl>
Date: Thu, 15 Jun 2017 14:30:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcMpc=84qFT8ekzWo9g3isA++8e2k5kHocXSx74_QzYT9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/17 14:29, Dave Stevenson wrote:
> On 15 June 2017 at 08:17, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 06/14/2017 11:03 PM, Dave Stevenson wrote:
>>>
>>> On 14 June 2017 at 18:38, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>
>>>> On 06/14/2017 06:29 PM, Dave Stevenson wrote:
>>>>>
>>>>>
>>>>> Hi Hans.
>>>>>
>>>>> On 14 June 2017 at 16:42, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>>
>>>>>>
>>>>>> Hi Dave,
>>>>>>
>>>>>> How does this driver relate to this staging driver:
>>>>>>
>>>>>> drivers/staging/vc04_services/bcm2835-camera/
>>>>>>
>>>>>> It's not obvious to me.
>>>>>
>>>>>
>>>>>
>>>>> drivers/staging/vc04_services/bcm2835-camera/ is using the VideoCore
>>>>> firmware to control Unicam, ISP, and all the tuner algorithms. The ARM
>>>>> gets delivered fully processed buffers from the VideoCore side. The
>>>>> firmware only has drivers for the Omnivision OV5647 and Sony IMX219
>>>>> (and an unsupported one for the Toshiba TC358743).
>>>>>
>>>>> This driver is solely the Unicam block, reading the data in over
>>>>> CSI2/CCP2 from the sensor and writing it to memory. No ISP or control
>>>>> loops.
>>>>> Other than power management, this driver is running solely on the ARM
>>>>> with no involvement from the VideoCore firmware.
>>>>> The sensor driver is whatever suitable V4L2 subdevice driver you fancy
>>>>> attaching (as long as it supports CSI2, or eventually CCP2).
>>>>
>>>>
>>>>
>>>> What is the interaction between these two drivers? Can they co-exist?
>>>> I would expect them to be mutually exclusive.
>>>
>>>
>>> Mutually exclusive for the same Unicam instance, yes.
>>>
>>> There are two Unicam instances on all BCM283x chips and both are
>>> brought out on the Compute Modules. You could run bcm2835-unicam on
>>> one and bcm2835-camera on the other if you so wished.
>>> The firmware checks whether the csi nodes in the device tree are
>>> active, and won't touch them if they are.
>>
>>
>> It would be good if this explanation is mentioned both in the driver code
>> and (I think) in the bindings document of *both* drivers. This setup is
>> unusual, so some extra documentation isn't amiss.
> 
> OK, will add it to this driver for V2.
> The other driver cleanups are on my to-do list. Would you object
> horrendously if I deferred adding the explanation to that driver to
> when I'm doing those cleanups?

That's OK.

Just mention in the cover letter of the v2 patch series that you are planning
to do this.

	Hans
