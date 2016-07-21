Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbcGUUS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 11/12] [media] v4l2-subdev.rst: add cross references to new sections
Date: Thu, 21 Jul 2016 17:18:16 -0300
Message-Id: <963179ee800d584fb1866fadcfef3df7c1a0b560.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two new sections were missing cross-references, and had
some other minor issues with the markups. Add such things.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-subdev.rst | 152 +++++++++++++++++--------------
 1 file changed, 82 insertions(+), 70 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index 2845a749409c..80982a9d002f 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -265,27 +265,28 @@ called. All three callbacks are optional.
 V4L2 sub-device userspace API
 -----------------------------
 
-Beside exposing a kernel API through the v4l2_subdev_ops structure, V4L2
-sub-devices can also be controlled directly by userspace applications.
+Beside exposing a kernel API through the :c:type:`v4l2_subdev_ops` structure,
+V4L2 sub-devices can also be controlled directly by userspace applications.
 
-Device nodes named v4l-subdevX can be created in /dev to access sub-devices
-directly. If a sub-device supports direct userspace configuration it must set
-the V4L2_SUBDEV_FL_HAS_DEVNODE flag before being registered.
+Device nodes named ``v4l-subdev``\ *X* can be created in ``/dev`` to access
+sub-devices directly. If a sub-device supports direct userspace configuration
+it must set the ``V4L2_SUBDEV_FL_HAS_DEVNODE`` flag before being registered.
 
-After registering sub-devices, the v4l2_device driver can create device nodes
-for all registered sub-devices marked with V4L2_SUBDEV_FL_HAS_DEVNODE by calling
-v4l2_device_register_subdev_nodes(). Those device nodes will be automatically
-removed when sub-devices are unregistered.
+After registering sub-devices, the :c:type:`v4l2_device` driver can create
+device nodes for all registered sub-devices marked with
+``V4L2_SUBDEV_FL_HAS_DEVNODE`` by calling
+:cpp:func:`v4l2_device_register_subdev_nodes`. Those device nodes will be
+automatically removed when sub-devices are unregistered.
 
 The device node handles a subset of the V4L2 API.
 
-VIDIOC_QUERYCTRL
-VIDIOC_QUERYMENU
-VIDIOC_G_CTRL
-VIDIOC_S_CTRL
-VIDIOC_G_EXT_CTRLS
-VIDIOC_S_EXT_CTRLS
-VIDIOC_TRY_EXT_CTRLS
+``VIDIOC_QUERYCTRL``,
+``VIDIOC_QUERYMENU``,
+``VIDIOC_G_CTRL``,
+``VIDIOC_S_CTRL``,
+``VIDIOC_G_EXT_CTRLS``,
+``VIDIOC_S_EXT_CTRLS`` and
+``VIDIOC_TRY_EXT_CTRLS``:
 
 	The controls ioctls are identical to the ones defined in V4L2. They
 	behave identically, with the only exception that they deal only with
@@ -293,9 +294,9 @@ VIDIOC_TRY_EXT_CTRLS
 	controls can be also be accessed through one (or several) V4L2 device
 	nodes.
 
-VIDIOC_DQEVENT
-VIDIOC_SUBSCRIBE_EVENT
-VIDIOC_UNSUBSCRIBE_EVENT
+``VIDIOC_DQEVENT``,
+``VIDIOC_SUBSCRIBE_EVENT`` and
+``VIDIOC_UNSUBSCRIBE_EVENT``
 
 	The events ioctls are identical to the ones defined in V4L2. They
 	behave identically, with the only exception that they deal only with
@@ -303,12 +304,12 @@ VIDIOC_UNSUBSCRIBE_EVENT
 	events can also be reported by one (or several) V4L2 device nodes.
 
 	Sub-device drivers that want to use events need to set the
