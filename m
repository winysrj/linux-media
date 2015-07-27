Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36686 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbbG0M3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 08:29:55 -0400
Date: Mon, 27 Jul 2015 13:29:49 +0100 (BST)
From: William Towle <william.towle@codethink.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 03/13] media: adv7604: fix probe of ADV7611/7612
In-Reply-To: <55B24978.1080109@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1507271326540.4745@xk120.dyn.ducie.codethink.co.uk>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-4-git-send-email-william.towle@codethink.co.uk> <55B24978.1080109@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Jul 2015, Hans Verkuil wrote:
>> -		val2 |= val;
>> +		val |= val2;

> Oops. Added to my TODO list, I'll probably pick this up on Tuesday for a pull
> request.

   And an oops from me: a keen-eyed local correspondent spotted that
I'd omitted the S-o-b :(

Wills.

...
Subject: [PATCH] media: adv7604: fix probe of ADV7611/7612

Prior to commit f862f57d ("[media] media: i2c: ADV7604: Migrate to
regmap"), the local variable 'val' contained the combined register
reads used in the chipset version ID test. Restore this expectation
so that the comparison works as it used to.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
  drivers/media/i2c/adv7604.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index bfb0b6a..0587d27 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3108,7 +3108,7 @@ static int adv76xx_probe(struct i2c_client *client,
  			v4l2_err(sd, "Error %d reading IO Regmap\n", err);
  			return -ENODEV;
  		}
-		val2 |= val;
+		val |= val2;
  		if ((state->info->type == ADV7611 && val != 0x2051) ||
  			(state->info->type == ADV7612 && val != 0x2041)) {
  			v4l2_err(sd, "not an adv761x on address 0x%x\n",
-- 
1.7.10.4

