Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32980 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935410AbdCJNHd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 08:07:33 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH 1/2] staging: css2400/sh_css: Remove parentheses from return arguments
Date: Fri, 10 Mar 2017 18:37:23 +0530
Message-Id: <1489151244-20714-2-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489151244-20714-1-git-send-email-singhalsimran0@gmail.com>
References: <1489151244-20714-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sematic patch used for this is:
@@
identifier i;
constant c;
@@
return
- (
    \(i\|-i\|i(...)\|c\)
- )
  ;

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c      | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 0a1544d..c442d22 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -1989,7 +1989,7 @@ enum ia_css_err ia_css_suspend(void)
 	for(i=0;i<MAX_ACTIVE_STREAMS;i++)
 		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "==*> after 1: seed %d (%p)\n", i, my_css_save.stream_seeds[i].stream);
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_suspend() leave\n");
-	return(IA_CSS_SUCCESS);
+	return IA_CSS_SUCCESS;
 }
 
 enum ia_css_err
@@ -2001,10 +2001,10 @@ ia_css_resume(void)
 
 	err = ia_css_init(&(my_css_save.driver_env), my_css_save.loaded_fw, my_css_save.mmu_base, my_css_save.irq_type);
 	if (err != IA_CSS_SUCCESS)
-		return(err);
+		return err;
 	err = ia_css_start_sp();
 	if (err != IA_CSS_SUCCESS)
-		return(err);
+		return err;
 	my_css_save.mode = sh_css_mode_resume;
 	for(i=0;i<MAX_ACTIVE_STREAMS;i++)
 	{
@@ -2018,7 +2018,7 @@ ia_css_resume(void)
 				if (i)
 					for(j=0;j<i;j++)
 						ia_css_stream_unload(my_css_save.stream_seeds[j].stream);
-				return(err);
+				return err;
 			}
 			err = ia_css_stream_start(my_css_save.stream_seeds[i].stream);
 			if (err != IA_CSS_SUCCESS)
@@ -2028,7 +2028,7 @@ ia_css_resume(void)
 					ia_css_stream_stop(my_css_save.stream_seeds[j].stream);
 					ia_css_stream_unload(my_css_save.stream_seeds[j].stream);
 				}
-				return(err);
+				return err;
 			}
 			*my_css_save.stream_seeds[i].orig_stream = my_css_save.stream_seeds[i].stream;
 			for(j=0;j<my_css_save.stream_seeds[i].num_pipes;j++)
@@ -2037,7 +2037,7 @@ ia_css_resume(void)
 	}
 	my_css_save.mode = sh_css_mode_working;
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_resume() leave: return_void\n");
-	return(IA_CSS_SUCCESS);
+	return IA_CSS_SUCCESS;
 }
 
 enum ia_css_err
@@ -10226,7 +10226,7 @@ ia_css_stream_load(struct ia_css_stream *stream)
 						for(k=0;k<j;k++)
 							ia_css_pipe_destroy(my_css_save.stream_seeds[i].pipes[k]);
 					}
-					return(err);
+					return err;
 				}
 			err = ia_css_stream_create(&(my_css_save.stream_seeds[i].stream_config), my_css_save.stream_seeds[i].num_pipes,
 						    my_css_save.stream_seeds[i].pipes, &(my_css_save.stream_seeds[i].stream));
@@ -10235,12 +10235,12 @@ ia_css_stream_load(struct ia_css_stream *stream)
 				ia_css_stream_destroy(stream);
 				for(j=0;j<my_css_save.stream_seeds[i].num_pipes;j++)
 					ia_css_pipe_destroy(my_css_save.stream_seeds[i].pipes[j]);
-				return(err);
+				return err;
 			}
 			break;
 		}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,	"ia_css_stream_load() exit, \n");
-	return(IA_CSS_SUCCESS);
+	return IA_CSS_SUCCESS;
 #else
 	/* TODO remove function - DEPRECATED */
 	(void)stream;
@@ -10381,7 +10381,7 @@ ia_css_stream_unload(struct ia_css_stream *stream)
 			break;
 		}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,	"ia_css_stream_unload() exit, \n");
-	return(IA_CSS_SUCCESS);
+	return IA_CSS_SUCCESS;
 }
 
 #endif
-- 
2.7.4
