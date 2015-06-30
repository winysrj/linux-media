Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35532 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbbF3Ofi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 10:35:38 -0400
Received: by pdbci14 with SMTP id ci14so7219437pdb.2
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2015 07:35:36 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] v4l-utils/contrib/gconv: fix build error with glibc 2.21+
Date: Tue, 30 Jun 2015 23:35:23 +0900
Message-Id: <1435674923-27623-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Building this gconv module with glibc > 2.21 failed with errors.

It has copies of glibc's iconv module files,
and #includes them as the base of implemententation,
which is the same impl. pattern as the other internal iconv modules.
But those base files depend on the internal of iconv to some extent,
and it had been changed in glibc 2.21.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 contrib/gconv/iconv/loop.c     | 44 ++++++++++++++++++++++++++++++++++++++++++
 contrib/gconv/iconv/skeleton.c | 10 ++++++++++
 2 files changed, 54 insertions(+)

diff --git a/contrib/gconv/iconv/loop.c b/contrib/gconv/iconv/loop.c
index a480c0c..127a466 100644
--- a/contrib/gconv/iconv/loop.c
+++ b/contrib/gconv/iconv/loop.c
@@ -211,6 +211,7 @@
    transcription functions and ignoring of errors.  Note that we cannot use
    the do while (0) trick since `break' and `continue' must reach certain
    points.  */
+#if ! __GLIBC_PREREQ(2,21)
 #define STANDARD_TO_LOOP_ERR_HANDLER(Incr) \
   {									      \
     struct __gconv_trans_data *trans;					      \
@@ -258,6 +259,49 @@
        that "iconv -c" must give the same exitcode as "iconv".  */	      \
     continue;								      \
   }
+#else
+#define STANDARD_TO_LOOP_ERR_HANDLER(Incr) \
+  {									      \
+    result = __GCONV_ILLEGAL_INPUT;					      \
+									      \
+    if (irreversible == NULL)						      \
+      /* This means we are in call from __gconv_transliterate.  In this	      \
+	 case we are not doing any error recovery outself.  */		      \
+      break;								      \
+									      \
+    /* If needed, flush any conversion state, so that __gconv_transliterate   \
+       starts with current shift state.  */				      \
+    UPDATE_PARAMS;							      \
+									      \
+    /* First try the transliteration methods.  */			      \
+    if ((step_data->__flags & __GCONV_TRANSLIT) != 0)			      \
+      result = __gconv_transliterate					      \
+	(step, step_data, *inptrp,					      \
+	 &inptr, inend, &outptr, irreversible);			      \
+									      \
+    REINIT_PARAMS;							      \
+									      \
+    /* If any of them recognized the input continue with the loop.  */	      \
+    if (result != __GCONV_ILLEGAL_INPUT)				      \
+      {									      \
+	if (__glibc_unlikely (result == __GCONV_FULL_OUTPUT))		      \
+	  break;							      \
+									      \
+	continue;							      \
+      }									      \
+									      \
+    /* Next see whether we have to ignore the error.  If not, stop.  */	      \
+    if (! ignore_errors_p ())						      \
+      break;								      \
+									      \
+    /* When we come here it means we ignore the character.  */		      \
+    ++*irreversible;							      \
+    inptr += Incr;							      \
+    /* But we keep result == __GCONV_ILLEGAL_INPUT, because of the constraint \
+       that "iconv -c" must give the same exitcode as "iconv".  */	      \
+    continue;								      \
+  }
+#endif									      \
 
 
 /* Handling of Unicode 3.1 TAG characters.  Unicode recommends
diff --git a/contrib/gconv/iconv/skeleton.c b/contrib/gconv/iconv/skeleton.c
index e64a414..9f7f80a 100644
--- a/contrib/gconv/iconv/skeleton.c
+++ b/contrib/gconv/iconv/skeleton.c
@@ -501,8 +501,14 @@ FUNCTION_NAME (struct __gconv_step *step, struct __gconv_step_data *data,
     }
   else
     {
+#if ! __GLIBC_PREREQ(2,21)
       /* We preserve the initial values of the pointer variables.  */
       const unsigned char *inptr = *inptrp;
+#else
+      /* We preserve the initial values of the pointer variables,
+	 but only some conversion modules need it.  */
+      const unsigned char *inptr __attribute__ ((__unused__)) = *inptrp;
+#endif
       unsigned char *outbuf = (__builtin_expect (outbufstart == NULL, 1)
 			       ? data->__outbuf : *outbufstart);
       unsigned char *outend = data->__outbufend;
@@ -592,8 +598,10 @@ FUNCTION_NAME (struct __gconv_step *step, struct __gconv_step_data *data,
 
       while (1)
 	{
+#if ! __GLIBC_PREREQ(2,21)
 	  struct __gconv_trans_data *trans;
 
+#endif
 	  /* Remember the start value for this round.  */
 	  inptr = *inptrp;
 	  /* The outbuf buffer is empty.  */
@@ -640,6 +648,7 @@ FUNCTION_NAME (struct __gconv_step *step, struct __gconv_step_data *data,
 	      return status;
 	    }
 
+#if  ! __GLIBC_PREREQ(2,21)
 	  /* Give the transliteration module the chance to store the
 	     original text and the result in case it needs a context.  */
 	  for (trans = data->__trans; trans != NULL; trans = trans->__next)
@@ -647,6 +656,7 @@ FUNCTION_NAME (struct __gconv_step *step, struct __gconv_step_data *data,
 	      DL_CALL_FCT (trans->__trans_context_fct,
 			   (trans->__data, inptr, *inptrp, outstart, outbuf));
 
+#endif
 	  /* We finished one use of the loops.  */
 	  ++data->__invocation_counter;
 
-- 
2.4.4

