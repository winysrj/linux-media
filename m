Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51391 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752113AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 04/58] soc_camera: don't break long lines
Date: Tue, 18 Oct 2016 18:45:16 -0200
Message-Id: <dbfe42b1ee7eb5c11229d081dcc15c6f9d3caa66.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/i2c/soc_camera/ov772x.c | 3 +--
 drivers/media/i2c/soc_camera/ov9740.c | 3 +--
 drivers/media/i2c/soc_camera/tw9910.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 7e68762b3a4b..985a3672b243 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -1064,8 +1064,7 @@ static int ov772x_probe(struct i2c_client *client,
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
-			"I2C-Adapter doesn't support "
-			"I2C_FUNC_SMBUS_BYTE_DATA\n");
+			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE_DATA\n");
 		return -EIO;
 	}
 
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 0da632d7d33a..f11f76cdacad 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -881,8 +881,7 @@ static int ov9740_video_probe(struct i2c_client *client)
 		goto done;
 	}
 
-	dev_info(&client->dev, "ov9740 Model ID 0x%04x, Revision 0x%02x, "
-		 "Manufacturer 0x%02x, SMIA Version 0x%02x\n",
+	dev_info(&client->dev, "ov9740 Model ID 0x%04x, Revision 0x%02x, Manufacturer 0x%02x, SMIA Version 0x%02x\n",
 		 priv->model, priv->revision, priv->manid, priv->smiaver);
 
 	ret = v4l2_ctrl_handler_setup(&priv->hdl);
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 4002c07f3857..c9c49ed707b8 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -947,8 +947,7 @@ static int tw9910_probe(struct i2c_client *client,
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&client->dev,
-			"I2C-Adapter doesn't support "
-			"I2C_FUNC_SMBUS_BYTE_DATA\n");
+			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE_DATA\n");
 		return -EIO;
 	}
 
-- 
2.7.4


