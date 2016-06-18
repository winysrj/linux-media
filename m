Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:49775 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbcFRMSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 08:18:13 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] Diffs between the CEC pull request and v17 patch series
Message-ID: <57653BFF.6010307@xs4all.nl>
Date: Sat, 18 Jun 2016 14:18:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This patch is the diff between my previous CEC pull request and the upcoming patch series 17.

It contains all the non-codingstyle changes made since the original pull request to avoid you
having to dig through the new patch series for the changes.

This should take care of all your comments (I hope!).

Changes since the original pull request:

- checkpatch changes (not included in this patch). There are still a number of 80-char limit
  warnings, but splitting those up makes the code harder to read IMHO.
- Dropped media/cec.h from Documentation/DocBook/device-drivers.tmpl
  (cec-edid.h isn't staging, so that stayed)
- Added notes to the cec DocBook files that mentions that this is a proposed API.
- Updated the DocBook files incorporating the review comments
- Disable CEC support by default in Kconfig for HDMI drivers since cec is still staging.
- CEC_DQEVENT didn't block waiting for events in blocking mode. Fixed this. The documentation
  was correct, but it was never implemented.
- Monitor mode now requires CAP_NET_ADMIN.
- Three fixes in cec-funcs.h: the language string wasn't zero-terminated and the
  latency messages are broadcast messages, not directed messages.
- Remove the cec.h dependency from cec-edid.h. Partially because cec.h belongs to the
  staging driver, partially because it really isn't necessary.
- Updated the TODO file
- Fixed vivid-cec.c top-level comment & copyright year.

Regards,

	Hans

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 5b77199..de79efd 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -272,10 +272,6 @@ X!Isound/sound_firmware.c
 !Iinclude/media/media-devnode.h
 !Iinclude/media/media-entity.h
     </sect1>
      <sect1><title>Consumer Electronics Control devices</title>
-!Iinclude/media/cec.h
 !Iinclude/media/cec-edid.h
      </sect1>

diff --git a/Documentation/DocBook/media/v4l/cec-api.xml b/Documentation/DocBook/media/v4l/cec-api.xml
index caa04c0..7062c1f 100644
--- a/Documentation/DocBook/media/v4l/cec-api.xml
+++ b/Documentation/DocBook/media/v4l/cec-api.xml
@@ -30,6 +30,10 @@

   <section id="cec-intro">
     <title>Introduction</title>
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
     <para>HDMI connectors provide a single pin for use by the Consumer Electronics
     Control protocol. This protocol allows different devices connected by an HDMI cable
     to communicate. The protocol for CEC version 1.4 is defined in supplements 1 (CEC)
@@ -48,8 +52,7 @@
     <para>In addition, CEC can be implemented in HDMI receivers, transmitters and in USB
     devices that have an HDMI input and an HDMI output and that control just the CEC pin.</para>

-    <para>Drivers that support CEC and that allow (or require) userspace to handle CEC
-    messages and/or configure the CEC adapter will create a CEC device node (/dev/cecX)
+    <para>Drivers that support CEC will create a CEC device node (/dev/cecX)
     to give userspace access to the CEC adapter. The &CEC-ADAP-G-CAPS; ioctl will tell userspace
     what it is allowed to do.</para>
   </section>
diff --git a/Documentation/DocBook/media/v4l/cec-func-close.xml b/Documentation/DocBook/media/v4l/cec-func-close.xml
index c3978af..0812c8c 100644
--- a/Documentation/DocBook/media/v4l/cec-func-close.xml
+++ b/Documentation/DocBook/media/v4l/cec-func-close.xml
@@ -35,6 +35,11 @@
   <refsect1>
     <title>Description</title>

+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>Closes the cec device. Resources associated with the file descriptor
     are freed. The device configuration remain unchanged.</para>
   </refsect1>
diff --git a/Documentation/DocBook/media/v4l/cec-func-ioctl.xml b/Documentation/DocBook/media/v4l/cec-func-ioctl.xml
index 0480eeb..f92817a 100644
--- a/Documentation/DocBook/media/v4l/cec-func-ioctl.xml
+++ b/Documentation/DocBook/media/v4l/cec-func-ioctl.xml
@@ -49,6 +49,11 @@

   <refsect1>
     <title>Description</title>
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>The <function>ioctl()</function> function manipulates cec device
     parameters. The argument <parameter>fd</parameter> must be an open file
     descriptor.</para>
diff --git a/Documentation/DocBook/media/v4l/cec-func-open.xml b/Documentation/DocBook/media/v4l/cec-func-open.xml
index d814847..2edc555 100644
--- a/Documentation/DocBook/media/v4l/cec-func-open.xml
+++ b/Documentation/DocBook/media/v4l/cec-func-open.xml
@@ -33,14 +33,24 @@
       <varlistentry>
 	<term><parameter>flags</parameter></term>
 	<listitem>
-	  <para>Open flags. Access mode must be either <constant>O_RDONLY</constant>
-	  or <constant>O_RDWR</constant>. Other flags have no effect.</para>
+	  <para>Open flags. Access mode must be <constant>O_RDWR</constant>.
+	  </para>
+	  <para>When the <constant>O_NONBLOCK</constant> flag is
+given, the &CEC-RECEIVE; ioctl will return &EAGAIN; when no message is
+available, and the &CEC-TRANSMIT;, &CEC-ADAP-S-PHYS-ADDR; and
+&CEC-ADAP-S-LOG-ADDRS; ioctls all act in non-blocking mode.</para>
+	  <para>Other flags have no effect.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
   <refsect1>
     <title>Description</title>
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>To open a cec device applications call <function>open()</function>
     with the desired device name. The function has no side effects; the device
     configuration remain unchanged.</para>
@@ -53,7 +63,7 @@

     <para><function>open</function> returns the new file descriptor on success.
     On error, -1 is returned, and <varname>errno</varname> is set appropriately.
-    Possible error codes are:</para>
+    Possible error codes include:</para>

     <variablelist>
       <varlistentry>
diff --git a/Documentation/DocBook/media/v4l/cec-func-poll.xml b/Documentation/DocBook/media/v4l/cec-func-poll.xml
index 6853817..1bddbde 100644
--- a/Documentation/DocBook/media/v4l/cec-func-poll.xml
+++ b/Documentation/DocBook/media/v4l/cec-func-poll.xml
@@ -24,6 +24,11 @@
   <refsect1>
     <title>Description</title>

+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>With the <function>poll()</function> function applications
 can wait for CEC events.</para>

diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
index b99ed22..3523ef2 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
@@ -49,6 +49,11 @@
   <refsect1>
     <title>Description</title>

+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>All cec devices must support the <constant>CEC_ADAP_G_CAPS</constant>
     ioctl. To query device information, applications call the ioctl with a
     pointer to a &cec-caps;. The driver fills the structure and returns
@@ -96,20 +101,26 @@
 	    <entry><constant>CEC_CAP_PHYS_ADDR</constant></entry>
 	    <entry>0x00000001</entry>
 	    <entry>Userspace has to configure the physical address by
-	    calling &CEC-ADAP-S-PHYS-ADDR;.</entry>
+	    calling &CEC-ADAP-S-PHYS-ADDR;. If this capability isn't set,
+	    then setting the physical address is handled by the kernel
+	    whenever the EDID is set (for an HDMI receiver) or read (for
+	    an HDMI transmitter).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>CEC_CAP_LOG_ADDRS</constant></entry>
 	    <entry>0x00000002</entry>
 	    <entry>Userspace has to configure the logical addresses by
-	    calling &CEC-ADAP-S-LOG-ADDRS;.</entry>
+	    calling &CEC-ADAP-S-LOG-ADDRS;. If this capability isn't set,
+	    then the kernel will have configured this.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>CEC_CAP_TRANSMIT</constant></entry>
 	    <entry>0x00000004</entry>
 	    <entry>Userspace can transmit CEC messages by calling &CEC-TRANSMIT;. This
 	    implies that userspace can be a follower as well, since being able to
-	    transmit messages is a prerequisite of becoming a follower.
+	    transmit messages is a prerequisite of becoming a follower. If this
+	    capability isn't set, then the kernel will handle all CEC transmits
+	    and process all CEC messages it receives.
 	    </entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
index 01bc5ab..302b829 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
@@ -50,15 +50,20 @@
   <refsect1>
     <title>Description</title>

-    <para>To query the current CEC logical addresses applications call the
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
+    <para>To query the current CEC logical addresses, applications call the
 <constant>CEC_ADAP_G_LOG_ADDRS</constant> ioctl with a pointer to a
 <structname>cec_log_addrs</structname> structure where the drivers stores the
 logical addresses.</para>

-    <para>To set new logical addresses applications fill in struct <structname>cec_log_addrs</structname>
+    <para>To set new logical addresses, applications fill in struct <structname>cec_log_addrs</structname>
 and call the <constant>CEC_ADAP_S_LOG_ADDRS</constant> ioctl with a pointer to this struct.
 The <constant>CEC_ADAP_S_LOG_ADDRS</constant> ioctl is only available if
-<constant>CEC_CAP_LOG_ADDRS</constant> is set. This ioctl will block until all
+<constant>CEC_CAP_LOG_ADDRS</constant> is set (&ENOTTY; is returned otherwise). This ioctl will block until all
 requested logical addresses have been claimed. <constant>CEC_ADAP_S_LOG_ADDRS</constant>
 can only be called by a file handle in initiator mode (see &CEC-S-MODE;).</para>

@@ -81,7 +86,7 @@ can only be called by a file handle in initiator mode (see &CEC-S-MODE;).</para>
 	    <entry><structfield>log_addr_mask</structfield></entry>
 	    <entry>The bitmask of all logical addresses this adapter has claimed.
 	    If this adapter is Unregistered then <structfield>log_addr_mask</structfield>
-	    sets bit 15, if this adapter is not configured at all, then
+	    sets bit 15 and clears all other bits. If this adapter is not configured at all, then
 	    <structfield>log_addr_mask</structfield> is set to 0. Set by the driver.</entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
index 7a08269..d95f178 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
@@ -50,6 +50,11 @@
   <refsect1>
     <title>Description</title>

+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>To query the current physical address applications call the
 <constant>CEC_ADAP_G_PHYS_ADDR</constant> ioctl with a pointer to an __u16
 where the driver stores the physical address.</para>
@@ -57,11 +62,10 @@ where the driver stores the physical address.</para>
     <para>To set a new physical address applications store the physical address in
 an __u16 and call the <constant>CEC_ADAP_S_PHYS_ADDR</constant> ioctl with a
 pointer to this integer. <constant>CEC_ADAP_S_PHYS_ADDR</constant> is only
-available if <constant>CEC_CAP_PHYS_ADDR</constant> is set. It is not allowed
-to change a valid physical address to another valid physical address: you must
-select <constant>CEC_PHYS_ADDR_INVALID</constant> (f.f.f.f) first.
-<constant>CEC_ADAP_S_PHYS_ADDR</constant>
-can only be called by a file handle in initiator mode (see &CEC-S-MODE;).</para>
+available if <constant>CEC_CAP_PHYS_ADDR</constant> is set (&ENOTTY; will be returned
+otherwise). <constant>CEC_ADAP_S_PHYS_ADDR</constant>
+can only be called by a file handle in initiator mode (see &CEC-S-MODE;), if not
+&EBUSY; will be returned.</para>

     <para>The physical address is a 16-bit number where each group of 4 bits
 represent a digit of the physical address a.b.c.d where the most significant
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml b/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
index 6a9960f..87d4f29 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
@@ -49,6 +49,11 @@
   <refsect1>
     <title>Description</title>

+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>CEC devices can send asynchronous events. These can be retrieved by calling
     the <constant>CEC_DQEVENT</constant> ioctl. If the file descriptor is in non-blocking
     mode and no event is pending, then it will return -1 and set errno to the &EAGAIN;.</para>
@@ -110,7 +115,7 @@
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>event</structfield></entry>
-	    <entry>The event, see <xref linkend="cec-events" />.</entry>
+	    <entry>The CEC event type, see <xref linkend="cec-events" />.</entry>
 	    <entry></entry>
 	  </row>
 	  <row>
@@ -144,7 +149,7 @@
     </table>

     <table pgwide="1" frame="none" id="cec-events">
-      <title>CEC Events</title>
+      <title>CEC Events Types</title>
       <tgroup cols="3">
 	&cs-def;
 	<tbody valign="top">
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
index 0cb1941..26b4282 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
@@ -50,12 +50,18 @@
   <refsect1>
     <title>Description</title>

+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>By default any filehandle can use &CEC-TRANSMIT; and &CEC-RECEIVE;, but
-in order to prevent applications from stepping on each others toes you want to get
-exclusive access to the CEC adapter. This ioctl allows you to try and become the
-exclusive initiator and/or follower. The initiator is the filehandle that is used
+in order to prevent applications from stepping on each others toes it must be possible
+to obtain exclusive access to the CEC adapter. This ioctl sets the filehandle
+to initiator and/or follower mode which can be exclusive depending on the chosen
+mode. The initiator is the filehandle that is used
 to initiate messages, i.e. it commands other CEC devices. The follower is the filehandle
-that receives messages sent to our CEC adapter and processes them. The same filehandle
+that receives messages sent to the CEC adapter and processes them. The same filehandle
 can be both initiator and follower, or this role can be taken by two different
 filehandles.</para>

@@ -72,10 +78,11 @@ is a follower, then the message is passed on to the follower who will use
 make the right decisions.</para>

     <para>The CEC framework will process core messages unless requested otherwise
-by the follower. The follower can enable the passthrough mode. In that case the
-CEC framework will pass on most core messages without processing them. In that
-case the follower will have to implement those messages. There are some messages
-that the core will always process, regardless of the passthrough mode.</para>
+by the follower. The follower can enable the passthrough mode. In that case, the
+CEC framework will pass on most core messages without processing them and
+the follower will have to implement those messages. There are some messages
+that the core will always process, regardless of the passthrough mode. See
+<xref linkend="cec-core-processing" /> for details.</para>

     <para>If there is no initiator, then any CEC filehandle can use &CEC-TRANSMIT;.
 If there is an exclusive initiator then only that initiator can call &CEC-TRANSMIT;.
@@ -162,7 +169,9 @@ The follower can of course always call &CEC-TRANSMIT;.</para>
 	    with <constant>CEC_MODE_NO_INITIATOR</constant>, otherwise &EINVAL; will be
 	    returned. In monitor mode all messages this CEC device transmits and all messages
 	    it receives (both broadcast messages and directed messages for one its logical
-	    addresses) will be reported. This is very useful for debugging.</entry>
+	    addresses) will be reported. This is very useful for debugging. This is only
+	    allowed if the process has the <constant>CAP_NET_ADMIN</constant>
+	    capability. If that is not set, then &EPERM; is returned.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>CEC_MODE_MONITOR_ALL</constant></entry>
@@ -172,8 +181,9 @@ The follower can of course always call &CEC-TRANSMIT;.</para>
             returned. In 'monitor all' mode all messages this CEC device transmits and all messages
             it receives, including directed messages for other CEC devices will be reported. This
 	    is very useful for debugging, but not all devices support this. This mode requires that
