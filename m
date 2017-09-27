Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33143
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751969AbdI0Vk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 37/37] media: frontend: use the newly nested kernel-doc support
Date: Wed, 27 Sep 2017 18:40:38 -0300
Message-Id: <9feab24a2e963d4aef115c5c3a6ba16f3023c96e.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that kernel-doc supports nested structs/unions, use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/uapi/linux/dvb/frontend.h | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 6bc26f35217b..44b90a0a0079 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -755,16 +755,15 @@ enum fecap_scale_params {
 /**
  * struct dtv_stats - Used for reading a DTV status property
  *
- * @scale:	Filled with enum fecap_scale_params - the scale
- *		in usage for that parameter
+ * @scale:
+ *	Filled with enum fecap_scale_params - the scale in usage
+ *	for that parameter
  *
- * The ``{unnamed_union}`` may have either one of the values below:
- *
- * %svalue
+ * @svalue:
  *	integer value of the measure, for %FE_SCALE_DECIBEL,
  *	used for dB measures. The unit is 0.001 dB.
  *
- * %uvalue
+ * @uvalue:
  *	unsigned integer value of the measure, used when @scale is
  *	either %FE_SCALE_RELATIVE or %FE_SCALE_COUNTER.
  *
@@ -827,19 +826,19 @@ struct dtv_fe_stats {
 /**
  * struct dtv_property - store one of frontend command and its value
  *
- * @cmd:	Digital TV command.
- * @reserved:	Not used.
- * @u:		Union with the values for the command.
- * @result:	Unused
+ * @cmd:		Digital TV command.
+ * @reserved:		Not used.
+ * @u:			Union with the values for the command.
+ * @u.data:		A unsigned 32 bits integer with command value.
+ * @u.buffer:		Struct to store bigger properties.
+ *			Currently unused.
+ * @u.buffer.data:	an unsigned 32-bits array.
+ * @u.buffer.len:	number of elements of the buffer.
+ * @u.buffer.reserved1:	Reserved.
+ * @u.buffer.reserved2:	Reserved.
+ * @u.st:		a &struct dtv_fe_stats array of statistics.
+ * @result:		Currently unused.
  *
- * The @u union may have either one of the values below:
- *
- * %data
- *	an unsigned 32-bits number.
- * %st
- *	a &struct dtv_fe_stats array of statistics.
- * %buffer
- *	a buffer of up to 32 characters (currently unused).
  */
 struct dtv_property {
 	__u32 cmd;
-- 
2.13.5
