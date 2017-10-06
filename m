Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33718 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751604AbdJFMYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 08:24:30 -0400
Date: Fri, 6 Oct 2017 15:24:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 4/7] media: open.rst: document devnode-centric and
 mc-centric types
Message-ID: <20171006122426.3yv4je6lzxf7ikqh@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <f3435f2eb6417a4b16e036a492fc5044915892d1.1506550930.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3435f2eb6417a4b16e036a492fc5044915892d1.1506550930.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Sep 27, 2017 at 07:23:46PM -0300, Mauro Carvalho Chehab wrote:
> When we added support for omap3, back in 2010, we added a new
> type of V4L2 devices that aren't fully controlled via the V4L2
> device node.
> 
> Yet, we have never clearly documented in the V4L2 specification
> the differences between the two types.
> 
> Let's document them based on the the current implementation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 40 +++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index 18030131ef77..f603bc9b49a0 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -7,6 +7,46 @@ Opening and Closing Devices
>  ***************************
>  
>  
> +.. _v4l2_hardware_control:
> +
> +
> +Types of V4L2 media hardware control
> +====================================
> +
> +V4L2 hardware periferal is usually complex: support for it is
> +implemented via a V4L2 main driver and often by several additional drivers.
> +The main driver always exposes one or more **V4L2 device nodes**
> +(see :ref:`v4l2_device_naming`) with are responsible for implementing
> +data streaming, if applicable.
> +
> +The other drivers are called **V4L2 sub-devices** and provide control to

s/drivers/devices/

> +other hardware components usually connected via a serial bus (like
> +I²C, SMBus or SPI). Depending on the main driver, they can be implicitly
> +controlled directly by the main driver or explicitly via
> +the **V4L2 sub-device API** (see :ref:`subdev`).
> +
> +When V4L2 was originally designed, there was only one type of
> +media hardware control: via the **V4L2 device nodes**. We refer to this kind
> +of control as **V4L2 device node centric** (or, simply, "**vdevnode-centric**").

I think this could be easier understood if we start with the differences
instead of what we call the types. I'd also refer to interfaces rather than
their instances.

How about (pending finalising discussion on naming):

When **V4L2** was originally designed, the **V4L2 device** served the
purpose of both control and data interfaces and there was no separation
between the two interface-wise. V4L2 controls, setting inputs and outputs,
format configuration and buffer related operations were all performed
through the same **V4L2 device nodes**. Devices offering such interface are
called **V4L2 device node centric**.

Later on, support for the **Media controller** interface was added to V4L2
in order to better support complex **V4L2 aggregate devices** where the
**V4L2** interface alone could no longer meaningfully serve as both a
control and a data interface. On such aggregate devices, **V4L2** interface
remains a data interface whereas control takes place through the **Media
controller** and **V4L2 sub-device** interfaces. Stream control is an
exception to this: streaming is enabled and disabled through the **V4L2**
interface. These devices are called **Media controller centric**.

**MC-centric** aggregate devices provide more versatile control of the
hardware than **V4L2 device node centric** devices. On **MC-centric**
aggregate devices the **V4L2 sub-device nodes** represent specific parts of
the **V4L2 aggregate device**, to which they enable control.

Also, the additional versatility of **MC-centric** aggregate devices comes
with additional responsibilities, the main one of which is the requirements
of the user configuring the device pipeline before starting streaming. This
typically involves configuring the links using the **Media controller**
interface and the media bus formats on pads (at both ends of the links)
using the **V4L2 sub-device** interface.

> +
> +Later (kernel 2.6.39), a new type of periferal control was
> +added in order to support complex media hardware that are common for embedded
> +systems. This type of periferal is controlled mainly via the media
> +controller and V4L2 sub-devices. So, it is called
> +**Media controller centric** (or, simply, "**MC-centric**") control.
> +
> +For **vdevnode-centric** media hardware control, the media hardware is
> +controlled via the **V4L2 device nodes**. They may optionally support the
> +:ref:`media controller API <media_controller>` as well,
> +in order to inform the application which device nodes are available
> +(see :ref:`related`).
> +
> +For **MC-centric** media hardware control it is required to configure
> +the pipelines via the :ref:`media controller API <media_controller>` before
> +the periferal can be used. For such devices, the sub-devices' configuration
> +can be controlled via the :ref:`sub-device API <subdev>`, which creates one
> +device node per sub-device.
> +
>  .. _v4l2_device_naming:
>  
>  V4L2 Device Node Naming

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
