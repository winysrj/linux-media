Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab3CUTjQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 15:39:16 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LJdGZr031158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 15:39:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] cx23885: use IS_ENABLED
Date: Thu, 21 Mar 2013 16:39:07 -0300
Message-Id: <1363894748-28000-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363894748-28000-1-git-send-email-mchehab@redhat.com>
References: <1363894748-28000-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking everywhere there for 3 symbols, use instead
IS_ENABLED macro.

This replacement was done using this small perl script:

my $data;
$data .= $_ while (<>);
if ($data =~ m/CONFIG_([A-Z\_\d]*)_MODULE/) {
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)\)[\s\|\&\\\(\)\!]+defined\(CONFIG_($f)_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;

        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_($f)\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(CONFIG_MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
        $data =~ s,defined\(CONFIG_($f)_MODULE\)[\s\|\&\\\(\)]+defined\(MODULE\)\)*,IS_ENABLED(CONFIG_$f),g;
}
print $data;

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx23885/altera-ci.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/altera-ci.h b/drivers/media/pci/cx23885/altera-ci.h
index 70e4fd6..7ac6d64 100644
--- a/drivers/media/pci/cx23885/altera-ci.h
+++ b/drivers/media/pci/cx23885/altera-ci.h
@@ -41,8 +41,7 @@ struct altera_ci_config {
 	int (*fpga_rw) (void *dev, int ad_rg, int val, int rw);
 };
 
-#if defined(CONFIG_MEDIA_ALTERA_CI) || (defined(CONFIG_MEDIA_ALTERA_CI_MODULE) \
-							&& defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_ALTERA_CI)
 
 extern int altera_ci_init(struct altera_ci_config *config, int ci_nr);
 extern void altera_ci_release(void *dev, int ci_nr);
-- 
1.8.1.4