-	    the <constant>CEC_CAP_MONITOR_ALL</constant> capability is set, and depending on the
-	    hardware, you may have to be root to select this mode.</entry>
+	    the <constant>CEC_CAP_MONITOR_ALL</constant> capability is set, otherwise &EINVAL; is
+	    returned. This is only allowed if the process has the <constant>CAP_NET_ADMIN</constant>
+	    capability. If that is not set, then &EPERM; is returned.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
index 66bf82f..4da7239 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
@@ -50,6 +50,11 @@
   <refsect1>
     <title>Description</title>

+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
     <para>To receive a CEC message the application has to fill in the
     <structname>cec_msg</structname> structure and pass it to the
     <constant>CEC_RECEIVE</constant> ioctl. <constant>CEC_RECEIVE</constant> is
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6c2acb6..929c500 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -222,7 +222,7 @@ config VIDEO_ADV7604
 config VIDEO_ADV7604_CEC
 	bool "Enable Analog Devices ADV7604 CEC support"
 	depends on VIDEO_ADV7604 && MEDIA_CEC
-	default y
+	default n
 	---help---
 	  When selected the adv7604 will support the optional
 	  HDMI CEC feature.
@@ -244,7 +244,7 @@ config VIDEO_ADV7842
 config VIDEO_ADV7842_CEC
 	bool "Enable Analog Devices ADV7842 CEC support"
 	depends on VIDEO_ADV7842 && MEDIA_CEC
