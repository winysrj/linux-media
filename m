Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:18308 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdITJuh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 05:50:37 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20170920095035epoutp03c28b5fbcb18154a33a70897178da86f1~mCQN4dm_n0229802298epoutp03J
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 09:50:35 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: mchehab@kernel.org
Cc: satendra.t@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/2] [DVB][FRONTEND] Added a new ioctl for optimizing
 frontend property set operation
Date: Wed, 20 Sep 2017 05:50:12 -0400
Message-Id: <1505901012-27425-1-git-send-email-satendra.t@samsung.com>
In-Reply-To: <1505884508-496-1-git-send-email-satendra.t@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <1505884508-496-1-git-send-email-satendra.t@samsung.com>
        <CGME20170920095035epcas5p1c2564d1da1ae4bc82fdf86c30bfb5c16@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-For setting one frontend property , one FE_SET_PROPERTY ioctl is called
-Since, size of struct dtv_property is 72 bytes, this ioctl requires
---allocating 72 bytes of memory in user space
---allocating 72 bytes of memory in kernel space
---copying 72 bytes of data from user space to kernel space
-However, for all the properties, only 8 out of 72 bytes are used
 for setting the property
-Four bytes are needed for specifying property type and another 4 for
 property value
-Moreover, there are 2 properties DTV_CLEAR and DTV_TUNE which use
 only 4 bytes for property name
---They don't use property value
-Therefore, we have defined new short variant/forms/version of currently
 used structures for such 8 byte properties.
-This results in 89% (8*100/72) of memory saving in user and kernel space
 each.
-This also results in faster copy (8 bytes as compared to 72 bytes) from
 user to kernel space
-We have added new ioctl FE_SET_PROPERTY_SHORT which utilizes above
 mentioned new property structures
-This ioctl can co-exist with present ioctl FE_SET_PROPERTY
-If the apps wish to use shorter forms they can use
 proposed FE_SET_PROPERTY_SHORT, rest of them can continue to use
 current versions FE_SET_PROPERTY

Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 Documentation/media/uapi/dvb/fe-get-property.rst | 24 +++++++++++------
 drivers/media/dvb-core/dvb_frontend.c            | 33 +++++++++++++++++++++++-
 include/uapi/linux/dvb/frontend.h                | 24 +++++++++++++++++
 3 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 948d2ba..efe95af 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -2,14 +2,14 @@
 
 .. _FE_GET_PROPERTY:
 
-**************************************
-ioctl FE_SET_PROPERTY, FE_GET_PROPERTY
-**************************************
+**************************************************************
+ioctl FE_SET_PROPERTY, FE_GET_PROPERTY, FE_SET_PROPERTY_SHORT
+**************************************************************
 
 Name
 ====
 
-FE_SET_PROPERTY - FE_GET_PROPERTY - FE_SET_PROPERTY sets one or more frontend properties. - FE_GET_PROPERTY returns one or more frontend properties.
+FE_SET_PROPERTY and FE_SET_PROPERTY_SHORT set one or more frontend properties. FE_GET_PROPERTY returns one or more frontend properties.
 
 
 Synopsis
@@ -21,6 +21,8 @@ Synopsis
 .. c:function:: int ioctl( int fd, FE_SET_PROPERTY, struct dtv_properties *argp )
     :name: FE_SET_PROPERTY
 
+.. c:function:: int ioctl( int fd, FE_SET_PROPERTY_SHORT, struct dtv_properties_short *argp )
+    :name: FE_SET_PROPERTY_SHORT
 
 Arguments
 =========
@@ -29,15 +31,16 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``argp``
-    Pointer to struct :c:type:`dtv_properties`.
+    Pointer to struct :c:type:`dtv_properties` or
+	struct :c:type:`dtv_properties_short`.
 
 
 Description
 ===========
 
