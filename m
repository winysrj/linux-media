Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbcGQOaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 10:30:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 7/7] [media] doc-rst: Fix conversion for dvb-core.rst
Date: Sun, 17 Jul 2016 11:30:04 -0300
Message-Id: <3ff2fb91f8c6af307d12f83f2f805c4851e245fd.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion from DocBook required some fixes:

- Now, the C files with the exported symbols also need to be
  added. So, all headers need to be included twice: one to
  get the structs/enums/.. and another one for the functions;

- Notes should use the ReST tag, as kernel-doc doesn't
  recognizes it anymore;

- Identation needs to be fixed, as ReST uses it to identify
  when a format "tag" ends.

- Fix the cross-references at the media controller description.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst | 40 +++++++++++-----
 drivers/media/dvb-core/demux.h        | 90 +++++++++++++++++------------------
 2 files changed, 72 insertions(+), 58 deletions(-)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index fa462d5d0247..3291190c1865 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -11,6 +11,15 @@ Digital TV Common functions
 .. kernel-doc:: drivers/media/dvb-core/dvbdev.h
 
 
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_math.h
+   :export: drivers/media/dvb-core/dvb_math.c
+
+.. kernel-doc:: drivers/media/dvb-core/dvbdev.h
+   :export: drivers/media/dvb-core/dvbdev.c
+
+
+
 Digital TV Frontend kABI
 ------------------------
 
@@ -24,17 +33,20 @@ The header file for this API is named dvb_frontend.h and located in
 drivers/media/dvb-core.
 
 Before using the Digital TV frontend core, the bridge driver should attach
-the frontend demod, tuner and SEC devices and call dvb_register_frontend(),
+the frontend demod, tuner and SEC devices and call
+:cpp:func:`dvb_register_frontend()`,
 in order to register the new frontend at the subsystem. At device
-detach/removal, the bridge driver should call dvb_unregister_frontend() to
-remove the frontend from the core and then dvb_frontend_detach() to free the
-memory allocated by the frontend drivers.
+detach/removal, the bridge driver should call
+:cpp:func:`dvb_unregister_frontend()` to
+remove the frontend from the core and then :cpp:func:`dvb_frontend_detach()`
+to free the memory allocated by the frontend drivers.
 
-The drivers should also call dvb_frontend_suspend() as part of their
-handler for the &device_driver.suspend(), and dvb_frontend_resume() as
-part of their handler for &device_driver.resume().
+The drivers should also call :cpp:func:`dvb_frontend_suspend()` as part of
+their handler for the :c:type:`device_driver`.\ ``suspend()``, and
+:cpp:func:`dvb_frontend_resume()` as
+part of their handler for :c:type:`device_driver`.\ ``resume()``.
 
-few other optional functions are provided to handle some special cases.
+A few other optional functions are provided to handle some special cases.
 
 .. kernel-doc:: drivers/media/dvb-core/dvb_frontend.h
 
@@ -70,7 +82,7 @@ static or module private and registered to the Demux core for external
 access. It is not necessary to implement every function in the struct
 &dmx_demux. For example, a demux interface might support Section filtering,
 but not PES filtering. The kABI client is expected to check the value of any
-function pointer before calling the function: the value of NULL means
+function pointer before calling the function: the value of ``NULL`` means
 that the function is not available.
 
 Whenever the functions of the demux API modify shared data, the
@@ -78,7 +90,7 @@ possibilities of lost update and race condition problems should be
 addressed, e.g. by protecting parts of code with mutexes.
 
 Note that functions called from a bottom half context must not sleep.
-Even a simple memory allocation without using %GFP_ATOMIC can result in a
+Even a simple memory allocation without using ``GFP_ATOMIC`` can result in a
 kernel thread being put to sleep if swapping is needed. For example, the
 Linux Kernel calls the functions of a network device interface from a
 bottom half context. Thus, if a demux kABI function is called from network
@@ -109,14 +121,16 @@ triggered by a hardware interrupt, it is recommended to use the Linux
 bottom half mechanism or start a tasklet instead of making the callback
 function call directly from a hardware interrupt.
 
-This mechanism is implemented by dmx_ts_cb() and dmx_section_cb()
+This mechanism is implemented by :cpp:func:`dmx_ts_cb()` and :cpp:func:`dmx_section_cb()`
 callbacks.
 
-
 .. kernel-doc:: drivers/media/dvb-core/demux.h
 
-
 Digital TV Conditional Access kABI
 ----------------------------------
 
 .. kernel-doc:: drivers/media/dvb-core/dvb_ca_en50221.h
