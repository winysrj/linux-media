Return-path: <mchehab@pedra>
Received: from luna.schedom-europe.net ([193.109.184.86]:58335 "EHLO
	luna.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1EUOT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 10:19:56 -0400
Received: from [2001:6f8:310:300:224:8cff:fe0b:7d8e] (helo=borg.bxl.tuxicoman.be)
	by ibiza.bxl.tuxicoman.be with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.76)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1QNnrW-0002gv-0V
	for linux-media@vger.kernel.org; Sat, 21 May 2011 17:13:06 +0200
Date: Sat, 21 May 2011 16:12:12 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Disable dynamic current limit for ttpci budget cards
Message-ID: <20110521161212.334204a1@borg.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Disable dynamic current limit for ttpci budget cards.
According to the ISL6423 datasheet, if dynamic current limiting is turned on,
the static limit is ignored and the current drawn can be as high as 990mW.
This is not what we want as it might overload the PCI bus. Disabling
dynamic limit also avoid issues with rotors and DiSEqC switches which
might require a higher current for a short period when powered on.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

--
 drivers/media/dvb/ttpci/budget.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index d238fb9..91340ab 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -462,7 +462,7 @@ static struct stv6110x_config tt1600_stv6110x_config = {
 
 static struct isl6423_config tt1600_isl6423_config = {
 	.current_max		= SEC_CURRENT_515m,
-	.curlim			= SEC_CURRENT_LIM_ON,
+	.curlim			= SEC_CURRENT_LIM_OFF,
 	.mod_extern		= 1,
 	.addr			= 0x08,
 };
