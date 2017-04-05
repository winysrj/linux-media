Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41553
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933498AbdDESjO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 14:39:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] tveeprom: get rid of documentation of an unused parameter
Date: Wed,  5 Apr 2017 15:38:53 -0300
Message-Id: <0fad6e2372074e69b7c2048fec86f5a4bcbb3edb.1491417529.git.mchehab@s-opensource.com>
In-Reply-To: <f8da4aad552ec9423ca723404472cc3db0c125d7.1491417529.git.mchehab@s-opensource.com>
References: <f8da4aad552ec9423ca723404472cc3db0c125d7.1491417529.git.mchehab@s-opensource.com>
In-Reply-To: <f8da4aad552ec9423ca723404472cc3db0c125d7.1491417529.git.mchehab@s-opensource.com>
References: <f8da4aad552ec9423ca723404472cc3db0c125d7.1491417529.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 446aba663b82 ("[media] tveeprom: get rid of unused arg
on tveeprom_hauppauge_analog()") removed the now unused I2C adapter
struct from struct tveeprom. Remove the corresponding kernel-doc
tag.

Fixes: 446aba663b82 ("[media] tveeprom: get rid of unused arg on tveeprom_hauppauge_analog()")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/tveeprom.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/tveeprom.h b/include/media/tveeprom.h
index 5324c82fc810..630bcf3d8885 100644
--- a/include/media/tveeprom.h
+++ b/include/media/tveeprom.h
@@ -94,7 +94,6 @@ struct tveeprom {
  *			       of the eeprom previously filled at
  *			       @eeprom_data field.
  *
- * @c:			I2C client struct
  * @tvee:		Struct to where the eeprom parsed data will be filled;
  * @eeprom_data:	Array with the contents of the eeprom_data. It should
  *			contain 256 bytes filled with the contents of the
-- 
2.9.3
