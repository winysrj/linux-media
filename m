Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39768 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753549AbdC2Syf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:35 -0400
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
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Alexander Dahl <post@lespocky.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
Date: Wed, 29 Mar 2017 15:54:01 -0300
Message-Id: <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're moving out of DocBook, let's convert the remaining
USB docbooks to ReST.

The transformation itself on this patch is a no-brainer
conversion using pandoc.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/DocBook/Makefile                     |   7 +-
 Documentation/DocBook/gadget.tmpl                  | 793 -------------------
 Documentation/DocBook/writing_musb_glue_layer.tmpl | 873 ---------------------
 Documentation/DocBook/writing_usb_driver.tmpl      | 412 ----------
 Documentation/driver-api/index.rst                 |   2 +-
 Documentation/driver-api/usb/gadget.rst            | 501 ++++++++++++
 Documentation/driver-api/usb/index.rst             |  17 +
 Documentation/driver-api/{ => usb}/usb.rst         | 168 ++--
 .../driver-api/usb/writing_musb_glue_layer.rst     | 731 +++++++++++++++++
 .../driver-api/usb/writing_usb_driver.rst          | 338 ++++++++
 10 files changed, 1675 insertions(+), 2167 deletions(-)
 delete mode 100644 Documentation/DocBook/gadget.tmpl
 delete mode 100644 Documentation/DocBook/writing_musb_glue_layer.tmpl
 delete mode 100644 Documentation/DocBook/writing_usb_driver.tmpl
 create mode 100644 Documentation/driver-api/usb/gadget.rst
 create mode 100644 Documentation/driver-api/usb/index.rst
 rename Documentation/driver-api/{ => usb}/usb.rst (87%)
 create mode 100644 Documentation/driver-api/usb/writing_musb_glue_layer.rst
 create mode 100644 Documentation/driver-api/usb/writing_usb_driver.rst

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 164c1c76971f..7d94db2b53cd 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -8,12 +8,11 @@
 
 DOCBOOKS := z8530book.xml  \
 	    kernel-hacking.xml kernel-locking.xml \
-	    writing_usb_driver.xml networking.xml \
+	    networking.xml \
 	    kernel-api.xml filesystems.xml lsm.xml kgdb.xml \
-	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
+	    libata.xml mtdnand.xml librs.xml rapidio.xml \
 	    genericirq.xml s390-drivers.xml scsi.xml \
-	    sh.xml w1.xml \
-	    writing_musb_glue_layer.xml
+	    sh.xml w1.xml
 
 ifeq ($(DOCBOOKS),)
 
