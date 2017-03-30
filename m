Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46315 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933228AbdC3KqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:10 -0400
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
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH v2 11/22] usb/power-management.txt: convert to ReST and add to driver-api book
Date: Thu, 30 Mar 2017 07:45:45 -0300
Message-Id: <2e3808e468f65c44062f29649396d992af7bb1c7.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describe some USB core functions. Add it to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/index.rst             |   1 +
 .../usb/power-management.rst}                      | 404 +++++++++++----------
 2 files changed, 214 insertions(+), 191 deletions(-)
 rename Documentation/{usb/power-management.txt => driver-api/usb/power-management.rst} (69%)

diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index 441c5dacdf27..23c76c17fc19 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -9,6 +9,7 @@ Linux USB API
    anchors
    bulk-streams
    callbacks
+   power-management
    writing_usb_driver
    writing_musb_glue_layer
 
diff --git a/Documentation/usb/power-management.txt b/Documentation/driver-api/usb/power-management.rst
similarity index 69%
rename from Documentation/usb/power-management.txt
rename to Documentation/driver-api/usb/power-management.rst
index 00e706997130..c068257f6d27 100644
--- a/Documentation/usb/power-management.txt
+++ b/Documentation/driver-api/usb/power-management.rst
@@ -1,10 +1,12 @@
-			Power Management for USB
+.. _usb-power-management:
 
-		 Alan Stern <stern@rowland.harvard.edu>
-
-		       Last-updated: February 2014
+Power Management for USB
+~~~~~~~~~~~~~~~~~~~~~~~~
 
+:Author: Alan Stern <stern@rowland.harvard.edu>
+:Date: Last-updated: February 2014
 
+..
 	Contents:
 	---------
 	* What is Power Management?
@@ -25,14 +27,14 @@
 	* Suggested Userspace Port Power Policy
 
 
-	What is Power Management?
-	-------------------------
+What is Power Management?
+-------------------------
 
 Power Management (PM) is the practice of saving energy by suspending
 parts of a computer system when they aren't being used.  While a
-component is "suspended" it is in a nonfunctional low-power state; it
+component is ``suspended`` it is in a nonfunctional low-power state; it
 might even be turned off completely.  A suspended component can be
