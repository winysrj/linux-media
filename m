Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:48377 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab1IWPLJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 11:11:09 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id 06A2B3963E
	for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 17:11:07 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: <o.endriss@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [DVB] Digital Devices Cine CT V6 support
Date: Fri, 23 Sep 2011 17:11:08 +0200
Message-ID: <004c01cc7a03$064111c0$12c33540$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Oliver,

Using your latest development tree (hg clone
http://linuxtv.org/hg/~endriss/media_build_experimental), I have made a
small modification in ddbridge-core.c (see below) to make the new "Cine CT
V6" card detected by the ddbridge module.

With this small patch, the card is now detected, but not the double C/T
tuner onboard.
If I connect a "DuoFlex CT" on a port, the tuners of the add-in card are
detected.

Also, I was wondering why they put a male and a female RF connectors on the
"Cine CT V6" (maybe a loop-through?) where there are two female RF
connectors on the "DuoFlex CT" card.

Best regards,
Sebastien.


Before 
------

static struct ddb_info ddb_v6 = {
	.type     = DDB_OCTOPUS,
	.name     = "Digital Devices Cine S2 V6 DVB adapter",
	.port_num = 3,
};

And

	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),

After
-----

static struct ddb_info ddb_v6_s2 = {
	.type     = DDB_OCTOPUS,
	.name     = "Digital Devices Cine S2 V6 DVB-S/S2 adapter",
	.port_num = 3,
};

static struct ddb_info ddb_v6_ct = {
	.type     = DDB_OCTOPUS,
	.name     = "Digital Devices Cine S2 V6 DVB-C/T adapter",
	.port_num = 3,
};

And

	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6_s2),
	DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_v6_ct),








