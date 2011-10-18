Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:38090 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1JRGMk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 02:12:40 -0400
Date: Tue, 18 Oct 2011 09:12:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Derek Kelly <user.vdr@gmail.com>,
	"Hans J. Koch" <hjk@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
	Ben Pfaff <blp@cs.stanford.edu>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] av7110: wrong limiter in av7110_start_feed()
Message-ID: <20111018061209.GF27732@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains that the wrong limiter is used here:
drivers/media/dvb/ttpci/av7110.c +906 dvb_feed_start_pid(12)
	error: buffer overflow 'npids' 5 <= 19

Here is the problem code:
   905          i = dvbdmxfeed->pes_type;
   906          npids[i] = (pid[i]&0x8000) ? 0 : pid[i];

"npids" is a 5 element array declared on the stack.  If
dvbdmxfeed->pes_type is more than 4 we probably put a (u16)0 past
the end of the array.

If dvbdmxfeed->pes_type is over 4 the rest of the function doesn't
do anything.  dvbdmxfeed->pes_type is capped at less than
DMX_TS_PES_OTHER (20) in the caller function, but I changed it to
less than or equal to DMX_TS_PES_PCR (4).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 3d20719..abf6b55 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -991,7 +991,7 @@ static int av7110_start_feed(struct dvb_demux_feed *feed)
 
 	if (feed->type == DMX_TYPE_TS) {
 		if ((feed->ts_type & TS_DECODER) &&
-		    (feed->pes_type < DMX_TS_PES_OTHER)) {
+		    (feed->pes_type <= DMX_TS_PES_PCR)) {
 			switch (demux->dmx.frontend->source) {
 			case DMX_MEMORY_FE:
 				if (feed->ts_type & TS_DECODER)