diff --git a/Documentation/DocBook/gadget.tmpl b/Documentation/DocBook/gadget.tmpl
deleted file mode 100644
index 641629221176..000000000000
--- a/Documentation/DocBook/gadget.tmpl
+++ /dev/null
@@ -1,793 +0,0 @@
-<?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
-
-<book id="USB-Gadget-API">
-  <bookinfo>
-    <title>USB Gadget API for Linux</title>
-    <date>20 August 2004</date>
-    <edition>20 August 2004</edition>
-  
-    <legalnotice>
-       <para>
-	 This documentation is free software; you can redistribute
-	 it and/or modify it under the terms of the GNU General Public
-	 License as published by the Free Software Foundation; either
-	 version 2 of the License, or (at your option) any later
-	 version.
-       </para>
-	  
-       <para>
-	 This program is distributed in the hope that it will be
-	 useful, but WITHOUT ANY WARRANTY; without even the implied
-	 warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-	 See the GNU General Public License for more details.
-       </para>
-	  
-       <para>
-	 You should have received a copy of the GNU General Public
-	 License along with this program; if not, write to the Free
-	 Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
-	 MA 02111-1307 USA
-       </para>
-	  
-       <para>
-	 For more details see the file COPYING in the source
-	 distribution of Linux.
-       </para>
-    </legalnotice>
-    <copyright>
-      <year>2003-2004</year>
-      <holder>David Brownell</holder>
-    </copyright>
-
-    <author>
-      <firstname>David</firstname> 
-      <surname>Brownell</surname>
-      <affiliation>
-        <address><email>dbrownell@users.sourceforge.net</email></address>
-      </affiliation>
-    </author>
-  </bookinfo>
-
-<toc></toc>
-
-<chapter id="intro"><title>Introduction</title>
-
-<para>This document presents a Linux-USB "Gadget"
-kernel mode
-API, for use within peripherals and other USB devices
-that embed Linux.
-It provides an overview of the API structure,
-and shows how that fits into a system development project.
-This is the first such API released on Linux to address
-a number of important problems, including: </para>
-
-<itemizedlist>
-    <listitem><para>Supports USB 2.0, for high speed devices which
-	can stream data at several dozen megabytes per second.
-	</para></listitem>
-    <listitem><para>Handles devices with dozens of endpoints just as
-	well as ones with just two fixed-function ones.  Gadget drivers
-	can be written so they're easy to port to new hardware.
-	</para></listitem>
-    <listitem><para>Flexible enough to expose more complex USB device
-	capabilities such as multiple configurations, multiple interfaces,
-	composite devices,
-	and alternate interface settings.
-	</para></listitem>
-    <listitem><para>USB "On-The-Go" (OTG) support, in conjunction
-	with updates to the Linux-USB host side.
-	</para></listitem>
-    <listitem><para>Sharing data structures and API models with the
-	Linux-USB host side API.  This helps the OTG support, and
-	looks forward to more-symmetric frameworks (where the same
-	I/O model is used by both host and device side drivers).
-	</para></listitem>
-    <listitem><para>Minimalist, so it's easier to support new device
-	controller hardware.  I/O processing doesn't imply large
-	demands for memory or CPU resources.
-	</para></listitem>
-</itemizedlist>
-
-
-<para>Most Linux developers will not be able to use this API, since they
-have USB "host" hardware in a PC, workstation, or server.
-Linux users with embedded systems are more likely to
-have USB peripheral hardware.
-To distinguish drivers running inside such hardware from the
-more familiar Linux "USB device drivers",
-which are host side proxies for the real USB devices,
-a different term is used:
-the drivers inside the peripherals are "USB gadget drivers".
-In USB protocol interactions, the device driver is the master
-(or "client driver")
-and the gadget driver is the slave (or "function driver").
-</para>
-
-<para>The gadget API resembles the host side Linux-USB API in that both
-use queues of request objects to package I/O buffers, and those requests
-may be submitted or canceled.
-They share common definitions for the standard USB
-<emphasis>Chapter 9</emphasis> messages, structures, and constants.
-Also, both APIs bind and unbind drivers to devices.
-The APIs differ in detail, since the host side's current
-URB framework exposes a number of implementation details
-and assumptions that are inappropriate for a gadget API.
-While the model for control transfers and configuration
-management is necessarily different (one side is a hardware-neutral master,
-the other is a hardware-aware slave), the endpoint I/0 API used here
-should also be usable for an overhead-reduced host side API.
-</para>
-
-</chapter>
-
-<chapter id="structure"><title>Structure of Gadget Drivers</title>
-
-<para>A system running inside a USB peripheral
-normally has at least three layers inside the kernel to handle
-USB protocol processing, and may have additional layers in
-user space code.
-The "gadget" API is used by the middle layer to interact
-with the lowest level (which directly handles hardware).
-</para>
-
-<para>In Linux, from the bottom up, these layers are:
-</para>
-
-<variablelist>
-
-    <varlistentry>
-        <term><emphasis>USB Controller Driver</emphasis></term>
-
-	<listitem>
-	<para>This is the lowest software level.
-	It is the only layer that talks to hardware,
-	through registers, fifos, dma, irqs, and the like.
-	The <filename>&lt;linux/usb/gadget.h&gt;</filename> API abstracts
-	the peripheral controller endpoint hardware.
-	That hardware is exposed through endpoint objects, which accept
-	streams of IN/OUT buffers, and through callbacks that interact
-	with gadget drivers.
-	Since normal USB devices only have one upstream
-	port, they only have one of these drivers.
-	The controller driver can support any number of different
-	gadget drivers, but only one of them can be used at a time.
-	</para>
-
-	<para>Examples of such controller hardware include
-	the PCI-based NetChip 2280 USB 2.0 high speed controller,
-	the SA-11x0 or PXA-25x UDC (found within many PDAs),
-	and a variety of other products.
-	</para>
-
-	</listitem></varlistentry>
-
-    <varlistentry>
-	<term><emphasis>Gadget Driver</emphasis></term>
-
-	<listitem>
-	<para>The lower boundary of this driver implements hardware-neutral
-	USB functions, using calls to the controller driver.
-	Because such hardware varies widely in capabilities and restrictions,
-	and is used in embedded environments where space is at a premium,
-	the gadget driver is often configured at compile time
-	to work with endpoints supported by one particular controller.
-	Gadget drivers may be portable to several different controllers,
-	using conditional compilation.
-	(Recent kernels substantially simplify the work involved in
-	supporting new hardware, by <emphasis>autoconfiguring</emphasis>
-	endpoints automatically for many bulk-oriented drivers.)
-	Gadget driver responsibilities include:
-	</para>
-	<itemizedlist>
-	    <listitem><para>handling setup requests (ep0 protocol responses)
-		possibly including class-specific functionality
-		</para></listitem>
-	    <listitem><para>returning configuration and string descriptors
-		</para></listitem>
-	    <listitem><para>(re)setting configurations and interface
-		altsettings, including enabling and configuring endpoints
-		</para></listitem>
-	    <listitem><para>handling life cycle events, such as managing
-		bindings to hardware,
-		USB suspend/resume, remote wakeup,
-		and disconnection from the USB host.
-		</para></listitem>
-	    <listitem><para>managing IN and OUT transfers on all currently
-		enabled endpoints
-		</para></listitem>
-	</itemizedlist>
-
-	<para>
-	Such drivers may be modules of proprietary code, although
-	that approach is discouraged in the Linux community.
-	</para>
-	</listitem></varlistentry>
-
-    <varlistentry>
-	<term><emphasis>Upper Level</emphasis></term>
-
-	<listitem>
-	<para>Most gadget drivers have an upper boundary that connects
-	to some Linux driver or framework in Linux.
-	Through that boundary flows the data which the gadget driver
-	produces and/or consumes through protocol transfers over USB.
-	Examples include:
-	</para>
-	<itemizedlist>
-	    <listitem><para>user mode code, using generic (gadgetfs)
-	        or application specific files in
-		<filename>/dev</filename>
-		</para></listitem>
-	    <listitem><para>networking subsystem (for network gadgets,
-		like the CDC Ethernet Model gadget driver)
-		</para></listitem>
-	    <listitem><para>data capture drivers, perhaps video4Linux or
-		 a scanner driver; or test and measurement hardware.
-		 </para></listitem>
-	    <listitem><para>input subsystem (for HID gadgets)
-		</para></listitem>
-	    <listitem><para>sound subsystem (for audio gadgets)
-		</para></listitem>
-	    <listitem><para>file system (for PTP gadgets)
-		</para></listitem>
-	    <listitem><para>block i/o subsystem (for usb-storage gadgets)
-		</para></listitem>
-	    <listitem><para>... and more </para></listitem>
-	</itemizedlist>
-	</listitem></varlistentry>
-
-    <varlistentry>
-	<term><emphasis>Additional Layers</emphasis></term>
-
-	<listitem>
-	<para>Other layers may exist.
-	These could include kernel layers, such as network protocol stacks,
-	as well as user mode applications building on standard POSIX
-	system call APIs such as
-	<emphasis>open()</emphasis>, <emphasis>close()</emphasis>,
-	<emphasis>read()</emphasis> and <emphasis>write()</emphasis>.
-	On newer systems, POSIX Async I/O calls may be an option.
-	Such user mode code will not necessarily be subject to
-	the GNU General Public License (GPL).
-	</para>
-	</listitem></varlistentry>
-
-
-</variablelist>
-
-<para>OTG-capable systems will also need to include a standard Linux-USB
-host side stack,
-with <emphasis>usbcore</emphasis>,
-one or more <emphasis>Host Controller Drivers</emphasis> (HCDs),
-<emphasis>USB Device Drivers</emphasis> to support
-the OTG "Targeted Peripheral List",
-and so forth.
-There will also be an <emphasis>OTG Controller Driver</emphasis>,
-which is visible to gadget and device driver developers only indirectly.
-That helps the host and device side USB controllers implement the
-two new OTG protocols (HNP and SRP).
-Roles switch (host to peripheral, or vice versa) using HNP
-during USB suspend processing, and SRP can be viewed as a
-more battery-friendly kind of device wakeup protocol.
-</para>
-
-<para>Over time, reusable utilities are evolving to help make some
-gadget driver tasks simpler.
-For example, building configuration descriptors from vectors of
-descriptors for the configurations interfaces and endpoints is
-now automated, and many drivers now use autoconfiguration to
-choose hardware endpoints and initialize their descriptors.
-
-A potential example of particular interest
-is code implementing standard USB-IF protocols for
-HID, networking, storage, or audio classes.
-Some developers are interested in KDB or KGDB hooks, to let
-target hardware be remotely debugged.
-Most such USB protocol code doesn't need to be hardware-specific,
-any more than network protocols like X11, HTTP, or NFS are.
-Such gadget-side interface drivers should eventually be combined,
-to implement composite devices.
-</para>
-
-</chapter>
-
-
-<chapter id="api"><title>Kernel Mode Gadget API</title>
-
-<para>Gadget drivers declare themselves through a
-<emphasis>struct usb_gadget_driver</emphasis>, which is responsible for
-most parts of enumeration for a <emphasis>struct usb_gadget</emphasis>.
-The response to a set_configuration usually involves
-enabling one or more of the <emphasis>struct usb_ep</emphasis> objects
-exposed by the gadget, and submitting one or more
-<emphasis>struct usb_request</emphasis> buffers to transfer data.
-Understand those four data types, and their operations, and
-you will understand how this API works.
-</para> 
-
-<note><title>Incomplete Data Type Descriptions</title>
-
-<para>This documentation was prepared using the standard Linux
-kernel <filename>docproc</filename> tool, which turns text
-and in-code comments into SGML DocBook and then into usable
-formats such as HTML or PDF.
-Other than the "Chapter 9" data types, most of the significant
-data types and functions are described here.
-</para>
-
-<para>However, docproc does not understand all the C constructs
-that are used, so some relevant information is likely omitted from
-what you are reading.  
-One example of such information is endpoint autoconfiguration.
-You'll have to read the header file, and use example source
-code (such as that for "Gadget Zero"), to fully understand the API.
-</para>
-
-<para>The part of the API implementing some basic
-driver capabilities is specific to the version of the
-Linux kernel that's in use.
-The 2.6 kernel includes a <emphasis>driver model</emphasis>
-framework that has no analogue on earlier kernels;
-so those parts of the gadget API are not fully portable.
-(They are implemented on 2.4 kernels, but in a different way.)
-The driver model state is another part of this API that is
-ignored by the kerneldoc tools.
-</para>
-</note>
-
-<para>The core API does not expose
-every possible hardware feature, only the most widely available ones.
-There are significant hardware features, such as device-to-device DMA
-(without temporary storage in a memory buffer)
-that would be added using hardware-specific APIs.
-</para>
-
-<para>This API allows drivers to use conditional compilation to handle
-endpoint capabilities of different hardware, but doesn't require that.
-Hardware tends to have arbitrary restrictions, relating to
-transfer types, addressing, packet sizes, buffering, and availability.
-As a rule, such differences only matter for "endpoint zero" logic
-that handles device configuration and management.
-The API supports limited run-time
-detection of capabilities, through naming conventions for endpoints.
-Many drivers will be able to at least partially autoconfigure
-themselves.
-In particular, driver init sections will often have endpoint
-autoconfiguration logic that scans the hardware's list of endpoints
-to find ones matching the driver requirements
-(relying on those conventions), to eliminate some of the most
-common reasons for conditional compilation.
-</para>
-
-<para>Like the Linux-USB host side API, this API exposes
-the "chunky" nature of USB messages:  I/O requests are in terms
-of one or more "packets", and packet boundaries are visible to drivers.
-Compared to RS-232 serial protocols, USB resembles
-synchronous protocols like HDLC
-(N bytes per frame, multipoint addressing, host as the primary
-station and devices as secondary stations)
-more than asynchronous ones
-(tty style:  8 data bits per frame, no parity, one stop bit).
-So for example the controller drivers won't buffer
-two single byte writes into a single two-byte USB IN packet,
-although gadget drivers may do so when they implement
-protocols where packet boundaries (and "short packets")
-are not significant.
-</para>
-
-<sect1 id="lifecycle"><title>Driver Life Cycle</title>
-
-<para>Gadget drivers make endpoint I/O requests to hardware without
-needing to know many details of the hardware, but driver
-setup/configuration code needs to handle some differences.
-Use the API like this:
-</para>
-
-<orderedlist numeration='arabic'>
-
-<listitem><para>Register a driver for the particular device side
-usb controller hardware,
-such as the net2280 on PCI (USB 2.0),
-sa11x0 or pxa25x as found in Linux PDAs,
-and so on.
-At this point the device is logically in the USB ch9 initial state
-("attached"), drawing no power and not usable
-(since it does not yet support enumeration).
-Any host should not see the device, since it's not
-activated the data line pullup used by the host to
-detect a device, even if VBUS power is available.
-</para></listitem>
-
-<listitem><para>Register a gadget driver that implements some higher level
-device function.  That will then bind() to a usb_gadget, which
-activates the data line pullup sometime after detecting VBUS.
-</para></listitem>
-
-<listitem><para>The hardware driver can now start enumerating.
-The steps it handles are to accept USB power and set_address requests.
-Other steps are handled by the gadget driver.
-If the gadget driver module is unloaded before the host starts to
-enumerate, steps before step 7 are skipped.
-</para></listitem>
-
-<listitem><para>The gadget driver's setup() call returns usb descriptors,
-based both on what the bus interface hardware provides and on the
-functionality being implemented.
-That can involve alternate settings or configurations,
-unless the hardware prevents such operation.
-For OTG devices, each configuration descriptor includes
-an OTG descriptor.
-</para></listitem>
-
-<listitem><para>The gadget driver handles the last step of enumeration,
-when the USB host issues a set_configuration call.
-It enables all endpoints used in that configuration,
-with all interfaces in their default settings.
-That involves using a list of the hardware's endpoints, enabling each
-endpoint according to its descriptor.
-It may also involve using <function>usb_gadget_vbus_draw</function>
-to let more power be drawn from VBUS, as allowed by that configuration.
-For OTG devices, setting a configuration may also involve reporting
-HNP capabilities through a user interface.
-</para></listitem>
-
-<listitem><para>Do real work and perform data transfers, possibly involving
-changes to interface settings or switching to new configurations, until the
-device is disconnect()ed from the host.
-Queue any number of transfer requests to each endpoint.
-It may be suspended and resumed several times before being disconnected.
-On disconnect, the drivers go back to step 3 (above).
-</para></listitem>
-
-<listitem><para>When the gadget driver module is being unloaded,
-the driver unbind() callback is issued.  That lets the controller
-driver be unloaded.
-</para></listitem>
-
-</orderedlist>
-
-<para>Drivers will normally be arranged so that just loading the
-gadget driver module (or statically linking it into a Linux kernel)
-allows the peripheral device to be enumerated, but some drivers
-will defer enumeration until some higher level component (like
-a user mode daemon) enables it.
-Note that at this lowest level there are no policies about how
-ep0 configuration logic is implemented,
-except that it should obey USB specifications.
-Such issues are in the domain of gadget drivers,
-including knowing about implementation constraints
-imposed by some USB controllers
-or understanding that composite devices might happen to
-be built by integrating reusable components.
-</para>
-
-<para>Note that the lifecycle above can be slightly different
-for OTG devices.
-Other than providing an additional OTG descriptor in each
-configuration, only the HNP-related differences are particularly
-visible to driver code.
-They involve reporting requirements during the SET_CONFIGURATION
-request, and the option to invoke HNP during some suspend callbacks.
-Also, SRP changes the semantics of
-<function>usb_gadget_wakeup</function>
-slightly.
-</para>
-
-</sect1>
-
-<sect1 id="ch9"><title>USB 2.0 Chapter 9 Types and Constants</title>
-
-<para>Gadget drivers
-rely on common USB structures and constants
-defined in the
-<filename>&lt;linux/usb/ch9.h&gt;</filename>
-header file, which is standard in Linux 2.6 kernels.
-These are the same types and constants used by host
-side drivers (and usbcore).
-</para>
-
-!Iinclude/linux/usb/ch9.h
-</sect1>
-
-<sect1 id="core"><title>Core Objects and Methods</title>
-
-<para>These are declared in
-<filename>&lt;linux/usb/gadget.h&gt;</filename>,
-and are used by gadget drivers to interact with
-USB peripheral controller drivers.
-</para>
-
-	<!-- yeech, this is ugly in nsgmls PDF output.
-
-	     the PDF bookmark and refentry output nesting is wrong,
-	     and the member/argument documentation indents ugly.
-
-	     plus something (docproc?) adds whitespace before the
-	     descriptive paragraph text, so it can't line up right
-	     unless the explanations are trivial.
-	  -->
-
-!Iinclude/linux/usb/gadget.h
-</sect1>
-
-<sect1 id="utils"><title>Optional Utilities</title>
-
-<para>The core API is sufficient for writing a USB Gadget Driver,
-but some optional utilities are provided to simplify common tasks.
-These utilities include endpoint autoconfiguration.
-</para>
-
-!Edrivers/usb/gadget/usbstring.c
-!Edrivers/usb/gadget/config.c
-<!-- !Edrivers/usb/gadget/epautoconf.c -->
-</sect1>
-
-<sect1 id="composite"><title>Composite Device Framework</title>
-
-<para>The core API is sufficient for writing drivers for composite
-USB devices (with more than one function in a given configuration),
-and also multi-configuration devices (also more than one function,
-but not necessarily sharing a given configuration).
-There is however an optional framework which makes it easier to
-reuse and combine functions.
-</para>
-
-<para>Devices using this framework provide a <emphasis>struct
-usb_composite_driver</emphasis>, which in turn provides one or
-more <emphasis>struct usb_configuration</emphasis> instances.
-Each such configuration includes at least one
-<emphasis>struct usb_function</emphasis>, which packages a user
-visible role such as "network link" or "mass storage device".
-Management functions may also exist, such as "Device Firmware
-Upgrade".
-</para>
-
-!Iinclude/linux/usb/composite.h
-!Edrivers/usb/gadget/composite.c
-
-</sect1>
-
-<sect1 id="functions"><title>Composite Device Functions</title>
-
-<para>At this writing, a few of the current gadget drivers have
-been converted to this framework.
-Near-term plans include converting all of them, except for "gadgetfs".
-</para>
-
-!Edrivers/usb/gadget/function/f_acm.c
-!Edrivers/usb/gadget/function/f_ecm.c
-!Edrivers/usb/gadget/function/f_subset.c
-!Edrivers/usb/gadget/function/f_obex.c
-!Edrivers/usb/gadget/function/f_serial.c
-
-</sect1>
-
-
-</chapter>
-
-<chapter id="controllers"><title>Peripheral Controller Drivers</title>
-
-<para>The first hardware supporting this API was the NetChip 2280
-controller, which supports USB 2.0 high speed and is based on PCI.
-This is the <filename>net2280</filename> driver module.
-The driver supports Linux kernel versions 2.4 and 2.6;
-contact NetChip Technologies for development boards and product
-information.
-</para> 
-
-<para>Other hardware working in the "gadget" framework includes:
-Intel's PXA 25x and IXP42x series processors
-(<filename>pxa2xx_udc</filename>),
-Toshiba TC86c001 "Goku-S" (<filename>goku_udc</filename>),
-Renesas SH7705/7727 (<filename>sh_udc</filename>),
-MediaQ 11xx (<filename>mq11xx_udc</filename>),
-Hynix HMS30C7202 (<filename>h7202_udc</filename>),
-National 9303/4 (<filename>n9604_udc</filename>),
-Texas Instruments OMAP (<filename>omap_udc</filename>),
-Sharp LH7A40x (<filename>lh7a40x_udc</filename>),
-and more.
-Most of those are full speed controllers.
-</para>
-
-<para>At this writing, there are people at work on drivers in
-this framework for several other USB device controllers,
-with plans to make many of them be widely available.
-</para>
-
-<!-- !Edrivers/usb/gadget/net2280.c -->
-
-<para>A partial USB simulator,
-the <filename>dummy_hcd</filename> driver, is available.
-It can act like a net2280, a pxa25x, or an sa11x0 in terms
-of available endpoints and device speeds; and it simulates
-control, bulk, and to some extent interrupt transfers.
-That lets you develop some parts of a gadget driver on a normal PC,
-without any special hardware, and perhaps with the assistance
-of tools such as GDB running with User Mode Linux.
-At least one person has expressed interest in adapting that
-approach, hooking it up to a simulator for a microcontroller.
-Such simulators can help debug subsystems where the runtime hardware
-is unfriendly to software development, or is not yet available.
-</para>
-
-<para>Support for other controllers is expected to be developed
-and contributed
-over time, as this driver framework evolves.
-</para>
-
-</chapter>
-
-<chapter id="gadget"><title>Gadget Drivers</title>
-
-<para>In addition to <emphasis>Gadget Zero</emphasis>
-(used primarily for testing and development with drivers
-for usb controller hardware), other gadget drivers exist.
-</para>
-
-<para>There's an <emphasis>ethernet</emphasis> gadget
-driver, which implements one of the most useful
-<emphasis>Communications Device Class</emphasis> (CDC) models.  
-One of the standards for cable modem interoperability even
-specifies the use of this ethernet model as one of two
-mandatory options.
-Gadgets using this code look to a USB host as if they're
-an Ethernet adapter.
-It provides access to a network where the gadget's CPU is one host,
-which could easily be bridging, routing, or firewalling
-access to other networks.
-Since some hardware can't fully implement the CDC Ethernet
-requirements, this driver also implements a "good parts only"
-subset of CDC Ethernet.
-(That subset doesn't advertise itself as CDC Ethernet,
-to avoid creating problems.)
-</para>
-
-<para>Support for Microsoft's <emphasis>RNDIS</emphasis>
-protocol has been contributed by Pengutronix and Auerswald GmbH.
-This is like CDC Ethernet, but it runs on more slightly USB hardware
-(but less than the CDC subset).
-However, its main claim to fame is being able to connect directly to
-recent versions of Windows, using drivers that Microsoft bundles
-and supports, making it much simpler to network with Windows.
-</para>
-
-<para>There is also support for user mode gadget drivers,
-using <emphasis>gadgetfs</emphasis>.
-This provides a <emphasis>User Mode API</emphasis> that presents
-each endpoint as a single file descriptor.  I/O is done using
-normal <emphasis>read()</emphasis> and <emphasis>read()</emphasis> calls.
-Familiar tools like GDB and pthreads can be used to
-develop and debug user mode drivers, so that once a robust
-controller driver is available many applications for it
-won't require new kernel mode software.
-Linux 2.6 <emphasis>Async I/O (AIO)</emphasis>
-support is available, so that user mode software
-can stream data with only slightly more overhead
-than a kernel driver.
-</para>
-
-<para>There's a USB Mass Storage class driver, which provides
-a different solution for interoperability with systems such
-as MS-Windows and MacOS.
-That <emphasis>Mass Storage</emphasis> driver uses a
-file or block device as backing store for a drive,
-like the <filename>loop</filename> driver.
-The USB host uses the BBB, CB, or CBI versions of the mass
-storage class specification, using transparent SCSI commands
-to access the data from the backing store.
-</para>
-
-<para>There's a "serial line" driver, useful for TTY style
-operation over USB.
-The latest version of that driver supports CDC ACM style
-operation, like a USB modem, and so on most hardware it can
-interoperate easily with MS-Windows.
-One interesting use of that driver is in boot firmware (like a BIOS),
-which can sometimes use that model with very small systems without
-real serial lines.
-</para>
-
-<para>Support for other kinds of gadget is expected to
-be developed and contributed
-over time, as this driver framework evolves.
-</para>
-
-</chapter>
-
-<chapter id="otg"><title>USB On-The-GO (OTG)</title>
-
-<para>USB OTG support on Linux 2.6 was initially developed
-by Texas Instruments for
-<ulink url="http://www.omap.com">OMAP</ulink> 16xx and 17xx
-series processors.
-Other OTG systems should work in similar ways, but the
-hardware level details could be very different.
-</para> 
-
-<para>Systems need specialized hardware support to implement OTG,
-notably including a special <emphasis>Mini-AB</emphasis> jack
-and associated transceiver to support <emphasis>Dual-Role</emphasis>
-operation:
-they can act either as a host, using the standard
-Linux-USB host side driver stack,
-or as a peripheral, using this "gadget" framework.
-To do that, the system software relies on small additions
-to those programming interfaces,
-and on a new internal component (here called an "OTG Controller")
-affecting which driver stack connects to the OTG port.
-In each role, the system can re-use the existing pool of
-hardware-neutral drivers, layered on top of the controller
-driver interfaces (<emphasis>usb_bus</emphasis> or
-<emphasis>usb_gadget</emphasis>).
-Such drivers need at most minor changes, and most of the calls
-added to support OTG can also benefit non-OTG products.
-</para>
-
-<itemizedlist>
-    <listitem><para>Gadget drivers test the <emphasis>is_otg</emphasis>
-	flag, and use it to determine whether or not to include
-	an OTG descriptor in each of their configurations.
-	</para></listitem>
-    <listitem><para>Gadget drivers may need changes to support the
-	two new OTG protocols, exposed in new gadget attributes
-	such as <emphasis>b_hnp_enable</emphasis> flag.
-	HNP support should be reported through a user interface
-	(two LEDs could suffice), and is triggered in some cases
-	when the host suspends the peripheral.
-	SRP support can be user-initiated just like remote wakeup,
-	probably by pressing the same button.
-	</para></listitem>
-    <listitem><para>On the host side, USB device drivers need
-	to be taught to trigger HNP at appropriate moments, using
-	<function>usb_suspend_device()</function>.
-	That also conserves battery power, which is useful even
-	for non-OTG configurations.
-	</para></listitem>
-    <listitem><para>Also on the host side, a driver must support the
-	OTG "Targeted Peripheral List".  That's just a whitelist,
-	used to reject peripherals not supported with a given
-	Linux OTG host.
-	<emphasis>This whitelist is product-specific;
-	each product must modify <filename>otg_whitelist.h</filename>
-	to match its interoperability specification.
-	</emphasis>
-	</para>
-	<para>Non-OTG Linux hosts, like PCs and workstations,
-	normally have some solution for adding drivers, so that
-	peripherals that aren't recognized can eventually be supported.
-	That approach is unreasonable for consumer products that may
-	never have their firmware upgraded, and where it's usually
-	unrealistic to expect traditional PC/workstation/server kinds
-	of support model to work.
-	For example, it's often impractical to change device firmware
-	once the product has been distributed, so driver bugs can't
-	normally be fixed if they're found after shipment.
-	</para></listitem>
-</itemizedlist>
-
-<para>
-Additional changes are needed below those hardware-neutral
-<emphasis>usb_bus</emphasis> and <emphasis>usb_gadget</emphasis>
-driver interfaces; those aren't discussed here in any detail.
-Those affect the hardware-specific code for each USB Host or Peripheral
-controller, and how the HCD initializes (since OTG can be active only
-on a single port).
-They also involve what may be called an <emphasis>OTG Controller
-Driver</emphasis>, managing the OTG transceiver and the OTG state
-machine logic as well as much of the root hub behavior for the
-OTG port.
-The OTG controller driver needs to activate and deactivate USB
-controllers depending on the relevant device role.
-Some related changes were needed inside usbcore, so that it
-can identify OTG-capable devices and respond appropriately
-to HNP or SRP protocols.
-</para> 
-
-</chapter>
-
-</book>
-<!--
-	vim:syntax=sgml:sw=4
--->
diff --git a/Documentation/DocBook/writing_musb_glue_layer.tmpl b/Documentation/DocBook/writing_musb_glue_layer.tmpl
deleted file mode 100644
index 837eca77f274..000000000000
--- a/Documentation/DocBook/writing_musb_glue_layer.tmpl
+++ /dev/null
@@ -1,873 +0,0 @@
-<?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
-
-<book id="Writing-MUSB-Glue-Layer">
- <bookinfo>
-  <title>Writing an MUSB Glue Layer</title>
-
-  <authorgroup>
-   <author>
-    <firstname>Apelete</firstname>
-    <surname>Seketeli</surname>
-    <affiliation>
-     <address>
-      <email>apelete at seketeli.net</email>
-     </address>
-    </affiliation>
-   </author>
-  </authorgroup>
-
-  <copyright>
-   <year>2014</year>
-   <holder>Apelete Seketeli</holder>
-  </copyright>
-
-  <legalnotice>
-   <para>
-     This documentation is free software; you can redistribute it
-     and/or modify it under the terms of the GNU General Public
-     License as published by the Free Software Foundation; either
-     version 2 of the License, or (at your option) any later version.
-   </para>
-
-   <para>
-     This documentation is distributed in the hope that it will be
-     useful, but WITHOUT ANY WARRANTY; without even the implied
-     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-     See the GNU General Public License for more details.
-   </para>
-
-   <para>
-     You should have received a copy of the GNU General Public License
-     along with this documentation; if not, write to the Free Software
-     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
-     02111-1307 USA
-   </para>
-
-   <para>
-     For more details see the file COPYING in the Linux kernel source
-     tree.
-   </para>
-  </legalnotice>
- </bookinfo>
-
-<toc></toc>
-
-  <chapter id="introduction">
-    <title>Introduction</title>
-    <para>
-      The Linux MUSB subsystem is part of the larger Linux USB
-      subsystem. It provides support for embedded USB Device Controllers
-      (UDC) that do not use Universal Host Controller Interface (UHCI)
-      or Open Host Controller Interface (OHCI).
-    </para>
-    <para>
-      Instead, these embedded UDC rely on the USB On-the-Go (OTG)
-      specification which they implement at least partially. The silicon
-      reference design used in most cases is the Multipoint USB
-      Highspeed Dual-Role Controller (MUSB HDRC) found in the Mentor
-      Graphics Inventra™ design.
-    </para>
-    <para>
-      As a self-taught exercise I have written an MUSB glue layer for
-      the Ingenic JZ4740 SoC, modelled after the many MUSB glue layers
-      in the kernel source tree. This layer can be found at
-      drivers/usb/musb/jz4740.c. In this documentation I will walk
-      through the basics of the jz4740.c glue layer, explaining the
-      different pieces and what needs to be done in order to write your
-      own device glue layer.
-    </para>
-  </chapter>
-
-  <chapter id="linux-musb-basics">
-    <title>Linux MUSB Basics</title>
-    <para>
-      To get started on the topic, please read USB On-the-Go Basics (see
-      Resources) which provides an introduction of USB OTG operation at
-      the hardware level. A couple of wiki pages by Texas Instruments
-      and Analog Devices also provide an overview of the Linux kernel
-      MUSB configuration, albeit focused on some specific devices
-      provided by these companies. Finally, getting acquainted with the
-      USB specification at USB home page may come in handy, with
-      practical instance provided through the Writing USB Device Drivers
-      documentation (again, see Resources).
-    </para>
-    <para>
-      Linux USB stack is a layered architecture in which the MUSB
-      controller hardware sits at the lowest. The MUSB controller driver
-      abstract the MUSB controller hardware to the Linux USB stack.
-    </para>
-    <programlisting>
-      ------------------------
-      |                      | &lt;------- drivers/usb/gadget
-      | Linux USB Core Stack | &lt;------- drivers/usb/host
-      |                      | &lt;------- drivers/usb/core
-      ------------------------
-                 ⬍
-     --------------------------
-     |                        | &lt;------ drivers/usb/musb/musb_gadget.c
-     | MUSB Controller driver | &lt;------ drivers/usb/musb/musb_host.c
-     |                        | &lt;------ drivers/usb/musb/musb_core.c
-     --------------------------
-                 ⬍
-  ---------------------------------
-  | MUSB Platform Specific Driver |
-  |                               | &lt;-- drivers/usb/musb/jz4740.c
-  |       aka &quot;Glue Layer&quot;        |
-  ---------------------------------
-                 ⬍
-  ---------------------------------
-  |   MUSB Controller Hardware    |
-  ---------------------------------
-    </programlisting>
-    <para>
-      As outlined above, the glue layer is actually the platform
-      specific code sitting in between the controller driver and the
-      controller hardware.
-    </para>
-    <para>
-      Just like a Linux USB driver needs to register itself with the
-      Linux USB subsystem, the MUSB glue layer needs first to register
-      itself with the MUSB controller driver. This will allow the
-      controller driver to know about which device the glue layer
-      supports and which functions to call when a supported device is
-      detected or released; remember we are talking about an embedded
-      controller chip here, so no insertion or removal at run-time.
-    </para>
-    <para>
-      All of this information is passed to the MUSB controller driver
-      through a platform_driver structure defined in the glue layer as:
-    </para>
-    <programlisting linenumbering="numbered">
-static struct platform_driver jz4740_driver = {
-	.probe		= jz4740_probe,
-	.remove		= jz4740_remove,
-	.driver		= {
-		.name	= "musb-jz4740",
-	},
-};
-    </programlisting>
-    <para>
-      The probe and remove function pointers are called when a matching
-      device is detected and, respectively, released. The name string
-      describes the device supported by this glue layer. In the current
-      case it matches a platform_device structure declared in
-      arch/mips/jz4740/platform.c. Note that we are not using device
-      tree bindings here.
-    </para>
-    <para>
-      In order to register itself to the controller driver, the glue
-      layer goes through a few steps, basically allocating the
-      controller hardware resources and initialising a couple of
-      circuits. To do so, it needs to keep track of the information used
-      throughout these steps. This is done by defining a private
-      jz4740_glue structure:
-    </para>
-    <programlisting linenumbering="numbered">
-struct jz4740_glue {
-	struct device           *dev;
-	struct platform_device  *musb;
-	struct clk		*clk;
-};
-    </programlisting>
-    <para>
-      The dev and musb members are both device structure variables. The
-      first one holds generic information about the device, since it's
-      the basic device structure, and the latter holds information more
-      closely related to the subsystem the device is registered to. The
-      clk variable keeps information related to the device clock
-      operation.
-    </para>
-    <para>
-      Let's go through the steps of the probe function that leads the
-      glue layer to register itself to the controller driver.
-    </para>
-    <para>
-      N.B.: For the sake of readability each function will be split in
-      logical parts, each part being shown as if it was independent from
-      the others.
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_probe(struct platform_device *pdev)
-{
-	struct platform_device		*musb;
-	struct jz4740_glue		*glue;
-	struct clk                      *clk;
-	int				ret;
-
-	glue = devm_kzalloc(&amp;pdev->dev, sizeof(*glue), GFP_KERNEL);
-	if (!glue)
-		return -ENOMEM;
-
-	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
-	if (!musb) {
-		dev_err(&amp;pdev->dev, "failed to allocate musb device\n");
-		return -ENOMEM;
-	}
-
-	clk = devm_clk_get(&amp;pdev->dev, "udc");
-	if (IS_ERR(clk)) {
-		dev_err(&amp;pdev->dev, "failed to get clock\n");
-		ret = PTR_ERR(clk);
-		goto err_platform_device_put;
-	}
-
-	ret = clk_prepare_enable(clk);
-	if (ret) {
-		dev_err(&amp;pdev->dev, "failed to enable clock\n");
-		goto err_platform_device_put;
-	}
-
-	musb->dev.parent		= &amp;pdev->dev;
-
-	glue->dev			= &amp;pdev->dev;
-	glue->musb			= musb;
-	glue->clk			= clk;
-
-	return 0;
-
-err_platform_device_put:
-	platform_device_put(musb);
-	return ret;
-}
-    </programlisting>
-    <para>
-      The first few lines of the probe function allocate and assign the
-      glue, musb and clk variables. The GFP_KERNEL flag (line 8) allows
-      the allocation process to sleep and wait for memory, thus being
-      usable in a blocking situation. The PLATFORM_DEVID_AUTO flag (line
-      12) allows automatic allocation and management of device IDs in
-      order to avoid device namespace collisions with explicit IDs. With
-      devm_clk_get() (line 18) the glue layer allocates the clock -- the
-      <literal>devm_</literal> prefix indicates that clk_get() is
-      managed: it automatically frees the allocated clock resource data
-      when the device is released -- and enable it.
-    </para>
-    <para>
-      Then comes the registration steps:
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_probe(struct platform_device *pdev)
-{
-	struct musb_hdrc_platform_data	*pdata = &amp;jz4740_musb_platform_data;
-
-	pdata->platform_ops		= &amp;jz4740_musb_ops;
-
-	platform_set_drvdata(pdev, glue);
-
-	ret = platform_device_add_resources(musb, pdev->resource,
-					    pdev->num_resources);
-	if (ret) {
-		dev_err(&amp;pdev->dev, "failed to add resources\n");
-		goto err_clk_disable;
-	}
-
-	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
-	if (ret) {
-		dev_err(&amp;pdev->dev, "failed to add platform_data\n");
-		goto err_clk_disable;
-	}
-
-	return 0;
-
-err_clk_disable:
-	clk_disable_unprepare(clk);
-err_platform_device_put:
-	platform_device_put(musb);
-	return ret;
-}
-    </programlisting>
-    <para>
-      The first step is to pass the device data privately held by the
-      glue layer on to the controller driver through
-      platform_set_drvdata() (line 7). Next is passing on the device
-      resources information, also privately held at that point, through
-      platform_device_add_resources() (line 9).
-    </para>
-    <para>
-      Finally comes passing on the platform specific data to the
-      controller driver (line 16). Platform data will be discussed in
-      <link linkend="device-platform-data">Chapter 4</link>, but here
-      we are looking at the platform_ops function pointer (line 5) in
-      musb_hdrc_platform_data structure (line 3).  This function
-      pointer allows the MUSB controller driver to know which function
-      to call for device operation:
-    </para>
-    <programlisting linenumbering="numbered">
-static const struct musb_platform_ops jz4740_musb_ops = {
-	.init		= jz4740_musb_init,
-	.exit		= jz4740_musb_exit,
-};
-    </programlisting>
-    <para>
-      Here we have the minimal case where only init and exit functions
-      are called by the controller driver when needed. Fact is the
-      JZ4740 MUSB controller is a basic controller, lacking some
-      features found in other controllers, otherwise we may also have
-      pointers to a few other functions like a power management function
-      or a function to switch between OTG and non-OTG modes, for
-      instance.
-    </para>
-    <para>
-      At that point of the registration process, the controller driver
-      actually calls the init function:
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_musb_init(struct musb *musb)
-{
-	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
-	if (!musb->xceiv) {
-		pr_err("HS UDC: no transceiver configured\n");
-		return -ENODEV;
-	}
-
-	/* Silicon does not implement ConfigData register.
-	 * Set dyn_fifo to avoid reading EP config from hardware.
-	 */
-	musb->dyn_fifo = true;
-
-	musb->isr = jz4740_musb_interrupt;
-
-	return 0;
-}
-    </programlisting>
-    <para>
-      The goal of jz4740_musb_init() is to get hold of the transceiver
-      driver data of the MUSB controller hardware and pass it on to the
-      MUSB controller driver, as usual. The transceiver is the circuitry
-      inside the controller hardware responsible for sending/receiving
-      the USB data. Since it is an implementation of the physical layer
-      of the OSI model, the transceiver is also referred to as PHY.
-    </para>
-    <para>
-      Getting hold of the MUSB PHY driver data is done with
-      usb_get_phy() which returns a pointer to the structure
-      containing the driver instance data. The next couple of
-      instructions (line 12 and 14) are used as a quirk and to setup
-      IRQ handling respectively. Quirks and IRQ handling will be
-      discussed later in <link linkend="device-quirks">Chapter
-      5</link> and <link linkend="handling-irqs">Chapter 3</link>.
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_musb_exit(struct musb *musb)
-{
-	usb_put_phy(musb->xceiv);
-
-	return 0;
-}
-    </programlisting>
-    <para>
-      Acting as the counterpart of init, the exit function releases the
-      MUSB PHY driver when the controller hardware itself is about to be
-      released.
-    </para>
-    <para>
-      Again, note that init and exit are fairly simple in this case due
-      to the basic set of features of the JZ4740 controller hardware.
-      When writing an musb glue layer for a more complex controller
-      hardware, you might need to take care of more processing in those
-      two functions.
-    </para>
-    <para>
-      Returning from the init function, the MUSB controller driver jumps
-      back into the probe function:
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_probe(struct platform_device *pdev)
-{
-	ret = platform_device_add(musb);
-	if (ret) {
-		dev_err(&amp;pdev->dev, "failed to register musb device\n");
-		goto err_clk_disable;
-	}
-
-	return 0;
-
-err_clk_disable:
-	clk_disable_unprepare(clk);
-err_platform_device_put:
-	platform_device_put(musb);
-	return ret;
-}
-    </programlisting>
-    <para>
-      This is the last part of the device registration process where the
-      glue layer adds the controller hardware device to Linux kernel
-      device hierarchy: at this stage, all known information about the
-      device is passed on to the Linux USB core stack.
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_remove(struct platform_device *pdev)
-{
-	struct jz4740_glue	*glue = platform_get_drvdata(pdev);
-
-	platform_device_unregister(glue->musb);
-	clk_disable_unprepare(glue->clk);
-
-	return 0;
-}
-    </programlisting>
-    <para>
-      Acting as the counterpart of probe, the remove function unregister
-      the MUSB controller hardware (line 5) and disable the clock (line
-      6), allowing it to be gated.
-    </para>
-  </chapter>
-
-  <chapter id="handling-irqs">
-    <title>Handling IRQs</title>
-    <para>
-      Additionally to the MUSB controller hardware basic setup and
-      registration, the glue layer is also responsible for handling the
-      IRQs:
-    </para>
-    <programlisting linenumbering="numbered">
-static irqreturn_t jz4740_musb_interrupt(int irq, void *__hci)
-{
-	unsigned long   flags;
-	irqreturn_t     retval = IRQ_NONE;
-	struct musb     *musb = __hci;
-
-	spin_lock_irqsave(&amp;musb->lock, flags);
-
-	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
-	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
-	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
-
-	/*
-	 * The controller is gadget only, the state of the host mode IRQ bits is
-	 * undefined. Mask them to make sure that the musb driver core will
-	 * never see them set
-	 */
-	musb->int_usb &amp;= MUSB_INTR_SUSPEND | MUSB_INTR_RESUME |
-	    MUSB_INTR_RESET | MUSB_INTR_SOF;
-
-	if (musb->int_usb || musb->int_tx || musb->int_rx)
-		retval = musb_interrupt(musb);
-
-	spin_unlock_irqrestore(&amp;musb->lock, flags);
-
-	return retval;
-}
-    </programlisting>
-    <para>
-      Here the glue layer mostly has to read the relevant hardware
-      registers and pass their values on to the controller driver which
-      will handle the actual event that triggered the IRQ.
-    </para>
-    <para>
-      The interrupt handler critical section is protected by the
-      spin_lock_irqsave() and counterpart spin_unlock_irqrestore()
-      functions (line 7 and 24 respectively), which prevent the
-      interrupt handler code to be run by two different threads at the
-      same time.
-    </para>
-    <para>
-      Then the relevant interrupt registers are read (line 9 to 11):
-    </para>
-    <itemizedlist>
-      <listitem>
-        <para>
-          MUSB_INTRUSB: indicates which USB interrupts are currently
-          active,
-        </para>
-      </listitem>
-      <listitem>
-        <para>
-          MUSB_INTRTX: indicates which of the interrupts for TX
-          endpoints are currently active,
-        </para>
-      </listitem>
-      <listitem>
-        <para>
-          MUSB_INTRRX: indicates which of the interrupts for TX
-          endpoints are currently active.
-        </para>
-      </listitem>
-    </itemizedlist>
-    <para>
-      Note that musb_readb() is used to read 8-bit registers at most,
-      while musb_readw() allows us to read at most 16-bit registers.
-      There are other functions that can be used depending on the size
-      of your device registers. See musb_io.h for more information.
-    </para>
-    <para>
-      Instruction on line 18 is another quirk specific to the JZ4740
-      USB device controller, which will be discussed later in <link
-      linkend="device-quirks">Chapter 5</link>.
-    </para>
-    <para>
-      The glue layer still needs to register the IRQ handler though.
-      Remember the instruction on line 14 of the init function:
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_musb_init(struct musb *musb)
-{
-	musb->isr = jz4740_musb_interrupt;
-
-	return 0;
-}
-    </programlisting>
-    <para>
-      This instruction sets a pointer to the glue layer IRQ handler
-      function, in order for the controller hardware to call the handler
-      back when an IRQ comes from the controller hardware. The interrupt
-      handler is now implemented and registered.
-    </para>
-  </chapter>
-
-  <chapter id="device-platform-data">
-    <title>Device Platform Data</title>
-    <para>
-      In order to write an MUSB glue layer, you need to have some data
-      describing the hardware capabilities of your controller hardware,
-      which is called the platform data.
-    </para>
-    <para>
-      Platform data is specific to your hardware, though it may cover a
-      broad range of devices, and is generally found somewhere in the
-      arch/ directory, depending on your device architecture.
-    </para>
-    <para>
-      For instance, platform data for the JZ4740 SoC is found in
-      arch/mips/jz4740/platform.c. In the platform.c file each device of
-      the JZ4740 SoC is described through a set of structures.
-    </para>
-    <para>
-      Here is the part of arch/mips/jz4740/platform.c that covers the
-      USB Device Controller (UDC):
-    </para>
-    <programlisting linenumbering="numbered">
-/* USB Device Controller */
-struct platform_device jz4740_udc_xceiv_device = {
-	.name = "usb_phy_gen_xceiv",
-	.id   = 0,
-};
-
-static struct resource jz4740_udc_resources[] = {
-	[0] = {
-		.start = JZ4740_UDC_BASE_ADDR,
-		.end   = JZ4740_UDC_BASE_ADDR + 0x10000 - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = JZ4740_IRQ_UDC,
-		.end   = JZ4740_IRQ_UDC,
-		.flags = IORESOURCE_IRQ,
-		.name  = "mc",
-	},
-};
-
-struct platform_device jz4740_udc_device = {
-	.name = "musb-jz4740",
-	.id   = -1,
-	.dev  = {
-		.dma_mask          = &amp;jz4740_udc_device.dev.coherent_dma_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(32),
-	},
-	.num_resources = ARRAY_SIZE(jz4740_udc_resources),
-	.resource      = jz4740_udc_resources,
-};
-    </programlisting>
-    <para>
-      The jz4740_udc_xceiv_device platform device structure (line 2)
-      describes the UDC transceiver with a name and id number.
-    </para>
-    <para>
-      At the time of this writing, note that
-      &quot;usb_phy_gen_xceiv&quot; is the specific name to be used for
-      all transceivers that are either built-in with reference USB IP or
-      autonomous and doesn't require any PHY programming. You will need
-      to set CONFIG_NOP_USB_XCEIV=y in the kernel configuration to make
-      use of the corresponding transceiver driver. The id field could be
-      set to -1 (equivalent to PLATFORM_DEVID_NONE), -2 (equivalent to
-      PLATFORM_DEVID_AUTO) or start with 0 for the first device of this
-      kind if we want a specific id number.
-    </para>
-    <para>
-      The jz4740_udc_resources resource structure (line 7) defines the
-      UDC registers base addresses.
-    </para>
-    <para>
-      The first array (line 9 to 11) defines the UDC registers base
-      memory addresses: start points to the first register memory
-      address, end points to the last register memory address and the
-      flags member defines the type of resource we are dealing with. So
-      IORESOURCE_MEM is used to define the registers memory addresses.
-      The second array (line 14 to 17) defines the UDC IRQ registers
-      addresses. Since there is only one IRQ register available for the
-      JZ4740 UDC, start and end point at the same address. The
-      IORESOURCE_IRQ flag tells that we are dealing with IRQ resources,
-      and the name &quot;mc&quot; is in fact hard-coded in the MUSB core
-      in order for the controller driver to retrieve this IRQ resource
-      by querying it by its name.
-    </para>
-    <para>
-      Finally, the jz4740_udc_device platform device structure (line 21)
-      describes the UDC itself.
-    </para>
-    <para>
-      The &quot;musb-jz4740&quot; name (line 22) defines the MUSB
-      driver that is used for this device; remember this is in fact
-      the name that we used in the jz4740_driver platform driver
-      structure in <link linkend="linux-musb-basics">Chapter
-      2</link>. The id field (line 23) is set to -1 (equivalent to
-      PLATFORM_DEVID_NONE) since we do not need an id for the device:
-      the MUSB controller driver was already set to allocate an
-      automatic id in <link linkend="linux-musb-basics">Chapter
-      2</link>. In the dev field we care for DMA related information
-      here. The dma_mask field (line 25) defines the width of the DMA
-      mask that is going to be used, and coherent_dma_mask (line 26)
-      has the same purpose but for the alloc_coherent DMA mappings: in
-      both cases we are using a 32 bits mask. Then the resource field
-      (line 29) is simply a pointer to the resource structure defined
-      before, while the num_resources field (line 28) keeps track of
-      the number of arrays defined in the resource structure (in this
-      case there were two resource arrays defined before).
-    </para>
-    <para>
-      With this quick overview of the UDC platform data at the arch/
-      level now done, let's get back to the MUSB glue layer specific
-      platform data in drivers/usb/musb/jz4740.c:
-    </para>
-    <programlisting linenumbering="numbered">
-static struct musb_hdrc_config jz4740_musb_config = {
-	/* Silicon does not implement USB OTG. */
-	.multipoint = 0,
-	/* Max EPs scanned, driver will decide which EP can be used. */
-	.num_eps    = 4,
-	/* RAMbits needed to configure EPs from table */
-	.ram_bits   = 9,
-	.fifo_cfg = jz4740_musb_fifo_cfg,
-	.fifo_cfg_size = ARRAY_SIZE(jz4740_musb_fifo_cfg),
-};
-
-static struct musb_hdrc_platform_data jz4740_musb_platform_data = {
-	.mode   = MUSB_PERIPHERAL,
-	.config = &amp;jz4740_musb_config,
-};
-    </programlisting>
-    <para>
-      First the glue layer configures some aspects of the controller
-      driver operation related to the controller hardware specifics.
-      This is done through the jz4740_musb_config musb_hdrc_config
-      structure.
-    </para>
-    <para>
-      Defining the OTG capability of the controller hardware, the
-      multipoint member (line 3) is set to 0 (equivalent to false)
-      since the JZ4740 UDC is not OTG compatible. Then num_eps (line
-      5) defines the number of USB endpoints of the controller
-      hardware, including endpoint 0: here we have 3 endpoints +
-      endpoint 0. Next is ram_bits (line 7) which is the width of the
-      RAM address bus for the MUSB controller hardware. This
-      information is needed when the controller driver cannot
-      automatically configure endpoints by reading the relevant
-      controller hardware registers. This issue will be discussed when
-      we get to device quirks in <link linkend="device-quirks">Chapter
-      5</link>. Last two fields (line 8 and 9) are also about device
-      quirks: fifo_cfg points to the USB endpoints configuration table
-      and fifo_cfg_size keeps track of the size of the number of
-      entries in that configuration table. More on that later in <link
-      linkend="device-quirks">Chapter 5</link>.
-    </para>
-    <para>
-      Then this configuration is embedded inside
-      jz4740_musb_platform_data musb_hdrc_platform_data structure (line
-      11): config is a pointer to the configuration structure itself,
-      and mode tells the controller driver if the controller hardware
-      may be used as MUSB_HOST only, MUSB_PERIPHERAL only or MUSB_OTG
-      which is a dual mode.
-    </para>
-    <para>
-      Remember that jz4740_musb_platform_data is then used to convey
-      platform data information as we have seen in the probe function
-      in <link linkend="linux-musb-basics">Chapter 2</link>
-    </para>
-  </chapter>
-
-  <chapter id="device-quirks">
-    <title>Device Quirks</title>
-    <para>
-      Completing the platform data specific to your device, you may also
-      need to write some code in the glue layer to work around some
-      device specific limitations. These quirks may be due to some
-      hardware bugs, or simply be the result of an incomplete
-      implementation of the USB On-the-Go specification.
-    </para>
-    <para>
-      The JZ4740 UDC exhibits such quirks, some of which we will discuss
-      here for the sake of insight even though these might not be found
-      in the controller hardware you are working on.
-    </para>
-    <para>
-      Let's get back to the init function first:
-    </para>
-    <programlisting linenumbering="numbered">
-static int jz4740_musb_init(struct musb *musb)
-{
-	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
-	if (!musb->xceiv) {
-		pr_err("HS UDC: no transceiver configured\n");
-		return -ENODEV;
-	}
-
-	/* Silicon does not implement ConfigData register.
-	 * Set dyn_fifo to avoid reading EP config from hardware.
-	 */
-	musb->dyn_fifo = true;
-
-	musb->isr = jz4740_musb_interrupt;
-
-	return 0;
-}
-    </programlisting>
-    <para>
-      Instruction on line 12 helps the MUSB controller driver to work
-      around the fact that the controller hardware is missing registers
-      that are used for USB endpoints configuration.
-    </para>
-    <para>
-      Without these registers, the controller driver is unable to read
-      the endpoints configuration from the hardware, so we use line 12
-      instruction to bypass reading the configuration from silicon, and
-      rely on a hard-coded table that describes the endpoints
-      configuration instead:
-    </para>
-    <programlisting linenumbering="numbered">
-static struct musb_fifo_cfg jz4740_musb_fifo_cfg[] = {
-{ .hw_ep_num = 1, .style = FIFO_TX, .maxpacket = 512, },
-{ .hw_ep_num = 1, .style = FIFO_RX, .maxpacket = 512, },
-{ .hw_ep_num = 2, .style = FIFO_TX, .maxpacket = 64, },
-};
-    </programlisting>
-    <para>
-      Looking at the configuration table above, we see that each
-      endpoints is described by three fields: hw_ep_num is the endpoint
-      number, style is its direction (either FIFO_TX for the controller
-      driver to send packets in the controller hardware, or FIFO_RX to
-      receive packets from hardware), and maxpacket defines the maximum
-      size of each data packet that can be transmitted over that
-      endpoint. Reading from the table, the controller driver knows that
-      endpoint 1 can be used to send and receive USB data packets of 512
-      bytes at once (this is in fact a bulk in/out endpoint), and
-      endpoint 2 can be used to send data packets of 64 bytes at once
-      (this is in fact an interrupt endpoint).
-    </para>
-    <para>
-      Note that there is no information about endpoint 0 here: that one
-      is implemented by default in every silicon design, with a
-      predefined configuration according to the USB specification. For
-      more examples of endpoint configuration tables, see musb_core.c.
-    </para>
-    <para>
-      Let's now get back to the interrupt handler function:
-    </para>
-    <programlisting linenumbering="numbered">
-static irqreturn_t jz4740_musb_interrupt(int irq, void *__hci)
-{
-	unsigned long   flags;
-	irqreturn_t     retval = IRQ_NONE;
-	struct musb     *musb = __hci;
-
-	spin_lock_irqsave(&amp;musb->lock, flags);
-
-	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
-	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
-	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
-
-	/*
-	 * The controller is gadget only, the state of the host mode IRQ bits is
-	 * undefined. Mask them to make sure that the musb driver core will
-	 * never see them set
-	 */
-	musb->int_usb &amp;= MUSB_INTR_SUSPEND | MUSB_INTR_RESUME |
-	    MUSB_INTR_RESET | MUSB_INTR_SOF;
-
-	if (musb->int_usb || musb->int_tx || musb->int_rx)
-		retval = musb_interrupt(musb);
-
-	spin_unlock_irqrestore(&amp;musb->lock, flags);
-
-	return retval;
-}
-    </programlisting>
-    <para>
-      Instruction on line 18 above is a way for the controller driver to
-      work around the fact that some interrupt bits used for USB host
-      mode operation are missing in the MUSB_INTRUSB register, thus left
-      in an undefined hardware state, since this MUSB controller
-      hardware is used in peripheral mode only. As a consequence, the
-      glue layer masks these missing bits out to avoid parasite
-      interrupts by doing a logical AND operation between the value read
-      from MUSB_INTRUSB and the bits that are actually implemented in
-      the register.
-    </para>
-    <para>
-      These are only a couple of the quirks found in the JZ4740 USB
-      device controller. Some others were directly addressed in the MUSB
-      core since the fixes were generic enough to provide a better
-      handling of the issues for others controller hardware eventually.
-    </para>
-  </chapter>
-
-  <chapter id="conclusion">
-    <title>Conclusion</title>
-    <para>
-      Writing a Linux MUSB glue layer should be a more accessible task,
-      as this documentation tries to show the ins and outs of this
-      exercise.
-    </para>
-    <para>
-      The JZ4740 USB device controller being fairly simple, I hope its
-      glue layer serves as a good example for the curious mind. Used
-      with the current MUSB glue layers, this documentation should
-      provide enough guidance to get started; should anything gets out
-      of hand, the linux-usb mailing list archive is another helpful
-      resource to browse through.
-    </para>
-  </chapter>
-
-  <chapter id="acknowledgements">
-    <title>Acknowledgements</title>
-    <para>
-      Many thanks to Lars-Peter Clausen and Maarten ter Huurne for
-      answering my questions while I was writing the JZ4740 glue layer
-      and for helping me out getting the code in good shape.
-    </para>
-    <para>
-      I would also like to thank the Qi-Hardware community at large for
-      its cheerful guidance and support.
-    </para>
-  </chapter>
-
-  <chapter id="resources">
-    <title>Resources</title>
-    <para>
-      USB Home Page:
-      <ulink url="http://www.usb.org">http://www.usb.org</ulink>
-    </para>
-    <para>
-      linux-usb Mailing List Archives:
-      <ulink url="http://marc.info/?l=linux-usb">http://marc.info/?l=linux-usb</ulink>
-    </para>
-    <para>
-      USB On-the-Go Basics:
-      <ulink url="http://www.maximintegrated.com/app-notes/index.mvp/id/1822">http://www.maximintegrated.com/app-notes/index.mvp/id/1822</ulink>
-    </para>
-    <para>
-      Writing USB Device Drivers:
-      <ulink url="https://www.kernel.org/doc/htmldocs/writing_usb_driver/index.html">https://www.kernel.org/doc/htmldocs/writing_usb_driver/index.html</ulink>
-    </para>
-    <para>
-      Texas Instruments USB Configuration Wiki Page:
-      <ulink url="http://processors.wiki.ti.com/index.php/Usbgeneralpage">http://processors.wiki.ti.com/index.php/Usbgeneralpage</ulink>
-    </para>
-    <para>
-      Analog Devices Blackfin MUSB Configuration:
-      <ulink url="http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:musb">http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:musb</ulink>
-    </para>
-  </chapter>
-
-</book>
diff --git a/Documentation/DocBook/writing_usb_driver.tmpl b/Documentation/DocBook/writing_usb_driver.tmpl
deleted file mode 100644
index 3210dcf741c9..000000000000
--- a/Documentation/DocBook/writing_usb_driver.tmpl
+++ /dev/null
@@ -1,412 +0,0 @@
-<?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
-
-<book id="USBDeviceDriver">
- <bookinfo>
-  <title>Writing USB Device Drivers</title>
-  
-  <authorgroup>
-   <author>
-    <firstname>Greg</firstname>
-    <surname>Kroah-Hartman</surname>
-    <affiliation>
-     <address>
-      <email>greg@kroah.com</email>
-     </address>
-    </affiliation>
-   </author>
-  </authorgroup>
-
-  <copyright>
-   <year>2001-2002</year>
-   <holder>Greg Kroah-Hartman</holder>
-  </copyright>
-
-  <legalnotice>
-   <para>
-     This documentation is free software; you can redistribute
-     it and/or modify it under the terms of the GNU General Public
-     License as published by the Free Software Foundation; either
-     version 2 of the License, or (at your option) any later
-     version.
-   </para>
-      
-   <para>
-     This program is distributed in the hope that it will be
-     useful, but WITHOUT ANY WARRANTY; without even the implied
-     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-     See the GNU General Public License for more details.
-   </para>
-      
-   <para>
-     You should have received a copy of the GNU General Public
-     License along with this program; if not, write to the Free
-     Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
-     MA 02111-1307 USA
-   </para>
-      
-   <para>
-     For more details see the file COPYING in the source
-     distribution of Linux.
-   </para>
-
-   <para>
-     This documentation is based on an article published in 
-     Linux Journal Magazine, October 2001, Issue 90.
-   </para>
-  </legalnotice>
- </bookinfo>
-
-<toc></toc>
-
-  <chapter id="intro">
-      <title>Introduction</title>
-  <para>
-      The Linux USB subsystem has grown from supporting only two different
-      types of devices in the 2.2.7 kernel (mice and keyboards), to over 20
-      different types of devices in the 2.4 kernel. Linux currently supports
-      almost all USB class devices (standard types of devices like keyboards,
-      mice, modems, printers and speakers) and an ever-growing number of
-      vendor-specific devices (such as USB to serial converters, digital
-      cameras, Ethernet devices and MP3 players). For a full list of the
-      different USB devices currently supported, see Resources.
-  </para>
-  <para>
-      The remaining kinds of USB devices that do not have support on Linux are
-      almost all vendor-specific devices. Each vendor decides to implement a
-      custom protocol to talk to their device, so a custom driver usually needs
-      to be created. Some vendors are open with their USB protocols and help
-      with the creation of Linux drivers, while others do not publish them, and
-      developers are forced to reverse-engineer. See Resources for some links
-      to handy reverse-engineering tools.
-  </para>
-  <para>
-      Because each different protocol causes a new driver to be created, I have
-      written a generic USB driver skeleton, modelled after the pci-skeleton.c
-      file in the kernel source tree upon which many PCI network drivers have
-      been based. This USB skeleton can be found at drivers/usb/usb-skeleton.c
-      in the kernel source tree. In this article I will walk through the basics
-      of the skeleton driver, explaining the different pieces and what needs to
-      be done to customize it to your specific device.
-  </para>
-  </chapter>
-
-  <chapter id="basics">
-      <title>Linux USB Basics</title>
-  <para>
-      If you are going to write a Linux USB driver, please become familiar with
-      the USB protocol specification. It can be found, along with many other
-      useful documents, at the USB home page (see Resources). An excellent
-      introduction to the Linux USB subsystem can be found at the USB Working
-      Devices List (see Resources). It explains how the Linux USB subsystem is
-      structured and introduces the reader to the concept of USB urbs
-      (USB Request Blocks), which are essential to USB drivers.
-  </para>
-  <para>
-      The first thing a Linux USB driver needs to do is register itself with
-      the Linux USB subsystem, giving it some information about which devices
-      the driver supports and which functions to call when a device supported
-      by the driver is inserted or removed from the system. All of this
-      information is passed to the USB subsystem in the usb_driver structure.
-      The skeleton driver declares a usb_driver as:
-  </para>
-  <programlisting>
-static struct usb_driver skel_driver = {
-        .name        = "skeleton",
-        .probe       = skel_probe,
-        .disconnect  = skel_disconnect,
-        .fops        = &amp;skel_fops,
-        .minor       = USB_SKEL_MINOR_BASE,
-        .id_table    = skel_table,
-};
-  </programlisting>
-  <para>
-      The variable name is a string that describes the driver. It is used in
-      informational messages printed to the system log. The probe and
-      disconnect function pointers are called when a device that matches the
-      information provided in the id_table variable is either seen or removed.
-  </para>
-  <para>
-      The fops and minor variables are optional. Most USB drivers hook into
-      another kernel subsystem, such as the SCSI, network or TTY subsystem.
-      These types of drivers register themselves with the other kernel
-      subsystem, and any user-space interactions are provided through that
-      interface. But for drivers that do not have a matching kernel subsystem,
-      such as MP3 players or scanners, a method of interacting with user space
-      is needed. The USB subsystem provides a way to register a minor device
-      number and a set of file_operations function pointers that enable this
-      user-space interaction. The skeleton driver needs this kind of interface,
-      so it provides a minor starting number and a pointer to its
-      file_operations functions.
-  </para>
-  <para>
-      The USB driver is then registered with a call to usb_register, usually in
-      the driver's init function, as shown here:
-  </para>
-  <programlisting>
-static int __init usb_skel_init(void)
-{
-        int result;
-
-        /* register this driver with the USB subsystem */
-        result = usb_register(&amp;skel_driver);
-        if (result &lt; 0) {
-                err(&quot;usb_register failed for the &quot;__FILE__ &quot;driver.&quot;
-                    &quot;Error number %d&quot;, result);
-                return -1;
-        }
-
-        return 0;
-}
-module_init(usb_skel_init);
-  </programlisting>
-  <para>
-      When the driver is unloaded from the system, it needs to deregister
-      itself with the USB subsystem. This is done with the usb_deregister
-      function:
-  </para>
-  <programlisting>
-static void __exit usb_skel_exit(void)
-{
-        /* deregister this driver with the USB subsystem */
-        usb_deregister(&amp;skel_driver);
-}
-module_exit(usb_skel_exit);
-  </programlisting>
-  <para>
-     To enable the linux-hotplug system to load the driver automatically when
-     the device is plugged in, you need to create a MODULE_DEVICE_TABLE. The
-     following code tells the hotplug scripts that this module supports a
-     single device with a specific vendor and product ID:
-  </para>
-  <programlisting>
-/* table of devices that work with this driver */
-static struct usb_device_id skel_table [] = {
-        { USB_DEVICE(USB_SKEL_VENDOR_ID, USB_SKEL_PRODUCT_ID) },
-        { }                      /* Terminating entry */
-};
-MODULE_DEVICE_TABLE (usb, skel_table);
-  </programlisting>
-  <para>
-     There are other macros that can be used in describing a usb_device_id for
-     drivers that support a whole class of USB drivers. See usb.h for more
-     information on this.
-  </para>
-  </chapter>
-
-  <chapter id="device">
-      <title>Device operation</title>
-  <para>
-     When a device is plugged into the USB bus that matches the device ID
-     pattern that your driver registered with the USB core, the probe function
-     is called. The usb_device structure, interface number and the interface ID
-     are passed to the function:
-  </para>
-  <programlisting>
-static int skel_probe(struct usb_interface *interface,
-    const struct usb_device_id *id)
-  </programlisting>
-  <para>
-     The driver now needs to verify that this device is actually one that it
-     can accept. If so, it returns 0.
-     If not, or if any error occurs during initialization, an errorcode
-     (such as <literal>-ENOMEM</literal> or <literal>-ENODEV</literal>)
-     is returned from the probe function.
-  </para>
-  <para>
-     In the skeleton driver, we determine what end points are marked as bulk-in
-     and bulk-out. We create buffers to hold the data that will be sent and
-     received from the device, and a USB urb to write data to the device is
-     initialized.
-  </para>
-  <para>
-     Conversely, when the device is removed from the USB bus, the disconnect
-     function is called with the device pointer. The driver needs to clean any
-     private data that has been allocated at this time and to shut down any
-     pending urbs that are in the USB system.
-  </para>
-  <para>
-     Now that the device is plugged into the system and the driver is bound to
-     the device, any of the functions in the file_operations structure that
-     were passed to the USB subsystem will be called from a user program trying
-     to talk to the device. The first function called will be open, as the
-     program tries to open the device for I/O. We increment our private usage
-     count and save a pointer to our internal structure in the file
-     structure. This is done so that future calls to file operations will
-     enable the driver to determine which device the user is addressing.  All
-     of this is done with the following code:
-  </para>
-  <programlisting>
-/* increment our usage count for the module */
-++skel->open_count;
-
-/* save our object in the file's private structure */
-file->private_data = dev;
-  </programlisting>
-  <para>
-     After the open function is called, the read and write functions are called
-     to receive and send data to the device. In the skel_write function, we
-     receive a pointer to some data that the user wants to send to the device
-     and the size of the data. The function determines how much data it can
-     send to the device based on the size of the write urb it has created (this
-     size depends on the size of the bulk out end point that the device has).
-     Then it copies the data from user space to kernel space, points the urb to
-     the data and submits the urb to the USB subsystem.  This can be seen in
-     the following code:
-  </para>
-  <programlisting>
-/* we can only write as much as 1 urb will hold */
-bytes_written = (count > skel->bulk_out_size) ? skel->bulk_out_size : count;
-
-/* copy the data from user space into our urb */
-copy_from_user(skel->write_urb->transfer_buffer, buffer, bytes_written);
-
-/* set up our urb */
-usb_fill_bulk_urb(skel->write_urb,
-                  skel->dev,
-                  usb_sndbulkpipe(skel->dev, skel->bulk_out_endpointAddr),
-                  skel->write_urb->transfer_buffer,
-                  bytes_written,
-                  skel_write_bulk_callback,
-                  skel);
-
-/* send the data out the bulk port */
-result = usb_submit_urb(skel->write_urb);
-if (result) {
-        err(&quot;Failed submitting write urb, error %d&quot;, result);
-}
-  </programlisting>
-  <para>
-     When the write urb is filled up with the proper information using the
-     usb_fill_bulk_urb function, we point the urb's completion callback to call our
-     own skel_write_bulk_callback function. This function is called when the
-     urb is finished by the USB subsystem. The callback function is called in
-     interrupt context, so caution must be taken not to do very much processing
-     at that time. Our implementation of skel_write_bulk_callback merely
-     reports if the urb was completed successfully or not and then returns.
-  </para>
-  <para>
-     The read function works a bit differently from the write function in that
-     we do not use an urb to transfer data from the device to the driver.
-     Instead we call the usb_bulk_msg function, which can be used to send or
-     receive data from a device without having to create urbs and handle
-     urb completion callback functions. We call the usb_bulk_msg function,
-     giving it a buffer into which to place any data received from the device
-     and a timeout value. If the timeout period expires without receiving any
-     data from the device, the function will fail and return an error message.
-     This can be shown with the following code:
-  </para>
-  <programlisting>
-/* do an immediate bulk read to get data from the device */
-retval = usb_bulk_msg (skel->dev,
-                       usb_rcvbulkpipe (skel->dev,
-                       skel->bulk_in_endpointAddr),
-                       skel->bulk_in_buffer,
-                       skel->bulk_in_size,
-                       &amp;count, HZ*10);
-/* if the read was successful, copy the data to user space */
-if (!retval) {
-        if (copy_to_user (buffer, skel->bulk_in_buffer, count))
-                retval = -EFAULT;
-        else
-                retval = count;
-}
-  </programlisting>
-  <para>
-     The usb_bulk_msg function can be very useful for doing single reads or
-     writes to a device; however, if you need to read or write constantly to a
-     device, it is recommended to set up your own urbs and submit them to the
-     USB subsystem.
-  </para>
-  <para>
-     When the user program releases the file handle that it has been using to
-     talk to the device, the release function in the driver is called. In this
-     function we decrement our private usage count and wait for possible
-     pending writes:
-  </para>
-  <programlisting>
-/* decrement our usage count for the device */
---skel->open_count;
-  </programlisting>
-  <para>
-     One of the more difficult problems that USB drivers must be able to handle
-     smoothly is the fact that the USB device may be removed from the system at
-     any point in time, even if a program is currently talking to it. It needs
-     to be able to shut down any current reads and writes and notify the
-     user-space programs that the device is no longer there. The following
-     code (function <function>skel_delete</function>)
-     is an example of how to do this: </para>
-  <programlisting>
-static inline void skel_delete (struct usb_skel *dev)
-{
-    kfree (dev->bulk_in_buffer);
-    if (dev->bulk_out_buffer != NULL)
-        usb_free_coherent (dev->udev, dev->bulk_out_size,
-            dev->bulk_out_buffer,
-            dev->write_urb->transfer_dma);
-    usb_free_urb (dev->write_urb);
-    kfree (dev);
-}
-  </programlisting>
-  <para>
-     If a program currently has an open handle to the device, we reset the flag
-     <literal>device_present</literal>. For
-     every read, write, release and other functions that expect a device to be
-     present, the driver first checks this flag to see if the device is
-     still present. If not, it releases that the device has disappeared, and a
-     -ENODEV error is returned to the user-space program. When the release
-     function is eventually called, it determines if there is no device
-     and if not, it does the cleanup that the skel_disconnect
-     function normally does if there are no open files on the device (see
-     Listing 5).
-  </para>
-  </chapter>
-
-  <chapter id="iso">
-      <title>Isochronous Data</title>
-  <para>
-     This usb-skeleton driver does not have any examples of interrupt or
-     isochronous data being sent to or from the device. Interrupt data is sent
-     almost exactly as bulk data is, with a few minor exceptions.  Isochronous
-     data works differently with continuous streams of data being sent to or
-     from the device. The audio and video camera drivers are very good examples
-     of drivers that handle isochronous data and will be useful if you also
-     need to do this.
-  </para>
-  </chapter>
-  
-  <chapter id="Conclusion">
-      <title>Conclusion</title>
-  <para>
-     Writing Linux USB device drivers is not a difficult task as the
-     usb-skeleton driver shows. This driver, combined with the other current
-     USB drivers, should provide enough examples to help a beginning author
-     create a working driver in a minimal amount of time. The linux-usb-devel
-     mailing list archives also contain a lot of helpful information.
-  </para>
-  </chapter>
-
-  <chapter id="resources">
-      <title>Resources</title>
-  <para>
-     The Linux USB Project: <ulink url="http://www.linux-usb.org">http://www.linux-usb.org/</ulink>
-  </para>
-  <para>
-     Linux Hotplug Project: <ulink url="http://linux-hotplug.sourceforge.net">http://linux-hotplug.sourceforge.net/</ulink>
-  </para>
-  <para>
-     Linux USB Working Devices List: <ulink url="http://www.qbik.ch/usb/devices">http://www.qbik.ch/usb/devices/</ulink>
-  </para>
-  <para>
-     linux-usb-devel Mailing List Archives: <ulink url="http://marc.theaimsgroup.com/?l=linux-usb-devel">http://marc.theaimsgroup.com/?l=linux-usb-devel</ulink>
-  </para>
-  <para>
-     Programming Guide for Linux USB Device Drivers: <ulink url="http://usb.cs.tum.edu/usbdoc">http://usb.cs.tum.edu/usbdoc</ulink>
-  </para>
-  <para>
-     USB Home Page: <ulink url="http://www.usb.org">http://www.usb.org</ulink>
-  </para>
-  </chapter>
-
-</book>
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 60db00d1532b..90e742577dfc 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -26,7 +26,7 @@ available subsections can be seen below.
    regulator
    iio/index
    input
