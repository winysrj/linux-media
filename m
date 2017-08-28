Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:57912 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751207AbdH1JGT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 05:06:19 -0400
Subject: Re: [PATCH v4 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1503747774.git.mchehab@s-opensource.com>
 <e529a2ac2346e50c5c314d1f1352d88fdb7180c4.1503747774.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3d6b460f-2ac0-58ae-4a96-5e66a5ab3995@xs4all.nl>
Date: Mon, 28 Aug 2017 11:06:12 +0200
MIME-Version: 1.0
In-Reply-To: <e529a2ac2346e50c5c314d1f1352d88fdb7180c4.1503747774.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a partial review. I think I need to review the other patches first
before continuing this review. But it doesn't hurt to post this now.

On 26/08/17 13:53, Mauro Carvalho Chehab wrote:
> Add a glossary of terms for V4L2, as several concepts are complex
> enough to cause misunderstandings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/glossary.rst | 98 +++++++++++++++++++++++++++++++
>  Documentation/media/uapi/v4l/v4l2.rst     |  1 +
>  2 files changed, 99 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> 
> diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> new file mode 100644
> index 000000000000..e55cd357dad3
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/glossary.rst
> @@ -0,0 +1,98 @@
> +========
> +Glossary
> +========
> +
> +.. note::
> +
> +   This goal of section is to standardize the terms used within the V4L2
> +   documentation. It is written incrementally as they're standardized at

they're -> they are
at -> in

> +   the V4L2 documentation. So, it is an incomplete Work In Progress.

an incomplete Work -> a Work

(a work in progress is by definition incomplete :-) )

> +
> +.. Please keep the glossary entries in alphabetical order
> +
> +.. glossary::
> +
> +    Bridge driver
> +	 The same as V4L2 main driver.
> +
> +    Device Node
> +	 A character device node at the file system used to control and do

at -> in

> +	 input/output data transfers to a Kernel driver.

to -> from/to

> +
> +    Driver
> +	 The part of the Linux Kernel that implements support
> +	 for a hardware component.
> +
> +    Inter-Integrated Circuit - I²C
> +	 A  multi-master, multi-slave, packet switched, single-ended,
> +	 serial computer bus used to control V4L2 sub-devices

Missing . at the end. Perhaps add a link to the i2c spec or wikipedia page?

Also, this entry is not in alphabetical order.

> +
> +    Hardware component
> +	 a subset of the media hardware.

Could use some examples:

"For example an i2c or SPI device, or an IP block inside an SoC or FPGA
(https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core)."

> +
> +    Hardware peripheral
> +	 A group of hardware components that together make a larger
> +	 user-facing functional peripheral. For instance the SoC ISP IP
> +	 cores and external camera sensors together make a
> +	 camera hardware peripheral.
> +	 Also known as peripheral.

SoC, ISP and IP core need their own entries here.

> +
> +    Hardware peripheral control
> +	 Type of control that it is possible for a V4L2 hardware peripheral.

This sentence makes no sense.

> +
> +	 See :ref:`v4l2_hardware_control`.
> +
> +    Peripheral
> +	 The same as hardware peripheral.
> +
> +    Media Controller
> +	 An API used to identify the hardware components.

...components and (optionally) change the links between hardware components.

> +
> +	 See :ref:`media_controller`.
> +
> +    MC-centric
> +	 V4L2 hardware that requires a Media controller to be controlled.

I think I would just drop the 'to be controlled' bit.

> +
> +	 See :ref:`v4l2_hardware_control`.
> +
> +    SMBus
> +	 A subset of I²C, with defines a stricter usage of the bus.
> +
> +    Serial Peripheral Interface Bus - SPI
> +	 Synchronous serial communication interface specification used for
> +	 short distance communication, primarily in embedded systems.
> +
> +    Sub-device hardware components
> +	 hardware components that aren't controlled by the

hardware -> Hardware

> +	 V4L2 main driver.
> +
> +    V4L2 device node
> +	 A device node that it is associated to a V4L2 main driver,

it is -> is
to -> with

> +	 as specified at :ref:`v4l2_device_naming`.

at -> in

> +
> +    V4L2 hardware
> +	 A hardware used to on a media device supported by the V4L2
> +	 subsystem.
> +
> +    V4L2 hardware control
> +	 The type of hardware control that a device supports.
> +
> +	 See :ref:`v4l2_hardware_control`.
> +
> +    V4L2 main driver
> +	 The V4L2 device driver that implements the main logic to talk with
> +	 the V4L2 hardware.
> +	 Also known as bridge driver.
> +
> +	 See :ref:`v4l2_hardware_control`.
> +
> +    V4L2 sub-device
> +	 part of the media hardware that it is implemented by a device
> +	 driver that is not part of the main V4L2 driver.
> +
> +	 See :ref:`subdev`.
> +
> +    Vdev-centric
> +	 V4L2 hardware that it is controlled via V4L2 device nodes.
> +
> +	 See :ref:`v4l2_hardware_control`.
> diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
> index f52a11c949d3..1ee4b86d18e1 100644
> --- a/Documentation/media/uapi/v4l/v4l2.rst
> +++ b/Documentation/media/uapi/v4l/v4l2.rst
> @@ -31,6 +31,7 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
>      videodev
>      capture-example
>      v4l2grab-example
> +    glossary
>      biblio
>  
>  
> 
