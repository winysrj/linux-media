Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40429 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754632AbdHYOCE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 10:02:04 -0400
Subject: Re: [PATCH 1/3] media: open.rst: document devnode-centric and
 mc-centric types
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
 <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
 <14323646.WPb2L3qxUc@avalon>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a60ac12c-6801-7830-a39f-2940c8dce66a@xs4all.nl>
Date: Fri, 25 Aug 2017 16:02:01 +0200
MIME-Version: 1.0
In-Reply-To: <14323646.WPb2L3qxUc@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/08/17 15:11, Laurent Pinchart wrote:
> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Friday, 25 August 2017 12:40:05 EEST Mauro Carvalho Chehab wrote:
>> From: "mchehab@s-opensource.com" <mchehab@s-opensource.com>
>>
>> When we added support for omap3, back in 2010, we added a new
>> type of V4L2 devices that aren't fully controlled via the V4L2
>> device node. Yet, we never made it clear, at the V4L2 spec,
>> about the differences between both types.
> 
> Nitpicking (and there will be lots of nitpicking in this review as I think 
> it's very important to get this piece of the documentation right down to 
> details):
> 
> s/at the V4L2 spec/in the V4L2 spec/
> 
> "make it clear about" doesn't sound good to me. How about the following ?
> 
> "Yet, we have never clearly documented in the V4L2 specification the 
> differences between the two types."
> 
>> Let's document them with the current implementation.
> 
> s/with the/based on the/
> 
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> ---
>>  Documentation/media/uapi/v4l/open.rst | 50 ++++++++++++++++++++++++++++++++
>>  1 file changed, 50 insertions(+)
>>
>> diff --git a/Documentation/media/uapi/v4l/open.rst
>> b/Documentation/media/uapi/v4l/open.rst index afd116edb40d..a72d142897c0
>> 100644
>> --- a/Documentation/media/uapi/v4l/open.rst
>> +++ b/Documentation/media/uapi/v4l/open.rst
>> @@ -6,6 +6,56 @@
>>  Opening and Closing Devices
>>  ***************************
>>
>> +Types of V4L2 hardware control
>> +==============================
>> +
>> +V4L2 devices are usually complex: they are implemented via a main driver
>> and
>> +often several additional drivers. The main driver always exposes one or
>> +more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`).
> 
> First of all, as stated in a previous e-mail, I think we should start by 
> defining the terms we are going to use. The word "device" is ambiguous, it can 
> mean
> 
> - device node
> 
> The /dev device node through which a character- or block-based API is exposed 
> through userspace.
> 
> The term "device node" is commonly used in the kernel, I think we can use it 
> as-is without ambiguity.

Ack.

> 
> - kernel struct device
> 
> An instance of the kernel struct device. Kernel devices are used to represent 
> hardware devices (and are then embedded in bus-specific device structure such 
> as platform_device, pci_device or i2c_client) and logical devices (and are 
> then embedded in class-spcific device structures such as struct video_device 
> or struct net_device).
> 
> For now I believe this isn't relevant to the V4L2 userspace API discussion, so 
> we can leave it out.

Agree.

> 
> - hardware device
> 
> The hardware counterpart of the first category of the kernel struct device, a 
> hardware (and thus physical) device such as an SoC IP core or an I2C chip.
> 
> We could call this "hardware device" or "hardware component". Other proposals 
> are welcome.

I like "hardware component". I prefer to avoid the word 'device' as much as possible.

> 
> - hardware peripheral
> 
> A group of hardware devices that together make a larger user-facing functional 
> peripheral. For instance the SoC ISP IP cores and external camera sensors 
> together make a camera peripheral.
> 
> If we call the previous device a "hardware component" this could be called 
> "hardware device". Otherwise "hardware peripheral" is a possible name, but we 
> can probably come up with a better name.

"hardware device" can be used provided it is clearly defined as being a collection
of hardware components that together form the fully functioning device. Or something
along those lines.

> 
> - software peripheral
> 
> The software counterpart of the hardware peripheral. In V4L2 this is modeled 
> by a struct v4l2_device, often associated with a struct media_device.

struct v4l2_device isn't visible to userspace (and is an awful name, I'm
really sorry about that, guys!).

> 
> I don't like the name "software peripheral", other proposals are welcome.

Where would you use the term "software peripheral"? In what context? Do we
need this at all?

> 
> Once we agree on names and definitions I'll comment on the reworked version of 
> this patch, as it's pointless to bikeshed the wording without first agreeing 
> on clear definitions of the concepts we're discussing. Please still see below 
> for a few comments not related to particular wording.
> 
>> +The other drivers are called **V4L2 sub-devices** and provide control to
>> +other parts of the hardware usually connected via a serial bus (like
>> +I²C, SMBus or SPI). They can be implicitly controlled directly by the
>> +main driver or explicitly through via the **V4L2 sub-device API**
>> interface.
>> +
>> +When V4L2 was originally designed, there was only one type of device
>> control.
>> +The entire device was controlled via the **V4L2 device nodes**. We refer to
>> +this kind of control as **V4L2 device node centric** (or,
>> simply, +**vdev-centric**).
>> +
>> +Since the end of 2010, a new type of V4L2 device control was added in order
>> +to support complex devices that are common for embedded systems. Those
>> +devices are controlled mainly via the media controller and sub-devices.
>> +So, they're called: **Media controller centric** (or, simply,
>> +"**MC-centric**").
> 
> Do we really need to explain the development history with dates ? I don't 
> think it helps understanding the separation between vdev-centric and MC-
> centric devices. For instance the previous paragraph that explains that V4L2 
> originally had a single type of device control that we now call vdev-centric 
> doesn't really help understanding what a vdev-centric device is.
> 
> It would be clearer in my opinion to explain the two kind of devices with an 
> associated use case, without referring to the history.

It doesn't hurt to mention that MC-centric came later. There are after all API
oddities that are due to the history of the API. But we can simply say "Later"
instead of "Since the end of 2010".

>> +For **vdev-centric** control, the device and their corresponding hardware
>> +pipelines are controlled via the **V4L2 device** node. They may optionally
>> +expose via the :ref:`media controller API <media_controller>`.
>> +
>> +For **MC-centric** control, before using the V4L2 device, it is required to
>> +set the hardware pipelines via the
>> +:ref:`media controller API <media_controller>`. For those devices, the
>> +sub-devices' configuration can be controlled via the
>> +:ref:`sub-device API <subdev>`, with creates one device node per sub
>> device.
>> +
>> +In summary, for **MC-centric** devices:
>> +
>> +- The **V4L2 device** node is responsible for controlling the streaming
>> +  features;
>> +- The **media controller device** is responsible to setup the pipelines;
>> +- The **V4L2 sub-devices** are responsible for sub-device
>> +  specific settings.
> 
> How about a summary of vdev-centric devices too ? Or, possibly, no summary at 
> all ? The need to summarize 5 short paragraphs probably indicates that those 
> paragraphis are not clear enough :-)

I was thinking the same. It should probably be dropped.

> I can try to help by proposing enhancements to the documentation once we agree 
> on the glossary above.
> 
>> +.. note::
>> +
>> +   A **vdev-centric** may optionally expose V4L2 sub-devices via
>> +   :ref:`sub-device API <subdev>`. In that case, it has to implement
>> +   the :ref:`media controller API <media_controller>` as well.
> 
> The separation between vdev-centric and MC-centric devices is quite clear. If 
> we allow a vdev-centric device to expose subdev nodes we will open the door to 
> all kind of hybrid implementations that have no clear definition today. It 
> will be very important in that case to document in details what is allowed and 
> what isn't, and how the video device nodes and subdev device nodes interact 
> with each other. I prefer not giving a green light to such implementations 
> until we have to

Well, they exist already. The original MC design that I made allowed for this.
In practice the only reason for doing this is to set private controls for
subdevs (i.e. controls not inherited by the video device node).

Three drivers use this: rcar-drif, cobalt (not an issue, I can just remove
support for this as Cisco is the only user) and I know there was a third one
that you found, but I keep forgetting the name of that driver.

>, and I also prefer discussing this topic separately. It will 
> require a fair amount of work to document (and thus first agree on), and 
> there's no need to block the rest of this patch until we complete that work. 
> For those reasons I would like to explicitly disallow those hybrid devices in 
> this patch, and start discussing the use cases we have for them, and how they 
> would operate.

I have no objection to dropping this note for the first version.

Regards,

	Hans

> 
>> +.. _v4l2_device_naming:
>>
>>  Device Naming
>>  =============
> 
> 
