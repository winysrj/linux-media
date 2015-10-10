Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbJJNgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 12/26] [media] DocBook: update documented fields at struct dmx_demux
Date: Sat, 10 Oct 2015 10:35:55 -0300
Message-Id: <28cff82ce2811a15bbaa4e978c64a231ddc71880.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few inconsistencies between the old documentation
that got imported into the header and the current status.

Update them, and use the proper doc-nano nomenclature for
struct artuments "@", instead of foo().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 54c3df38bb1b..ca56d1cc57bd 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -214,10 +214,10 @@ struct dmx_frontend {
  *
  * @open: This function reserves the demux for use by the caller and, if
  *	necessary, initializes the demux. When the demux is no longer needed,
- * 	the function close() should be called. It should be possible for
+ * 	the function @close should be called. It should be possible for
  *	multiple clients to access the demux at the same time. Thus, the
  *	function implementation should increment the demux usage count when
- *	open() is called and decrement it when close() is called.
+ *	@open is called and decrement it when @close is called.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
  *	It returns
@@ -227,15 +227,15 @@ struct dmx_frontend {
  *
  * @close: This function reserves the demux for use by the caller and, if
  *	necessary, initializes the demux. When the demux is no longer needed,
- *	the function close() should be called. It should be possible for
+ *	the function @close should be called. It should be possible for
  *	multiple clients to access the demux at the same time. Thus, the
  *	function implementation should increment the demux usage count when
- *	open() is called and decrement it when close() is called.
+ *	@open is called and decrement it when @close is called.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
  *	It returns
  *		0 on success;
- *		-ENODEV, if demux was not in use
+ *		-ENODEV, if demux was not in use (e. g. no users);
  *		-EINVAL, on bad parameter.
  *
  * @write: This function provides the demux driver with a memory buffer
@@ -253,7 +253,9 @@ struct dmx_frontend {
  *	The @count function parameter contains the length of the TS data.
  *	It returns
  *		0 on success;
- *		-ENOSYS, if the command is not implemented;
+ *		-ERESTARTSYS, if mutex lock was interrupted;
+ *		-EINTR, if a signal handling is pending;
+ *		-ENODEV, if demux was removed;
  *		-EINVAL, on bad parameter.
  *
  * @allocate_ts_feed: Allocates a new TS feed, which is used to filter the TS
@@ -267,11 +269,11 @@ struct dmx_frontend {
  *	function for passing received TS packet.
  *	It returns
  *		0 on success;
+ *		-ERESTARTSYS, if mutex lock was interrupted;
  *		-EBUSY, if no more TS feeds is available;
- *		-ENOSYS, if the command is not implemented;
  *		-EINVAL, on bad parameter.
  *
- * @release_ts_feed: Releases the resources allocated with allocate_ts_feed().
+ * @release_ts_feed: Releases the resources allocated with @allocate_ts_feed.
  *	Any filtering in progress on the TS feed should be stopped before
  *	calling this function.
  *	The @demux function parameter contains a pointer to the demux API and
@@ -299,11 +301,10 @@ struct dmx_frontend {
  *	It returns
  *		0 on success;
  *		-EBUSY, if no more TS feeds is available;
- *		-ENOSYS, if the command is not implemented;
  *		-EINVAL, on bad parameter.
  *
  * @release_section_feed: Releases the resources allocated with
- *	allocate_section_feed(), including allocated filters. Any filtering in
+ *	@allocate_section_feed, including allocated filters. Any filtering in
  *	progress on the section feed should be stopped before calling this
  *	function.
  *	The @demux function parameter contains a pointer to the demux API and
@@ -316,31 +317,27 @@ struct dmx_frontend {
  *
  * @add_frontend: Registers a connectivity between a demux and a front-end,
  *	i.e., indicates that the demux can be connected via a call to
- *	connect_frontend() to use the given front-end as a TS source. The
+ *	@connect_frontend to use the given front-end as a TS source. The
  *	client of this function has to allocate dynamic or static memory for
  *	the frontend structure and initialize its fields before calling this
  *	function. This function is normally called during the driver
  *	initialization. The caller must not free the memory of the frontend
- *	struct before successfully calling remove_frontend().
+ *	struct before successfully calling @remove_frontend.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
  *	The @frontend function parameter contains a pointer to the front-end
  *	instance data.
  *	It returns
  *		0 on success;
- *		-EEXIST, if a front-end with the same value of the id field
- *			already registered;
- * 		-EINUSE, if the demux is in use;
- *		-ENOMEM, if no more front-ends can be added;
  *		-EINVAL, on bad parameter.
  *
  * @remove_frontend: Indicates that the given front-end, registered by a call
- *	to add_frontend(), can no longer be connected as a TS source by this
+ *	to @add_frontend, can no longer be connected as a TS source by this
  *	demux. The function should be called when a front-end driver or a demux
  *	driver is removed from the system. If the front-end is in use, the
  *	function fails with the return value of -EBUSY. After successfully
  *	calling this function, the caller can free the memory of the frontend
- *	struct if it was dynamically allocated before the add_frontend()
+ *	struct if it was dynamically allocated before the @add_frontend
  *	operation.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
@@ -348,18 +345,16 @@ struct dmx_frontend {
  *	instance data.
  *	It returns
  *		0 on success;
- *		-EBUSY, if the front-end is in use, i.e. a call to
- *			connect_frontend() has not been followed by a call to
- *			disconnect_frontend();
+ *		-ENODEV, if the front-end was not found,
  *		-EINVAL, on bad parameter.
  *
  * @get_frontends: Provides the APIs of the front-ends that have been
  *	registered for this demux. Any of the front-ends obtained with this
- *	call can be used as a parameter for connect_frontend(). The include
+ *	call can be used as a parameter for @connect_frontend. The include
  *	file demux.h contains the macro DMX_FE_ENTRY() for converting an
- *	element of the generic type struct list_head* to the type
- * 	dmx_frontend_t*. The caller must not free the memory of any of the
- *	elements obtained via this function call.
+ *	element of the generic type struct &list_head * to the type
+ * 	struct &dmx_frontend *. The caller must not free the memory of any of
+ *	the elements obtained via this function call.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
  *	It returns a struct list_head pointer to the list of front-end
@@ -367,21 +362,20 @@ struct dmx_frontend {
  *
  * @connect_frontend: Connects the TS output of the front-end to the input of
  *	the demux. A demux can only be connected to a front-end registered to
- *	the demux with the function add_frontend(). It may or may not be
+ *	the demux with the function @add_frontend. It may or may not be
  *	possible to connect multiple demuxes to the same front-end, depending
  *	on the capabilities of the HW platform. When not used, the front-end
- *	should be released by calling disconnect_frontend().
+ *	should be released by calling @disconnect_frontend.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
  *	The @frontend function parameter contains a pointer to the front-end
  *	instance data.
  *	It returns
  *		0 on success;
- *		-EBUSY, if the front-end is in use;
  *		-EINVAL, on bad parameter.
  *
  * @disconnect_frontend: Disconnects the demux and a front-end previously
- *	connected by a connect_frontend() call.
+ *	connected by a @connect_frontend call.
  *	The @demux function parameter contains a pointer to the demux API and
  *	instance data.
  *	It returns
-- 
2.4.3


