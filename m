Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:36260 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753444AbdLUMXC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 07:23:02 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, rjkm@metzlerbros.de, d.scheller@gmx.net,
        jasmin@anw.at
Subject: [PATCH V2 3/3] media: dvb-core: Added documentation for ca sysfs timer nodes
Date: Thu, 21 Dec 2017 13:22:39 +0000
Message-Id: <1513862559-19725-4-git-send-email-jasmin@anw.at>
In-Reply-To: <1513862559-19725-1-git-send-email-jasmin@anw.at>
References: <1513862559-19725-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Added the documentation for the new ca? sysfs nodes in
/sys/class/dvb/dvb?/ca?/tim_wr_????.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 Documentation/ABI/testing/sysfs-class-ca        | 63 ++++++++++++++++++
 Documentation/media/uapi/dvb/ca-sysfs-nodes.rst | 85 +++++++++++++++++++++++++
 Documentation/media/uapi/dvb/ca.rst             |  1 +
 3 files changed, 149 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-ca
 create mode 100644 Documentation/media/uapi/dvb/ca-sysfs-nodes.rst

diff --git a/Documentation/ABI/testing/sysfs-class-ca b/Documentation/ABI/testing/sysfs-class-ca
new file mode 100644
index 0000000..7a2a52c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-ca
@@ -0,0 +1,63 @@
+What:		/sys/class/dvb/dvbN/
+Date:		Dec 2017
+KernelVersion:	4.15
+Contact:	Jasmin Jessich <jasmin@anw.at>
+Description:
+        The dvbN/ class sub-directory belongs to the Adapter with the
+        index N. It is created for each found Adapter and depends on
+        the DVB hardware.
+
+What:		/sys/class/dvb/dvbN/caM
+Date:		Dec 2017
+KernelVersion:	4.15
+Contact:	Jasmin Jessich <jasmin@anw.at>
+Description:
+        The dvbN/caM/ class sub-directory belongs to the CA device with
+        the index M on the Adapter with the index N. It is created for
+        each found Conditional Access Interface where M is the number
+        of the CA Interface.
+
+What:		/sys/class/dvb/dvbN/caM/tim_wr_high
+Date:		Dec 2017
+KernelVersion:	4.15
+Contact:	Jasmin Jessich <jasmin@anw.at>
+Description:
+        Reading this file returns the wait time after writing the
+        length high byte to the CAM. The default timeout it '0', which
+        means no 'no timeout'. Any other value specifies the timeout in
+        micro seconds.
+          
+        Writing a value will change the timeout.
+             
+        Write fails with ``EINVAL`` if an invalid value has been written
+        (valid values are 0..100000).
+
+What:		/sys/class/dvb/dvbN/caM/tim_wr_low
+Date:		Dec 2017
+KernelVersion:	4.15
+Contact:	Jasmin Jessich <jasmin@anw.at>
+Description:
+        Reading this file returns the wait time after writing the
+        length low byte to the CAM. The default timeout it '0', which
+        means no 'no timeout'. Any other  value specifies the timeout in
+        micro seconds.
+          
+        Writing a value will change the timeout.
+             
+        Write fails with ``EINVAL`` if an invalid value has been written
+        (valid values are 0..100000).
+
+What:		/sys/class/dvb/dvbN/caM/tim_wr_data
+Date:		Dec 2017
+KernelVersion:	4.15
+Contact:	Jasmin Jessich <jasmin@anw.at>
+Description:
+        Reading this file returns the wait time between data bytes sent
+        to the CAM. The default timeout it '0', which means no 'no timeout'.
+        Any other value specifies the timeout in micro seconds.
+
+        Writing a value will change the timeout.
+             
+        Write fails with ``EINVAL`` if an invalid value has been written
+        (valid values are 0..100000).
+
diff --git a/Documentation/media/uapi/dvb/ca-sysfs-nodes.rst b/Documentation/media/uapi/dvb/ca-sysfs-nodes.rst
new file mode 100644
index 0000000..4a26afd
--- /dev/null
+++ b/Documentation/media/uapi/dvb/ca-sysfs-nodes.rst
@@ -0,0 +1,85 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _ca_sysfs_nodes:
+
+******************************
+Conditional Access sysfs nodes
+******************************
+
+As defined at ``Documentation/ABI/testing/sysfs-class-ca``, those are
+the sysfs nodes that control the en50221 CA driver:
+
+
+.. _sys_class_dvb_dvbN:
+
+/sys/class/dvb/dvbN/
+====================
+
+The ``/sys/class/dvb/dvbN/`` class sub-directory belongs to the Adapter
+with the index N. It is created for each found Adapter and depends on the
+DVB hardware.
+
+
+.. _sys_class_dvb_dvbN_caM:
+
+/sys/class/dvb/dvbN/caM
+=======================
+
+The ``/sys/class/dvb/dvbN/caM`` class sub-directory belongs to the CA device
+with the index M on the Adapter with the index N. It is created for each
+found Conditional Access Interface where M is the number of the CA Interface.
+A Conditional Access Module (CAM) will be inserted into the CI interface. The
+caM device is used to communicate to the CAM.
+
+The communication protocol contains a length field followed by the data bytes.
+The length is written in two parts. First the high byte of the length
+followed by the low byte. The following sysfs nodes define three timeouts
+which may be used to extend the communication to the CAM. Modern CAMs usually
+do not need those timeouts, but older CAMs will produce communication errors,
+when the bytes are written too fast. The underliying hardware has also a big
+impact due to the access speed.
+
+
+.. _sys_class_dvb_dvbN_caM_tim_wr_high:
+
+/sys/class/dvb/dvbN/caM/tim_wr_high
+===================================
+
+Reading this file returns the wait time after writing the length high byte to
+the CAM. The default timeout it '0', which means no 'no timeout'. Any other
+value specifies the timeout in micro seconds.
+
+Writing a value will change the timeout.
+
+Write fails with ``EINVAL`` if an invalid value has been written (valid values
+are 0..100000).
+
+
+.. _sys_class_dvb_dvbN_caM_tim_wr_low:
+
+/sys/class/dvb/dvbN/caM/tim_wr_low
+==================================
+
+Reading this file returns the wait time after writing the length low byte to
+the CAM. The default timeout it '0', which means no 'no timeout'. Any other
+value specifies the timeout in micro seconds.
+
+Writing a value will change the timeout.
+
+Write fails with ``EINVAL`` if an invalid value has been written (valid values
+are 0..100000).
+
+
+.. _sys_class_dvb_dvbN_caM_tim_wr_data:
+
+/sys/class/dvb/dvbN/caM/tim_wr_data
+===================================
+
+Reading this file returns the wait time between data bytes sent to the CAM.
+The default timeout it '0', which means no 'no timeout'. Any other value
+specifies the timeout in micro seconds.
+
+Writing a value will change the timeout.
+
+Write fails with ``EINVAL`` if an invalid value has been written (valid values
+are 0..100000).
diff --git a/Documentation/media/uapi/dvb/ca.rst b/Documentation/media/uapi/dvb/ca.rst
index deac72d..e790d19d 100644
--- a/Documentation/media/uapi/dvb/ca.rst
+++ b/Documentation/media/uapi/dvb/ca.rst
@@ -22,3 +22,4 @@ application.
 
     ca_data_types
     ca_function_calls
+    ca-sysfs-nodes
-- 
2.7.4
