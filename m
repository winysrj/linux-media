Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37328 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1IWSFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 14:05:18 -0400
Message-ID: <4E7CCA59.1040806@infradead.org>
Date: Fri, 23 Sep 2011 15:05:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>
Subject: Re: [GIT PATCHES FOR 3.2] fix type error in cx23885 and  altera-stapl
 move out from staging
References: <201109232026.31162.liplianin@me.by>
In-Reply-To: <201109232026.31162.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-09-2011 14:26, Igor M. Liplianin escreveu:
> The following changes since commit 3a7a62378be538944ff00904b8e0b795fe16609a:
> 
>   [media] ati_remote: update Kconfig description (2011-09-22 10:55:10 -0300)
> 
> are available in the git repository at:
>   http://linuxtv.org/git/liplianin/media_tree.git netup_patches
> 
> Igor M. Liplianin (2):
>       cx23885: fix type error
>       altera-stapl: it is time to move out from staging

Applied, thanks!

There was a merge conflict with some patch(es) that were fixing the memory
leak on some errors conditions, so, I've reverted the changes bellow.

Thanks,
Mauro.

--- a/drivers/staging/altera-stapl/altera.c
+++ b/drivers/misc/altera-stapl/altera.c
@@ -2430,23 +2430,16 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 	int index = 0;
 	s32 offset = 0L;
 	s32 error_address = 0L;
-	int retval = 0;
 
-	key = kzalloc(33, GFP_KERNEL);
-	if (!key) {
-		retval = -ENOMEM;
-		goto out;
-	}
-	value = kzalloc(257, GFP_KERNEL);
-	if (!value) {
-		retval = -ENOMEM;
-		goto free_key;
-	}
+	key = kzalloc(33 * sizeof(char), GFP_KERNEL);
+	if (!key)
+		return -ENOMEM;
+	value = kzalloc(257 * sizeof(char), GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
 	astate = kzalloc(sizeof(struct altera_state), GFP_KERNEL);
-	if (!astate) {
-		retval = -ENOMEM;
-		goto free_value;
-	}
+	if (!astate)
+		return -ENOMEM;
 
 	astate->config = config;
 	if (!astate->config->jtag_io) {
@@ -2525,12 +2518,10 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 	} else if (exec_result)
 		printk(KERN_ERR "%s: error %d\n", __func__, exec_result);
 
-	kfree(astate);
-free_value:
-	kfree(value);
-free_key:
 	kfree(key);
-out:
-	return retval;
+	kfree(value);
+	kfree(astate);
+
+	return 0;
 }
 EXPORT_SYMBOL(altera_init);