-   usb
+   usb/index
    spi
    i2c
    hsi
diff --git a/Documentation/driver-api/usb/gadget.rst b/Documentation/driver-api/usb/gadget.rst
new file mode 100644
index 000000000000..4fd9862f3f21
--- /dev/null
+++ b/Documentation/driver-api/usb/gadget.rst
@@ -0,0 +1,501 @@
+Introduction
+============
+
+This document presents a Linux-USB "Gadget" kernel mode API, for use
+within peripherals and other USB devices that embed Linux. It provides
+an overview of the API structure, and shows how that fits into a system
+development project. This is the first such API released on Linux to
+address a number of important problems, including:
+
+-  Supports USB 2.0, for high speed devices which can stream data at
+   several dozen megabytes per second.
+
+-  Handles devices with dozens of endpoints just as well as ones with
+   just two fixed-function ones. Gadget drivers can be written so
+   they're easy to port to new hardware.
+
+-  Flexible enough to expose more complex USB device capabilities such
+   as multiple configurations, multiple interfaces, composite devices,
+   and alternate interface settings.
+
+-  USB "On-The-Go" (OTG) support, in conjunction with updates to the
+   Linux-USB host side.
+
+-  Sharing data structures and API models with the Linux-USB host side
+   API. This helps the OTG support, and looks forward to more-symmetric
+   frameworks (where the same I/O model is used by both host and device
+   side drivers).
+
+-  Minimalist, so it's easier to support new device controller hardware.
+   I/O processing doesn't imply large demands for memory or CPU
+   resources.
+
+Most Linux developers will not be able to use this API, since they have
+USB "host" hardware in a PC, workstation, or server. Linux users with
+embedded systems are more likely to have USB peripheral hardware. To
+distinguish drivers running inside such hardware from the more familiar
+Linux "USB device drivers", which are host side proxies for the real USB
+devices, a different term is used: the drivers inside the peripherals
+are "USB gadget drivers". In USB protocol interactions, the device
+driver is the master (or "client driver") and the gadget driver is the
+slave (or "function driver").
+
+The gadget API resembles the host side Linux-USB API in that both use
+queues of request objects to package I/O buffers, and those requests may
+be submitted or canceled. They share common definitions for the standard
+USB *Chapter 9* messages, structures, and constants. Also, both APIs
+bind and unbind drivers to devices. The APIs differ in detail, since the
+host side's current URB framework exposes a number of implementation
+details and assumptions that are inappropriate for a gadget API. While
+the model for control transfers and configuration management is
+necessarily different (one side is a hardware-neutral master, the other
+is a hardware-aware slave), the endpoint I/0 API used here should also
+be usable for an overhead-reduced host side API.
+
+Structure of Gadget Drivers
+===========================
+
+A system running inside a USB peripheral normally has at least three
+layers inside the kernel to handle USB protocol processing, and may have
+additional layers in user space code. The "gadget" API is used by the
+middle layer to interact with the lowest level (which directly handles
+hardware).
+
+In Linux, from the bottom up, these layers are:
+
+*USB Controller Driver*
+    This is the lowest software level. It is the only layer that talks
+    to hardware, through registers, fifos, dma, irqs, and the like. The
+    ``<linux/usb/gadget.h>`` API abstracts the peripheral controller
+    endpoint hardware. That hardware is exposed through endpoint
+    objects, which accept streams of IN/OUT buffers, and through
+    callbacks that interact with gadget drivers. Since normal USB
+    devices only have one upstream port, they only have one of these
+    drivers. The controller driver can support any number of different
+    gadget drivers, but only one of them can be used at a time.
+
+    Examples of such controller hardware include the PCI-based NetChip
+    2280 USB 2.0 high speed controller, the SA-11x0 or PXA-25x UDC
+    (found within many PDAs), and a variety of other products.
+
+*Gadget Driver*
+    The lower boundary of this driver implements hardware-neutral USB
+    functions, using calls to the controller driver. Because such
+    hardware varies widely in capabilities and restrictions, and is used
+    in embedded environments where space is at a premium, the gadget
+    driver is often configured at compile time to work with endpoints
+    supported by one particular controller. Gadget drivers may be
+    portable to several different controllers, using conditional
+    compilation. (Recent kernels substantially simplify the work
+    involved in supporting new hardware, by *autoconfiguring* endpoints
+    automatically for many bulk-oriented drivers.) Gadget driver
+    responsibilities include:
+
+    -  handling setup requests (ep0 protocol responses) possibly
+       including class-specific functionality
+
+    -  returning configuration and string descriptors
+
+    -  (re)setting configurations and interface altsettings, including
+       enabling and configuring endpoints
+
+    -  handling life cycle events, such as managing bindings to
+       hardware, USB suspend/resume, remote wakeup, and disconnection
+       from the USB host.
+
+    -  managing IN and OUT transfers on all currently enabled endpoints
+
+    Such drivers may be modules of proprietary code, although that
+    approach is discouraged in the Linux community.
+
+*Upper Level*
+    Most gadget drivers have an upper boundary that connects to some
+    Linux driver or framework in Linux. Through that boundary flows the
+    data which the gadget driver produces and/or consumes through
+    protocol transfers over USB. Examples include:
+
+    -  user mode code, using generic (gadgetfs) or application specific
+       files in ``/dev``
+
+    -  networking subsystem (for network gadgets, like the CDC Ethernet
+       Model gadget driver)
+
+    -  data capture drivers, perhaps video4Linux or a scanner driver; or
+       test and measurement hardware.
+
+    -  input subsystem (for HID gadgets)
+
+    -  sound subsystem (for audio gadgets)
+
+    -  file system (for PTP gadgets)
+
+    -  block i/o subsystem (for usb-storage gadgets)
+
+    -  ... and more
+
+*Additional Layers*
+    Other layers may exist. These could include kernel layers, such as
+    network protocol stacks, as well as user mode applications building
+    on standard POSIX system call APIs such as *open()*, *close()*,
+    *read()* and *write()*. On newer systems, POSIX Async I/O calls may
+    be an option. Such user mode code will not necessarily be subject to
+    the GNU General Public License (GPL).
+
+OTG-capable systems will also need to include a standard Linux-USB host
+side stack, with *usbcore*, one or more *Host Controller Drivers*
+(HCDs), *USB Device Drivers* to support the OTG "Targeted Peripheral
+List", and so forth. There will also be an *OTG Controller Driver*,
+which is visible to gadget and device driver developers only indirectly.
+That helps the host and device side USB controllers implement the two
+new OTG protocols (HNP and SRP). Roles switch (host to peripheral, or
+vice versa) using HNP during USB suspend processing, and SRP can be
+viewed as a more battery-friendly kind of device wakeup protocol.
+
+Over time, reusable utilities are evolving to help make some gadget
+driver tasks simpler. For example, building configuration descriptors
+from vectors of descriptors for the configurations interfaces and
+endpoints is now automated, and many drivers now use autoconfiguration
+to choose hardware endpoints and initialize their descriptors. A
+potential example of particular interest is code implementing standard
+USB-IF protocols for HID, networking, storage, or audio classes. Some
+developers are interested in KDB or KGDB hooks, to let target hardware
+be remotely debugged. Most such USB protocol code doesn't need to be
+hardware-specific, any more than network protocols like X11, HTTP, or
+NFS are. Such gadget-side interface drivers should eventually be
+combined, to implement composite devices.
+
+Kernel Mode Gadget API
+======================
+
+Gadget drivers declare themselves through a *struct
+usb\_gadget\_driver*, which is responsible for most parts of enumeration
+for a *struct usb\_gadget*. The response to a set\_configuration usually
+involves enabling one or more of the *struct usb\_ep* objects exposed by
+the gadget, and submitting one or more *struct usb\_request* buffers to
+transfer data. Understand those four data types, and their operations,
+and you will understand how this API works.
+
+    **Note**
+
+    This documentation was prepared using the standard Linux kernel
+    ``docproc`` tool, which turns text and in-code comments into SGML
+    DocBook and then into usable formats such as HTML or PDF. Other than
+    the "Chapter 9" data types, most of the significant data types and
+    functions are described here.
+
+    However, docproc does not understand all the C constructs that are
+    used, so some relevant information is likely omitted from what you
+    are reading. One example of such information is endpoint
+    autoconfiguration. You'll have to read the header file, and use
+    example source code (such as that for "Gadget Zero"), to fully
+    understand the API.
+
+    The part of the API implementing some basic driver capabilities is
+    specific to the version of the Linux kernel that's in use. The 2.6
+    kernel includes a *driver model* framework that has no analogue on
+    earlier kernels; so those parts of the gadget API are not fully
+    portable. (They are implemented on 2.4 kernels, but in a different
+    way.) The driver model state is another part of this API that is
+    ignored by the kerneldoc tools.
+
+The core API does not expose every possible hardware feature, only the
+most widely available ones. There are significant hardware features,
+such as device-to-device DMA (without temporary storage in a memory
+buffer) that would be added using hardware-specific APIs.
+
+This API allows drivers to use conditional compilation to handle
+endpoint capabilities of different hardware, but doesn't require that.
+Hardware tends to have arbitrary restrictions, relating to transfer
+types, addressing, packet sizes, buffering, and availability. As a rule,
+such differences only matter for "endpoint zero" logic that handles
+device configuration and management. The API supports limited run-time
+detection of capabilities, through naming conventions for endpoints.
+Many drivers will be able to at least partially autoconfigure
+themselves. In particular, driver init sections will often have endpoint
+autoconfiguration logic that scans the hardware's list of endpoints to
+find ones matching the driver requirements (relying on those
+conventions), to eliminate some of the most common reasons for
+conditional compilation.
+
+Like the Linux-USB host side API, this API exposes the "chunky" nature
+of USB messages: I/O requests are in terms of one or more "packets", and
+packet boundaries are visible to drivers. Compared to RS-232 serial
+protocols, USB resembles synchronous protocols like HDLC (N bytes per
+frame, multipoint addressing, host as the primary station and devices as
+secondary stations) more than asynchronous ones (tty style: 8 data bits
+per frame, no parity, one stop bit). So for example the controller
+drivers won't buffer two single byte writes into a single two-byte USB
+IN packet, although gadget drivers may do so when they implement
+protocols where packet boundaries (and "short packets") are not
+significant.
+
+Driver Life Cycle
+-----------------
+
+Gadget drivers make endpoint I/O requests to hardware without needing to
+know many details of the hardware, but driver setup/configuration code
+needs to handle some differences. Use the API like this:
+
+1. Register a driver for the particular device side usb controller
+   hardware, such as the net2280 on PCI (USB 2.0), sa11x0 or pxa25x as
+   found in Linux PDAs, and so on. At this point the device is logically
+   in the USB ch9 initial state ("attached"), drawing no power and not
+   usable (since it does not yet support enumeration). Any host should
+   not see the device, since it's not activated the data line pullup
+   used by the host to detect a device, even if VBUS power is available.
+
+2. Register a gadget driver that implements some higher level device
+   function. That will then bind() to a usb\_gadget, which activates the
+   data line pullup sometime after detecting VBUS.
+
+3. The hardware driver can now start enumerating. The steps it handles
+   are to accept USB power and set\_address requests. Other steps are
+   handled by the gadget driver. If the gadget driver module is unloaded
+   before the host starts to enumerate, steps before step 7 are skipped.
+
+4. The gadget driver's setup() call returns usb descriptors, based both
+   on what the bus interface hardware provides and on the functionality
+   being implemented. That can involve alternate settings or
+   configurations, unless the hardware prevents such operation. For OTG
+   devices, each configuration descriptor includes an OTG descriptor.
+
+5. The gadget driver handles the last step of enumeration, when the USB
+   host issues a set\_configuration call. It enables all endpoints used
+   in that configuration, with all interfaces in their default settings.
+   That involves using a list of the hardware's endpoints, enabling each
+   endpoint according to its descriptor. It may also involve using
+   ``usb_gadget_vbus_draw`` to let more power be drawn from VBUS, as
+   allowed by that configuration. For OTG devices, setting a
+   configuration may also involve reporting HNP capabilities through a
+   user interface.
+
+6. Do real work and perform data transfers, possibly involving changes
+   to interface settings or switching to new configurations, until the
+   device is disconnect()ed from the host. Queue any number of transfer
+   requests to each endpoint. It may be suspended and resumed several
+   times before being disconnected. On disconnect, the drivers go back
+   to step 3 (above).
+
+7. When the gadget driver module is being unloaded, the driver unbind()
+   callback is issued. That lets the controller driver be unloaded.
+
+Drivers will normally be arranged so that just loading the gadget driver
+module (or statically linking it into a Linux kernel) allows the
+peripheral device to be enumerated, but some drivers will defer
+enumeration until some higher level component (like a user mode daemon)
+enables it. Note that at this lowest level there are no policies about
+how ep0 configuration logic is implemented, except that it should obey
+USB specifications. Such issues are in the domain of gadget drivers,
+including knowing about implementation constraints imposed by some USB
+controllers or understanding that composite devices might happen to be
+built by integrating reusable components.
+
+Note that the lifecycle above can be slightly different for OTG devices.
+Other than providing an additional OTG descriptor in each configuration,
+only the HNP-related differences are particularly visible to driver
+code. They involve reporting requirements during the SET\_CONFIGURATION
+request, and the option to invoke HNP during some suspend callbacks.
+Also, SRP changes the semantics of ``usb_gadget_wakeup`` slightly.
+
+USB 2.0 Chapter 9 Types and Constants
+-------------------------------------
+
+Gadget drivers rely on common USB structures and constants defined in
+the ``<linux/usb/ch9.h>`` header file, which is standard in Linux 2.6
+kernels. These are the same types and constants used by host side
+drivers (and usbcore).
+
+!Iinclude/linux/usb/ch9.h
+Core Objects and Methods
+------------------------
+
+These are declared in ``<linux/usb/gadget.h>``, and are used by gadget
+drivers to interact with USB peripheral controller drivers.
+
+!Iinclude/linux/usb/gadget.h
+Optional Utilities
+------------------
+
+The core API is sufficient for writing a USB Gadget Driver, but some
+optional utilities are provided to simplify common tasks. These
+utilities include endpoint autoconfiguration.
+
+!Edrivers/usb/gadget/usbstring.c !Edrivers/usb/gadget/config.c
+Composite Device Framework
+--------------------------
+
+The core API is sufficient for writing drivers for composite USB devices
+(with more than one function in a given configuration), and also
+multi-configuration devices (also more than one function, but not
+necessarily sharing a given configuration). There is however an optional
+framework which makes it easier to reuse and combine functions.
+
+Devices using this framework provide a *struct usb\_composite\_driver*,
+which in turn provides one or more *struct usb\_configuration*
+instances. Each such configuration includes at least one *struct
+usb\_function*, which packages a user visible role such as "network
+link" or "mass storage device". Management functions may also exist,
+such as "Device Firmware Upgrade".
+
+!Iinclude/linux/usb/composite.h !Edrivers/usb/gadget/composite.c
+Composite Device Functions
+--------------------------
+
+At this writing, a few of the current gadget drivers have been converted
+to this framework. Near-term plans include converting all of them,
+except for "gadgetfs".
+
+!Edrivers/usb/gadget/function/f\_acm.c
+!Edrivers/usb/gadget/function/f\_ecm.c
+!Edrivers/usb/gadget/function/f\_subset.c
+!Edrivers/usb/gadget/function/f\_obex.c
+!Edrivers/usb/gadget/function/f\_serial.c
+Peripheral Controller Drivers
+=============================
+
+The first hardware supporting this API was the NetChip 2280 controller,
+which supports USB 2.0 high speed and is based on PCI. This is the
+``net2280`` driver module. The driver supports Linux kernel versions 2.4
+and 2.6; contact NetChip Technologies for development boards and product
+information.
+
+Other hardware working in the "gadget" framework includes: Intel's PXA
+25x and IXP42x series processors (``pxa2xx_udc``), Toshiba TC86c001
+"Goku-S" (``goku_udc``), Renesas SH7705/7727 (``sh_udc``), MediaQ 11xx
+(``mq11xx_udc``), Hynix HMS30C7202 (``h7202_udc``), National 9303/4
+(``n9604_udc``), Texas Instruments OMAP (``omap_udc``), Sharp LH7A40x
+(``lh7a40x_udc``), and more. Most of those are full speed controllers.
+
+At this writing, there are people at work on drivers in this framework
+for several other USB device controllers, with plans to make many of
+them be widely available.
+
+A partial USB simulator, the ``dummy_hcd`` driver, is available. It can
+act like a net2280, a pxa25x, or an sa11x0 in terms of available
+endpoints and device speeds; and it simulates control, bulk, and to some
+extent interrupt transfers. That lets you develop some parts of a gadget
+driver on a normal PC, without any special hardware, and perhaps with
+the assistance of tools such as GDB running with User Mode Linux. At
+least one person has expressed interest in adapting that approach,
+hooking it up to a simulator for a microcontroller. Such simulators can
+help debug subsystems where the runtime hardware is unfriendly to
+software development, or is not yet available.
+
+Support for other controllers is expected to be developed and
+contributed over time, as this driver framework evolves.
+
+Gadget Drivers
+==============
+
+In addition to *Gadget Zero* (used primarily for testing and development
+with drivers for usb controller hardware), other gadget drivers exist.
+
+There's an *ethernet* gadget driver, which implements one of the most
+useful *Communications Device Class* (CDC) models. One of the standards
+for cable modem interoperability even specifies the use of this ethernet
+model as one of two mandatory options. Gadgets using this code look to a
+USB host as if they're an Ethernet adapter. It provides access to a
+network where the gadget's CPU is one host, which could easily be
+bridging, routing, or firewalling access to other networks. Since some
+hardware can't fully implement the CDC Ethernet requirements, this
+driver also implements a "good parts only" subset of CDC Ethernet. (That
+subset doesn't advertise itself as CDC Ethernet, to avoid creating
+problems.)
+
+Support for Microsoft's *RNDIS* protocol has been contributed by
+Pengutronix and Auerswald GmbH. This is like CDC Ethernet, but it runs
+on more slightly USB hardware (but less than the CDC subset). However,
+its main claim to fame is being able to connect directly to recent
+versions of Windows, using drivers that Microsoft bundles and supports,
+making it much simpler to network with Windows.
+
+There is also support for user mode gadget drivers, using *gadgetfs*.
+This provides a *User Mode API* that presents each endpoint as a single
+file descriptor. I/O is done using normal *read()* and *read()* calls.
+Familiar tools like GDB and pthreads can be used to develop and debug
+user mode drivers, so that once a robust controller driver is available
+many applications for it won't require new kernel mode software. Linux
+2.6 *Async I/O (AIO)* support is available, so that user mode software
+can stream data with only slightly more overhead than a kernel driver.
+
+There's a USB Mass Storage class driver, which provides a different
+solution for interoperability with systems such as MS-Windows and MacOS.
+That *Mass Storage* driver uses a file or block device as backing store
+for a drive, like the ``loop`` driver. The USB host uses the BBB, CB, or
+CBI versions of the mass storage class specification, using transparent
+SCSI commands to access the data from the backing store.
+
+There's a "serial line" driver, useful for TTY style operation over USB.
+The latest version of that driver supports CDC ACM style operation, like
+a USB modem, and so on most hardware it can interoperate easily with
+MS-Windows. One interesting use of that driver is in boot firmware (like
+a BIOS), which can sometimes use that model with very small systems
+without real serial lines.
+
+Support for other kinds of gadget is expected to be developed and
+contributed over time, as this driver framework evolves.
+
+USB On-The-GO (OTG)
+===================
+
+USB OTG support on Linux 2.6 was initially developed by Texas
+Instruments for `OMAP <http://www.omap.com>`__ 16xx and 17xx series
+processors. Other OTG systems should work in similar ways, but the
+hardware level details could be very different.
+
+Systems need specialized hardware support to implement OTG, notably
+including a special *Mini-AB* jack and associated transceiver to support
+*Dual-Role* operation: they can act either as a host, using the standard
+Linux-USB host side driver stack, or as a peripheral, using this
+"gadget" framework. To do that, the system software relies on small
+additions to those programming interfaces, and on a new internal
+component (here called an "OTG Controller") affecting which driver stack
+connects to the OTG port. In each role, the system can re-use the
+existing pool of hardware-neutral drivers, layered on top of the
+controller driver interfaces (*usb\_bus* or *usb\_gadget*). Such drivers
+need at most minor changes, and most of the calls added to support OTG
+can also benefit non-OTG products.
+
+-  Gadget drivers test the *is\_otg* flag, and use it to determine
+   whether or not to include an OTG descriptor in each of their
+   configurations.
+
+-  Gadget drivers may need changes to support the two new OTG protocols,
+   exposed in new gadget attributes such as *b\_hnp\_enable* flag. HNP
+   support should be reported through a user interface (two LEDs could
+   suffice), and is triggered in some cases when the host suspends the
+   peripheral. SRP support can be user-initiated just like remote
+   wakeup, probably by pressing the same button.
+
+-  On the host side, USB device drivers need to be taught to trigger HNP
+   at appropriate moments, using ``usb_suspend_device()``. That also
+   conserves battery power, which is useful even for non-OTG
+   configurations.
+
+-  Also on the host side, a driver must support the OTG "Targeted
+   Peripheral List". That's just a whitelist, used to reject peripherals
+   not supported with a given Linux OTG host. *This whitelist is
+   product-specific; each product must modify ``otg_whitelist.h`` to
+   match its interoperability specification.*
+
+   Non-OTG Linux hosts, like PCs and workstations, normally have some
+   solution for adding drivers, so that peripherals that aren't
+   recognized can eventually be supported. That approach is unreasonable
+   for consumer products that may never have their firmware upgraded,
+   and where it's usually unrealistic to expect traditional
+   PC/workstation/server kinds of support model to work. For example,
+   it's often impractical to change device firmware once the product has
+   been distributed, so driver bugs can't normally be fixed if they're
+   found after shipment.
+
+Additional changes are needed below those hardware-neutral *usb\_bus*
+and *usb\_gadget* driver interfaces; those aren't discussed here in any
+detail. Those affect the hardware-specific code for each USB Host or
+Peripheral controller, and how the HCD initializes (since OTG can be
+active only on a single port). They also involve what may be called an
+*OTG Controller Driver*, managing the OTG transceiver and the OTG state
+machine logic as well as much of the root hub behavior for the OTG port.
+The OTG controller driver needs to activate and deactivate USB
+controllers depending on the relevant device role. Some related changes
+were needed inside usbcore, so that it can identify OTG-capable devices
+and respond appropriately to HNP or SRP protocols.
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
new file mode 100644
index 000000000000..cf2fa2e8d236
--- /dev/null
+++ b/Documentation/driver-api/usb/index.rst
@@ -0,0 +1,17 @@
+=============
+Linux USB API
+=============
+
+.. toctree::
+
+   usb
+   gadget
+   writing_usb_driver
+   writing_musb_glue_layer
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/driver-api/usb.rst b/Documentation/driver-api/usb/usb.rst
similarity index 87%
rename from Documentation/driver-api/usb.rst
rename to Documentation/driver-api/usb/usb.rst
index 851cc40b66b5..b856abb3200e 100644
--- a/Documentation/driver-api/usb.rst
+++ b/Documentation/driver-api/usb/usb.rst
@@ -329,11 +329,11 @@ to detect when devices are added or removed:
     fd = open("/proc/bus/usb/devices", O_RDONLY);
     pfd = { fd, POLLIN, 0 };
     for (;;) {
-        /* The first time through, this call will return immediately. */
-        poll(&pfd, 1, -1);
+	/* The first time through, this call will return immediately. */
+	poll(&pfd, 1, -1);
 
-        /* To see what's changed, compare the file's previous and current
-           contents or scan the filesystem.  (Scanning is more precise.) */
+	/* To see what's changed, compare the file's previous and current
+	   contents or scan the filesystem.  (Scanning is more precise.) */
     }
 
 Note that this behavior is intended to be used for informational and
