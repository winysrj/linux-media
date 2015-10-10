Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbJJNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 25/26] [media] DocBook: Add documentation about the demux API
Date: Sat, 10 Oct 2015 10:36:08 -0300
Message-Id: <de08e701c6b9edb0e555da48a95c9250cbec3ea8.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several stuff at media's kdapi.xml that don't
belong there, as it documents the Kernel internal ABI, and
not the userspace API.

Add the documentation here. The hole kdapi.xml will be
removed on a latter patch, after we finish documenting
what's there at the proper places.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 8d5620aeaf36..42a2d8593e39 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -239,21 +239,86 @@ X!Isound/sound_firmware.c
      </sect1>
      <sect1><title>Digital TV (DVB) devices</title>
 !Idrivers/media/dvb-core/dvb_ca_en50221.h
-!Idrivers/media/dvb-core/demux.h
 !Idrivers/media/dvb-core/dvb_frontend.h
 !Idrivers/media/dvb-core/dvb_math.h
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
 !Idrivers/media/dvb-core/dvbdev.h
-     </sect1>
-     <sect1><title>Remote Controller devices</title>
+	<sect1><title>Digital TV Demux API</title>
+	    <para>The kernel demux API defines a driver-internal interface for
+	    registering low-level, hardware specific driver to a hardware
+	    independent demux layer. It is only of interest for Digital TV
+	    device driver writers. The header file for this API is named
+	    <constant>demux.h</constant> and located in
+	    <constant>drivers/media/dvb-core</constant>.</para>
+
+	<para>The demux API should be implemented for each demux in the
+	system. It is used to select the TS source of a demux and to manage
+	the demux resources. When the demux client allocates a resource via
+	the demux API, it receives a pointer to the API of that
+	resource.</para>
+	<para>Each demux receives its TS input from a DVB front-end or from
+	memory, as set via this demux API. In a system with more than one
+	front-end, the API can be used to select one of the DVB front-ends
+	as a TS source for a demux, unless this is fixed in the HW platform.
+	The demux API only controls front-ends regarding to their connections
+	with demuxes; the APIs used to set the other front-end parameters,
+	such as tuning, are not defined in this document.</para>
+	<para>The functions that implement the abstract interface demux should
+	be defined static or module private and registered to the Demux
+	core for external access. It is not necessary to implement every
+	function in the struct <constant>dmx_demux</constant>. For example,
+	a demux interface might support Section filtering, but not PES
+	filtering. The API client is expected to check the value of any
+	function pointer before calling the function: the value of NULL means
+	that the &#8220;function is not available&#8221;.</para>
+	<para>Whenever the functions of the demux API modify shared data,
+	the possibilities of lost update and race condition problems should
+	be addressed, e.g. by protecting parts of code with mutexes.</para>
+	<para>Note that functions called from a bottom half context must not
+	sleep. Even a simple memory allocation without using GFP_ATOMIC can
+	result in a kernel thread being put to sleep if swapping is needed.
+	For example, the Linux kernel calls the functions of a network device
+	interface from a bottom half context. Thus, if a demux API function
+	is called from network device code, the function must not sleep.
+	</para>
+    </sect1>
+
+    <section id="demux_callback_api">
+	<title>Demux Callback API</title>
+	<para>This kernel-space API comprises the callback functions that
+	deliver filtered data to the demux client. Unlike the other DVB
+	kABIs, these functions are provided by the client and called from
+	the demux code.</para>
+	<para>The function pointers of this abstract interface are not
+	packed into a structure as in the other demux APIs, because the
+	callback functions are registered and used independent of each
+	other. As an example, it is possible for the API client to provide
+	several callback functions for receiving TS packets and no
+	callbacks for PES packets or sections.</para>
+	<para>The functions that implement the callback API need not be
+	re-entrant: when a demux driver calls one of these functions,
+	the driver is not allowed to call the function again before
+	the original call returns. If a callback is triggered by a
+	hardware interrupt, it is recommended to use the Linux
+	&#8220;bottom half&#8221; mechanism or start a tasklet instead of
+	making the callback function call directly from a hardware
+	interrupt.</para>
+	<para>This mechanism is implemented by
+	<link linkend='API-dmx-ts-cb'>dmx_ts_cb()</link> and
+	<link linkend='API-dmx-section-cb'>dmx_section_cb()</link>.</para>
+    </section>
+
+!Idrivers/media/dvb-core/demux.h
+    </sect1>
+    <sect1><title>Remote Controller devices</title>
 !Iinclude/media/rc-core.h
 !Iinclude/media/lirc_dev.h
-     </sect1>
-     <sect1><title>Media Controller devices</title>
+    </sect1>
+    <sect1><title>Media Controller devices</title>
 !Iinclude/media/media-device.h
 !Iinclude/media/media-devnode.h
 !Iinclude/media/media-entity.h
-     </sect1>
+    </sect1>
 
   </chapter>
 
-- 
2.4.3