+
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_ca_en50221.h
+   :export: drivers/media/dvb-core/dvb_ca_en50221.c
diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index e8f04f8872f8..ad42252b1c66 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -379,10 +379,10 @@ enum dmx_demux_caps {
  *	@open is called and decrement it when @close is called.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
- *	It returns
- *		0 on success;
- *		-EUSERS, if maximum usage count was reached;
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EUSERS, if maximum usage count was reached;
+ *	-EINVAL, on bad parameter.
  *
  * @close: This function reserves the demux for use by the caller and, if
  *	necessary, initializes the demux. When the demux is no longer needed,
@@ -392,10 +392,10 @@ enum dmx_demux_caps {
  *	@open is called and decrement it when @close is called.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
- *	It returns
- *		0 on success;
- *		-ENODEV, if demux was not in use (e. g. no users);
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-ENODEV, if demux was not in use (e. g. no users);
+ *	-EINVAL, on bad parameter.
  *
  * @write: This function provides the demux driver with a memory buffer
  *	containing TS packets. Instead of receiving TS packets from the DVB
@@ -410,12 +410,12 @@ enum dmx_demux_caps {
  *	The @buf function parameter contains a pointer to the TS data in
  *	kernel-space memory.
  *	The @count function parameter contains the length of the TS data.
- *	It returns
- *		0 on success;
- *		-ERESTARTSYS, if mutex lock was interrupted;
- *		-EINTR, if a signal handling is pending;
- *		-ENODEV, if demux was removed;
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-ERESTARTSYS, if mutex lock was interrupted;
+ *	-EINTR, if a signal handling is pending;
+ *	-ENODEV, if demux was removed;
+ *	-EINVAL, on bad parameter.
  *
  * @allocate_ts_feed: Allocates a new TS feed, which is used to filter the TS
  *	packets carrying a certain PID. The TS feed normally corresponds to a
@@ -426,11 +426,11 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @callback function parameter contains a pointer to the callback
  *	function for passing received TS packet.
- *	It returns
- *		0 on success;
- *		-ERESTARTSYS, if mutex lock was interrupted;
- *		-EBUSY, if no more TS feeds is available;
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-ERESTARTSYS, if mutex lock was interrupted;
+ *	-EBUSY, if no more TS feeds is available;
+ *	-EINVAL, on bad parameter.
  *
  * @release_ts_feed: Releases the resources allocated with @allocate_ts_feed.
  *	Any filtering in progress on the TS feed should be stopped before
@@ -439,9 +439,9 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @feed function parameter contains a pointer to the TS feed API and
  *	instance data.
- *	It returns
- *		0 on success;
- *		-EINVAL on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EINVAL on bad parameter.
  *
  * @allocate_section_feed: Allocates a new section feed, i.e. a demux resource
  *	for filtering and receiving sections. On platforms with hardware
@@ -457,10 +457,10 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @callback function parameter contains a pointer to the callback
  *	function for passing received TS packet.
- *	It returns
- *		0 on success;
- *		-EBUSY, if no more TS feeds is available;
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EBUSY, if no more TS feeds is available;
+ *	-EINVAL, on bad parameter.
  *
  * @release_section_feed: Releases the resources allocated with
  *	@allocate_section_feed, including allocated filters. Any filtering in
@@ -470,9 +470,9 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @feed function parameter contains a pointer to the TS feed API and
  *	instance data.
- *	It returns
- *		0 on success;
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EINVAL, on bad parameter.
  *
  * @add_frontend: Registers a connectivity between a demux and a front-end,
  *	i.e., indicates that the demux can be connected via a call to
@@ -486,9 +486,9 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @frontend function parameter contains a pointer to the front-end
  *	instance data.
- *	It returns
- *		0 on success;
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EINVAL, on bad parameter.
  *
  * @remove_frontend: Indicates that the given front-end, registered by a call
  *	to @add_frontend, can no longer be connected as a TS source by this
@@ -502,10 +502,10 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @frontend function parameter contains a pointer to the front-end
  *	instance data.
- *	It returns
- *		0 on success;
- *		-ENODEV, if the front-end was not found,
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-ENODEV, if the front-end was not found,
+ *	-EINVAL, on bad parameter.
  *
  * @get_frontends: Provides the APIs of the front-ends that have been
  *	registered for this demux. Any of the front-ends obtained with this
@@ -529,17 +529,17 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @frontend function parameter contains a pointer to the front-end
  *	instance data.
- *	It returns
- *		0 on success;
- *		-EINVAL, on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EINVAL, on bad parameter.
  *
  * @disconnect_frontend: Disconnects the demux and a front-end previously
  *	connected by a @connect_frontend call.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
- *	It returns
- *		0 on success;
- *		-EINVAL on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EINVAL on bad parameter.
  *
  * @get_pes_pids: Get the PIDs for DMX_PES_AUDIO0, DMX_PES_VIDEO0,
  *	DMX_PES_TELETEXT0, DMX_PES_SUBTITLE0 and DMX_PES_PCR0.
@@ -547,9 +547,9 @@ enum dmx_demux_caps {
  *	instance data.
  *	The @pids function parameter contains an array with five u16 elements
  *	where the PIDs will be stored.
- *	It returns
- *		0 on success;
- *		-EINVAL on bad parameter.
+ *	It returns:
+ *	0 on success;
+ *	-EINVAL on bad parameter.
  */
 
 struct dmx_demux {
-- 
2.7.4

