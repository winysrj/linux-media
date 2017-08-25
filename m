Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:42793 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755018AbdHYI7o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 04:59:44 -0400
Subject: Re: [PATCH RFC v2] media: open.rst: document devnode-centric and
 mc-centric types
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <779378fa18f93929547665467990ff9284a60521.1503576451.git.mchehab@osg.samsung.com>
Cc: "mchehab@s-opensource.com" <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fc2457ae-b4de-67aa-76ca-765f607d7d8d@xs4all.nl>
Date: Fri, 25 Aug 2017 10:59:40 +0200
MIME-Version: 1.0
In-Reply-To: <779378fa18f93929547665467990ff9284a60521.1503576451.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/08/17 14:07, Mauro Carvalho Chehab wrote:
> From: "mchehab@s-opensource.com" <mchehab@s-opensource.com>
> 
> When we added support for omap3, back in 2010, we added a new
> type of V4L2 devices that aren't fully controlled via the V4L2
> device node. Yet, we never made it clear, at the V4L2 spec,
> about the differences between both types.
> 
> Let's document them with the current implementation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 47 +++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index afd116edb40d..cf522d9bb53c 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -6,6 +6,53 @@
>  Opening and Closing Devices
>  ***************************
>  
> +Types of V4L2 device control

I don't like calling this 'device control'. Mostly because the word 'device' can
mean almost anything and is very overused.

How about "hardware control"?

> +============================
> +
> +V4L2 devices are usually complex: they're implemented via a main driver and

they're -> they are

(contractions like "they're" aren't normally used in formal texts)

> +often several additional drivers. The main driver always exposes one or
> +more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`). The other
> +devices are called **V4L2 sub-devices**. They are usually controlled via a
> +serial bus (I2C or SMBus).
> +
> +When V4L2 started, there was only one type of device control. The entire

started -> was originally designed

> +device was controlled via the **V4L2 device nodes**. We refer to this
> +kind of control as **V4L2 device-centric** (or, simply, **device-centric**).

For the same reason as mentioned above I prefer "device node-centric" or
"devnode-centric". "device" is too ambiguous.

> +
> +Since the end of 2010, a new type of V4L2 device control was added in order
> +to support complex devices that are common on embedded systems. Those

on -> for

> +devices are controlled mainly via the media controller and sub-devices.
> +So, they're called: **media controller centric** (or, simply,
> +"**mc-centric**").
> +
> +On **device-centric** control, the device and their corresponding hardware

On -> For

> +pipelines are controlled via the **V4L2 device** node. They may optionally
> +expose the hardware pipelines via the
> +:ref:`media controller API <media_controller>`.
> +
> +On a **mc-centric**, before using the V4L2 device, it is required to

"For **mc-centric** control"

> +set the hardware pipelines via the
> +:ref:`media controller API <media_controller>`. On those devices, the

On -> For

> +sub-devices' configuration can be controlled via the

can be -> is

> +:ref:`sub-device API <subdev>`, with creates one device node per sub device.
> +
> +In summary, on **mc-centric** devices:

on -> for

> +
> +- The **V4L2 device** node is mainly responsible for controlling the
> +  streaming features;

I think "mainly" can be dropped.

> +- The **media controller device** is responsible to setup the pipelines
> +  and image settings (like size and format);
> +- The **V4L2 sub-devices** are responsible for sub-device
> +  specific settings.
> +
> +.. note::
> +
> +   It is forbidden for **device-centric** devices to expose V4L2
> +   sub-devices via :ref:`sub-device API <subdev>`, although this
> +   might change in the future.

We discussed this on irc yesterday, so this has to be tweaked a bit.

> +
> +
> +.. _v4l2_device_naming:
>  
>  Device Naming
>  =============
> 

Regards,

	Hans
