Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482Ab3DAOnG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:43:06 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r31Eh6P6001964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 1 Apr 2013 10:43:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/5] mb86a20s: some smatch fixes
Date: Mon,  1 Apr 2013 11:41:54 -0300
Message-Id: <1364827319-18332-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <20130401072529.GL18466@mwanda>
References: <20130401072529.GL18466@mwanda>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed by Dan Carpenter, there are two smatch warnings on
this driver:

	drivers/media/dvb-frontends/mb86a20s.c:1897 mb86a20s_set_frontend() error: buffer overflow 'mb86a20s_subchannel' 8 <= 8
	drivers/media/dvb-frontends/mb86a20s.c:644 mb86a20s_layer_bitrate() error: buffer overflow 'state->estimated_rate' 3 <= 3

While both of them are trivial, one of the errors were due to a bad
cut-and-paste silly error, plus the abuse of "i" on loops and
array indexes.

So, let's fix both errors and remove the "i" temp var abuse on the
driver.

Mauro Carvalho Chehab (5):
  [media] mb86a20s: Use a macro for the number of layers
  [media] mb86a20s: Fix estimate_rate setting
  [media] mb86a20s: fix audio sub-channel check
  [media] mb86a20s: Use 'layer' instead of 'i' on all places
  [media] mb86a20s: better name temp vars at mb86a20s_layer_bitrate()

 drivers/media/dvb-frontends/mb86a20s.c | 213 +++++++++++++++++----------------
 1 file changed, 108 insertions(+), 105 deletions(-)

-- 
1.8.1.4

