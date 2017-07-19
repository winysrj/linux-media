Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:57234 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932714AbdGSTYH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 15:24:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] [media] fix warning on v4l2_subdev_call() result interpreted as bool
Date: Wed, 19 Jul 2017 21:23:27 +0200
Message-Id: <20170719192338.2671881-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_call is a macro returning whatever the callback return
type is, usually 'int'. With gcc-7 and ccache, this can lead to
many wanings like:

media/platform/pxa_camera.c: In function 'pxa_mbus_build_fmts_xlate':
media/platform/pxa_camera.c:766:27: error: ?: using integer constants in boolean context [-Werror=int-in-bool-context]
  while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
media/atomisp/pci/atomisp2/atomisp_cmd.c: In function 'atomisp_s_ae_window':
media/atomisp/pci/atomisp2/atomisp_cmd.c:6414:52: error: ?: using integer constants in boolean context [-Werror=int-in-bool-context]
  if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,

The problem here is that after preprocessing, we the compiler
sees a variation of

	if (a ? 0 : 2)

that it thinks is suspicious.

This replaces the ?: operator with an different expression that
does the same thing in a more easily readable way that cannot
tigger the warning

Link: https://lkml.org/lkml/2017/7/14/156
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: replace large patch touching all the users with a simpler
    change to the macro itself.
---
 include/media/v4l2-subdev.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0f92ebd2d710..e83872078376 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -982,8 +982,16 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
  * Example: err = v4l2_subdev_call(sd, video, s_std, norm);
  */
 #define v4l2_subdev_call(sd, o, f, args...)				\
-	(!(sd) ? -ENODEV : (((sd)->ops->o && (sd)->ops->o->f) ?	\
-		(sd)->ops->o->f((sd), ##args) : -ENOIOCTLCMD))
+	({								\
+		int __result;						\
+		if (!(sd))						\
+			__result = -ENODEV;				\
+		else if (!((sd)->ops->o && (sd)->ops->o->f))		\
+			__result = -ENOIOCTLCMD;			\
+		else							\
+			__result = (sd)->ops->o->f((sd), ##args);	\
+		__result;						\
+	})
 
 #define v4l2_subdev_has_op(sd, o, f) \
 	((sd)->ops->o && (sd)->ops->o->f)
-- 
2.9.0