@@ -462,10 +462,10 @@ USBDEVFS_CONNECTINFO
 
     ::
 
-        struct usbdevfs_connectinfo {
-                unsigned int   devnum;
-                unsigned char  slow;
-        };
+	struct usbdevfs_connectinfo {
+		unsigned int   devnum;
+		unsigned char  slow;
+	};
 
     File modification time is not updated by this request.
 
@@ -481,10 +481,10 @@ USBDEVFS_GETDRIVER
 
     ::
 
-        struct usbdevfs_getdriver {
-                unsigned int  interface;
-                char          driver[USBDEVFS_MAXDRIVERNAME + 1];
-        };
+	struct usbdevfs_getdriver {
+		unsigned int  interface;
+		char          driver[USBDEVFS_MAXDRIVERNAME + 1];
+	};
 
     File modification time is not updated by this request.
 
@@ -494,28 +494,28 @@ USBDEVFS_IOCTL
 
     ::
 
-        struct usbdevfs_ioctl {
-                int     ifno;
-                int     ioctl_code;
-                void    *data;
-        };
+	struct usbdevfs_ioctl {
+		int     ifno;
+		int     ioctl_code;
+		void    *data;
+	};
 
-        /* user mode call looks like this.
-         * 'request' becomes the driver->ioctl() 'code' parameter.
-         * the size of 'param' is encoded in 'request', and that data
-         * is copied to or from the driver->ioctl() 'buf' parameter.
-         */
-        static int
-        usbdev_ioctl (int fd, int ifno, unsigned request, void *param)
-        {
-                struct usbdevfs_ioctl   wrapper;
+	/* user mode call looks like this.
+	 * 'request' becomes the driver->ioctl() 'code' parameter.
+	 * the size of 'param' is encoded in 'request', and that data
+	 * is copied to or from the driver->ioctl() 'buf' parameter.
+	 */
+	static int
+	usbdev_ioctl (int fd, int ifno, unsigned request, void *param)
+	{
+		struct usbdevfs_ioctl   wrapper;
 
-                wrapper.ifno = ifno;
-                wrapper.ioctl_code = request;
-                wrapper.data = param;
+		wrapper.ifno = ifno;
+		wrapper.ioctl_code = request;
+		wrapper.data = param;
 
-                return ioctl (fd, USBDEVFS_IOCTL, &wrapper);
-        }
+		return ioctl (fd, USBDEVFS_IOCTL, &wrapper);
+	}
 
     File modification time is not updated by this request.
 
