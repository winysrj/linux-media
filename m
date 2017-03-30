Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:27986 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752733AbdC3HBf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 03:01:35 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 04/22] gadget.rst: Enrich its ReST representation and add kernel-doc tag
In-Reply-To: <61bf3d87b32a57f5d223dc3fd0228c342ba1b4a0.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com> <61bf3d87b32a57f5d223dc3fd0228c342ba1b4a0.1490813422.git.mchehab@s-opensource.com>
Date: Thu, 30 Mar 2017 10:01:29 +0300
Message-ID: <874lyb459y.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 29 Mar 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> The pandoc conversion is not perfect. Do handwork in order to:
>
> - add a title to this chapter;
> - use the proper warning and note markups;
> - use kernel-doc to include Kernel header and c files;

Please look at Documentation/sphinx/tmplcvt which takes care of all of
that.

BR,
Jani.

> - remove legacy notes with regards to DocBook;
> - some other minor adjustments to make it better to read in
>   text mode and in html.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/driver-api/usb/gadget.rst | 69 +++++++++++++++++++++------------
>  1 file changed, 45 insertions(+), 24 deletions(-)
>
> diff --git a/Documentation/driver-api/usb/gadget.rst b/Documentation/driver-api/usb/gadget.rst
> index 4fd9862f3f21..c4c76ebb51d3 100644
> --- a/Documentation/driver-api/usb/gadget.rst
> +++ b/Documentation/driver-api/usb/gadget.rst
> @@ -1,3 +1,7 @@
> +Linux-USB "Gadget" kernel mode API
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +
>  Introduction
>  ============
>  
> @@ -175,16 +179,12 @@ the gadget, and submitting one or more *struct usb\_request* buffers to
>  transfer data. Understand those four data types, and their operations,
>  and you will understand how this API works.
>  
> -    **Note**
> +.. Note::
>  
> -    This documentation was prepared using the standard Linux kernel
> -    ``docproc`` tool, which turns text and in-code comments into SGML
> -    DocBook and then into usable formats such as HTML or PDF. Other than
> -    the "Chapter 9" data types, most of the significant data types and
> -    functions are described here.
> +    Other than the "Chapter 9" data types, most of the significant data
> +    types and functions are described here.
>  
> -    However, docproc does not understand all the C constructs that are
> -    used, so some relevant information is likely omitted from what you
> +    However, some relevant information is likely omitted from what you
>      are reading. One example of such information is endpoint
>      autoconfiguration. You'll have to read the header file, and use
>      example source code (such as that for "Gadget Zero"), to fully
> @@ -192,10 +192,10 @@ and you will understand how this API works.
>  
>      The part of the API implementing some basic driver capabilities is
>      specific to the version of the Linux kernel that's in use. The 2.6
> -    kernel includes a *driver model* framework that has no analogue on
> -    earlier kernels; so those parts of the gadget API are not fully
> -    portable. (They are implemented on 2.4 kernels, but in a different
> -    way.) The driver model state is another part of this API that is
> +    and upper kernel versions include a *driver model* framework that has
> +    no analogue on earlier kernels; so those parts of the gadget API are
> +    not fully portable. (They are implemented on 2.4 kernels, but in a
> +    different way.) The driver model state is another part of this API that is
>      ignored by the kerneldoc tools.
>  
>  The core API does not expose every possible hardware feature, only the
> @@ -301,18 +301,19 @@ USB 2.0 Chapter 9 Types and Constants
>  -------------------------------------
>  
>  Gadget drivers rely on common USB structures and constants defined in
> -the ``<linux/usb/ch9.h>`` header file, which is standard in Linux 2.6
> -kernels. These are the same types and constants used by host side
> +the :ref:`linux/usb/ch9.h <usb_chapter9>` header file, which is standard in
> +Linux 2.6+ kernels. These are the same types and constants used by host side
>  drivers (and usbcore).
>  
> -!Iinclude/linux/usb/ch9.h
>  Core Objects and Methods
>  ------------------------
>  
>  These are declared in ``<linux/usb/gadget.h>``, and are used by gadget
>  drivers to interact with USB peripheral controller drivers.
>  
> -!Iinclude/linux/usb/gadget.h
> +.. kernel-doc:: include/linux/usb/gadget.h
> +   :internal:
> +
>  Optional Utilities
>  ------------------
>  
> @@ -320,7 +321,12 @@ The core API is sufficient for writing a USB Gadget Driver, but some
>  optional utilities are provided to simplify common tasks. These
>  utilities include endpoint autoconfiguration.
>  
> -!Edrivers/usb/gadget/usbstring.c !Edrivers/usb/gadget/config.c
> +.. kernel-doc:: drivers/usb/gadget/usbstring.c
> +   :export:
> +
> +.. kernel-doc:: drivers/usb/gadget/config.c
> +   :export:
> +
>  Composite Device Framework
>  --------------------------
>  
> @@ -337,7 +343,12 @@ usb\_function*, which packages a user visible role such as "network
>  link" or "mass storage device". Management functions may also exist,
>  such as "Device Firmware Upgrade".
>  
> -!Iinclude/linux/usb/composite.h !Edrivers/usb/gadget/composite.c
> +.. kernel-doc:: include/linux/usb/composite.h
> +   :internal:
> +
> +.. kernel-doc:: drivers/usb/gadget/composite.c
> +   :export:
> +
>  Composite Device Functions
>  --------------------------
>  
> @@ -345,11 +356,21 @@ At this writing, a few of the current gadget drivers have been converted
>  to this framework. Near-term plans include converting all of them,
>  except for "gadgetfs".
>  
> -!Edrivers/usb/gadget/function/f\_acm.c
> -!Edrivers/usb/gadget/function/f\_ecm.c
> -!Edrivers/usb/gadget/function/f\_subset.c
> -!Edrivers/usb/gadget/function/f\_obex.c
> -!Edrivers/usb/gadget/function/f\_serial.c
> +.. kernel-doc:: drivers/usb/gadget/function/f_acm.c
> +   :export:
> +
> +.. kernel-doc:: drivers/usb/gadget/function/f_ecm.c
> +   :export:
> +
> +.. kernel-doc:: drivers/usb/gadget/function/f_subset.c
> +   :export:
> +
> +.. kernel-doc:: drivers/usb/gadget/function/f_obex.c
> +   :export:
> +
> +.. kernel-doc:: drivers/usb/gadget/function/f_serial.c
> +   :export:
> +
>  Peripheral Controller Drivers
>  =============================
>  
> @@ -475,7 +496,7 @@ can also benefit non-OTG products.
>  -  Also on the host side, a driver must support the OTG "Targeted
>     Peripheral List". That's just a whitelist, used to reject peripherals
>     not supported with a given Linux OTG host. *This whitelist is
> -   product-specific; each product must modify ``otg_whitelist.h`` to
> +   product-specific; each product must modify* ``otg_whitelist.h`` *to
>     match its interoperability specification.*
>  
>     Non-OTG Linux hosts, like PCs and workstations, normally have some

-- 
Jani Nikula, Intel Open Source Technology Center
