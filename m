Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35278 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbEYPee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:34:34 -0400
Received: by wgme6 with SMTP id e6so7195104wgm.2
        for <linux-media@vger.kernel.org>; Mon, 25 May 2015 08:34:33 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/3] media: davinci_vpfe: clear the output_specs
Date: Mon, 25 May 2015 16:34:27 +0100
Message-Id: <1432568069-11349-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1432568069-11349-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1432568069-11349-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

clear of the output_specs before passing it to the
configure_resizer_out_params(), so that no garbage values
are set.

This fixes following build warning:
drivers/staging/media/davinci_vpfe/dm365_resizer.c: In function 'resizer_set_stream':
drivers/staging/media/davinci_vpfe/dm365_resizer.c:190:46: warning: 'output_specs.vst_c'
may be used uninitialized in this function [-Wmaybe-uninitialized]
  param->ext_mem_param[index].rsz_sdr_ptr_s_c = output->vst_c;
                                              ^
drivers/staging/media/davinci_vpfe/dm365_resizer.c:316:30: note: 'output_specs.vst_c' was declared here
  struct vpfe_rsz_output_spec output_specs;
                              ^
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index b649813..acb293e 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -321,6 +321,7 @@ static int resizer_configure_output_win(struct vpfe_resizer_device *resizer)
 
 	outformat = &resizer->resizer_a.formats[RESIZER_PAD_SOURCE];
 
+	memset(&output_specs, 0x0, sizeof(struct vpfe_rsz_output_spec));
 	output_specs.vst_y = param->user_config.vst;
 	if (outformat->code == MEDIA_BUS_FMT_YDYUYDYV8_1X16)
 		output_specs.vst_c = param->user_config.vst;
-- 
2.1.4