-"resumed" (returned to a functional full-power state) when the kernel
+``resumed`` (returned to a functional full-power state) when the kernel
 needs to use it.  (There also are forms of PM in which components are
 placed in a less functional but still usable state instead of being
 suspended; an example would be reducing the CPU's clock rate.  This
@@ -44,22 +46,25 @@ device is turned off while the system as a whole remains running, we
 call it a "dynamic suspend" (also known as a "runtime suspend" or
 "selective suspend").  This document concentrates mostly on how
 dynamic PM is implemented in the USB subsystem, although system PM is
-covered to some extent (see Documentation/power/*.txt for more
+covered to some extent (see ``Documentation/power/*.txt`` for more
 information about system PM).
 
-System PM support is present only if the kernel was built with CONFIG_SUSPEND
-or CONFIG_HIBERNATION enabled.  Dynamic PM support for USB is present whenever
-the kernel was built with CONFIG_PM enabled.
+System PM support is present only if the kernel was built with
+``CONFIG_SUSPEND`` or ``CONFIG_HIBERNATION`` enabled.  Dynamic PM support
+
+for USB is present whenever
+the kernel was built with ``CONFIG_PM`` enabled.
 
 [Historically, dynamic PM support for USB was present only if the
-kernel had been built with CONFIG_USB_SUSPEND enabled (which depended on
-CONFIG_PM_RUNTIME).  Starting with the 3.10 kernel release, dynamic PM support
-for USB was present whenever the kernel was built with CONFIG_PM_RUNTIME
-enabled.  The CONFIG_USB_SUSPEND option had been eliminated.]
+kernel had been built with ``CONFIG_USB_SUSPEND`` enabled (which depended on
+``CONFIG_PM_RUNTIME``).  Starting with the 3.10 kernel release, dynamic PM
+support for USB was present whenever the kernel was built with
+``CONFIG_PM_RUNTIME`` enabled.  The ``CONFIG_USB_SUSPEND`` option had been
+eliminated.]
 
 
-	What is Remote Wakeup?
-	----------------------
+What is Remote Wakeup?
+----------------------
 
 When a device has been suspended, it generally doesn't resume until
 the computer tells it to.  Likewise, if the entire computer has been
@@ -76,8 +81,8 @@ event.  Examples include a suspended keyboard resuming when a key is
 pressed, or a suspended USB hub resuming when a device is plugged in.
 
 
-	When is a USB device idle?
-	--------------------------
+When is a USB device idle?
+--------------------------
 
 A device is idle whenever the kernel thinks it's not busy doing
 anything important and thus is a candidate for being suspended.  The
@@ -92,11 +97,11 @@ If a USB device has no driver, its usbfs file isn't open, and it isn't
 being accessed through sysfs, then it definitely is idle.
 
 
-	Forms of dynamic PM
-	-------------------
+Forms of dynamic PM
+-------------------
 
 Dynamic suspends occur when the kernel decides to suspend an idle
-device.  This is called "autosuspend" for short.  In general, a device
+device.  This is called ``autosuspend`` for short.  In general, a device
 won't be autosuspended unless it has been idle for some minimum period
 of time, the so-called idle-delay time.
 
@@ -125,51 +130,51 @@ all dynamic suspend events are internal; external agents are not
 allowed to issue dynamic suspends.
 
 
-	The user interface for dynamic PM
-	---------------------------------
+The user interface for dynamic PM
+---------------------------------
 
-The user interface for controlling dynamic PM is located in the power/
+The user interface for controlling dynamic PM is located in the ``power/``
 subdirectory of each USB device's sysfs directory, that is, in
-/sys/bus/usb/devices/.../power/ where "..." is the device's ID.  The
+``/sys/bus/usb/devices/.../power/`` where "..." is the device's ID.  The
 relevant attribute files are: wakeup, control, and
-autosuspend_delay_ms.  (There may also be a file named "level"; this
+``autosuspend_delay_ms``.  (There may also be a file named ``level``; this
 file was deprecated as of the 2.6.35 kernel and replaced by the
-"control" file.  In 2.6.38 the "autosuspend" file will be deprecated
-and replaced by the "autosuspend_delay_ms" file.  The only difference
+``control`` file.  In 2.6.38 the ``autosuspend`` file will be deprecated
+and replaced by the ``autosuspend_delay_ms`` file.  The only difference
 is that the newer file expresses the delay in milliseconds whereas the
 older file uses seconds.  Confusingly, both files are present in 2.6.37
-but only "autosuspend" works.)
+but only ``autosuspend`` works.)
 
-	power/wakeup
+	``power/wakeup``
 
 		This file is empty if the device does not support
 		remote wakeup.  Otherwise the file contains either the
-		word "enabled" or the word "disabled", and you can
+		word ``enabled`` or the word ``disabled``, and you can
 		write those words to the file.  The setting determines
 		whether or not remote wakeup will be enabled when the
 		device is next suspended.  (If the setting is changed
 		while the device is suspended, the change won't take
 		effect until the following suspend.)
 
-	power/control
+	``power/control``
 
-		This file contains one of two words: "on" or "auto".
+		This file contains one of two words: ``on`` or ``auto``.
 		You can write those words to the file to change the
 		device's setting.
 
-		"on" means that the device should be resumed and
-		autosuspend is not allowed.  (Of course, system
-		suspends are still allowed.)
+		- ``on`` means that the device should be resumed and
+		  autosuspend is not allowed.  (Of course, system
+		  suspends are still allowed.)
 
-		"auto" is the normal state in which the kernel is
-		allowed to autosuspend and autoresume the device.
+		- ``auto`` is the normal state in which the kernel is
+		  allowed to autosuspend and autoresume the device.
 
 		(In kernels up to 2.6.32, you could also specify
-		"suspend", meaning that the device should remain
+		``suspend``, meaning that the device should remain
 		suspended and autoresume was not allowed.  This
 		setting is no longer supported.)
 
-	power/autosuspend_delay_ms
+	``power/autosuspend_delay_ms``
 
 		This file contains an integer value, which is the
 		number of milliseconds the device should remain idle
@@ -180,31 +185,31 @@ but only "autosuspend" works.)
 		number to the file to change the autosuspend
 		idle-delay time.
 
-Writing "-1" to power/autosuspend_delay_ms and writing "on" to
-power/control do essentially the same thing -- they both prevent the
+Writing ``-1`` to ``power/autosuspend_delay_ms`` and writing ``on`` to
+``power/control`` do essentially the same thing -- they both prevent the
 device from being autosuspended.  Yes, this is a redundancy in the
 API.
 
-(In 2.6.21 writing "0" to power/autosuspend would prevent the device
+(In 2.6.21 writing ``0`` to ``power/autosuspend`` would prevent the device
 from being autosuspended; the behavior was changed in 2.6.22.  The
-power/autosuspend attribute did not exist prior to 2.6.21, and the
-power/level attribute did not exist prior to 2.6.22.  power/control
-was added in 2.6.34, and power/autosuspend_delay_ms was added in
+``power/autosuspend`` attribute did not exist prior to 2.6.21, and the
+``power/level`` attribute did not exist prior to 2.6.22.  ``power/control``
+was added in 2.6.34, and ``power/autosuspend_delay_ms`` was added in
 2.6.37 but did not become functional until 2.6.38.)
 
 
-	Changing the default idle-delay time
-	------------------------------------
+Changing the default idle-delay time
+------------------------------------
 
 The default autosuspend idle-delay time (in seconds) is controlled by
 a module parameter in usbcore.  You can specify the value when usbcore
 is loaded.  For example, to set it to 5 seconds instead of 2 you would
-do:
+do::
 
 	modprobe usbcore autosuspend=5
 
 Equivalently, you could add to a configuration file in /etc/modprobe.d
-a line saying:
+a line saying::
 
 	options usbcore autosuspend=5
 
@@ -214,14 +219,14 @@ image.  To alter the parameter value you would have to rebuild that
 image.
 
 If usbcore is compiled into the kernel rather than built as a loadable
-module, you can add
+module, you can add::
 
 	usbcore.autosuspend=5
 
 to the kernel's boot command line.
 
 Finally, the parameter value can be changed while the system is
-running.  If you do:
+running.  If you do::
 
 	echo 5 >/sys/module/usbcore/parameters/autosuspend
 
@@ -234,8 +239,8 @@ autosuspend of any USB device.  This has the benefit of allowing you
 then to enable autosuspend for selected devices.
 
 
-	Warnings
-	--------
+Warnings
+--------
 
 The USB specification states that all USB devices must support power
 management.  Nevertheless, the sad fact is that many devices do not
@@ -246,7 +251,7 @@ among printers and scanners, but plenty of other types of device have
 the same deficiency.
 
 For this reason, by default the kernel disables autosuspend (the
-power/control attribute is initialized to "on") for all devices other
+``power/control`` attribute is initialized to ``on``) for all devices other
 than hubs.  Hubs, at least, appear to be reasonably well-behaved in
 this regard.
 
@@ -284,30 +289,30 @@ device by suspending it at the wrong time.  (Highly unlikely, but
 possible.)  Take care.
 
 
-	The driver interface for Power Management
-	-----------------------------------------
+The driver interface for Power Management
+-----------------------------------------
 
 The requirements for a USB driver to support external power management
-are pretty modest; the driver need only define
+are pretty modest; the driver need only define::
 
 	.suspend
 	.resume
 	.reset_resume
 
-methods in its usb_driver structure, and the reset_resume method is
-optional.  The methods' jobs are quite simple:
+methods in its :c:type:`usb_driver` structure, and the ``reset_resume`` method
+is optional.  The methods' jobs are quite simple:
 
-	The suspend method is called to warn the driver that the
+      - The ``suspend`` method is called to warn the driver that the
 	device is going to be suspended.  If the driver returns a
 	negative error code, the suspend will be aborted.  Normally
 	the driver will return 0, in which case it must cancel all
-	outstanding URBs (usb_kill_urb()) and not submit any more.
+	outstanding URBs (:c:func:`usb_kill_urb`) and not submit any more.
 
-	The resume method is called to tell the driver that the
+      - The ``resume`` method is called to tell the driver that the
 	device has been resumed and the driver can return to normal
 	operation.  URBs may once more be submitted.
 
-	The reset_resume method is called to tell the driver that
+      - The ``reset_resume`` method is called to tell the driver that
 	the device has been resumed and it also has been reset.
 	The driver should redo any necessary device initialization,
 	since the device has probably lost most or all of its state
@@ -315,22 +320,22 @@ optional.  The methods' jobs are quite simple:
 	before the suspend).
 
 If the device is disconnected or powered down while it is suspended,
-the disconnect method will be called instead of the resume or
-reset_resume method.  This is also quite likely to happen when
+the ``disconnect`` method will be called instead of the ``resume`` or
+``reset_resume`` method.  This is also quite likely to happen when
 waking up from hibernation, as many systems do not maintain suspend
 current to the USB host controllers during hibernation.  (It's
 possible to work around the hibernation-forces-disconnect problem by
 using the USB Persist facility.)
 
-The reset_resume method is used by the USB Persist facility (see
-Documentation/usb/persist.txt) and it can also be used under certain
-circumstances when CONFIG_USB_PERSIST is not enabled.  Currently, if a
+The ``reset_resume`` method is used by the USB Persist facility (see
+``Documentation/usb/persist.txt``) and it can also be used under certain
+circumstances when ``CONFIG_USB_PERSIST`` is not enabled.  Currently, if a
 device is reset during a resume and the driver does not have a
-reset_resume method, the driver won't receive any notification about
-the resume.  Later kernels will call the driver's disconnect method;
+``reset_resume`` method, the driver won't receive any notification about
+the resume.  Later kernels will call the driver's ``disconnect`` method;
 2.6.23 doesn't do this.
 
-USB drivers are bound to interfaces, so their suspend and resume
+USB drivers are bound to interfaces, so their ``suspend`` and ``resume``
 methods get called when the interfaces are suspended or resumed.  In
 principle one might want to suspend some interfaces on a device (i.e.,
 force the drivers for those interface to stop all activity) without
@@ -341,15 +346,15 @@ to suspend or resume some but not all of a device's interfaces.  The
 closest you can come is to unbind the interfaces' drivers.
 
 
-	The driver interface for autosuspend and autoresume
-	---------------------------------------------------
+The driver interface for autosuspend and autoresume
+---------------------------------------------------
 
 To support autosuspend and autoresume, a driver should implement all
 three of the methods listed above.  In addition, a driver indicates
-that it supports autosuspend by setting the .supports_autosuspend flag
+that it supports autosuspend by setting the ``.supports_autosuspend`` flag
 in its usb_driver structure.  It is then responsible for informing the
 USB core whenever one of its interfaces becomes busy or idle.  The
-driver does so by calling these six functions:
+driver does so by calling these six functions::
 
 	int  usb_autopm_get_interface(struct usb_interface *intf);
 	void usb_autopm_put_interface(struct usb_interface *intf);
@@ -368,41 +373,41 @@ autosuspend the device.
 Drivers need not be concerned about balancing changes to the usage
 counter; the USB core will undo any remaining "get"s when a driver
 is unbound from its interface.  As a corollary, drivers must not call
-any of the usb_autopm_* functions after their disconnect() routine has
-returned.
+any of the ``usb_autopm_*`` functions after their ``disconnect``
+routine has returned.
 
 Drivers using the async routines are responsible for their own
 synchronization and mutual exclusion.
 
-	usb_autopm_get_interface() increments the usage counter and
+	:c:func:`usb_autopm_get_interface` increments the usage counter and
 	does an autoresume if the device is suspended.  If the
 	autoresume fails, the counter is decremented back.
 
-	usb_autopm_put_interface() decrements the usage counter and
+	:c:func:`usb_autopm_put_interface` decrements the usage counter and
 	attempts an autosuspend if the new value is = 0.
 
-	usb_autopm_get_interface_async() and
-	usb_autopm_put_interface_async() do almost the same things as
+	:c:func:`usb_autopm_get_interface_async` and
+	:c:func:`usb_autopm_put_interface_async` do almost the same things as
 	their non-async counterparts.  The big difference is that they
 	use a workqueue to do the resume or suspend part of their
 	jobs.  As a result they can be called in an atomic context,
 	such as an URB's completion handler, but when they return the
 	device will generally not yet be in the desired state.
 
-	usb_autopm_get_interface_no_resume() and
-	usb_autopm_put_interface_no_suspend() merely increment or
+	:c:func:`usb_autopm_get_interface_no_resume` and
+	:c:func:`usb_autopm_put_interface_no_suspend` merely increment or
 	decrement the usage counter; they do not attempt to carry out
 	an autoresume or an autosuspend.  Hence they can be called in
 	an atomic context.
 
 The simplest usage pattern is that a driver calls
-usb_autopm_get_interface() in its open routine and
-usb_autopm_put_interface() in its close or release routine.  But other
+:c:func:`usb_autopm_get_interface` in its open routine and
+:c:func:`usb_autopm_put_interface` in its close or release routine.  But other
 patterns are possible.
 
 The autosuspend attempts mentioned above will often fail for one
-reason or another.  For example, the power/control attribute might be
-set to "on", or another interface in the same device might not be
+reason or another.  For example, the ``power/control`` attribute might be
+set to ``on``, or another interface in the same device might not be
 idle.  This is perfectly normal.  If the reason for failure was that
 the device hasn't been idle for long enough, a timer is scheduled to
 carry out the operation automatically when the autosuspend idle-delay
@@ -413,37 +418,37 @@ the device is no longer present or operating properly.  Unlike
 autosuspend, there's no idle-delay for an autoresume.
 
 
-	Other parts of the driver interface
-	-----------------------------------
+Other parts of the driver interface
+-----------------------------------
 
-Drivers can enable autosuspend for their devices by calling
+Drivers can enable autosuspend for their devices by calling::
 
 	usb_enable_autosuspend(struct usb_device *udev);
 
-in their probe() routine, if they know that the device is capable of
+in their :c:func:`probe` routine, if they know that the device is capable of
 suspending and resuming correctly.  This is exactly equivalent to
-writing "auto" to the device's power/control attribute.  Likewise,
-drivers can disable autosuspend by calling
+writing ``auto`` to the device's ``power/control`` attribute.  Likewise,
+drivers can disable autosuspend by calling::
 
 	usb_disable_autosuspend(struct usb_device *udev);
 
-This is exactly the same as writing "on" to the power/control attribute.
+This is exactly the same as writing ``on`` to the ``power/control`` attribute.
 
 Sometimes a driver needs to make sure that remote wakeup is enabled
 during autosuspend.  For example, there's not much point
 autosuspending a keyboard if the user can't cause the keyboard to do a
 remote wakeup by typing on it.  If the driver sets
-intf->needs_remote_wakeup to 1, the kernel won't autosuspend the
+``intf->needs_remote_wakeup`` to 1, the kernel won't autosuspend the
 device if remote wakeup isn't available.  (If the device is already
 autosuspended, though, setting this flag won't cause the kernel to
-autoresume it.  Normally a driver would set this flag in its probe
+autoresume it.  Normally a driver would set this flag in its ``probe``
 method, at which time the device is guaranteed not to be
 autosuspended.)
 
 If a driver does its I/O asynchronously in interrupt context, it
-should call usb_autopm_get_interface_async() before starting output and
-usb_autopm_put_interface_async() when the output queue drains.  When
-it receives an input event, it should call
+should call :c:func:`usb_autopm_get_interface_async` before starting output and
+:c:func:`usb_autopm_put_interface_async` when the output queue drains.  When
+it receives an input event, it should call::
 
 	usb_mark_last_busy(struct usb_device *udev);
 
@@ -453,41 +458,41 @@ be pushed back.  Many of the usb_autopm_* routines also make this call,
 so drivers need to worry only when interrupt-driven input arrives.
 
 Asynchronous operation is always subject to races.  For example, a
-driver may call the usb_autopm_get_interface_async() routine at a time
+driver may call the :c:func:`usb_autopm_get_interface_async` routine at a time
 when the core has just finished deciding the device has been idle for
-long enough but not yet gotten around to calling the driver's suspend
-method.  The suspend method must be responsible for synchronizing with
+long enough but not yet gotten around to calling the driver's ``suspend``
+method.  The ``suspend`` method must be responsible for synchronizing with
 the I/O request routine and the URB completion handler; it should
 cause autosuspends to fail with -EBUSY if the driver needs to use the
 device.
 
 External suspend calls should never be allowed to fail in this way,
 only autosuspend calls.  The driver can tell them apart by applying
-the PMSG_IS_AUTO() macro to the message argument to the suspend
+the :c:func:`PMSG_IS_AUTO` macro to the message argument to the ``suspend``
 method; it will return True for internal PM events (autosuspend) and
 False for external PM events.
 
 
-	Mutual exclusion
-	----------------
+Mutual exclusion
+----------------
 
 For external events -- but not necessarily for autosuspend or
 autoresume -- the device semaphore (udev->dev.sem) will be held when a
-suspend or resume method is called.  This implies that external
-suspend/resume events are mutually exclusive with calls to probe,
-disconnect, pre_reset, and post_reset; the USB core guarantees that
+``suspend`` or ``resume`` method is called.  This implies that external
+suspend/resume events are mutually exclusive with calls to ``probe``,
+``disconnect``, ``pre_reset``, and ``post_reset``; the USB core guarantees that
 this is true of autosuspend/autoresume events as well.
 
 If a driver wants to block all suspend/resume calls during some
 critical section, the best way is to lock the device and call
-usb_autopm_get_interface() (and do the reverse at the end of the
+:c:func:`usb_autopm_get_interface` (and do the reverse at the end of the
 critical section).  Holding the device semaphore will block all
-external PM calls, and the usb_autopm_get_interface() will prevent any
+external PM calls, and the :c:func:`usb_autopm_get_interface` will prevent any
 internal PM calls, even if it fails.  (Exercise: Why?)
 
 
-	Interaction between dynamic PM and system PM
-	--------------------------------------------
+Interaction between dynamic PM and system PM
+--------------------------------------------
 
 Dynamic power management and system power management can interact in
 a couple of ways.
@@ -512,8 +517,8 @@ wakeup may fail and get lost.  Which outcome occurs depends on timing
 and on the hardware and firmware design.
 
 
-	xHCI hardware link PM
-	---------------------
+xHCI hardware link PM
+---------------------
 
 xHCI host controller provides hardware link power management to usb2.0
 (xHCI 1.0 feature) and usb3.0 devices which support link PM. By
@@ -522,11 +527,11 @@ lower power state(L1 for usb2.0 devices, or U1/U2 for usb3.0 devices),
 which state device can enter and resume very quickly.
 
 The user interface for controlling hardware LPM is located in the
-power/ subdirectory of each USB device's sysfs directory, that is, in
-/sys/bus/usb/devices/.../power/ where "..." is the device's ID. The
-relevant attribute files are usb2_hardware_lpm and usb3_hardware_lpm.
+``power/`` subdirectory of each USB device's sysfs directory, that is, in
+``/sys/bus/usb/devices/.../power/`` where "..." is the device's ID. The
+relevant attribute files are ``usb2_hardware_lpm`` and ``usb3_hardware_lpm``.
 
-	power/usb2_hardware_lpm
+	``power/usb2_hardware_lpm``
 
 		When a USB2 device which support LPM is plugged to a
 		xHCI host root hub which support software LPM, the
@@ -537,8 +542,8 @@ relevant attribute files are usb2_hardware_lpm and usb3_hardware_lpm.
 		can write y/Y/1 or n/N/0 to the file to	enable/disable
 		USB2 hardware LPM manually. This is for	test purpose mainly.
 
-	power/usb3_hardware_lpm_u1
-	power/usb3_hardware_lpm_u2
+	``power/usb3_hardware_lpm_u1``
+	``power/usb3_hardware_lpm_u2``
 
 		When a USB 3.0 lpm-capable device is plugged in to a
 		xHCI host which supports link PM, it will check if U1
@@ -550,29 +555,31 @@ relevant attribute files are usb2_hardware_lpm and usb3_hardware_lpm.
 		indicating whether or not USB3 hardware LPM U1 or U2
 		is enabled for the device.
 
-	USB Port Power Control
-	----------------------
+USB Port Power Control
+----------------------
 
 In addition to suspending endpoint devices and enabling hardware
 controlled link power management, the USB subsystem also has the
 capability to disable power to ports under some conditions.  Power is
-controlled through Set/ClearPortFeature(PORT_POWER) requests to a hub.
+controlled through ``Set/ClearPortFeature(PORT_POWER)`` requests to a hub.
 In the case of a root or platform-internal hub the host controller
-driver translates PORT_POWER requests into platform firmware (ACPI)
+driver translates ``PORT_POWER`` requests into platform firmware (ACPI)
 method calls to set the port power state. For more background see the
-Linux Plumbers Conference 2012 slides [1] and video [2]:
+Linux Plumbers Conference 2012 slides [#f1]_ and video [#f2]_:
 
-Upon receiving a ClearPortFeature(PORT_POWER) request a USB port is
-logically off, and may trigger the actual loss of VBUS to the port [3].
+Upon receiving a ``ClearPortFeature(PORT_POWER)`` request a USB port is
+logically off, and may trigger the actual loss of VBUS to the port [#f3]_.
 VBUS may be maintained in the case where a hub gangs multiple ports into
 a shared power well causing power to remain until all ports in the gang
 are turned off.  VBUS may also be maintained by hub ports configured for
 a charging application.  In any event a logically off port will lose
 connection with its device, not respond to hotplug events, and not
-respond to remote wakeup events*.
+respond to remote wakeup events.
 
-WARNING: turning off a port may result in the inability to hot add a device.
-Please see "User Interface for Port Power Control" for details.
+.. warning::
+
+   turning off a port may result in the inability to hot add a device.
+   Please see "User Interface for Port Power Control" for details.
 
 As far as the effect on the device itself it is similar to what a device
 goes through during system suspend, i.e. the power session is lost.  Any
@@ -581,38 +588,49 @@ similarly affected by a port power cycle event.  For this reason the
 implementation shares the same device recovery path (and honors the same
 quirks) as the system resume path for the hub.
 
-[1]: http://dl.dropbox.com/u/96820575/sarah-sharp-lpt-port-power-off2-mini.pdf
-[2]: http://linuxplumbers.ubicast.tv/videos/usb-port-power-off-kerneluserspace-api/
-[3]: USB 3.1 Section 10.12
-* wakeup note: if a device is configured to send wakeup events the port
+.. [#f1]
+
+  http://dl.dropbox.com/u/96820575/sarah-sharp-lpt-port-power-off2-mini.pdf
+
+.. [#f2]
+
+  http://linuxplumbers.ubicast.tv/videos/usb-port-power-off-kerneluserspace-api/
+
+.. [#f3]
+
+  USB 3.1 Section 10.12
+
+  wakeup note: if a device is configured to send wakeup events the port
   power control implementation will block poweroff attempts on that
   port.
 
 
-	User Interface for Port Power Control
-	-------------------------------------
+User Interface for Port Power Control
+-------------------------------------
 
 The port power control mechanism uses the PM runtime system.  Poweroff is
-requested by clearing the power/pm_qos_no_power_off flag of the port device
+requested by clearing the ``power/pm_qos_no_power_off`` flag of the port device
 (defaults to 1).  If the port is disconnected it will immediately receive a
-ClearPortFeature(PORT_POWER) request.  Otherwise, it will honor the pm runtime
-rules and require the attached child device and all descendants to be suspended.
-This mechanism is dependent on the hub advertising port power switching in its
-hub descriptor (wHubCharacteristics logical power switching mode field).
+``ClearPortFeature(PORT_POWER)`` request.  Otherwise, it will honor the pm
+runtime rules and require the attached child device and all descendants to be
+suspended. This mechanism is dependent on the hub advertising port power
+switching in its hub descriptor (wHubCharacteristics logical power switching
+mode field).
 
 Note, some interface devices/drivers do not support autosuspend.  Userspace may
-need to unbind the interface drivers before the usb_device will suspend.  An
-unbound interface device is suspended by default.  When unbinding, be careful
-to unbind interface drivers, not the driver of the parent usb device.  Also,
-leave hub interface drivers bound.  If the driver for the usb device (not
-interface) is unbound the kernel is no longer able to resume the device.  If a
-hub interface driver is unbound, control of its child ports is lost and all
-attached child-devices will disconnect.  A good rule of thumb is that if the
-'driver/module' link for a device points to /sys/module/usbcore then unbinding
-it will interfere with port power control.
+need to unbind the interface drivers before the :c:type:`usb_device` will
+suspend.  An unbound interface device is suspended by default.  When unbinding,
+be careful to unbind interface drivers, not the driver of the parent usb
+device.  Also, leave hub interface drivers bound.  If the driver for the usb
+device (not interface) is unbound the kernel is no longer able to resume the
+device.  If a hub interface driver is unbound, control of its child ports is
+lost and all attached child-devices will disconnect.  A good rule of thumb is
+that if the 'driver/module' link for a device points to
+``/sys/module/usbcore`` then unbinding it will interfere with port power
+control.
 
 Example of the relevant files for port power control.  Note, in this example
-these files are relative to a usb hub device (prefix).
+these files are relative to a usb hub device (prefix)::
 
      prefix=/sys/devices/pci0000:00/0000:00:14.0/usb3/3-1
 
@@ -631,10 +649,10 @@ these files are relative to a usb hub device (prefix).
 
 In addition to these files some ports may have a 'peer' link to a port on
 another hub.  The expectation is that all superspeed ports have a
-hi-speed peer.
+hi-speed peer::
 
-$prefix/3-1:1.0/3-1-port1/peer -> ../../../../usb2/2-1/2-1:1.0/2-1-port1
-../../../../usb2/2-1/2-1:1.0/2-1-port1/peer -> ../../../../usb3/3-1/3-1:1.0/3-1-port1
+  $prefix/3-1:1.0/3-1-port1/peer -> ../../../../usb2/2-1/2-1:1.0/2-1-port1
+  ../../../../usb2/2-1/2-1:1.0/2-1-port1/peer -> ../../../../usb3/3-1/3-1:1.0/3-1-port1
 
 Distinct from 'companion ports', or 'ehci/xhci shared switchover ports'
 peer ports are simply the hi-speed and superspeed interface pins that
@@ -645,24 +663,26 @@ While a superspeed port is powered off a device may downgrade its
 connection and attempt to connect to the hi-speed pins.  The
 implementation takes steps to prevent this:
 
-1/ Port suspend is sequenced to guarantee that hi-speed ports are powered-off
+1. Port suspend is sequenced to guarantee that hi-speed ports are powered-off
    before their superspeed peer is permitted to power-off.  The implication is
-   that the setting pm_qos_no_power_off to zero on a superspeed port may not cause
-   the port to power-off until its highspeed peer has gone to its runtime suspend
-   state.  Userspace must take care to order the suspensions if it wants to
-   guarantee that a superspeed port will power-off.
+   that the setting ``pm_qos_no_power_off`` to zero on a superspeed port may
+   not cause the port to power-off until its highspeed peer has gone to its
+   runtime suspend state.  Userspace must take care to order the suspensions
+   if it wants to guarantee that a superspeed port will power-off.
 
-2/ Port resume is sequenced to force a superspeed port to power-on prior to its
+2. Port resume is sequenced to force a superspeed port to power-on prior to its
    highspeed peer.
 
-3/ Port resume always triggers an attached child device to resume.  After a
+3. Port resume always triggers an attached child device to resume.  After a
    power session is lost the device may have been removed, or need reset.
    Resuming the child device when the parent port regains power resolves those
-   states and clamps the maximum port power cycle frequency at the rate the child
-   device can suspend (autosuspend-delay) and resume (reset-resume latency).
+   states and clamps the maximum port power cycle frequency at the rate the
+   child device can suspend (autosuspend-delay) and resume (reset-resume
+   latency).
 
 Sysfs files relevant for port power control:
-	<hubdev-portX>/power/pm_qos_no_power_off:
+
+	``<hubdev-portX>/power/pm_qos_no_power_off``:
 		This writable flag controls the state of an idle port.
 		Once all children and descendants have suspended the
 		port may suspend/poweroff provided that
@@ -670,24 +690,24 @@ Sysfs files relevant for port power control:
 		'1' the port will remain active/powered regardless of
 		the stats of descendants.  Defaults to 1.
 
-	<hubdev-portX>/power/runtime_status:
+	``<hubdev-portX>/power/runtime_status``:
 		This file reflects whether the port is 'active' (power is on)
 		or 'suspended' (logically off).  There is no indication to
 		userspace whether VBUS is still supplied.
 
-	<hubdev-portX>/connect_type:
+	``<hubdev-portX>/connect_type``:
 		An advisory read-only flag to userspace indicating the
 		location and connection type of the port.  It returns
 		one of four values 'hotplug', 'hardwired', 'not used',
 		and 'unknown'.  All values, besides unknown, are set by
 		platform firmware.
 
-		"hotplug" indicates an externally connectable/visible
+		``hotplug`` indicates an externally connectable/visible
 		port on the platform.  Typically userspace would choose
 		to keep such a port powered to handle new device
 		connection events.
 
-		"hardwired" refers to a port that is not visible but
+		``hardwired`` refers to a port that is not visible but
 		connectable. Examples are internal ports for USB
 		bluetooth that can be disconnected via an external
 		switch or a port with a hardwired USB camera.  It is
@@ -698,48 +718,50 @@ Sysfs files relevant for port power control:
 		powering off, or to activate the port prior to enabling
 		connection via a switch.
 
-		"not used" refers to an internal port that is expected
+		``not used`` refers to an internal port that is expected
 		to never have a device connected to it.  These may be
 		empty internal ports, or ports that are not physically
 		exposed on a platform.  Considered safe to be
 		powered-off at all times.
 
-		"unknown" means platform firmware does not provide
+		``unknown`` means platform firmware does not provide
 		information for this port.  Most commonly refers to
 		external hub ports which should be considered 'hotplug'
 		for policy decisions.
 
-		NOTE1: since we are relying on the BIOS to get this ACPI
-		information correct, the USB port descriptions may be
-		missing or wrong.
+		.. note::
 
-		NOTE2: Take care in clearing pm_qos_no_power_off.  Once
-		power is off this port will
-		not respond to new connect events.
+			- since we are relying on the BIOS to get this ACPI
+			  information correct, the USB port descriptions may
+			  be missing or wrong.
+
+			- Take care in clearing ``pm_qos_no_power_off``. Once
+			  power is off this port will
+			  not respond to new connect events.
 
 	Once a child device is attached additional constraints are
 	applied before the port is allowed to poweroff.
 
-	<child>/power/control:
-		Must be 'auto', and the port will not
-		power down until <child>/power/runtime_status
+	``<child>/power/control``:
+		Must be ``auto``, and the port will not
+		power down until ``<child>/power/runtime_status``
 		reflects the 'suspended' state.  Default
 		value is controlled by child device driver.
 
-	<child>/power/persist:
-		This defaults to '1' for most devices and indicates if
+	``<child>/power/persist``:
+		This defaults to ``1`` for most devices and indicates if
 		kernel can persist the device's configuration across a
 		power session loss (suspend / port-power event).  When
-		this value is '0' (quirky devices), port poweroff is
+		this value is ``0`` (quirky devices), port poweroff is
 		disabled.
 
-	<child>/driver/unbind:
+	``<child>/driver/unbind``:
 		Wakeup capable devices will block port poweroff.  At
 		this time the only mechanism to clear the usb-internal
 		wakeup-capability for an interface device is to unbind
 		its driver.
 
-Summary of poweroff pre-requisite settings relative to a port device:
+Summary of poweroff pre-requisite settings relative to a port device::
 
 	echo 0 > power/pm_qos_no_power_off
 	echo 0 > peer/power/pm_qos_no_power_off # if it exists
@@ -747,14 +769,14 @@ Summary of poweroff pre-requisite settings relative to a port device:
 	echo auto > <child>/power/control
 	echo 1 > <child>/power/persist # this is the default value
 
-	Suggested Userspace Port Power Policy
-	-------------------------------------
+Suggested Userspace Port Power Policy
+-------------------------------------
 
 As noted above userspace needs to be careful and deliberate about what
 ports are enabled for poweroff.
 
 The default configuration is that all ports start with
-power/pm_qos_no_power_off set to '1' causing ports to always remain
+``power/pm_qos_no_power_off`` set to ``1`` causing ports to always remain
 active.
 
 Given confidence in the platform firmware's description of the ports
@@ -764,7 +786,7 @@ done for 'hardwired' ports provided poweroff is coordinated with any
 connection switch for the port.
 
 A more aggressive userspace policy is to enable USB port power off for
-all ports (set <hubdev-portX>/power/pm_qos_no_power_off to '0') when
+all ports (set ``<hubdev-portX>/power/pm_qos_no_power_off`` to ``0``) when
 some external factor indicates the user has stopped interacting with the
 system.  For example, a distro may want to enable power off all USB
 ports when the screen blanks, and re-power them when the screen becomes
-- 
2.9.3
