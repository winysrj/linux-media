Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54386
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751833AbdIWTnm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:43:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] media: rc-core.rst: add an introduction for RC core
Date: Sat, 23 Sep 2017 16:43:34 -0300
Message-Id: <30ff1c93d77ab1fd6e8a3403f86feba5358204aa.1506195810.git.mchehab@s-opensource.com>
In-Reply-To: <b9e7680dfaec02a007ccfc883be1d95712051d1f.1506195810.git.mchehab@s-opensource.com>
References: <b9e7680dfaec02a007ccfc883be1d95712051d1f.1506195810.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <b9e7680dfaec02a007ccfc883be1d95712051d1f.1506195810.git.mchehab@s-opensource.com>
References: <b9e7680dfaec02a007ccfc883be1d95712051d1f.1506195810.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RC core does several assumptions, but those aren't documented
anywhere, with could make harder for ones that want to understand
what's there.

So, add an introduction explaining the basic concepts of RC and
how they're related to the RC core implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/rc-core.rst | 77 ++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/Documentation/media/kapi/rc-core.rst b/Documentation/media/kapi/rc-core.rst
index a45895886257..355c8ea3ad9f 100644
--- a/Documentation/media/kapi/rc-core.rst
+++ b/Documentation/media/kapi/rc-core.rst
@@ -4,6 +4,83 @@ Remote Controller devices
 Remote Controller core
 ~~~~~~~~~~~~~~~~~~~~~~
 
+The remote controller core implements infrastructure to receive and send
+remote controller keyboard keystrokes and mouse events.
+
+Every time a key is pressed on a remote controller, a scan code is produced.
+Also, on most hardware, keeping a key pressed for more than a few dozens of
+milliseconds produce a repeat key event. That's somewhat similar to what
+a normal keyboard or mouse is handled internally on Linux\ [#f1]_. So, the
+remote controller core is implemented on the top of the linux input/evdev
+interface.
+
+.. [#f1]
+
+   The main difference is that, on keyboard events, the keyboard controller
+   produces one event for a key press and another one for key release. On
+   infrared-based remote controllers, there's no key release event. Instead,
+   an extra code is produced to indicate key repeats.
+
+However, most of the remote controllers use infrared (IR) to transmit signals.
+As there are several protocols used to modulate infrared signals, one
+important part of the core is dedicated to adjust the driver and the core
+system to support the infrared protocol used by the emitter.
+
+The infrared transmission is done by blinking a infrared emitter using a
+carrier. The carrier can be switched on or off by the IR transmitter
+hardware. When the carrier is switched on, it is called *PULSE*.
+When the carrier is switched off, it is called *SPACE*.
+
+In other words, a typical IR transmission can be thinking on a sequence of
+*PULSE* and *SPACE* events, each with a given duration.
+
+The carrier parameters (frequency, duty cycle) and the intervals for
+*PULSE* and *SPACE* events depend on the protocol.
+For example, the NEC protocol uses a carrier of 38kHz, and transmissions
+start with a 9ms *PULSE* and a 4.5ms SPACE. It then transmits 16 bits of
+scan code, being 8 bits for address (usually it is a fixed number for a
+given remote controller), followed by 8 bits of code. A bit "1" is modulated
+with 560µs *PULSE* followed by 1690µs *SPACE* and a bit "0"  is modulated
+with 560µs *PULSE* followed by 560µs *SPACE*.
+
+At receiver, a simple low-pass filter can be used to convert the received
+signal in a sequence of *PULSE/SPACE* events, filtering out the carrier
+frequency. Due to that, the receiver doesn't care about the carrier's
+actual frequency parameters: all it has to do is to measure the amount
+of time it receives *PULSE/SPACE* events.
+So, a simple IR receiver hardware will just provide a sequence of timings
+for those events to the Kernel. The drivers for hardware with such kind of
+receivers are identified by  ``RC_DRIVER_IR_RAW``, as defined by
+:c:type:`rc_driver_type`\ [#f2]_. Other hardware come with a
+microcontroller that decode the *PULSE/SPACE* sequence and return scan
+codes to the Kernel. Such kind of receivers are identified
+by ``RC_DRIVER_SCANCODE``.
+
+.. [#f2]
+
+   The RC core also supports devices that have just IR emitters,
+   without any receivers. Right now, all such devices work only in
+   raw TX mode. Such kind of hardware is identified as
+   ``RC_DRIVER_IR_RAW_TX``.
+
+When the RC core receives events produced by ``RC_DRIVER_IR_RAW`` IR
+receivers, it needs to decode the IR protocol, in order to obtain the
+corresponding scan code. The protocols supported by the RC core are
+defined at enum :c:type:`rc_proto`.
+
+When the RC code receives a scan code (either directly, by a driver
+of the type ``RC_DRIVER_SCANCODE``, or via its IR decoders), it needs
+to convert into a Linux input event code. This is done via a mapping
+table.
+
+The Kernel has support for mapping tables available on most media
+devices. It also supports loading a table in runtime, via some
+sysfs nodes. See the :ref:`RC userspace API <Remote_controllers_Intro>`
+for more details.
+
+Remote controller data structures and functions
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
 .. kernel-doc:: include/media/rc-core.h
 
 .. kernel-doc:: include/media/rc-map.h
-- 
2.13.5