-	V4L2_SUBDEV_USES_EVENTS v4l2_subdev::flags and initialize
-	v4l2_subdev::nevents to events queue depth before registering the
-	sub-device. After registration events can be queued as usual on the
-	v4l2_subdev::devnode device node.
+	``V4L2_SUBDEV_USES_EVENTS`` :c:type:`v4l2_subdev`.flags and initialize
+	:c:type:`v4l2_subdev`.nevents to events queue depth before registering
+	the sub-device. After registration events can be queued as usual on the
+	:c:type:`v4l2_subdev`.devnode device node.
 
-	To properly support events, the poll() file operation is also
+	To properly support events, the ``poll()`` file operation is also
 	implemented.
 
 Private ioctls
@@ -321,84 +322,89 @@ I2C sub-device drivers
 ----------------------
 
 Since these drivers are so common, special helper functions are available to
-ease the use of these drivers (v4l2-common.h).
+ease the use of these drivers (``v4l2-common.h``).
 
-The recommended method of adding v4l2_subdev support to an I2C driver is to
-embed the v4l2_subdev struct into the state struct that is created for each
-I2C device instance. Very simple devices have no state struct and in that case
-you can just create a v4l2_subdev directly.
+The recommended method of adding :c:type:`v4l2_subdev` support to an I2C driver
+is to embed the :c:type:`v4l2_subdev` struct into the state struct that is
+created for each I2C device instance. Very simple devices have no state
+struct and in that case you can just create a :c:type:`v4l2_subdev` directly.
 
 A typical state struct would look like this (where 'chipname' is replaced by
 the name of the chip):
 
-.. code-block:: none
+.. code-block:: c
 
 	struct chipname_state {
 		struct v4l2_subdev sd;
 		...  /* additional state fields */
 	};
 
-Initialize the v4l2_subdev struct as follows:
+Initialize the :c:type:`v4l2_subdev` struct as follows:
 
-.. code-block:: none
+.. code-block:: c
 
 	v4l2_i2c_subdev_init(&state->sd, client, subdev_ops);
 
-This function will fill in all the fields of v4l2_subdev and ensure that the
-v4l2_subdev and i2c_client both point to one another.
+This function will fill in all the fields of :c:type:`v4l2_subdev` ensure that
+the :c:type:`v4l2_subdev` and i2c_client both point to one another.
 
-You should also add a helper inline function to go from a v4l2_subdev pointer
-to a chipname_state struct:
+You should also add a helper inline function to go from a :c:type:`v4l2_subdev`
+pointer to a chipname_state struct:
 
-.. code-block:: none
+.. code-block:: c
 
 	static inline struct chipname_state *to_state(struct v4l2_subdev *sd)
 	{
 		return container_of(sd, struct chipname_state, sd);
 	}
 
-Use this to go from the v4l2_subdev struct to the i2c_client struct:
+Use this to go from the :c:type:`v4l2_subdev` struct to the ``i2c_client``
+struct:
 
-.. code-block:: none
+.. code-block:: c
 
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-And this to go from an i2c_client to a v4l2_subdev struct:
+And this to go from an ``i2c_client`` to a :c:type:`v4l2_subdev` struct:
 
-.. code-block:: none
+.. code-block:: c
 
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
-Make sure to call v4l2_device_unregister_subdev(sd) when the remove() callback
-is called. This will unregister the sub-device from the bridge driver. It is
-safe to call this even if the sub-device was never registered.
+Make sure to call
+:cpp:func:`v4l2_device_unregister_subdev`\ (:c:type:`sd <v4l2_subdev>`)
+when the ``remove()`` callback is called. This will unregister the sub-device
+from the bridge driver. It is safe to call this even if the sub-device was
+never registered.
 
 You need to do this because when the bridge driver destroys the i2c adapter
-the remove() callbacks are called of the i2c devices on that adapter.
+the ``remove()`` callbacks are called of the i2c devices on that adapter.
 After that the corresponding v4l2_subdev structures are invalid, so they
-have to be unregistered first. Calling v4l2_device_unregister_subdev(sd)
-from the remove() callback ensures that this is always done correctly.
+have to be unregistered first. Calling
+:cpp:func:`v4l2_device_unregister_subdev`\ (:c:type:`sd <v4l2_subdev>`)
+from the ``remove()`` callback ensures that this is always done correctly.
 
 
 The bridge driver also has some helper functions it can use:
 
