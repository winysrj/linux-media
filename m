Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43930 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754063AbdERNvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 09/13] staging: media: atomisp: Fix -Werror=int-in-bool-context compile errors
Date: Thu, 18 May 2017 15:50:18 +0200
Message-Id: <20170518135022.6069-10-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

With gcc-7.1.1 I was getting the following compile error:

error: ‘*’ in boolean context, suggest ‘&&’ instead

The problem is the definition of CEIL_DIV:
 #define CEIL_DIV(a, b)       ((b) ? ((a) + (b) - 1) / (b) : 0)

Which when called as: CEIL_DIV(x, y * z) triggers this error, note
we cannot do as the error suggests since b is evaluated multiple times.

This commit fixes these compile errors.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c   | 1 -
 .../pci/atomisp2/css2400/hive_isp_css_include/math_support.h        | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index b830b241e2e6..ad2c610d2ce3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -2506,7 +2506,6 @@ static void __configure_capture_pp_input(struct atomisp_sub_device *asd,
 	struct ia_css_pipe_extra_config *pipe_extra_configs =
 		&stream_env->pipe_extra_configs[pipe_id];
 	unsigned int hor_ds_factor = 0, ver_ds_factor = 0;
-#define CEIL_DIV(a, b)       ((b) ? ((a) + (b) - 1) / (b) : 0)
 
 	if (width == 0 && height == 0)
 		return;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
index 48d84bc0ad9e..f74b405b0f39 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/math_support.h
@@ -62,15 +62,15 @@
 #define MAX(a, b)            (((a) > (b)) ? (a) : (b))
 #define MIN(a, b)            (((a) < (b)) ? (a) : (b))
 #ifdef ISP2401
-#define ROUND_DIV(a, b)      ((b) ? ((a) + ((b) >> 1)) / (b) : 0)
+#define ROUND_DIV(a, b)      (((b) != 0) ? ((a) + ((b) >> 1)) / (b) : 0)
 #endif
-#define CEIL_DIV(a, b)       ((b) ? ((a) + (b) - 1) / (b) : 0)
+#define CEIL_DIV(a, b)       (((b) != 0) ? ((a) + (b) - 1) / (b) : 0)
 #define CEIL_MUL(a, b)       (CEIL_DIV(a, b) * (b))
 #define CEIL_MUL2(a, b)      (((a) + (b) - 1) & ~((b) - 1))
 #define CEIL_SHIFT(a, b)     (((a) + (1 << (b)) - 1)>>(b))
 #define CEIL_SHIFT_MUL(a, b) (CEIL_SHIFT(a, b) << (b))
 #ifdef ISP2401
-#define ROUND_HALF_DOWN_DIV(a, b)	((b) ? ((a) + (b / 2) - 1) / (b) : 0)
+#define ROUND_HALF_DOWN_DIV(a, b)	(((b) != 0) ? ((a) + (b / 2) - 1) / (b) : 0)
 #define ROUND_HALF_DOWN_MUL(a, b)	(ROUND_HALF_DOWN_DIV(a, b) * (b))
 #endif
 
-- 
2.13.0
