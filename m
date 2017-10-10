Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34495 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932142AbdJJOeB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 10:34:01 -0400
Subject: Re: [PATCH v8 4/7] media: open.rst: document vdevnode-centric and
 mc-centric types
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
 <ff134d19fc163e16710c81f4f90f885a9003e383.1507635716.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <52f4c5e9-a89a-fafa-0d19-20df43225703@xs4all.nl>
Date: Tue, 10 Oct 2017 16:33:55 +0200
MIME-Version: 1.0
In-Reply-To: <ff134d19fc163e16710c81f4f90f885a9003e383.1507635716.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More word-smithing...

On 10/10/2017 01:45 PM, Mauro Carvalho Chehab wrote:
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
>  Documentation/media/uapi/v4l/open.rst | 55 +++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index 46ef63e05696..1a8a9e1d0e84 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -7,6 +7,61 @@ Opening and Closing Devices
>  ***************************
>  
>  
> +.. _v4l2_hardware_control:
> +
> +
> +Types of V4L2 media hardware control
> +====================================
> +
> +A :term:`V4L2 hardware` is usually complex: support for it is

No 'A '.

> +implemented via a :term:`V4L2 main driver` and often by several

I prefer 'by' instead of 'via'.

> +additional :term:`drivers <driver>`.
> +The main driver always exposes one or more
> +:term:`V4L2 device nodes <v4l2 device node>`
> +(see :ref:`v4l2_device_naming`) with are responsible for implementing

with -> which

> +data streaming, if applicable.
> +
> +The other drivers are called :term:`V4L2 sub-devices <v4l2 sub-device>`

I'd say "V4L2 sub-device drivers"

> +and provide control to other
> +:term:`hardware components <hardware component>` are usually connected

:term:`hardware components <hardware component>`. Those component are usually controlled

> +via a serial bus (like :term:`I²C`, :term:`SMBus` or :term:`SPI`).
> +Depending on the main driver, they can be implicitly
> +controlled directly by the main driver or explicitly via
> +the V4L2 sub-device API (see :ref:`subdev`).
> +
> +When **V4L2** was originally designed, the
> +:term:`V4L2 device nodes <v4l2 device node>` served the purpose of both
> +control and data interfaces and there was no separation
> +between the two interface-wise. V4L2 controls, setting inputs and outputs,

Instead of 'interface-wise' I'd use 'API-wise'. That reminds me: should we add
'API' to the glossary as well? (Can be done later)

> +format configuration and buffer related operations were all performed
> +through the same **V4L2 device nodes**. Devices offering such interface are
> +called **V4L2 device node centric**.
> +
> +Later on, support for the :term:`media controller` interface was added
> +to V4L2 in order to better support complex :term:`V4L2 hardware` where the
> +**V4L2** interface alone could no longer meaningfully serve as both a
> +control and a data interface. On such V4L2 hardware, **V4L2** interface

**V4L2** -> the **V4L2**

> +remains a data interface whereas control takes place through the
> +:term:`media controller` and :term:`V4L2 sub-device` interfaces. Stream
> +control is an exception to this: streaming is enabled and disabled
> +through the **V4L2** interface. These devices are called
> +**Media controller centric**.
> +
> +**MC-centric** V4L2 hardware provide more versatile control of the

provide -> provides

> +hardware than **V4L2 device node centric** devices at the expense of
> +requiring device-specific userspace settings.
> +
> +On **MC-centric** V4L2 hardware, the **V4L2 sub-device nodes**
> +represent specific parts of the V4L2 hardware, to which they enable
> +control.

I'd rephrase this:

On **MC-centric** V4L2 hardware, the **V4L2 sub-device nodes**
provide control of the specific part of the V4L2 hardware represented
by each node.

> +
> +Also, the additional versatility of **MC-centric** V4L2 hardware comes
> +with additional responsibilities, the main one of which is the requirements

...of which the main one is the requirement...

> +of the user configuring the device pipeline before starting streaming. This
> +typically involves configuring the links using the **Media controller**
> +interface and the media bus formats on pads (at both ends of the links)
> +using the **V4L2 sub-device** interface.
> +
>  .. _v4l2_device_naming:
>  
>  V4L2 Device Node Naming
> 

Regards,

	Hans
