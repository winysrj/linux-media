Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030440AbbD1Poc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [PATCH 07/14] radio-si476x: Fix indent
Date: Tue, 28 Apr 2015 12:43:46 -0300
Message-Id: <6e9257a34dc39eba0aa11e86b79dc784671bb466.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/radio/radio-si476x.c:571 si476x_radio_do_post_powerup_init() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index dccf58691650..9cbb8cdf0ac0 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -568,8 +568,8 @@ static int si476x_radio_do_post_powerup_init(struct si476x_radio *radio,
 	err = regcache_sync_region(radio->core->regmap,
 				   SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE,
 				   SI476X_PROP_DIGITAL_IO_OUTPUT_FORMAT);
-		if (err < 0)
-			return err;
+	if (err < 0)
+		return err;
 
 	err = regcache_sync_region(radio->core->regmap,
 				   SI476X_PROP_AUDIO_DEEMPHASIS,
-- 
2.1.0