-All Digital TV frontend devices support the ``FE_SET_PROPERTY`` and
-``FE_GET_PROPERTY`` ioctls. The supported properties and statistics
-depends on the delivery system and on the device:
+All Digital TV frontend devices support the ``FE_SET_PROPERTY``, ``FE_GET_PROPERTY``
+and ``FE_SET_PROPERTY_SHORT`` ioctls. The supported  properties and
+statistics depends on the delivery system and on the device:
 
 -  ``FE_SET_PROPERTY:``
 
@@ -60,6 +63,11 @@ depends on the delivery system and on the device:
 
    -  This call only requires read-only access to the device.
 
+-  ``FE_SET_PROPERTY_SHORT:``
+
+   -  This ioctl is similar to FE_SET_PROPERTY ioctl mentioned above
+      except that the arguments of the former utilize a struct :c:type:`dtv_property_short`
+      which is smaller in size.
 
 Return Value
 ============
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2fcba16..a6a5340 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1925,6 +1925,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
+
 static int dvb_frontend_ioctl(struct file *file,
 			unsigned int cmd, void *parg)
 {
@@ -1950,7 +1951,8 @@ static int dvb_frontend_ioctl(struct file *file,
 		return -EPERM;
 	}
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
+	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY)
+	    || (cmd == FE_SET_PROPERTY_SHORT))
 		err = dvb_frontend_ioctl_properties(file, cmd, parg);
 	else {
 		c->state = DTV_UNDEFINED;
@@ -2037,6 +2039,35 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			err = -EFAULT;
 			goto out;
 		}
+	/* New ioctl for optimizing property set*/
+	} else if (cmd == FE_SET_PROPERTY_SHORT) {
+		struct dtv_property_short *tvp_short = NULL;
+		struct dtv_properties_short *tvps_short = parg;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+				__func__, tvps_short->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+				__func__, tvps_short->props);
+		if ((!tvps_short->num) ||
+		    (tvps_short->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+		tvp_short = memdup_user(tvps_short->props,
+		tvps_short->num * sizeof(*tvp_short));
+		if (IS_ERR(tvp_short))
+			return PTR_ERR(tvp_short);
+		for (i = 0; i < tvps_short->num; i++) {
+			err = dtv_property_process_set(fe, file,
+					(tvp_short + i)->cmd,
+					(tvp_short + i)->data);
+			if (err < 0) {
+				kfree(tvp_short);
+				return err;
+			}
+		}
+		if (c->state == DTV_TUNE)
+			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n",
+					__func__);
+		kfree(tvp_short);
 
 	} else
 		err = -EOPNOTSUPP;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 861cacd..dedee0d 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -857,6 +857,17 @@ struct dtv_property {
 	int result;
 } __attribute__ ((packed));
 
+/**
+ * struct dtv_property_short - A shorter version of &struct dtv_property
+ *
+ * @cmd:	Digital TV command.
+ * @data:	An unsigned 32-bits number.
+ */
+struct dtv_property_short {
+	__u32 cmd;
+	__u32 data;
+};
+
 /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
 #define DTV_IOCTL_MAX_MSGS 64
 
@@ -871,6 +882,18 @@ struct dtv_properties {
 	struct dtv_property *props;
 };
 
+/**
+ * struct dtv_properties_short - A variant of &struct dtv_properties
+ * to support &struct dtv_property_short
+ *
+ * @num:	Number of properties
+ * @props:	Pointer to &struct dtv_property_short
+ */
+struct dtv_properties_short {
+	__u32 num;
+	struct dtv_property_short *props;
+};
+
 /*
  * When set, this flag will disable any zigzagging or other "normal" tuning
  * behavior. Additionally, there will be no automatic monitoring of the lock
@@ -906,6 +929,7 @@ struct dtv_properties {
 
 #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
 #define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
+#define FE_SET_PROPERTY_SHORT	   _IOW('o', 84, struct dtv_properties_short)
 
 #if defined(__DVB_CORE__) || !defined(__KERNEL__)
 
-- 
2.7.4
