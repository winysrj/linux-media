Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46438 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756903Ab1I2VWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 17:22:38 -0400
Message-ID: <4E84E1A5.3040903@gmx.net>
Date: Thu, 29 Sep 2011 23:22:45 +0200
From: Lutz Sammer <johns98@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH v2] stb0899: Fix slow and not locking DVB-S transponder(s)
References: <4E84E010.5020602@gmx.net>
In-Reply-To: <4E84E010.5020602@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another version of
http://patchwork.linuxtv.org/patch/6307
http://patchwork.linuxtv.org/patch/6510
which was superseded or rejected, but I don't know why.

In stb0899_status stb0899_check_data the first read of STB0899_VSTATUS
could read old (from previous search) status bits and the search fails
on a good frequency.

With the patch more transponder could be locked and locks about 2* faster.

Signed-off-by: Lutz Sammer <johns98@gmx.net>
---
 drivers/media/dvb/frontends/stb0899_algo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index d70eee0..8eca419 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -358,6 +358,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
        else
                dataTime = 500;
 
+       stb0899_read_reg(state, STB0899_VSTATUS); /* clear old status bits */
        stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop */
        while (1) {
                /* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP   */
-- 
1.7.6.1
