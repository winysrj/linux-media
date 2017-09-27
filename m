Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33174
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752160AbdI0Vkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH v2 12/37] media: dvb_frontend: fix return values for FE_SET_PROPERTY
Date: Wed, 27 Sep 2017 18:40:13 -0300
Message-Id: <7412de01de1e6558f28f840b3023930e1dee0705.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several problems with regards to the return of
FE_SET_PROPERTY. The original idea were to return per-property
return codes via tvp->result field, and to return an updated
set of values.

However, that never worked. What's actually implemented is:

- the FE_SET_PROPERTY implementation doesn't call .get_frontend
  callback in order to get the actual parameters after return;

- the tvp->result field is only filled if there's no error.
  So, it is always filled with zero;

- FE_SET_PROPERTY doesn't call memdup_user() nor any other
  copy_to_user() function. So, any changes to the properties
  will be lost;

- FE_SET_PROPERTY is declared as a write-only ioctl (IOW).

While we could fix the above, it could cause regressions.

So, let's just assume what the code really does, updating
the documentation accordingly and removing the logic that
would update the discarded tvp->result.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/fe-get-property.rst | 7 +++++--
 drivers/media/dvb-core/dvb_frontend.c            | 2 --
 include/uapi/linux/dvb/frontend.h                | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 948d2ba84f2c..b69741d9cedf 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -48,8 +48,11 @@ depends on the delivery system and on the device:
 
    -  This call requires read/write access to the device.
 
-   -  At return, the values are updated to reflect the actual parameters
-      used.
+.. note::
+
+   At return, the values aren't updated to reflect the actual
+   parameters used. If the actual parameters are needed, an explicit
+   call to ``FE_GET_PROPERTY`` is needed.
 
 -  ``FE_GET_PROPERTY:``
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2036cf1b7784..768d7703bdb3 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2142,7 +2142,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 				kfree(tvp);
 				return err;
 			}
-			(tvp + i)->result = err;
 		}
 		kfree(tvp);
 		break;
@@ -2187,7 +2186,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 				kfree(tvp);
 				return err;
 			}
-			(tvp + i)->result = err;
 		}
 
 		if (copy_to_user((void __user *)tvps->props, tvp,
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 861cacd5711f..6bc26f35217b 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -830,7 +830,7 @@ struct dtv_fe_stats {
  * @cmd:	Digital TV command.
  * @reserved:	Not used.
  * @u:		Union with the values for the command.
- * @result:	Result of the command set (currently unused).
+ * @result:	Unused
  *
  * The @u union may have either one of the values below:
  *
-- 
2.13.5
