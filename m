Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39306 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761420AbZC0UH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 16:07:28 -0400
Date: Fri, 27 Mar 2009 21:00:46 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH resend] DVB: firedtv: FireDTV S2 problems with tuning solved
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
	Beat Michel Liechti <bml303@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org
In-Reply-To: <3e03d4060903261446s777bc55bx98e4dce8e1fd6c21@mail.gmail.com>
Message-ID: <tkrat.61cf63974add377d@s5r6.in-berlin.de>
References: <3e03d4060903261446s777bc55bx98e4dce8e1fd6c21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This came in via linux1394-devel.  If there are no objections, I'll
include it in my pull request to Linus which I want to send in a few
hours.  It's also good to send to stable.


Date: Thu, Mar 26, 2009 22:36:52 +0100 (CET)
From: Beat Michel Liechti <bml303@gmail.com>
Subject: DVB: firedtv: FireDTV S2 problems with tuning solved

Signed-off-by: Beat Michel Liechti <bml303@gmail.com>

Tuning was broken on FireDTV S2 (and presumably  FloppyDTV S2) because a
wrong opcode was sent.  The box only gave "not implemented" responses.
Changing the opcode to _TUNE_QPSK2 fixes this for good.

Cc: stable@kernel.org
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-avc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux/drivers/media/dvb/firewire/firedtv-avc.c
@@ -135,6 +135,7 @@ static const char *debug_fcp_opcode(unsi
 	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:	return "RegisterRC";
 	case SFE_VENDOR_OPCODE_LNB_CONTROL:		return "LNBControl";
 	case SFE_VENDOR_OPCODE_TUNE_QPSK:		return "TuneQPSK";
+	case SFE_VENDOR_OPCODE_TUNE_QPSK2:		return "TuneQPSK2";
 	case SFE_VENDOR_OPCODE_HOST2CA:			return "Host2CA";
 	case SFE_VENDOR_OPCODE_CA2HOST:			return "CA2Host";
 	}
@@ -266,7 +267,10 @@ static void avc_tuner_tuneqpsk(struct fi
 	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
 	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
 	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
-	c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK;
+	if (fdtv->type == FIREDTV_DVB_S2)
+		c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK2;
+	else
+		c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK;
 
 	c->operand[4] = (params->frequency >> 24) & 0xff;
 	c->operand[5] = (params->frequency >> 16) & 0xff;


-- 
Stefan Richter
-=====-==--= --== ==-==
http://arcgraph.de/sr/

