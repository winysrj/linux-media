Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55559 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753059AbdC2Syd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 12/22] error-codes.rst: convert to ReST and add to driver-api book
Date: Wed, 29 Mar 2017 15:54:11 -0300
Message-Id: <9117bae6b6e9092a93ad40a03684443b939f7b61.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describe some USB core features. Add it to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/error-codes.rst | 205 +++++++++++++++++++++++++++
 Documentation/driver-api/usb/index.rst       |   1 +
 Documentation/usb/error-codes.txt            | 175 -----------------------
 3 files changed, 206 insertions(+), 175 deletions(-)
 create mode 100644 Documentation/driver-api/usb/error-codes.rst
 delete mode 100644 Documentation/usb/error-codes.txt

diff --git a/Documentation/driver-api/usb/error-codes.rst b/Documentation/driver-api/usb/error-codes.rst
new file mode 100644
index 000000000000..715cc35b29b0
--- /dev/null
+++ b/Documentation/driver-api/usb/error-codes.rst
@@ -0,0 +1,205 @@
+USB Error codes
+~~~~~~~~~~~~~~~
+
+Revised: 2004-Oct-21
+
+This is the documentation of (hopefully) all possible error codes (and
+their interpretation) that can be returned from usbcore.
+
+Some of them are returned by the Host Controller Drivers (HCDs), which
+device drivers only see through usbcore.  As a rule, all the HCDs should
+behave the same except for transfer speed dependent behaviors and the
+way certain faults are reported.
+
+
+Error codes returned by :c:func:`usb_submit_urb`
+================================================
+
+Non-USB-specific:
+
+
+=============== ===============================================
+0		URB submission went fine
+
+``-ENOMEM``	no memory for allocation of internal structures
+=============== ===============================================
+
+USB-specific:
+
+=======================	=======================================================
+``-EBUSY``		The URB is already active.
+
+``-ENODEV``		specified USB-device or bus doesn't exist
+
+``-ENOENT``		specified interface or endpoint does not exist or
+			is not enabled
+
+``-ENXIO``		host controller driver does not support queuing of
+			this type of urb.  (treat as a host controller bug.)
+
+``-EINVAL``		a) Invalid transfer type specified (or not supported)
+			b) Invalid or unsupported periodic transfer interval
+			c) ISO: attempted to change transfer interval
+			d) ISO: ``number_of_packets`` is < 0
+			e) various other cases
+
+``-EXDEV``		ISO: ``URB_ISO_ASAP`` wasn't specified and all the
+			frames the URB would be scheduled in have already
+			expired.
+
+``-EFBIG``		Host controller driver can't schedule that many ISO
+			frames.
+
+``-EPIPE``		The pipe type specified in the URB doesn't match the
+			endpoint's actual type.
+
+``-EMSGSIZE``		(a) endpoint maxpacket size is zero; it is not usable
+			    in the current interface altsetting.
+			(b) ISO packet is larger than the endpoint maxpacket.
+			(c) requested data transfer length is invalid: negative
+			    or too large for the host controller.
+
+``-ENOSPC``		This request would overcommit the usb bandwidth reserved
+			for periodic transfers (interrupt, isochronous).
+
+``-ESHUTDOWN``		The device or host controller has been disabled due to
+			some problem that could not be worked around.
+
+``-EPERM``		Submission failed because ``urb->reject`` was set.
+
+``-EHOSTUNREACH``	URB was rejected because the device is suspended.
+
+``-ENOEXEC``		A control URB doesn't contain a Setup packet.
+=======================	=======================================================
+
+Error codes returned by ``in urb->status`` or in ``iso_frame_desc[n].status`` (for ISO)
+=======================================================================================
+
+USB device drivers may only test urb status values in completion handlers.
+This is because otherwise there would be a race between HCDs updating
+these values on one CPU, and device drivers testing them on another CPU.
+
+A transfer's actual_length may be positive even when an error has been
+reported.  That's because transfers often involve several packets, so that
+one or more packets could finish before an error stops further endpoint I/O.
+
+For isochronous URBs, the urb status value is non-zero only if the URB is
+unlinked, the device is removed, the host controller is disabled, or the total
+transferred length is less than the requested length and the
+``URB_SHORT_NOT_OK`` flag is set.  Completion handlers for isochronous URBs
+should only see ``urb->status`` set to zero, ``-ENOENT``, ``-ECONNRESET``,
+``-ESHUTDOWN``, or ``-EREMOTEIO``. Individual frame descriptor status fields
+may report more status codes.
+
+
+===============================	===============================================
+0				Transfer completed successfully
+
+``-ENOENT``			URB was synchronously unlinked by
+				:c:func:`usb_unlink_urb`
+
+``-EINPROGRESS``		URB still pending, no results yet
+				(That is, if drivers see this it's a bug.)
+
+``-EPROTO`` [#f1]_, [#f2]_	a) bitstuff error
+				b) no response packet received within the
+				   prescribed bus turn-around time
+				c) unknown USB error
+
+``-EILSEQ`` [#f1]_, [#f2]_	a) CRC mismatch
+				b) no response packet received within the
+				   prescribed bus turn-around time
+				c) unknown USB error
+
+				Note that often the controller hardware does
+				not distinguish among cases a), b), and c), so
+				a driver cannot tell whether there was a
+				protocol error, a failure to respond (often
+				caused by device disconnect), or some other
+				fault.
+
+``-ETIME`` [#f2]_		No response packet received within the
+				prescribed bus turn-around time.  This error
+				may instead be reported as
+				``-EPROTO`` or ``-EILSEQ``.
+
+``-ETIMEDOUT``			Synchronous USB message functions use this code
+				to indicate timeout expired before the transfer
+				completed, and no other error was reported
+				by HC.
+
+``-EPIPE`` [#f2]_		Endpoint stalled.  For non-control endpoints,
+				reset this status with
+				:c:func:`usb_clear_halt`.
+
+``-ECOMM``			During an IN transfer, the host controller
+				received data from an endpoint faster than it
+				could be written to system memory
+
+``-ENOSR``			During an OUT transfer, the host controller
+				could not retrieve data from system memory fast
+				enough to keep up with the USB data rate
+
+``-EOVERFLOW`` [#f1]_		The amount of data returned by the endpoint was
+				greater than either the max packet size of the
+				endpoint or the remaining buffer size.
+				"Babble".
+
+``-EREMOTEIO``			The data read from the endpoint did not fill
+				the specified buffer, and ``URB_SHORT_NOT_OK``
+				was set in ``urb->transfer_flags``.
+
+``-ENODEV``			Device was removed.  Often preceded by a burst
+				of other errors, since the hub driver doesn't
+				detect device removal events immediately.
+
+``-EXDEV``			ISO transfer only partially completed
+				(only set in ``iso_frame_desc[n].status``,
+				not ``urb->status``)
+
+``-EINVAL``			ISO madness, if this happens: Log off and
+				go home
+
+``-ECONNRESET``			URB was asynchronously unlinked by
+				:c:func:`usb_unlink_urb`
+
+``-ESHUTDOWN``			The device or host controller has been
+				disabled due to some problem that could not
+				be worked around, such as a physical
+				disconnect.
+===============================	===============================================
+
+
+.. [#f1]
+
+   Error codes like ``-EPROTO``, ``-EILSEQ`` and ``-EOVERFLOW`` normally
+   indicate hardware problems such as bad devices (including firmware)
+   or cables.
+
+.. [#f2]
+
+   This is also one of several codes that different kinds of host
+   controller use to indicate a transfer has failed because of device
+   disconnect.  In the interval before the hub driver starts disconnect
+   processing, devices may receive such fault reports for every request.
+
+
+
+Error codes returned by usbcore-functions
+=========================================
+
+.. note:: expect also other submit and transfer status codes
+
+:c:func:`usb_register`:
+
+======================= ===================================
+``-EINVAL``		error during registering new driver
+======================= ===================================
+
+``usb_get_*/usb_set_*()``,
+:c:func:`usb_control_msg`,
+:c:func:`usb_bulk_msg()`:
+
+======================= ==============================================
+``-ETIMEDOUT``		Timeout expired before the transfer completed.
+======================= ==============================================
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index d7610777784b..1e2a0c54eb3d 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -11,6 +11,7 @@ Linux USB API
    callbacks
    dma
    power-management
+   error-codes
    writing_usb_driver
    writing_musb_glue_layer
 
diff --git a/Documentation/usb/error-codes.txt b/Documentation/usb/error-codes.txt
deleted file mode 100644
index 9c3eb845ebe5..000000000000
--- a/Documentation/usb/error-codes.txt
+++ /dev/null
@@ -1,175 +0,0 @@
-Revised: 2004-Oct-21
-
-This is the documentation of (hopefully) all possible error codes (and
-their interpretation) that can be returned from usbcore.
-
-Some of them are returned by the Host Controller Drivers (HCDs), which
-device drivers only see through usbcore.  As a rule, all the HCDs should
-behave the same except for transfer speed dependent behaviors and the
-way certain faults are reported.
-
-
-**************************************************************************
-*                   Error codes returned by usb_submit_urb               *
-**************************************************************************
-
-Non-USB-specific:
-
-0		URB submission went fine
-
--ENOMEM		no memory for allocation of internal structures	
-
-USB-specific:
-
--EBUSY		The URB is already active.
-
--ENODEV		specified USB-device or bus doesn't exist
-
--ENOENT		specified interface or endpoint does not exist or
-		is not enabled
-
--ENXIO		host controller driver does not support queuing of this type
-		of urb.  (treat as a host controller bug.)
-
--EINVAL		a) Invalid transfer type specified (or not supported)
-		b) Invalid or unsupported periodic transfer interval
-		c) ISO: attempted to change transfer interval
-		d) ISO: number_of_packets is < 0
-		e) various other cases
-
--EXDEV		ISO: URB_ISO_ASAP wasn't specified and all the frames
-		the URB would be scheduled in have already expired.
-
--EFBIG		Host controller driver can't schedule that many ISO frames.
-
--EPIPE		The pipe type specified in the URB doesn't match the
-		endpoint's actual type.
-
--EMSGSIZE	(a) endpoint maxpacket size is zero; it is not usable
-		    in the current interface altsetting.
-		(b) ISO packet is larger than the endpoint maxpacket.
-		(c) requested data transfer length is invalid: negative
-		    or too large for the host controller.
-
--ENOSPC		This request would overcommit the usb bandwidth reserved
-		for periodic transfers (interrupt, isochronous).
-
--ESHUTDOWN	The device or host controller has been disabled due to some
-		problem that could not be worked around.
-
--EPERM		Submission failed because urb->reject was set.
-
--EHOSTUNREACH	URB was rejected because the device is suspended.
-
--ENOEXEC	A control URB doesn't contain a Setup packet.
-
-
-**************************************************************************
-*                   Error codes returned by in urb->status               *
-*                   or in iso_frame_desc[n].status (for ISO)             *
-**************************************************************************
-
-USB device drivers may only test urb status values in completion handlers.
-This is because otherwise there would be a race between HCDs updating
-these values on one CPU, and device drivers testing them on another CPU.
-
-A transfer's actual_length may be positive even when an error has been
-reported.  That's because transfers often involve several packets, so that
-one or more packets could finish before an error stops further endpoint I/O.
-
-For isochronous URBs, the urb status value is non-zero only if the URB is
-unlinked, the device is removed, the host controller is disabled, or the total
-transferred length is less than the requested length and the URB_SHORT_NOT_OK
-flag is set.  Completion handlers for isochronous URBs should only see
-urb->status set to zero, -ENOENT, -ECONNRESET, -ESHUTDOWN, or -EREMOTEIO.
-Individual frame descriptor status fields may report more status codes.
-
-
-0			Transfer completed successfully
-
--ENOENT			URB was synchronously unlinked by usb_unlink_urb
-
--EINPROGRESS		URB still pending, no results yet
-			(That is, if drivers see this it's a bug.)
-
--EPROTO (*, **)		a) bitstuff error
-			b) no response packet received within the
-			   prescribed bus turn-around time
-			c) unknown USB error 
-
--EILSEQ (*, **)		a) CRC mismatch
-			b) no response packet received within the
-			   prescribed bus turn-around time
-			c) unknown USB error 
-
-			Note that often the controller hardware does not
-			distinguish among cases a), b), and c), so a
-			driver cannot tell whether there was a protocol
-			error, a failure to respond (often caused by
-			device disconnect), or some other fault.
-
--ETIME (**)		No response packet received within the prescribed
-			bus turn-around time.  This error may instead be
-			reported as -EPROTO or -EILSEQ.
-
--ETIMEDOUT		Synchronous USB message functions use this code
-			to indicate timeout expired before the transfer
-			completed, and no other error was reported by HC.
-
--EPIPE (**)		Endpoint stalled.  For non-control endpoints,
-			reset this status with usb_clear_halt().
-
--ECOMM			During an IN transfer, the host controller
-			received data from an endpoint faster than it
-			could be written to system memory
-
--ENOSR			During an OUT transfer, the host controller
-			could not retrieve data from system memory fast
-			enough to keep up with the USB data rate
-
--EOVERFLOW (*)		The amount of data returned by the endpoint was
-			greater than either the max packet size of the
-			endpoint or the remaining buffer size.  "Babble".
-
--EREMOTEIO		The data read from the endpoint did not fill the
-			specified buffer, and URB_SHORT_NOT_OK was set in
-			urb->transfer_flags.
-
--ENODEV			Device was removed.  Often preceded by a burst of
-			other errors, since the hub driver doesn't detect
-			device removal events immediately.
-
--EXDEV			ISO transfer only partially completed
-			(only set in iso_frame_desc[n].status, not urb->status)
-
--EINVAL			ISO madness, if this happens: Log off and go home
-
--ECONNRESET		URB was asynchronously unlinked by usb_unlink_urb
-
--ESHUTDOWN		The device or host controller has been disabled due
-			to some problem that could not be worked around,
-			such as a physical disconnect.
-
-
-(*) Error codes like -EPROTO, -EILSEQ and -EOVERFLOW normally indicate
-hardware problems such as bad devices (including firmware) or cables.
-
-(**) This is also one of several codes that different kinds of host
-controller use to indicate a transfer has failed because of device
-disconnect.  In the interval before the hub driver starts disconnect
-processing, devices may receive such fault reports for every request.
-
-
-
-**************************************************************************
-*              Error codes returned by usbcore-functions                 *
-*           (expect also other submit and transfer status codes)         *
-**************************************************************************
-
-usb_register():
--EINVAL			error during registering new driver
-
-usb_get_*/usb_set_*():
-usb_control_msg():
-usb_bulk_msg():
--ETIMEDOUT		Timeout expired before the transfer completed.
-- 
2.9.3
