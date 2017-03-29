Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38047 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753213AbdC2Syd (ORCPT
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
Subject: [PATCH 06/22] writing_musb_glue_layer.rst: Enrich its ReST representation
Date: Wed, 29 Mar 2017 15:54:05 -0300
Message-Id: <b233125aa76ba6027d5baf8af2a32ed0d23e6bf7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is actually quite complex, and required several
manual handwork:

- add a title for the document;
- use the right tags for monospaced fonts;
- use c references where needed;
- adjust cross-reference to writing_usb_driver.rst
- hightlight cross-referenced lines.

With regards to C code snippet line highlights, the better would be
to use :linenos: for the C code snippets that are referenced by
the line number. However, at least with Sphinx 1.4.9, enabling
it cause the line number to be misaligned with the code,
making it even more confusing. So, instead, let's use
:emphasize-lines: tag to mark the lines that are referenced
at the text.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../driver-api/usb/writing_musb_glue_layer.rst     | 251 ++++++++++-----------
 1 file changed, 120 insertions(+), 131 deletions(-)

diff --git a/Documentation/driver-api/usb/writing_musb_glue_layer.rst b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
index 2546a102394f..89333a69d4ba 100644
--- a/Documentation/driver-api/usb/writing_musb_glue_layer.rst
+++ b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
@@ -1,3 +1,6 @@
+Writing MUSB Glue Layer
+~~~~~~~~~~~~~~~~~~~~~~~
+
 Introduction
 ============
 
@@ -15,10 +18,12 @@ design.
 As a self-taught exercise I have written an MUSB glue layer for the
 Ingenic JZ4740 SoC, modelled after the many MUSB glue layers in the
 kernel source tree. This layer can be found at
-drivers/usb/musb/jz4740.c. In this documentation I will walk through the
-basics of the jz4740.c glue layer, explaining the different pieces and
+``drivers/usb/musb/jz4740.c``. In this documentation I will walk through the
+basics of the ``jz4740.c`` glue layer, explaining the different pieces and
 what needs to be done in order to write your own device glue layer.
 
+.. _musb-basics:
+
 Linux MUSB Basics
 =================
 
@@ -33,9 +38,7 @@ USB Device Drivers documentation (again, see Resources).
 
 Linux USB stack is a layered architecture in which the MUSB controller
 hardware sits at the lowest. The MUSB controller driver abstract the
-MUSB controller hardware to the Linux USB stack.
-
-::
+MUSB controller hardware to the Linux USB stack::
 
 	  ------------------------
 	  |                      | <------- drivers/usb/gadget
@@ -59,7 +62,6 @@ MUSB controller hardware to the Linux USB stack.
       |   MUSB Controller Hardware    |
       ---------------------------------
 
-
 As outlined above, the glue layer is actually the platform specific code
 sitting in between the controller driver and the controller hardware.
 
@@ -72,9 +74,7 @@ about an embedded controller chip here, so no insertion or removal at
 run-time.
 
 All of this information is passed to the MUSB controller driver through
-a platform\_driver structure defined in the glue layer as:
-
-::
+a :c:type:`platform_driver` structure defined in the glue layer as::
 
     static struct platform_driver jz4740_driver = {
 	.probe      = jz4740_probe,
@@ -84,20 +84,17 @@ a platform\_driver structure defined in the glue layer as:
 	},
     };
 
-
 The probe and remove function pointers are called when a matching device
 is detected and, respectively, released. The name string describes the
 device supported by this glue layer. In the current case it matches a
-platform\_device structure declared in arch/mips/jz4740/platform.c. Note
+platform_device structure declared in ``arch/mips/jz4740/platform.c``. Note
 that we are not using device tree bindings here.
 
 In order to register itself to the controller driver, the glue layer
 goes through a few steps, basically allocating the controller hardware
 resources and initialising a couple of circuits. To do so, it needs to
 keep track of the information used throughout these steps. This is done
