Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35236 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754727AbdHYLIb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 07:08:31 -0400
Date: Fri, 25 Aug 2017 14:08:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/3] media: open.rst: document devnode-centric and
 mc-centric types
Message-ID: <20170825110827.7kghpjmeqqxbhoa2@valkosipuli.retiisi.org.uk>
References: <cover.1503653839.git.mchehab@s-opensource.com>
 <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bef8524bf9eb1fbf51fff93d59c42602009858c1.1503653839.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the update. A few more small comments below.

On Fri, Aug 25, 2017 at 06:40:05AM -0300, Mauro Carvalho Chehab wrote:
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
> +often several additional drivers. The main driver always exposes one or
> +more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`).

s/V4L2 device\*\* devnodes/V4L2 device nodes\*\*/

(As you also have a few paragraphs below.)

> +
> +The other drivers are called **V4L2 sub-devices** and provide control to
> +other parts of the hardware usually connected via a serial bus (like
> +I²C, SMBus or SPI). They can be implicitly controlled directly by the

s/They/Depending on the main driver, they/

> +main driver or explicitly through via the **V4L2 sub-device API** interface.

Through or via, but not both. " interface" is redundant.

> +
> +When V4L2 was originally designed, there was only one type of device control.
> +The entire device was controlled via the **V4L2 device nodes**. We refer to
> +this kind of control as **V4L2 device node centric** (or, simply,
> +**vdev-centric**).

s/vdev-centric/V4L2-centric/ ?

> +
> +Since the end of 2010, a new type of V4L2 device control was added in order
> +to support complex devices that are common for embedded systems. Those
> +devices are controlled mainly via the media controller and sub-devices.
> +So, they're called: **Media controller centric** (or, simply,
> +"**MC-centric**").
> +
> +For **vdev-centric** control, the device and their corresponding hardware
> +pipelines are controlled via the **V4L2 device** node. They may optionally

I'd add highlighting to " node" as well.

> +expose via the :ref:`media controller API <media_controller>`.
> +
> +For **MC-centric** control, before using the V4L2 device, it is required to
> +set the hardware pipelines via the
> +:ref:`media controller API <media_controller>`. For those devices, the
> +sub-devices' configuration can be controlled via the
> +:ref:`sub-device API <subdev>`, with creates one device node per sub device.
> +
> +In summary, for **MC-centric** devices:
> +
> +- The **V4L2 device** node is responsible for controlling the streaming
> +  features;

Same here. Or, just remove node. The other device nodes are just as much
nodes as this one.

> +- The **media controller device** is responsible to setup the pipelines;
> +- The **V4L2 sub-devices** are responsible for sub-device
> +  specific settings.
> +
> +.. note::
> +
> +   A **vdev-centric** may optionally expose V4L2 sub-devices via
> +   :ref:`sub-device API <subdev>`. In that case, it has to implement
> +   the :ref:`media controller API <media_controller>` as well.

Looks good!

> +
> +
> +
> +.. _v4l2_device_naming:
>  
>  Device Naming
>  =============

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
