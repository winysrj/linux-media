Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53268 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754535AbdHYKcc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 06:32:32 -0400
Subject: Re: [PATCH 1/3] media: open.rst: document devnode-centric and
 mc-centric types
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1503653839.git.mchehab@s-opensource.com>
 <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <90619be1-3288-1b24-58e4-c1302133279d@xs4all.nl>
Date: Fri, 25 Aug 2017 12:32:29 +0200
MIME-Version: 1.0
In-Reply-To: <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/08/17 11:40, Mauro Carvalho Chehab wrote:
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
> ---
>  Documentation/media/uapi/v4l/open.rst | 50 +++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index afd116edb40d..a72d142897c0 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -6,6 +6,56 @@
>  Opening and Closing Devices
>  ***************************
>  
> +Types of V4L2 hardware control
> +==============================
> +
> +V4L2 devices are usually complex: they are implemented via a main driver and

V4L2 hardware is usually complex: support for the hardware is implemented...

> +often several additional drivers. The main driver always exposes one or

Should we change this to "via a main (also known as 'bridge') driver"?

To help understanding terminology that we use?

> +more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`).
> +
> +The other drivers are called **V4L2 sub-devices** and provide control to
> +other parts of the hardware usually connected via a serial bus (like
> +I²C, SMBus or SPI). They can be implicitly controlled directly by the
> +main driver or explicitly through via the **V4L2 sub-device API** interface.
> +
> +When V4L2 was originally designed, there was only one type of device control.

hardware control

> +The entire device was controlled via the **V4L2 device nodes**. We refer to

entire V4L2 hardware

> +this kind of control as **V4L2 device node centric** (or, simply,
> +**vdev-centric**).
> +
> +Since the end of 2010, a new type of V4L2 device control was added in order

hardware control

> +to support complex devices that are common for embedded systems. Those
> +devices are controlled mainly via the media controller and sub-devices.
> +So, they're called: **Media controller centric** (or, simply,

they are

> +"**MC-centric**").
> +
> +For **vdev-centric** control, the device and their corresponding hardware

s/control/hardware control/

s/the device and their corresponding hardware pipelines are/the hardware is/

(let's keep it simple).

> +pipelines are controlled via the **V4L2 device** node. They may optionally

node -> node (or nodes, if there is more than one V4L2 device node)

> +expose via the :ref:`media controller API <media_controller>`.

I'd say: "support the :ref:`media controller API <media_controller>` as well
in order to let the application know which device nodes are available.

> +
> +For **MC-centric** control, before using the V4L2 device, it is required to

s/control/hardware control/

s/device/hardware/ (I think. Or did you mean "device node"?)

> +set the hardware pipelines via the
> +:ref:`media controller API <media_controller>`. For those devices, the
> +sub-devices' configuration can be controlled via the
> +:ref:`sub-device API <subdev>`, with creates one device node per sub device.

s/with/which/

> +
> +In summary, for **MC-centric** devices:

s/devices/hardware/

> +
> +- The **V4L2 device** node is responsible for controlling the streaming
> +  features;
> +- The **media controller device** is responsible to setup the pipelines;
> +- The **V4L2 sub-devices** are responsible for sub-device
> +  specific settings.
> +
> +.. note::
> +
> +   A **vdev-centric** may optionally expose V4L2 sub-devices via
> +   :ref:`sub-device API <subdev>`. In that case, it has to implement
> +   the :ref:`media controller API <media_controller>` as well.

This note should be moved up to the vdev-centric description. It's weird now
as it comes after the MC centric summary, but deals with a vdev-centric driver.

> +
> +
> +
> +.. _v4l2_device_naming:
>  
>  Device Naming
>  =============
> 

Regards,

	Hans