@@ -534,11 +534,11 @@ USBDEVFS_RELEASEINTERFACE
     the number of the interface (bInterfaceNumber from descriptor); File
     modification time is not updated by this request.
 
-        **Warning**
+	**Warning**
 
-        *No security check is made to ensure that the task which made
-        the claim is the one which is releasing it. This means that user
-        mode driver may interfere other ones.*
+	*No security check is made to ensure that the task which made
+	the claim is the one which is releasing it. This means that user
+	mode driver may interfere other ones.*
 
 USBDEVFS_RESETEP
     Resets the data toggle value for an endpoint (bulk or interrupt) to
@@ -546,13 +546,13 @@ USBDEVFS_RESETEP
     as identified in the endpoint descriptor), with USB_DIR_IN added
     if the device's endpoint sends data to the host.
 
-        **Warning**
+	**Warning**
 
-        *Avoid using this request. It should probably be removed.* Using
-        it typically means the device and driver will lose toggle
-        synchronization. If you really lost synchronization, you likely
-        need to completely handshake with the device, using a request
-        like CLEAR_HALT or SET_INTERFACE.
+	*Avoid using this request. It should probably be removed.* Using
+	it typically means the device and driver will lose toggle
+	synchronization. If you really lost synchronization, you likely
+	need to completely handshake with the device, using a request
+	like CLEAR_HALT or SET_INTERFACE.
 
 USBDEVFS_DROP_PRIVILEGES
     This is used to relinquish the ability to do certain operations
@@ -578,12 +578,12 @@ USBDEVFS_BULK
 
     ::
 
-        struct usbdevfs_bulktransfer {
-                unsigned int  ep;
-                unsigned int  len;
-                unsigned int  timeout; /* in milliseconds */
-                void          *data;
-        };
+	struct usbdevfs_bulktransfer {
+		unsigned int  ep;
+		unsigned int  len;
+		unsigned int  timeout; /* in milliseconds */
+		void          *data;
+	};
 
     The "ep" value identifies a bulk endpoint number (1 to 15, as
     identified in an endpoint descriptor), masked with USB_DIR_IN when
@@ -610,15 +610,15 @@ USBDEVFS_CONTROL
 
     ::
 
-        struct usbdevfs_ctrltransfer {
-                __u8   bRequestType;
-                __u8   bRequest;
-                __u16  wValue;
-                __u16  wIndex;
-                __u16  wLength;
-                __u32  timeout;  /* in milliseconds */
-                void   *data;
-        };
+	struct usbdevfs_ctrltransfer {
+		__u8   bRequestType;
+		__u8   bRequest;
+		__u16  wValue;
+		__u16  wIndex;
+		__u16  wLength;
+		__u32  timeout;  /* in milliseconds */
+		void   *data;
+	};
 
     The first eight bytes of this structure are the contents of the
     SETUP packet to be sent to the device; see the USB 2.0 specification
@@ -638,11 +638,11 @@ USBDEVFS_RESET
     the reset, this rebinds all device interfaces. File modification
     time is not updated by this request.
 
-        **Warning**
+	**Warning**
 
-        *Avoid using this call* until some usbcore bugs get fixed, since
-        it does not fully synchronize device, interface, and driver (not
-        just usbfs) state.
+	*Avoid using this call* until some usbcore bugs get fixed, since
+	it does not fully synchronize device, interface, and driver (not
+	just usbfs) state.
 
 USBDEVFS_SETINTERFACE
     Sets the alternate setting for an interface. The ioctl parameter is
@@ -650,10 +650,10 @@ USBDEVFS_SETINTERFACE
 
     ::
 
-        struct usbdevfs_setinterface {
-                unsigned int  interface;
-                unsigned int  altsetting;
-        };
+	struct usbdevfs_setinterface {
+		unsigned int  interface;
+		unsigned int  altsetting;
+	};
 
     File modification time is not updated by this request.
 
@@ -669,11 +669,11 @@ USBDEVFS_SETCONFIGURATION
     configuration (bConfigurationValue from descriptor). File
     modification time is not updated by this request.
 
-        **Warning**
+	**Warning**
 
-        *Avoid using this call* until some usbcore bugs get fixed, since
-        it does not fully synchronize device, interface, and driver (not
-        just usbfs) state.
+	*Avoid using this call* until some usbcore bugs get fixed, since
+	it does not fully synchronize device, interface, and driver (not
+	just usbfs) state.
 
 Asynchronous I/O Support
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -707,25 +707,25 @@ fewer bytes were read than were requested then you get an error report.
 ::
 
     struct usbdevfs_iso_packet_desc {
-            unsigned int                     length;
-            unsigned int                     actual_length;
-            unsigned int                     status;
+	    unsigned int                     length;
+	    unsigned int                     actual_length;
+	    unsigned int                     status;
     };
 
     struct usbdevfs_urb {
-            unsigned char                    type;
-            unsigned char                    endpoint;
-            int                              status;
-            unsigned int                     flags;
-            void                             *buffer;
-            int                              buffer_length;
-            int                              actual_length;
-            int                              start_frame;
-            int                              number_of_packets;
-            int                              error_count;
-            unsigned int                     signr;
-            void                             *usercontext;
-            struct usbdevfs_iso_packet_desc  iso_frame_desc[];
+	    unsigned char                    type;
+	    unsigned char                    endpoint;
+	    int                              status;
+	    unsigned int                     flags;
+	    void                             *buffer;
+	    int                              buffer_length;
+	    int                              actual_length;
+	    int                              start_frame;
+	    int                              number_of_packets;
+	    int                              error_count;
+	    unsigned int                     signr;
+	    void                             *usercontext;
+	    struct usbdevfs_iso_packet_desc  iso_frame_desc[];
     };
 
 For these asynchronous requests, the file modification time reflects