-by defining a private jz4740\_glue structure:
-
-::
+by defining a private ``jz4740_glue`` structure::
 
     struct jz4740_glue {
 	struct device           *dev;
@@ -115,10 +112,13 @@ information related to the device clock operation.
 Let's go through the steps of the probe function that leads the glue
 layer to register itself to the controller driver.
 
-N.B.: For the sake of readability each function will be split in logical
-parts, each part being shown as if it was independent from the others.
+.. note::
 
-::
+   For the sake of readability each function will be split in logical
+   parts, each part being shown as if it was independent from the others:
+
+   .. code-block:: c
+    :emphasize-lines: 8,12,18
 
     static int jz4740_probe(struct platform_device *pdev)
     {
@@ -163,21 +163,23 @@ parts, each part being shown as if it was independent from the others.
 	return ret;
     }
 
+   The first few lines of the probe function allocate and assign the glue,
+   musb and clk variables. The ``GFP_KERNEL`` flag (line 8) allows the
+   allocation process to sleep and wait for memory, thus being usable in a
+   locking situation. The ``PLATFORM_DEVID_AUTO`` flag (line 12) allows
+   automatic allocation and management of device IDs in order to avoid
+   device namespace collisions with explicit IDs. With :c:func:`devm_clk_get`
+   (line 18) the glue layer allocates the clock -- the ``devm_`` prefix
+   indicates that :c:func:`clk_get` is managed: it automatically frees the
+   allocated clock resource data when the device is released -- and enable
+   it.
+
 
-The first few lines of the probe function allocate and assign the glue,
-musb and clk variables. The GFP\_KERNEL flag (line 8) allows the
-allocation process to sleep and wait for memory, thus being usable in a
-blocking situation. The PLATFORM\_DEVID\_AUTO flag (line 12) allows
-automatic allocation and management of device IDs in order to avoid
-device namespace collisions with explicit IDs. With devm\_clk\_get()
-(line 18) the glue layer allocates the clock -- the ``devm_`` prefix
-indicates that clk\_get() is managed: it automatically frees the
-allocated clock resource data when the device is released -- and enable
-it.
 
 Then comes the registration steps:
 
-::
+.. code-block:: c
+    :emphasize-lines: 3,5,7,9,16
 
     static int jz4740_probe(struct platform_device *pdev)
     {
@@ -209,27 +211,23 @@ Then comes the registration steps:
 	return ret;
     }
 
-
 The first step is to pass the device data privately held by the glue
-layer on to the controller driver through platform\_set\_drvdata() (line
-7). Next is passing on the device resources information, also privately
-held at that point, through platform\_device\_add\_resources() (line 9).
+layer on to the controller driver through :c:func:`platform_set_drvdata`
+(line 7). Next is passing on the device resources information, also privately
+held at that point, through :c:func:`platform_device_add_resources` (line 9).
 
 Finally comes passing on the platform specific data to the controller
-driver (line 16). Platform data will be discussed in `Chapter
-4 <#device-platform-data>`__, but here we are looking at the
-platform\_ops function pointer (line 5) in musb\_hdrc\_platform\_data
+driver (line 16). Platform data will be discussed in
+:ref:`musb-dev-platform-data`, but here we are looking at the
+``platform_ops`` function pointer (line 5) in ``musb_hdrc_platform_data``
 structure (line 3). This function pointer allows the MUSB controller
-driver to know which function to call for device operation:
-
-::
+driver to know which function to call for device operation::
 
     static const struct musb_platform_ops jz4740_musb_ops = {
 	.init       = jz4740_musb_init,
 	.exit       = jz4740_musb_exit,
     };
 
-
 Here we have the minimal case where only init and exit functions are
 called by the controller driver when needed. Fact is the JZ4740 MUSB
 controller is a basic controller, lacking some features found in other
@@ -240,7 +238,8 @@ between OTG and non-OTG modes, for instance.
 At that point of the registration process, the controller driver
 actually calls the init function:
 
-::
+   .. code-block:: c
+    :emphasize-lines: 12,14
 
     static int jz4740_musb_init(struct musb *musb)
     {
@@ -260,22 +259,19 @@ actually calls the init function:
 	return 0;
     }
 
-
-The goal of jz4740\_musb\_init() is to get hold of the transceiver
+The goal of ``jz4740_musb_init()`` is to get hold of the transceiver
 driver data of the MUSB controller hardware and pass it on to the MUSB
 controller driver, as usual. The transceiver is the circuitry inside the
 controller hardware responsible for sending/receiving the USB data.
 Since it is an implementation of the physical layer of the OSI model,
 the transceiver is also referred to as PHY.
 
-Getting hold of the MUSB PHY driver data is done with usb\_get\_phy()
+Getting hold of the ``MUSB PHY`` driver data is done with ``usb_get_phy()``
 which returns a pointer to the structure containing the driver instance
 data. The next couple of instructions (line 12 and 14) are used as a
 quirk and to setup IRQ handling respectively. Quirks and IRQ handling
-will be discussed later in `Chapter 5 <#device-quirks>`__ and `Chapter
-3 <#handling-irqs>`__.
-
-::
+will be discussed later in :ref:`musb-dev-quirks` and
+:ref:`musb-handling-irqs`\ ::
 
     static int jz4740_musb_exit(struct musb *musb)
     {
@@ -284,7 +280,6 @@ will be discussed later in `Chapter 5 <#device-quirks>`__ and `Chapter
 	return 0;
     }
 
-
 Acting as the counterpart of init, the exit function releases the MUSB
 PHY driver when the controller hardware itself is about to be released.
 
@@ -294,9 +289,7 @@ musb glue layer for a more complex controller hardware, you might need
 to take care of more processing in those two functions.
 
 Returning from the init function, the MUSB controller driver jumps back
-into the probe function:
-
-::
+into the probe function::
 
     static int jz4740_probe(struct platform_device *pdev)
     {
@@ -315,13 +308,13 @@ into the probe function:
 	return ret;
     }
 
-
 This is the last part of the device registration process where the glue
 layer adds the controller hardware device to Linux kernel device
 hierarchy: at this stage, all known information about the device is
-passed on to the Linux USB core stack.
+passed on to the Linux USB core stack:
 
-::
+   .. code-block:: c
+    :emphasize-lines: 5,6
 
     static int jz4740_remove(struct platform_device *pdev)
     {
@@ -333,18 +326,20 @@ passed on to the Linux USB core stack.
 	return 0;
     }
 
-
 Acting as the counterpart of probe, the remove function unregister the
 MUSB controller hardware (line 5) and disable the clock (line 6),
 allowing it to be gated.
 
+.. _musb-handling-irqs:
+
 Handling IRQs
 =============
 
 Additionally to the MUSB controller hardware basic setup and
 registration, the glue layer is also responsible for handling the IRQs:
 
-::
+   .. code-block:: c
+    :emphasize-lines: 7,9-11,14,24
 
     static irqreturn_t jz4740_musb_interrupt(int irq, void *__hci)
     {
@@ -374,39 +369,35 @@ registration, the glue layer is also responsible for handling the IRQs:
 	return retval;
     }
 
-
 Here the glue layer mostly has to read the relevant hardware registers
 and pass their values on to the controller driver which will handle the
 actual event that triggered the IRQ.
 
 The interrupt handler critical section is protected by the
-spin\_lock\_irqsave() and counterpart spin\_unlock\_irqrestore()
+:c:func:`spin_lock_irqsave` and counterpart :c:func:`spin_unlock_irqrestore`
 functions (line 7 and 24 respectively), which prevent the interrupt
 handler code to be run by two different threads at the same time.
 
 Then the relevant interrupt registers are read (line 9 to 11):
 
--  MUSB\_INTRUSB: indicates which USB interrupts are currently active,
+-  ``MUSB_INTRUSB``: indicates which USB interrupts are currently active,
 
--  MUSB\_INTRTX: indicates which of the interrupts for TX endpoints are
+-  ``MUSB_INTRTX``: indicates which of the interrupts for TX endpoints are
    currently active,
 
--  MUSB\_INTRRX: indicates which of the interrupts for TX endpoints are
+-  ``MUSB_INTRRX``: indicates which of the interrupts for TX endpoints are
    currently active.
 
-Note that musb\_readb() is used to read 8-bit registers at most, while
-musb\_readw() allows us to read at most 16-bit registers. There are
+Note that :c:func:`musb_readb` is used to read 8-bit registers at most, while
+:c:func:`musb_readw` allows us to read at most 16-bit registers. There are
 other functions that can be used depending on the size of your device
-registers. See musb\_io.h for more information.
+registers. See ``musb_io.h`` for more information.
 
 Instruction on line 18 is another quirk specific to the JZ4740 USB
-device controller, which will be discussed later in `Chapter
-5 <#device-quirks>`__.
+device controller, which will be discussed later in :ref:`musb-dev-quirks`.
 
 The glue layer still needs to register the IRQ handler though. Remember
-the instruction on line 14 of the init function:
-
-::
+the instruction on line 14 of the init function::
 
     static int jz4740_musb_init(struct musb *musb)
     {
@@ -415,12 +406,13 @@ the instruction on line 14 of the init function:
 	return 0;
     }
 
-
 This instruction sets a pointer to the glue layer IRQ handler function,
 in order for the controller hardware to call the handler back when an
 IRQ comes from the controller hardware. The interrupt handler is now
 implemented and registered.
 
+.. _musb-dev-platform-data:
+
 Device Platform Data
 ====================
 
@@ -429,17 +421,18 @@ describing the hardware capabilities of your controller hardware, which
 is called the platform data.
 
 Platform data is specific to your hardware, though it may cover a broad
-range of devices, and is generally found somewhere in the arch/
+range of devices, and is generally found somewhere in the ``arch/``
 directory, depending on your device architecture.
 
 For instance, platform data for the JZ4740 SoC is found in
-arch/mips/jz4740/platform.c. In the platform.c file each device of the
+``arch/mips/jz4740/platform.c``. In the ``platform.c`` file each device of the
 JZ4740 SoC is described through a set of structures.
 
-Here is the part of arch/mips/jz4740/platform.c that covers the USB
+Here is the part of ``arch/mips/jz4740/platform.c`` that covers the USB
 Device Controller (UDC):
 
-::
+   .. code-block:: c
+    :emphasize-lines: 2,7,14-17,21,22,25,26,28,29
 
     /* USB Device Controller */
     struct platform_device jz4740_udc_xceiv_device = {
@@ -472,59 +465,58 @@ Device Controller (UDC):
 	.resource      = jz4740_udc_resources,
     };
 
-
-The jz4740\_udc\_xceiv\_device platform device structure (line 2)
+The ``jz4740_udc_xceiv_device`` platform device structure (line 2)
 describes the UDC transceiver with a name and id number.
 
-At the time of this writing, note that "usb\_phy\_gen\_xceiv" is the
+At the time of this writing, note that ``usb_phy_gen_xceiv`` is the
 specific name to be used for all transceivers that are either built-in
 with reference USB IP or autonomous and doesn't require any PHY
-programming. You will need to set CONFIG\_NOP\_USB\_XCEIV=y in the
+programming. You will need to set ``CONFIG_NOP_USB_XCEIV=y`` in the
 kernel configuration to make use of the corresponding transceiver
 driver. The id field could be set to -1 (equivalent to
-PLATFORM\_DEVID\_NONE), -2 (equivalent to PLATFORM\_DEVID\_AUTO) or
+``PLATFORM_DEVID_NONE``), -2 (equivalent to ``PLATFORM_DEVID_AUTO``) or
 start with 0 for the first device of this kind if we want a specific id
 number.
 
-The jz4740\_udc\_resources resource structure (line 7) defines the UDC
+The ``jz4740_udc_resources`` resource structure (line 7) defines the UDC
 registers base addresses.
 
 The first array (line 9 to 11) defines the UDC registers base memory
 addresses: start points to the first register memory address, end points
 to the last register memory address and the flags member defines the
-type of resource we are dealing with. So IORESOURCE\_MEM is used to
+type of resource we are dealing with. So ``IORESOURCE_MEM`` is used to
 define the registers memory addresses. The second array (line 14 to 17)
 defines the UDC IRQ registers addresses. Since there is only one IRQ
 register available for the JZ4740 UDC, start and end point at the same
-address. The IORESOURCE\_IRQ flag tells that we are dealing with IRQ
-resources, and the name "mc" is in fact hard-coded in the MUSB core in
+address. The ``IORESOURCE_IRQ`` flag tells that we are dealing with IRQ
+resources, and the name ``mc`` is in fact hard-coded in the MUSB core in
 order for the controller driver to retrieve this IRQ resource by
 querying it by its name.
 
-Finally, the jz4740\_udc\_device platform device structure (line 21)
+Finally, the ``jz4740_udc_device`` platform device structure (line 21)
 describes the UDC itself.
 
-The "musb-jz4740" name (line 22) defines the MUSB driver that is used
+The ``musb-jz4740`` name (line 22) defines the MUSB driver that is used
 for this device; remember this is in fact the name that we used in the
-jz4740\_driver platform driver structure in `Chapter
-2 <#linux-musb-basics>`__. The id field (line 23) is set to -1
-(equivalent to PLATFORM\_DEVID\_NONE) since we do not need an id for the
-device: the MUSB controller driver was already set to allocate an
-automatic id in `Chapter 2 <#linux-musb-basics>`__. In the dev field we
-care for DMA related information here. The dma\_mask field (line 25)
+``jz4740_driver`` platform driver structure in :ref:`musb-basics`.
+The id field (line 23) is set to -1 (equivalent to ``PLATFORM_DEVID_NONE``)
+since we do not need an id for the device: the MUSB controller driver was
+already set to allocate an automatic id in :ref:`musb-basics`. In the dev field
+we care for DMA related information here. The ``dma_mask`` field (line 25)
 defines the width of the DMA mask that is going to be used, and
-coherent\_dma\_mask (line 26) has the same purpose but for the
-alloc\_coherent DMA mappings: in both cases we are using a 32 bits mask.
+``coherent_dma_mask`` (line 26) has the same purpose but for the
+``alloc_coherent`` DMA mappings: in both cases we are using a 32 bits mask.
 Then the resource field (line 29) is simply a pointer to the resource
-structure defined before, while the num\_resources field (line 28) keeps
+structure defined before, while the ``num_resources`` field (line 28) keeps
 track of the number of arrays defined in the resource structure (in this
 case there were two resource arrays defined before).
 
-With this quick overview of the UDC platform data at the arch/ level now
+With this quick overview of the UDC platform data at the ``arch/`` level now
 done, let's get back to the MUSB glue layer specific platform data in
-drivers/usb/musb/jz4740.c:
+``drivers/usb/musb/jz4740.c``:
 
-::
+   .. code-block:: c
+    :emphasize-lines: 3,5,7-9,11
 
     static struct musb_hdrc_config jz4740_musb_config = {
 	/* Silicon does not implement USB OTG. */
@@ -542,35 +534,36 @@ drivers/usb/musb/jz4740.c:
 	.config = &jz4740_musb_config,
     };
 
-
 First the glue layer configures some aspects of the controller driver
 operation related to the controller hardware specifics. This is done
-through the jz4740\_musb\_config musb\_hdrc\_config structure.
+through the ``jz4740_musb_config`` :c:type:`musb_hdrc_config` structure.
 
 Defining the OTG capability of the controller hardware, the multipoint
 member (line 3) is set to 0 (equivalent to false) since the JZ4740 UDC
-is not OTG compatible. Then num\_eps (line 5) defines the number of USB
+is not OTG compatible. Then ``num_eps`` (line 5) defines the number of USB
 endpoints of the controller hardware, including endpoint 0: here we have
-3 endpoints + endpoint 0. Next is ram\_bits (line 7) which is the width
+3 endpoints + endpoint 0. Next is ``ram_bits`` (line 7) which is the width
 of the RAM address bus for the MUSB controller hardware. This
 information is needed when the controller driver cannot automatically
 configure endpoints by reading the relevant controller hardware
 registers. This issue will be discussed when we get to device quirks in
-`Chapter 5 <#device-quirks>`__. Last two fields (line 8 and 9) are also
-about device quirks: fifo\_cfg points to the USB endpoints configuration
-table and fifo\_cfg\_size keeps track of the size of the number of
-entries in that configuration table. More on that later in `Chapter
-5 <#device-quirks>`__.
+:ref:`musb-dev-quirks`. Last two fields (line 8 and 9) are also
+about device quirks: ``fifo_cfg`` points to the USB endpoints configuration
+table and ``fifo_cfg_size`` keeps track of the size of the number of
+entries in that configuration table. More on that later in
+:ref:`musb-dev-quirks`.
 
-Then this configuration is embedded inside jz4740\_musb\_platform\_data
-musb\_hdrc\_platform\_data structure (line 11): config is a pointer to
+Then this configuration is embedded inside ``jz4740_musb_platform_data``
+:c:type:`musb_hdrc_platform_data` structure (line 11): config is a pointer to
 the configuration structure itself, and mode tells the controller driver
-if the controller hardware may be used as MUSB\_HOST only,
-MUSB\_PERIPHERAL only or MUSB\_OTG which is a dual mode.
+if the controller hardware may be used as ``MUSB_HOST`` only,
+``MUSB_PERIPHERAL`` only or ``MUSB_OTG`` which is a dual mode.
 
-Remember that jz4740\_musb\_platform\_data is then used to convey
+Remember that ``jz4740_musb_platform_data`` is then used to convey
 platform data information as we have seen in the probe function in
-`Chapter 2 <#linux-musb-basics>`__
+:ref:`musb-basics`.
+
+.. _musb-dev-quirks:
 
 Device Quirks
 =============
@@ -587,7 +580,8 @@ controller hardware you are working on.
 
 Let's get back to the init function first:
 
-::
+   .. code-block:: c
+    :emphasize-lines: 12
 
     static int jz4740_musb_init(struct musb *musb)
     {
@@ -607,7 +601,6 @@ Let's get back to the init function first:
 	return 0;
     }
 
-
 Instruction on line 12 helps the MUSB controller driver to work around
 the fact that the controller hardware is missing registers that are used
 for USB endpoints configuration.
@@ -615,21 +608,18 @@ for USB endpoints configuration.
 Without these registers, the controller driver is unable to read the
 endpoints configuration from the hardware, so we use line 12 instruction
 to bypass reading the configuration from silicon, and rely on a
-hard-coded table that describes the endpoints configuration instead:
-
-::
+hard-coded table that describes the endpoints configuration instead::
 
     static struct musb_fifo_cfg jz4740_musb_fifo_cfg[] = {
-    { .hw_ep_num = 1, .style = FIFO_TX, .maxpacket = 512, },
-    { .hw_ep_num = 1, .style = FIFO_RX, .maxpacket = 512, },
-    { .hw_ep_num = 2, .style = FIFO_TX, .maxpacket = 64, },
+	{ .hw_ep_num = 1, .style = FIFO_TX, .maxpacket = 512, },
+	{ .hw_ep_num = 1, .style = FIFO_RX, .maxpacket = 512, },
+	{ .hw_ep_num = 2, .style = FIFO_TX, .maxpacket = 64, },
     };
 
-
 Looking at the configuration table above, we see that each endpoints is
-described by three fields: hw\_ep\_num is the endpoint number, style is
-its direction (either FIFO\_TX for the controller driver to send packets
-in the controller hardware, or FIFO\_RX to receive packets from
+described by three fields: ``hw_ep_num`` is the endpoint number, style is
+its direction (either ``FIFO_TX`` for the controller driver to send packets
+in the controller hardware, or ``FIFO_RX`` to receive packets from
 hardware), and maxpacket defines the maximum size of each data packet
 that can be transmitted over that endpoint. Reading from the table, the
 controller driver knows that endpoint 1 can be used to send and receive
@@ -640,11 +630,12 @@ at once (this is in fact an interrupt endpoint).
 Note that there is no information about endpoint 0 here: that one is
 implemented by default in every silicon design, with a predefined
 configuration according to the USB specification. For more examples of
-endpoint configuration tables, see musb\_core.c.
+endpoint configuration tables, see ``musb_core.c``.
 
 Let's now get back to the interrupt handler function:
 
-::
+   .. code-block:: c
+    :emphasize-lines: 18-19
 
     static irqreturn_t jz4740_musb_interrupt(int irq, void *__hci)
     {
@@ -674,14 +665,13 @@ Let's now get back to the interrupt handler function:
 	return retval;
     }
 
-
 Instruction on line 18 above is a way for the controller driver to work
 around the fact that some interrupt bits used for USB host mode
-operation are missing in the MUSB\_INTRUSB register, thus left in an
+operation are missing in the ``MUSB_INTRUSB`` register, thus left in an
 undefined hardware state, since this MUSB controller hardware is used in
 peripheral mode only. As a consequence, the glue layer masks these
 missing bits out to avoid parasite interrupts by doing a logical AND
-operation between the value read from MUSB\_INTRUSB and the bits that
+operation between the value read from ``MUSB_INTRUSB`` and the bits that
 are actually implemented in the register.
 
 These are only a couple of the quirks found in the JZ4740 USB device
@@ -721,8 +711,7 @@ linux-usb Mailing List Archives: http://marc.info/?l=linux-usb
 USB On-the-Go Basics:
 http://www.maximintegrated.com/app-notes/index.mvp/id/1822
 
-Writing USB Device Drivers:
-https://www.kernel.org/doc/htmldocs/writing_usb_driver/index.html
+:ref:`Writing USB Device Drivers <writing-usb-driver>`
 
 Texas Instruments USB Configuration Wiki Page:
 http://processors.wiki.ti.com/index.php/Usbgeneralpage
-- 
2.9.3