-	default y
+	default n
 	---help---
 	  When selected the adv7842 will support the optional
 	  HDMI CEC feature.
@@ -477,7 +477,7 @@ config VIDEO_ADV7511
 config VIDEO_ADV7511_CEC
 	bool "Enable Analog Devices ADV7511 CEC support"
 	depends on VIDEO_ADV7511 && MEDIA_CEC
-	default y
+	default n
 	---help---
 	  When selected the adv7511 will support the optional
 	  HDMI CEC feature.
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 20c5eea..dbb1584 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -26,7 +26,7 @@ config VIDEO_VIVID
 config VIDEO_VIVID_CEC
 	bool "Enable CEC emulation support"
 	depends on VIDEO_VIVID && MEDIA_CEC
-	default y
+	default n
 	---help---
 	  When selected the vivid module will emulate the optional
 	  HDMI CEC feature.
diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index 2ad7f06..b5714fa 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -1,7 +1,7 @@
 /*
- * vivid-core.c - A Virtual Video Test Driver, core initialization
+ * vivid-cec.c - A Virtual Video Test Driver, cec emulation
  *
- * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
  *
  * This program is free software; you may redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index c0751ef..e3c384a 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -10,4 +10,14 @@ them public.

 Hopefully this will happen later in 2016.

+Other TODOs:
+
+- Add a flag to inhibit passing CEC RC messages to the rc subsystem.
+  Applications should be able to choose this when calling S_LOG_ADDRS.
+- Convert cec.txt to sphinx.
+- If the reply field of cec_msg is set then when the reply arrives it
+  is only sent to the filehandle that transmitted the original message
+  and not to any followers. Should this behavior change or perhaps
+  controlled through a cec_msg flag?
+
 Hans Verkuil <hans.verkuil@cisco.com>
diff --git a/drivers/staging/media/cec/cec.c b/drivers/staging/media/cec/cec.c
index 65a3cb3..8634773 100644
--- a/drivers/staging/media/cec/cec.c
+++ b/drivers/staging/media/cec/cec.c
@@ -1827,9 +1827,17 @@ static long cec_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
 		struct cec_event_queue *evq = NULL;
 		struct cec_event *ev = NULL;
 		u64 ts = ~0ULL;
-		unsigned i;
+		unsigned int i;

 		mutex_lock(&fh->lock);
+		while (!fh->events && block) {
+			mutex_unlock(&fh->lock);
+			err = wait_event_interruptible(fh->wait, fh->events);
+			if (err)
+				return err;
+			mutex_lock(&fh->lock);
+		}
+
 		/* Find the oldest event */
 		for (i = 0; i < CEC_NUM_EVENTS; i++) {
 			struct cec_event_queue *q = fh->evqueue + i;
@@ -1975,6 +1983,10 @@ static long cec_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
 		if (mode_initiator && mode_follower >= CEC_MODE_MONITOR)
 			return -EINVAL;

+		/* Monitor modes require CAP_NET_ADMIN */
+		if (mode_follower >= CEC_MODE_MONITOR && !capable(CAP_NET_ADMIN))
+			return -EPERM;
+
 		mutex_lock(&adap->lock);
 		/*
 		 * You can't become exclusive follower if someone else already
diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 25c37bb..155f6b9 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -835,6 +835,7 @@ static inline void cec_ops_set_menu_language(struct cec_msg *msg,
 					     char *language)
 {
 	memcpy(language, msg->msg + 2, 3);
+	language[3] = '\0';
 }

 static inline void cec_msg_get_menu_language(struct cec_msg *msg,
@@ -1574,6 +1576,7 @@ static inline void cec_msg_report_current_latency(struct cec_msg *msg,
 						  __u8 audio_out_delay)
 {
 	msg->len = 7;
+	msg->msg[0] |= 0xf; /* broadcast */
 	msg->msg[1] = CEC_MSG_REPORT_CURRENT_LATENCY;
 	msg->msg[2] = phys_addr >> 8;
 	msg->msg[3] = phys_addr & 0xff;
@@ -1601,6 +1604,7 @@ static inline void cec_msg_request_current_latency(struct cec_msg *msg,
 						   __u16 phys_addr)
 {
 	msg->len = 4;
+	msg->msg[0] |= 0xf; /* broadcast */
 	msg->msg[1] = CEC_MSG_REQUEST_CURRENT_LATENCY;
 	msg->msg[2] = phys_addr >> 8;
 	msg->msg[3] = phys_addr & 0xff;
diff --git a/include/media/cec-edid.h b/include/media/cec-edid.h
index d6e39ca..bdf731e 100644
--- a/include/media/cec-edid.h
+++ b/include/media/cec-edid.h
@@ -21,8 +21,8 @@
 #define _MEDIA_CEC_EDID_H

 #include <linux/types.h>
-#include <linux/cec.h>

+#define CEC_PHYS_ADDR_INVALID		0xffff
 #define cec_phys_addr_exp(pa) \
 	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf

