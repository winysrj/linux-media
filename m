Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51639 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935553AbcJRUqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 17/58] solo6x10: don't break long lines
Date: Tue, 18 Oct 2016 18:45:29 -0200
Message-Id: <9661a82d59b02006316bd7387a4ced5b7320e618.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/pci/solo6x10/solo6x10-v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index b4be47969b6b..896bec6627aa 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -702,8 +702,8 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 	snprintf(solo_dev->vfd->name, sizeof(solo_dev->vfd->name), "%s (%i)",
 		 SOLO6X10_NAME, solo_dev->vfd->num);
 
-	dev_info(&solo_dev->pdev->dev, "Display as /dev/video%d with "
-		 "%d inputs (%d extended)\n", solo_dev->vfd->num,
+	dev_info(&solo_dev->pdev->dev, "Display as /dev/video%d with %d inputs (%d extended)\n",
+		 solo_dev->vfd->num,
 		 solo_dev->nr_chans, solo_dev->nr_ext);
 
 	return 0;
-- 
2.7.4


