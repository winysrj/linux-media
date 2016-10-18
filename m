Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51531 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934789AbcJRUqV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH v2 10/58] ddbridge: don't break long lines
Date: Tue, 18 Oct 2016 18:45:22 -0200
Message-Id: <6e959593ec17d60df17e8d2f0378962784c33857.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 18e3a4deee64..a6c9fe235974 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -824,8 +824,7 @@ static int dvb_input_attach(struct ddb_input *input)
 				   &input->port->dev->pdev->dev,
 				   adapter_nr);
 	if (ret < 0) {
-		printk(KERN_ERR "ddbridge: Could not register adapter."
-		       "Check if you enabled enough adapters in dvb-core!\n");
+		printk(KERN_ERR "ddbridge: Could not register adapter.Check if you enabled enough adapters in dvb-core!\n");
 		return ret;
 	}
 	input->attached = 1;
@@ -1730,8 +1729,7 @@ static __init int module_init_ddbridge(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Digital Devices PCIE bridge driver, "
-	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
+	printk(KERN_INFO "Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH\n");
 
 	ret = ddb_class_create();
 	if (ret < 0)
-- 
2.7.4


