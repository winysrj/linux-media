Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:60731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0L0Qat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:30:49 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGUnAn007132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:30:49 -0500
Received: from gaivota (vpn-11-243.rdu.redhat.com [10.11.11.243])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNDpJ028091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:30:46 -0500
Date: Mon, 27 Dec 2010 14:22:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/8] [media] dmxdev: Fix a compilation warning due to a bad
 type
Message-ID: <20101227142249.51a8cfef@gaivota>
In-Reply-To: <cover.1293466891.git.mchehab@redhat.com>
References: <cover.1293466891.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

drivers/media/dvb/dvb-core/dmxdev.c: In function ‘dvb_dmxdev_start_feed’:
drivers/media/dvb/dvb-core/dmxdev.c:583:13: warning: comparison between ‘enum dmx_ts_pes’ and ‘enum <anonymous>’

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index ad1f61d..e4b5c03 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -572,13 +572,13 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 	dmx_output_t otype;
 	int ret;
 	int ts_type;
-	enum dmx_ts_pes ts_pes;
+	dmx_pes_type_t ts_pes;
 	struct dmx_ts_feed *tsfeed;
 
 	feed->ts = NULL;
 	otype = para->output;
 
-	ts_pes = (enum dmx_ts_pes)para->pes_type;
+	ts_pes = para->pes_type;
 
 	if (ts_pes < DMX_PES_OTHER)
 		ts_type = TS_DECODER;
-- 
1.7.3.4