diff --git a/Documentation/driver-api/usb/writing_musb_glue_layer.rst b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
new file mode 100644
index 000000000000..2546a102394f
--- /dev/null
+++ b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
@@ -0,0 +1,731 @@
+Introduction
+============
+
+The Linux MUSB subsystem is part of the larger Linux USB subsystem. It
+provides support for embedded USB Device Controllers (UDC) that do not
+use Universal Host Controller Interface (UHCI) or Open Host Controller
+Interface (OHCI).
+
+Instead, these embedded UDC rely on the USB On-the-Go (OTG)
+specification which they implement at least partially. The silicon
+reference design used in most cases is the Multipoint USB Highspeed
+Dual-Role Controller (MUSB HDRC) found in the Mentor Graphics Inventra™
+design.
+
+As a self-taught exercise I have written an MUSB glue layer for the
+Ingenic JZ4740 SoC, modelled after the many MUSB glue layers in the
+kernel source tree. This layer can be found at
+drivers/usb/musb/jz4740.c. In this documentation I will walk through the
+basics of the jz4740.c glue layer, explaining the different pieces and
+what needs to be done in order to write your own device glue layer.
+
+Linux MUSB Basics
+=================
+
+To get started on the topic, please read USB On-the-Go Basics (see
+Resources) which provides an introduction of USB OTG operation at the
+hardware level. A couple of wiki pages by Texas Instruments and Analog
+Devices also provide an overview of the Linux kernel MUSB configuration,
+albeit focused on some specific devices provided by these companies.
+Finally, getting acquainted with the USB specification at USB home page
+may come in handy, with practical instance provided through the Writing
+USB Device Drivers documentation (again, see Resources).
+
+Linux USB stack is a layered architecture in which the MUSB controller
+hardware sits at the lowest. The MUSB controller driver abstract the
+MUSB controller hardware to the Linux USB stack.
+
+::
+
+	  ------------------------
+	  |                      | <------- drivers/usb/gadget
+	  | Linux USB Core Stack | <------- drivers/usb/host
+	  |                      | <------- drivers/usb/core
+	  ------------------------
+		     ⬍
+	 --------------------------
+	 |                        | <------ drivers/usb/musb/musb_gadget.c
+	 | MUSB Controller driver | <------ drivers/usb/musb/musb_host.c
+	 |                        | <------ drivers/usb/musb/musb_core.c
+	 --------------------------
+		     ⬍
+      ---------------------------------
+      | MUSB Platform Specific Driver |
+      |                               | <-- drivers/usb/musb/jz4740.c
+      |       aka "Glue Layer"        |
+      ---------------------------------
+		     ⬍
+      ---------------------------------
+      |   MUSB Controller Hardware    |
+      ---------------------------------
+
+
+As outlined above, the glue layer is actually the platform specific code
+sitting in between the controller driver and the controller hardware.
+
+Just like a Linux USB driver needs to register itself with the Linux USB
+subsystem, the MUSB glue layer needs first to register itself with the
+MUSB controller driver. This will allow the controller driver to know
+about which device the glue layer supports and which functions to call
+when a supported device is detected or released; remember we are talking
+about an embedded controller chip here, so no insertion or removal at
+run-time.
+
+All of this information is passed to the MUSB controller driver through
+a platform\_driver structure defined in the glue layer as:
+
+::
+
+    static struct platform_driver jz4740_driver = {
+	.probe      = jz4740_probe,
+	.remove     = jz4740_remove,
+	.driver     = {
+	    .name   = "musb-jz4740",
+	},
+    };
+
+
+The probe and remove function pointers are called when a matching device
+is detected and, respectively, released. The name string describes the
+device supported by this glue layer. In the current case it matches a
+platform\_device structure declared in arch/mips/jz4740/platform.c. Note
+that we are not using device tree bindings here.
+
+In order to register itself to the controller driver, the glue layer
+goes through a few steps, basically allocating the controller hardware
+resources and initialising a couple of circuits. To do so, it needs to
+keep track of the information used throughout these steps. This is done
+by defining a private jz4740\_glue structure:
+
+::
+
+    struct jz4740_glue {
+	struct device           *dev;
+	struct platform_device  *musb;
+	struct clk      *clk;
+    };
+
+
+The dev and musb members are both device structure variables. The first
+one holds generic information about the device, since it's the basic
+device structure, and the latter holds information more closely related
+to the subsystem the device is registered to. The clk variable keeps
+information related to the device clock operation.
+
+Let's go through the steps of the probe function that leads the glue
+layer to register itself to the controller driver.
+
+N.B.: For the sake of readability each function will be split in logical
+parts, each part being shown as if it was independent from the others.
+
+::
+
+    static int jz4740_probe(struct platform_device *pdev)
+    {
+	struct platform_device      *musb;
+	struct jz4740_glue      *glue;
+	struct clk                      *clk;
+	int             ret;
+
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
+	if (!glue)
+	    return -ENOMEM;
+
+	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
+	if (!musb) {
+	    dev_err(&pdev->dev, "failed to allocate musb device\n");
+	    return -ENOMEM;
+	}
+
+	clk = devm_clk_get(&pdev->dev, "udc");
+	if (IS_ERR(clk)) {
+	    dev_err(&pdev->dev, "failed to get clock\n");
+	    ret = PTR_ERR(clk);
+	    goto err_platform_device_put;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+	    dev_err(&pdev->dev, "failed to enable clock\n");
+	    goto err_platform_device_put;
+	}
+
+	musb->dev.parent        = &pdev->dev;
+
+	glue->dev           = &pdev->dev;
+	glue->musb          = musb;
+	glue->clk           = clk;
+
+	return 0;
+
+    err_platform_device_put:
+	platform_device_put(musb);
+	return ret;
+    }
+
+
+The first few lines of the probe function allocate and assign the glue,
+musb and clk variables. The GFP\_KERNEL flag (line 8) allows the
+allocation process to sleep and wait for memory, thus being usable in a
+blocking situation. The PLATFORM\_DEVID\_AUTO flag (line 12) allows
+automatic allocation and management of device IDs in order to avoid
+device namespace collisions with explicit IDs. With devm\_clk\_get()
+(line 18) the glue layer allocates the clock -- the ``devm_`` prefix
+indicates that clk\_get() is managed: it automatically frees the
+allocated clock resource data when the device is released -- and enable
+it.
+
+Then comes the registration steps:
+
+::
+
+    static int jz4740_probe(struct platform_device *pdev)
+    {
+	struct musb_hdrc_platform_data  *pdata = &jz4740_musb_platform_data;
+
+	pdata->platform_ops     = &jz4740_musb_ops;
+
+	platform_set_drvdata(pdev, glue);
+
+	ret = platform_device_add_resources(musb, pdev->resource,
+			    pdev->num_resources);
+	if (ret) {
+	    dev_err(&pdev->dev, "failed to add resources\n");
+	    goto err_clk_disable;
+	}
+
+	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
+	if (ret) {
+	    dev_err(&pdev->dev, "failed to add platform_data\n");
+	    goto err_clk_disable;
+	}
+
+	return 0;
+
+    err_clk_disable:
+	clk_disable_unprepare(clk);
+    err_platform_device_put:
+	platform_device_put(musb);
+	return ret;
+    }
+
+
+The first step is to pass the device data privately held by the glue
+layer on to the controller driver through platform\_set\_drvdata() (line
+7). Next is passing on the device resources information, also privately
+held at that point, through platform\_device\_add\_resources() (line 9).
+
+Finally comes passing on the platform specific data to the controller
+driver (line 16). Platform data will be discussed in `Chapter
+4 <#device-platform-data>`__, but here we are looking at the
+platform\_ops function pointer (line 5) in musb\_hdrc\_platform\_data
+structure (line 3). This function pointer allows the MUSB controller
+driver to know which function to call for device operation:
+
+::
+
+    static const struct musb_platform_ops jz4740_musb_ops = {
+	.init       = jz4740_musb_init,
+	.exit       = jz4740_musb_exit,
+    };
+
+
+Here we have the minimal case where only init and exit functions are
+called by the controller driver when needed. Fact is the JZ4740 MUSB
+controller is a basic controller, lacking some features found in other
+controllers, otherwise we may also have pointers to a few other
+functions like a power management function or a function to switch
+between OTG and non-OTG modes, for instance.
+
+At that point of the registration process, the controller driver
+actually calls the init function:
+
+::
+
+    static int jz4740_musb_init(struct musb *musb)
+    {
+	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+	if (!musb->xceiv) {
+	    pr_err("HS UDC: no transceiver configured\n");
+	    return -ENODEV;
+	}
+
+	/* Silicon does not implement ConfigData register.
+	 * Set dyn_fifo to avoid reading EP config from hardware.
+	 */
+	musb->dyn_fifo = true;
+
+	musb->isr = jz4740_musb_interrupt;
+
+	return 0;
+    }
+
+
+The goal of jz4740\_musb\_init() is to get hold of the transceiver
+driver data of the MUSB controller hardware and pass it on to the MUSB
+controller driver, as usual. The transceiver is the circuitry inside the
+controller hardware responsible for sending/receiving the USB data.
+Since it is an implementation of the physical layer of the OSI model,
+the transceiver is also referred to as PHY.
+
+Getting hold of the MUSB PHY driver data is done with usb\_get\_phy()
+which returns a pointer to the structure containing the driver instance
+data. The next couple of instructions (line 12 and 14) are used as a
+quirk and to setup IRQ handling respectively. Quirks and IRQ handling
+will be discussed later in `Chapter 5 <#device-quirks>`__ and `Chapter
+3 <#handling-irqs>`__.
+
+::
+
+    static int jz4740_musb_exit(struct musb *musb)
+    {
+	usb_put_phy(musb->xceiv);
+
+	return 0;
+    }
+
+
+Acting as the counterpart of init, the exit function releases the MUSB
+PHY driver when the controller hardware itself is about to be released.
+
+Again, note that init and exit are fairly simple in this case due to the
+basic set of features of the JZ4740 controller hardware. When writing an
+musb glue layer for a more complex controller hardware, you might need
+to take care of more processing in those two functions.
+
+Returning from the init function, the MUSB controller driver jumps back
+into the probe function:
+
+::
+
+    static int jz4740_probe(struct platform_device *pdev)
+    {
+	ret = platform_device_add(musb);
+	if (ret) {
+	    dev_err(&pdev->dev, "failed to register musb device\n");
+	    goto err_clk_disable;
+	}
+
+	return 0;
+
+    err_clk_disable:
+	clk_disable_unprepare(clk);
+    err_platform_device_put:
+	platform_device_put(musb);
+	return ret;
+    }
+
+
+This is the last part of the device registration process where the glue
+layer adds the controller hardware device to Linux kernel device
+hierarchy: at this stage, all known information about the device is
+passed on to the Linux USB core stack.
+
+::
+
+    static int jz4740_remove(struct platform_device *pdev)
+    {
+	struct jz4740_glue  *glue = platform_get_drvdata(pdev);
+
+	platform_device_unregister(glue->musb);
+	clk_disable_unprepare(glue->clk);
+
+	return 0;
+    }
+
+
+Acting as the counterpart of probe, the remove function unregister the
+MUSB controller hardware (line 5) and disable the clock (line 6),
+allowing it to be gated.
+
+Handling IRQs
+=============
+
+Additionally to the MUSB controller hardware basic setup and
+registration, the glue layer is also responsible for handling the IRQs:
+
+::
+
+    static irqreturn_t jz4740_musb_interrupt(int irq, void *__hci)
+    {
+	unsigned long   flags;
+	irqreturn_t     retval = IRQ_NONE;
+	struct musb     *musb = __hci;
+
+	spin_lock_irqsave(&musb->lock, flags);
+
+	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
+	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
+	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
+
+	/*
+	 * The controller is gadget only, the state of the host mode IRQ bits is
+	 * undefined. Mask them to make sure that the musb driver core will
+	 * never see them set
+	 */
+	musb->int_usb &= MUSB_INTR_SUSPEND | MUSB_INTR_RESUME |
+	    MUSB_INTR_RESET | MUSB_INTR_SOF;
+
+	if (musb->int_usb || musb->int_tx || musb->int_rx)
+	    retval = musb_interrupt(musb);
+
+	spin_unlock_irqrestore(&musb->lock, flags);
+
+	return retval;
+    }
+
+
+Here the glue layer mostly has to read the relevant hardware registers
+and pass their values on to the controller driver which will handle the
+actual event that triggered the IRQ.
+
+The interrupt handler critical section is protected by the
+spin\_lock\_irqsave() and counterpart spin\_unlock\_irqrestore()
+functions (line 7 and 24 respectively), which prevent the interrupt
+handler code to be run by two different threads at the same time.
+
+Then the relevant interrupt registers are read (line 9 to 11):
+
+-  MUSB\_INTRUSB: indicates which USB interrupts are currently active,
+
+-  MUSB\_INTRTX: indicates which of the interrupts for TX endpoints are
+   currently active,
+
+-  MUSB\_INTRRX: indicates which of the interrupts for TX endpoints are
+   currently active.
+
+Note that musb\_readb() is used to read 8-bit registers at most, while
+musb\_readw() allows us to read at most 16-bit registers. There are
+other functions that can be used depending on the size of your device
+registers. See musb\_io.h for more information.
+
+Instruction on line 18 is another quirk specific to the JZ4740 USB
+device controller, which will be discussed later in `Chapter
+5 <#device-quirks>`__.
+
+The glue layer still needs to register the IRQ handler though. Remember
+the instruction on line 14 of the init function:
+
+::
+
+    static int jz4740_musb_init(struct musb *musb)
+    {
+	musb->isr = jz4740_musb_interrupt;
+
+	return 0;
+    }
+
+
+This instruction sets a pointer to the glue layer IRQ handler function,
+in order for the controller hardware to call the handler back when an
+IRQ comes from the controller hardware. The interrupt handler is now
+implemented and registered.
+
+Device Platform Data
+====================
+
+In order to write an MUSB glue layer, you need to have some data
+describing the hardware capabilities of your controller hardware, which
+is called the platform data.
+
+Platform data is specific to your hardware, though it may cover a broad
+range of devices, and is generally found somewhere in the arch/
+directory, depending on your device architecture.
+
+For instance, platform data for the JZ4740 SoC is found in
+arch/mips/jz4740/platform.c. In the platform.c file each device of the
+JZ4740 SoC is described through a set of structures.
+
+Here is the part of arch/mips/jz4740/platform.c that covers the USB
+Device Controller (UDC):
+
+::
+
+    /* USB Device Controller */
+    struct platform_device jz4740_udc_xceiv_device = {
+	.name = "usb_phy_gen_xceiv",
+	.id   = 0,
+    };
+
+    static struct resource jz4740_udc_resources[] = {
+	[0] = {
+	    .start = JZ4740_UDC_BASE_ADDR,
+	    .end   = JZ4740_UDC_BASE_ADDR + 0x10000 - 1,
+	    .flags = IORESOURCE_MEM,
+	},
+	[1] = {
+	    .start = JZ4740_IRQ_UDC,
+	    .end   = JZ4740_IRQ_UDC,
+	    .flags = IORESOURCE_IRQ,
+	    .name  = "mc",
+	},
+    };
+
+    struct platform_device jz4740_udc_device = {
+	.name = "musb-jz4740",
+	.id   = -1,
+	.dev  = {
+	    .dma_mask          = &jz4740_udc_device.dev.coherent_dma_mask,
+	    .coherent_dma_mask = DMA_BIT_MASK(32),
+	},
+	.num_resources = ARRAY_SIZE(jz4740_udc_resources),
+	.resource      = jz4740_udc_resources,
+    };
+
+
+The jz4740\_udc\_xceiv\_device platform device structure (line 2)
+describes the UDC transceiver with a name and id number.
+
+At the time of this writing, note that "usb\_phy\_gen\_xceiv" is the
+specific name to be used for all transceivers that are either built-in
+with reference USB IP or autonomous and doesn't require any PHY
+programming. You will need to set CONFIG\_NOP\_USB\_XCEIV=y in the
+kernel configuration to make use of the corresponding transceiver
+driver. The id field could be set to -1 (equivalent to
+PLATFORM\_DEVID\_NONE), -2 (equivalent to PLATFORM\_DEVID\_AUTO) or
+start with 0 for the first device of this kind if we want a specific id
+number.
+
+The jz4740\_udc\_resources resource structure (line 7) defines the UDC
+registers base addresses.
+
+The first array (line 9 to 11) defines the UDC registers base memory
+addresses: start points to the first register memory address, end points
+to the last register memory address and the flags member defines the
+type of resource we are dealing with. So IORESOURCE\_MEM is used to
+define the registers memory addresses. The second array (line 14 to 17)
+defines the UDC IRQ registers addresses. Since there is only one IRQ
+register available for the JZ4740 UDC, start and end point at the same
+address. The IORESOURCE\_IRQ flag tells that we are dealing with IRQ
+resources, and the name "mc" is in fact hard-coded in the MUSB core in
+order for the controller driver to retrieve this IRQ resource by
+querying it by its name.
+
+Finally, the jz4740\_udc\_device platform device structure (line 21)
+describes the UDC itself.
+
+The "musb-jz4740" name (line 22) defines the MUSB driver that is used
+for this device; remember this is in fact the name that we used in the
+jz4740\_driver platform driver structure in `Chapter
+2 <#linux-musb-basics>`__. The id field (line 23) is set to -1
+(equivalent to PLATFORM\_DEVID\_NONE) since we do not need an id for the
+device: the MUSB controller driver was already set to allocate an
+automatic id in `Chapter 2 <#linux-musb-basics>`__. In the dev field we
+care for DMA related information here. The dma\_mask field (line 25)
+defines the width of the DMA mask that is going to be used, and
+coherent\_dma\_mask (line 26) has the same purpose but for the
+alloc\_coherent DMA mappings: in both cases we are using a 32 bits mask.
+Then the resource field (line 29) is simply a pointer to the resource
+structure defined before, while the num\_resources field (line 28) keeps
+track of the number of arrays defined in the resource structure (in this
+case there were two resource arrays defined before).
+
+With this quick overview of the UDC platform data at the arch/ level now
+done, let's get back to the MUSB glue layer specific platform data in
+drivers/usb/musb/jz4740.c:
+
+::
+
+    static struct musb_hdrc_config jz4740_musb_config = {
+	/* Silicon does not implement USB OTG. */
+	.multipoint = 0,
+	/* Max EPs scanned, driver will decide which EP can be used. */
+	.num_eps    = 4,
+	/* RAMbits needed to configure EPs from table */
+	.ram_bits   = 9,
+	.fifo_cfg = jz4740_musb_fifo_cfg,
+	.fifo_cfg_size = ARRAY_SIZE(jz4740_musb_fifo_cfg),
+    };
+
+    static struct musb_hdrc_platform_data jz4740_musb_platform_data = {
+	.mode   = MUSB_PERIPHERAL,
+	.config = &jz4740_musb_config,
+    };
+
+
+First the glue layer configures some aspects of the controller driver
+operation related to the controller hardware specifics. This is done
+through the jz4740\_musb\_config musb\_hdrc\_config structure.
+
+Defining the OTG capability of the controller hardware, the multipoint
+member (line 3) is set to 0 (equivalent to false) since the JZ4740 UDC
+is not OTG compatible. Then num\_eps (line 5) defines the number of USB
+endpoints of the controller hardware, including endpoint 0: here we have
+3 endpoints + endpoint 0. Next is ram\_bits (line 7) which is the width
+of the RAM address bus for the MUSB controller hardware. This
+information is needed when the controller driver cannot automatically
+configure endpoints by reading the relevant controller hardware
+registers. This issue will be discussed when we get to device quirks in
+`Chapter 5 <#device-quirks>`__. Last two fields (line 8 and 9) are also
+about device quirks: fifo\_cfg points to the USB endpoints configuration
+table and fifo\_cfg\_size keeps track of the size of the number of
+entries in that configuration table. More on that later in `Chapter
+5 <#device-quirks>`__.
+
+Then this configuration is embedded inside jz4740\_musb\_platform\_data
+musb\_hdrc\_platform\_data structure (line 11): config is a pointer to
+the configuration structure itself, and mode tells the controller driver
+if the controller hardware may be used as MUSB\_HOST only,
+MUSB\_PERIPHERAL only or MUSB\_OTG which is a dual mode.
+
+Remember that jz4740\_musb\_platform\_data is then used to convey
+platform data information as we have seen in the probe function in
+`Chapter 2 <#linux-musb-basics>`__
+
+Device Quirks
+=============
+
+Completing the platform data specific to your device, you may also need
+to write some code in the glue layer to work around some device specific
+limitations. These quirks may be due to some hardware bugs, or simply be
+the result of an incomplete implementation of the USB On-the-Go
+specification.
+
+The JZ4740 UDC exhibits such quirks, some of which we will discuss here
+for the sake of insight even though these might not be found in the
+controller hardware you are working on.
+
+Let's get back to the init function first:
+
+::
+
+    static int jz4740_musb_init(struct musb *musb)
+    {
+	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+	if (!musb->xceiv) {
+	    pr_err("HS UDC: no transceiver configured\n");
+	    return -ENODEV;
+	}
+
+	/* Silicon does not implement ConfigData register.
+	 * Set dyn_fifo to avoid reading EP config from hardware.
+	 */
+	musb->dyn_fifo = true;
+
+	musb->isr = jz4740_musb_interrupt;
+
+	return 0;
+    }
+
+
+Instruction on line 12 helps the MUSB controller driver to work around
+the fact that the controller hardware is missing registers that are used
+for USB endpoints configuration.
+
+Without these registers, the controller driver is unable to read the
+endpoints configuration from the hardware, so we use line 12 instruction
+to bypass reading the configuration from silicon, and rely on a
+hard-coded table that describes the endpoints configuration instead:
+
+::
+
+    static struct musb_fifo_cfg jz4740_musb_fifo_cfg[] = {
+    { .hw_ep_num = 1, .style = FIFO_TX, .maxpacket = 512, },
+    { .hw_ep_num = 1, .style = FIFO_RX, .maxpacket = 512, },
+    { .hw_ep_num = 2, .style = FIFO_TX, .maxpacket = 64, },
+    };
+
+
+Looking at the configuration table above, we see that each endpoints is
+described by three fields: hw\_ep\_num is the endpoint number, style is
+its direction (either FIFO\_TX for the controller driver to send packets
+in the controller hardware, or FIFO\_RX to receive packets from
+hardware), and maxpacket defines the maximum size of each data packet
+that can be transmitted over that endpoint. Reading from the table, the
+controller driver knows that endpoint 1 can be used to send and receive
+USB data packets of 512 bytes at once (this is in fact a bulk in/out
+endpoint), and endpoint 2 can be used to send data packets of 64 bytes
+at once (this is in fact an interrupt endpoint).
+
+Note that there is no information about endpoint 0 here: that one is
+implemented by default in every silicon design, with a predefined
+configuration according to the USB specification. For more examples of
+endpoint configuration tables, see musb\_core.c.
+
+Let's now get back to the interrupt handler function:
+
+::
+
+    static irqreturn_t jz4740_musb_interrupt(int irq, void *__hci)
+    {
+	unsigned long   flags;
+	irqreturn_t     retval = IRQ_NONE;
+	struct musb     *musb = __hci;
+
+	spin_lock_irqsave(&musb->lock, flags);
+
+	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
+	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
+	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
+
+	/*
+	 * The controller is gadget only, the state of the host mode IRQ bits is
+	 * undefined. Mask them to make sure that the musb driver core will
+	 * never see them set
+	 */
+	musb->int_usb &= MUSB_INTR_SUSPEND | MUSB_INTR_RESUME |
+	    MUSB_INTR_RESET | MUSB_INTR_SOF;
+
+	if (musb->int_usb || musb->int_tx || musb->int_rx)
+	    retval = musb_interrupt(musb);
+
+	spin_unlock_irqrestore(&musb->lock, flags);
+
+	return retval;
+    }
+
+
+Instruction on line 18 above is a way for the controller driver to work
+around the fact that some interrupt bits used for USB host mode
+operation are missing in the MUSB\_INTRUSB register, thus left in an
+undefined hardware state, since this MUSB controller hardware is used in
+peripheral mode only. As a consequence, the glue layer masks these
+missing bits out to avoid parasite interrupts by doing a logical AND
+operation between the value read from MUSB\_INTRUSB and the bits that
+are actually implemented in the register.
+
+These are only a couple of the quirks found in the JZ4740 USB device
+controller. Some others were directly addressed in the MUSB core since
+the fixes were generic enough to provide a better handling of the issues
+for others controller hardware eventually.
+
+Conclusion
+==========
+
+Writing a Linux MUSB glue layer should be a more accessible task, as
+this documentation tries to show the ins and outs of this exercise.
+
+The JZ4740 USB device controller being fairly simple, I hope its glue
+layer serves as a good example for the curious mind. Used with the
+current MUSB glue layers, this documentation should provide enough
+guidance to get started; should anything gets out of hand, the linux-usb
+mailing list archive is another helpful resource to browse through.
+
+Acknowledgements
+================
+
+Many thanks to Lars-Peter Clausen and Maarten ter Huurne for answering
+my questions while I was writing the JZ4740 glue layer and for helping
+me out getting the code in good shape.
+
+I would also like to thank the Qi-Hardware community at large for its
+cheerful guidance and support.
+
+Resources
+=========
+
+USB Home Page: http://www.usb.org
+
+linux-usb Mailing List Archives: http://marc.info/?l=linux-usb
+
+USB On-the-Go Basics:
+http://www.maximintegrated.com/app-notes/index.mvp/id/1822
+
+Writing USB Device Drivers:
+https://www.kernel.org/doc/htmldocs/writing_usb_driver/index.html
+
+Texas Instruments USB Configuration Wiki Page:
+http://processors.wiki.ti.com/index.php/Usbgeneralpage
+
+Analog Devices Blackfin MUSB Configuration:
+http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:musb
diff --git a/Documentation/driver-api/usb/writing_usb_driver.rst b/Documentation/driver-api/usb/writing_usb_driver.rst
new file mode 100644
index 000000000000..48f2fdb4745b
--- /dev/null
+++ b/Documentation/driver-api/usb/writing_usb_driver.rst
@@ -0,0 +1,338 @@
+Introduction
+============
+
+The Linux USB subsystem has grown from supporting only two different
+types of devices in the 2.2.7 kernel (mice and keyboards), to over 20
+different types of devices in the 2.4 kernel. Linux currently supports
+almost all USB class devices (standard types of devices like keyboards,
+mice, modems, printers and speakers) and an ever-growing number of
+vendor-specific devices (such as USB to serial converters, digital
+cameras, Ethernet devices and MP3 players). For a full list of the
+different USB devices currently supported, see Resources.
+
+The remaining kinds of USB devices that do not have support on Linux are
+almost all vendor-specific devices. Each vendor decides to implement a
+custom protocol to talk to their device, so a custom driver usually
+needs to be created. Some vendors are open with their USB protocols and
+help with the creation of Linux drivers, while others do not publish
+them, and developers are forced to reverse-engineer. See Resources for
+some links to handy reverse-engineering tools.
+
+Because each different protocol causes a new driver to be created, I
+have written a generic USB driver skeleton, modelled after the
+pci-skeleton.c file in the kernel source tree upon which many PCI
+network drivers have been based. This USB skeleton can be found at
+drivers/usb/usb-skeleton.c in the kernel source tree. In this article I
+will walk through the basics of the skeleton driver, explaining the
+different pieces and what needs to be done to customize it to your
+specific device.
+
+Linux USB Basics
+================
+
+If you are going to write a Linux USB driver, please become familiar
+with the USB protocol specification. It can be found, along with many
+other useful documents, at the USB home page (see Resources). An
+excellent introduction to the Linux USB subsystem can be found at the
+USB Working Devices List (see Resources). It explains how the Linux USB
+subsystem is structured and introduces the reader to the concept of USB
+urbs (USB Request Blocks), which are essential to USB drivers.
+
+The first thing a Linux USB driver needs to do is register itself with
+the Linux USB subsystem, giving it some information about which devices
+the driver supports and which functions to call when a device supported
+by the driver is inserted or removed from the system. All of this
+information is passed to the USB subsystem in the usb\_driver structure.
+The skeleton driver declares a usb\_driver as:
+
+::
+
+    static struct usb_driver skel_driver = {
+	    .name        = "skeleton",
+	    .probe       = skel_probe,
+	    .disconnect  = skel_disconnect,
+	    .fops        = &skel_fops,
+	    .minor       = USB_SKEL_MINOR_BASE,
+	    .id_table    = skel_table,
+    };
+
+
+The variable name is a string that describes the driver. It is used in
+informational messages printed to the system log. The probe and
+disconnect function pointers are called when a device that matches the
+information provided in the id\_table variable is either seen or
+removed.
+
+The fops and minor variables are optional. Most USB drivers hook into
+another kernel subsystem, such as the SCSI, network or TTY subsystem.
+These types of drivers register themselves with the other kernel
+subsystem, and any user-space interactions are provided through that
+interface. But for drivers that do not have a matching kernel subsystem,
+such as MP3 players or scanners, a method of interacting with user space
+is needed. The USB subsystem provides a way to register a minor device
+number and a set of file\_operations function pointers that enable this
+user-space interaction. The skeleton driver needs this kind of
+interface, so it provides a minor starting number and a pointer to its
+file\_operations functions.
+
+The USB driver is then registered with a call to usb\_register, usually
+in the driver's init function, as shown here:
+
+::
+
+    static int __init usb_skel_init(void)
+    {
+	    int result;
+
+	    /* register this driver with the USB subsystem */
+	    result = usb_register(&skel_driver);
+	    if (result < 0) {
+		    err("usb_register failed for the "__FILE__ "driver."
+			"Error number %d", result);
+		    return -1;
+	    }
+
+	    return 0;
+    }
+    module_init(usb_skel_init);
+
+
+When the driver is unloaded from the system, it needs to deregister
+itself with the USB subsystem. This is done with the usb\_deregister
+function:
+
+::
+
+    static void __exit usb_skel_exit(void)
+    {
+	    /* deregister this driver with the USB subsystem */
+	    usb_deregister(&skel_driver);
+    }
+    module_exit(usb_skel_exit);
+
+
+To enable the linux-hotplug system to load the driver automatically when
+the device is plugged in, you need to create a MODULE\_DEVICE\_TABLE.
+The following code tells the hotplug scripts that this module supports a
+single device with a specific vendor and product ID:
+
+::
+
+    /* table of devices that work with this driver */
+    static struct usb_device_id skel_table [] = {
+	    { USB_DEVICE(USB_SKEL_VENDOR_ID, USB_SKEL_PRODUCT_ID) },
+	    { }                      /* Terminating entry */
+    };
+    MODULE_DEVICE_TABLE (usb, skel_table);
+
+
+There are other macros that can be used in describing a usb\_device\_id
+for drivers that support a whole class of USB drivers. See usb.h for
+more information on this.
+
+Device operation
+================
+
+When a device is plugged into the USB bus that matches the device ID
+pattern that your driver registered with the USB core, the probe
+function is called. The usb\_device structure, interface number and the
+interface ID are passed to the function:
+
+::
+
+    static int skel_probe(struct usb_interface *interface,
+	const struct usb_device_id *id)
+
+
+The driver now needs to verify that this device is actually one that it
+can accept. If so, it returns 0. If not, or if any error occurs during
+initialization, an errorcode (such as ``-ENOMEM`` or ``-ENODEV``) is
+returned from the probe function.
+
+In the skeleton driver, we determine what end points are marked as
+bulk-in and bulk-out. We create buffers to hold the data that will be
+sent and received from the device, and a USB urb to write data to the
+device is initialized.
+
+Conversely, when the device is removed from the USB bus, the disconnect
+function is called with the device pointer. The driver needs to clean
+any private data that has been allocated at this time and to shut down
+any pending urbs that are in the USB system.
+
+Now that the device is plugged into the system and the driver is bound
+to the device, any of the functions in the file\_operations structure
+that were passed to the USB subsystem will be called from a user program
+trying to talk to the device. The first function called will be open, as
+the program tries to open the device for I/O. We increment our private
+usage count and save a pointer to our internal structure in the file
+structure. This is done so that future calls to file operations will
+enable the driver to determine which device the user is addressing. All
+of this is done with the following code:
+
+::
+
+    /* increment our usage count for the module */
+    ++skel->open_count;
+
+    /* save our object in the file's private structure */
+    file->private_data = dev;
+
+
+After the open function is called, the read and write functions are
+called to receive and send data to the device. In the skel\_write
+function, we receive a pointer to some data that the user wants to send
+to the device and the size of the data. The function determines how much
+data it can send to the device based on the size of the write urb it has
+created (this size depends on the size of the bulk out end point that
+the device has). Then it copies the data from user space to kernel
+space, points the urb to the data and submits the urb to the USB
+subsystem. This can be seen in the following code:
+
+::
+
+    /* we can only write as much as 1 urb will hold */
+    bytes_written = (count > skel->bulk_out_size) ? skel->bulk_out_size : count;
+
+    /* copy the data from user space into our urb */
+    copy_from_user(skel->write_urb->transfer_buffer, buffer, bytes_written);
+
+    /* set up our urb */
+    usb_fill_bulk_urb(skel->write_urb,
+		      skel->dev,
+		      usb_sndbulkpipe(skel->dev, skel->bulk_out_endpointAddr),
+		      skel->write_urb->transfer_buffer,
+		      bytes_written,
+		      skel_write_bulk_callback,
+		      skel);
+
+    /* send the data out the bulk port */
+    result = usb_submit_urb(skel->write_urb);
+    if (result) {
+	    err("Failed submitting write urb, error %d", result);
+    }
+
+
+When the write urb is filled up with the proper information using the
+usb\_fill\_bulk\_urb function, we point the urb's completion callback to
+call our own skel\_write\_bulk\_callback function. This function is
+called when the urb is finished by the USB subsystem. The callback
+function is called in interrupt context, so caution must be taken not to
+do very much processing at that time. Our implementation of
+skel\_write\_bulk\_callback merely reports if the urb was completed
+successfully or not and then returns.
+
+The read function works a bit differently from the write function in
+that we do not use an urb to transfer data from the device to the
+driver. Instead we call the usb\_bulk\_msg function, which can be used
+to send or receive data from a device without having to create urbs and
+handle urb completion callback functions. We call the usb\_bulk\_msg
+function, giving it a buffer into which to place any data received from
+the device and a timeout value. If the timeout period expires without
+receiving any data from the device, the function will fail and return an
+error message. This can be shown with the following code:
+
+::
+
+    /* do an immediate bulk read to get data from the device */
+    retval = usb_bulk_msg (skel->dev,
+			   usb_rcvbulkpipe (skel->dev,
+			   skel->bulk_in_endpointAddr),
+			   skel->bulk_in_buffer,
+			   skel->bulk_in_size,
+			   &count, HZ*10);
+    /* if the read was successful, copy the data to user space */
+    if (!retval) {
+	    if (copy_to_user (buffer, skel->bulk_in_buffer, count))
+		    retval = -EFAULT;
+	    else
+		    retval = count;
+    }
+
+
+The usb\_bulk\_msg function can be very useful for doing single reads or
+writes to a device; however, if you need to read or write constantly to
+a device, it is recommended to set up your own urbs and submit them to
+the USB subsystem.
+
+When the user program releases the file handle that it has been using to
+talk to the device, the release function in the driver is called. In
+this function we decrement our private usage count and wait for possible
+pending writes:
+
+::
+
+    /* decrement our usage count for the device */
+    --skel->open_count;
+
+
+One of the more difficult problems that USB drivers must be able to
+handle smoothly is the fact that the USB device may be removed from the
+system at any point in time, even if a program is currently talking to
+it. It needs to be able to shut down any current reads and writes and
+notify the user-space programs that the device is no longer there. The
+following code (function ``skel_delete``) is an example of how to do
+this:
+
+::
+
+    static inline void skel_delete (struct usb_skel *dev)
+    {
+	kfree (dev->bulk_in_buffer);
+	if (dev->bulk_out_buffer != NULL)
+	    usb_free_coherent (dev->udev, dev->bulk_out_size,
+		dev->bulk_out_buffer,
+		dev->write_urb->transfer_dma);
+	usb_free_urb (dev->write_urb);
+	kfree (dev);
+    }
+
+
+If a program currently has an open handle to the device, we reset the
+flag ``device_present``. For every read, write, release and other
+functions that expect a device to be present, the driver first checks
+this flag to see if the device is still present. If not, it releases
+that the device has disappeared, and a -ENODEV error is returned to the
+user-space program. When the release function is eventually called, it
+determines if there is no device and if not, it does the cleanup that
+the skel\_disconnect function normally does if there are no open files
+on the device (see Listing 5).
+
+Isochronous Data
+================
+
+This usb-skeleton driver does not have any examples of interrupt or
+isochronous data being sent to or from the device. Interrupt data is
+sent almost exactly as bulk data is, with a few minor exceptions.
+Isochronous data works differently with continuous streams of data being
+sent to or from the device. The audio and video camera drivers are very
+good examples of drivers that handle isochronous data and will be useful
+if you also need to do this.
+
+Conclusion
+==========
+
+Writing Linux USB device drivers is not a difficult task as the
+usb-skeleton driver shows. This driver, combined with the other current
+USB drivers, should provide enough examples to help a beginning author
+create a working driver in a minimal amount of time. The linux-usb-devel
+mailing list archives also contain a lot of helpful information.
+
+Resources
+=========
+
+The Linux USB Project:
+`http://www.linux-usb.org/ <http://www.linux-usb.org>`__
+
+Linux Hotplug Project:
+`http://linux-hotplug.sourceforge.net/ <http://linux-hotplug.sourceforge.net>`__
+
+Linux USB Working Devices List:
+`http://www.qbik.ch/usb/devices/ <http://www.qbik.ch/usb/devices>`__
+
+linux-usb-devel Mailing List Archives:
+http://marc.theaimsgroup.com/?l=linux-usb-devel
+
+Programming Guide for Linux USB Device Drivers:
+http://usb.cs.tum.edu/usbdoc
+
+USB Home Page: http://www.usb.org
-- 
2.9.3