-.. code-block:: none
+.. code-block:: c
 
 	struct v4l2_subdev *sd = v4l2_i2c_new_subdev(v4l2_dev, adapter,
 					"module_foo", "chipid", 0x36, NULL);
 
-This loads the given module (can be NULL if no module needs to be loaded) and
-calls i2c_new_device() with the given i2c_adapter and chip/address arguments.
-If all goes well, then it registers the subdev with the v4l2_device.
+This loads the given module (can be ``NULL`` if no module needs to be loaded)
+and calls :cpp:func:`i2c_new_device` with the given ``i2c_adapter`` and
+chip/address arguments. If all goes well, then it registers the subdev with
+the v4l2_device.
 
-You can also use the last argument of v4l2_i2c_new_subdev() to pass an array
-of possible I2C addresses that it should probe. These probe addresses are
-only used if the previous argument is 0. A non-zero argument means that you
+You can also use the last argument of :cpp:func:`v4l2_i2c_new_subdev` to pass
+an array of possible I2C addresses that it should probe. These probe addresses
+are only used if the previous argument is 0. A non-zero argument means that you
 know the exact i2c address so in that case no probing will take place.
 
-Both functions return NULL if something went wrong.
+Both functions return ``NULL`` if something went wrong.
 
-Note that the chipid you pass to v4l2_i2c_new_subdev() is usually
+Note that the chipid you pass to :cpp:func:`v4l2_i2c_new_subdev` is usually
 the same as the module name. It allows you to specify a chip variant, e.g.
 "saa7114" or "saa7115". In general though the i2c driver autodetects this.
 The use of chipid is something that needs to be looked at more closely at a
@@ -408,32 +414,38 @@ for the i2c_device_id table. This lists all the possibilities.
 
 There are two more helper functions:
 
-v4l2_i2c_new_subdev_cfg: this function adds new irq and platform_data
-arguments and has both 'addr' and 'probed_addrs' arguments: if addr is not
-0 then that will be used (non-probing variant), otherwise the probed_addrs
-are probed.
+:cpp:func:`v4l2_i2c_new_subdev_cfg`: this function adds new irq and
+platform_data arguments and has both 'addr' and 'probed_addrs' arguments:
+if addr is not 0 then that will be used (non-probing variant), otherwise the
+probed_addrs are probed.
 
 For example: this will probe for address 0x10:
 
-.. code-block:: none
+.. code-block:: c
 
 	struct v4l2_subdev *sd = v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter,
 			  "module_foo", "chipid", 0, NULL, 0, I2C_ADDRS(0x10));
 
-v4l2_i2c_new_subdev_board uses an i2c_board_info struct which is passed
-to the i2c driver and replaces the irq, platform_data and addr arguments.
+:cpp:func:`v4l2_i2c_new_subdev_board` uses an :c:type:`i2c_board_info` struct
+which is passed to the i2c driver and replaces the irq, platform_data and addr
+arguments.
 
 If the subdev supports the s_config core ops, then that op is called with
-the irq and platform_data arguments after the subdev was setup. The older
-v4l2_i2c_new_(probed\_)subdev functions will call s_config as well, but with
-irq set to 0 and platform_data set to NULL.
+the irq and platform_data arguments after the subdev was setup.
 
-V4L2 subdev kAPI
-^^^^^^^^^^^^^^^^
+The older :cpp:func:`v4l2_i2c_new_subdev` and
+:cpp:func:`v4l2_i2c_new_probed_subdev` functions will call ``s_config`` as
+well, but with irq set to 0 and platform_data set to ``NULL``.
+
+V4L2 sub-device functions and data structures
+---------------------------------------------
+
+V4L2 sub-device kAPI
+^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-subdev.h
 
-V4L2 subdev async kAPI
-^^^^^^^^^^^^^^^^^^^^^^
+V4L2 sub-device asynchronous kAPI
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-async.h
-- 
2.7.4

