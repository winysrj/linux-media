Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48883
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751614AbdITQ1x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 12:27:53 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH] scripts: kernel-doc: fix nexted handling
Date: Wed, 20 Sep 2017 13:27:47 -0300
Message-Id: <a788284f66d113ceec57dd6f66b1d024e7b1ddf1.1505924829.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At DVB, we have, at some structs, things like (see
struct dvb_demux_feed, at dvb_demux.h):

	union {
		struct dmx_ts_feed ts;
		struct dmx_section_feed sec;
	} feed;

	union {
		dmx_ts_cb ts;
		dmx_section_cb sec;
	} cb;

Fix the nested parser to avoid it to eat the first union.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

Jon,

While documenting some DVB demux  headers, I noticed the above bug.

 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9d3eafea58f0..15f934a23d1d 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2173,7 +2173,7 @@ sub dump_struct($$) {
 	my $members = $3;
 
 	# ignore embedded structs or unions
-	$members =~ s/({.*})//g;
+	$members =~ s/({[^\}]*})//g;
 	$nested = $1;
 
 	# ignore members marked private:
-- 
2.13.5
