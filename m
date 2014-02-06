Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaBFOcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 09:32:14 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] DocBook: Add a description for the Remote Controller interface
Date: Thu,  6 Feb 2014 12:31:19 -0200
Message-Id: <1391697079-9156-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1391697079-9156-1-git-send-email-m.chehab@samsung.com>
References: <1391697079-9156-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds a missing section to describe the remote controller interface.

The DocBook is just addin the same documentation as written at
Documentation/ABI/testing/sysfs-class-rc, using the DocBook's
way, and dropping timestamps/contact info.

While that means that we'll have the same info on two parts, there
are parts of the remote controller interface that doesn't belong
at Documentation/ABI/, and it makes sense to have everything
on the same place. This also means that we'll need to manually
track to be sure that both places will be synchronized, but, as
it is not expected much changes on it, this sync can be done
manually.

It also adds an introduction that states that the IR is a normal
evdev/input interface, plus the sysfs class nodes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../DocBook/media/v4l/remote_controllers.xml       | 98 +++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/remote_controllers.xml b/Documentation/DocBook/media/v4l/remote_controllers.xml
index 18288a3c595b..c440a81f14c0 100644
--- a/Documentation/DocBook/media/v4l/remote_controllers.xml
+++ b/Documentation/DocBook/media/v4l/remote_controllers.xml
@@ -16,7 +16,13 @@
 <revhistory>
 <!-- Put document revisions here, newest first. -->
 <revision>
-<revnumber>1.0.0</revnumber>
+<revnumber>3.15</revnumber>
+<date>2014-02-06</date>
+<authorinitials>mcc</authorinitials>
+<revremark>Added the interface description and the RC sysfs class description.</revremark>
+</revision>
+<revision>
+<revnumber>1.0</revnumber>
 <date>2009-09-06</date>
 <authorinitials>mcc</authorinitials>
 <revremark>Initial revision</revremark>
@@ -35,6 +41,96 @@
 <para>Currently, most analog and digital devices have a Infrared input for remote controllers. Each
 manufacturer has their own type of control. It is not rare for the same manufacturer to ship different
 types of controls, depending on the device.</para>
+<para>A Remote Controller interface is mapped as a normal evdev/input interface, just like a keyboard or a mouse.
+So, it uses all ioctls already defined for any other input devices.</para>
+<para>However, remove controllers are more flexible than a normal input device, as the IR
+receiver (and/or transmitter) can be used in conjunction with a wide variety of different IR remotes.</para>
+<para>In order to allow flexibility, the Remote Controller subsystem allows controlling the
+RC-specific attributes via <link linkend="remote_controllers_sysfs_nodes">the sysfs class nodes</link>.</para>
+</section>
+
+<section id="remote_controllers_sysfs_nodes">
+<title>Remote Controller's sysfs nodes</title>
+<para>As defined at <constant>Documentation/ABI/testing/sysfs-class-rc</constant>, those are the sysfs nodes that control the Remote Controllers:</para>
+
+<section id="sys_class_rc">
+<title>/sys/class/rc/</title>
+<para>The <constant>/sys/class/rc/</constant> class sub-directory belongs to the Remote Controller
+core and provides a sysfs interface for configuring infrared remote controller receivers.
+</para>
+
+</section>
+<section id="sys_class_rc_rcN">
+<title>/sys/class/rc/rcN/</title>
+<para>A <constant>/sys/class/rc/rcN</constant> directory is created for each remote
+  control receiver device where N is the number of the receiver.</para>
+
+</section>
+<section id="sys_class_rc_rcN_protocols">
+<title>/sys/class/rc/rcN/protocols</title>
+<para>Reading this file returns a list of available protocols, something like:</para>
+<para><constant>rc5 [rc6] nec jvc [sony]</constant></para>
+<para>Enabled protocols are shown in [] brackets.</para>
+<para>Writing "+proto" will add a protocol to the list of enabled protocols.</para>
+<para>Writing "-proto" will remove a protocol from the list of enabled protocols.</para>
+<para>Writing "proto" will enable only "proto".</para>
+<para>Writing "none" will disable all protocols.</para>
+<para>Write fails with EINVAL if an invalid protocol combination or unknown protocol name is used.</para>
+
+</section>
+<section id="sys_class_rc_rcN_filter">
+<title>/sys/class/rc/rcN/filter</title>
+<para>Sets the scancode filter expected value.</para>
+<para>Use in combination with <constant>/sys/class/rc/rcN/filter_mask</constant> to set the
+expected value of the bits set in the filter mask.
+If the hardware supports it then scancodes which do not match
+the filter will be ignored. Otherwise the write will fail with
+an error.</para>
+<para>This value may be reset to 0 if the current protocol is altered.</para>
+
+</section>
+<section id="sys_class_rc_rcN_filter_mask">
+<title>/sys/class/rc/rcN/filter_mask</title>
+<para>Sets the scancode filter mask of bits to compare.
+Use in combination with <constant>/sys/class/rc/rcN/filter</constant> to set the bits
+of the scancode which should be compared against the expected
+value. A value of 0 disables the filter to allow all valid
+scancodes to be processed.</para>
+<para>If the hardware supports it then scancodes which do not match
+the filter will be ignored. Otherwise the write will fail with
+an error.</para>
+<para>This value may be reset to 0 if the current protocol is altered.</para>
+
+</section>
+<section id="sys_class_rc_rcN_wakeup_filter">
+<title>/sys/class/rc/rcN/wakeup_filter</title>
+<para>Sets the scancode wakeup filter expected value.
+Use in combination with <constant>/sys/class/rc/rcN/wakeup_filter_mask</constant> to
+set the expected value of the bits set in the wakeup filter mask
+to trigger a system wake event.</para>
+<para>If the hardware supports it and wakeup_filter_mask is not 0 then
+scancodes which match the filter will wake the system from e.g.
+suspend to RAM or power off.
+Otherwise the write will fail with an error.</para>
+<para>This value may be reset to 0 if the current protocol is altered.</para>
+
+</section>
+<section id="sys_class_rc_rcN_wakeup_filter_mask">
+<title>/sys/class/rc/rcN/wakeup_filter_mask</title>
+<para>Sets the scancode wakeup filter mask of bits to compare.
+Use in combination with <constant>/sys/class/rc/rcN/wakeup_filter</constant> to set
+the bits of the scancode which should be compared against the
+expected value to trigger a system wake event.</para>
+<para>If the hardware supports it and wakeup_filter_mask is not 0 then
+scancodes which match the filter will wake the system from e.g.
+suspend to RAM or power off.
+Otherwise the write will fail with an error.</para>
+<para>This value may be reset to 0 if the current protocol is altered.</para>
+</section>
+</section>
+
+<section id="Remote_controllers_tables">
+<title>Remote controller tables</title>
 <para>Unfortunately, for several years, there was no effort to create uniform IR keycodes for
 different devices.  This caused the same IR keyname to be mapped completely differently on
 different IR devices. This resulted that the same IR keyname to be mapped completely different on
-- 
1.8.3.1

