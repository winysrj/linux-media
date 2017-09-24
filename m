Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59393
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751267AbdIXKXv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 06:23:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH v2] scripts: kernel-doc: fix nexted handling
Date: Sun, 24 Sep 2017 07:23:43 -0300
Message-Id: <3d54014d786733715a94fa783a479a498aaca1ea.1506248420.git.mchehab@s-opensource.com>
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

v2:  handle embedded structs/unions from inner to outer

When we have multiple levels of embedded structs, like
(see v4l2-async.h):

struct v4l2_async_subdev {
	enum v4l2_async_match_type match_type;
	union {
		struct {
			struct fwnode_handle *fwnode;
		} fwnode;
		struct {
			const char *name;
		} device_name;
		struct {
			int adapter_id;
			unsigned short address;
		} i2c;
		struct {
			bool (*match)(struct device *,
				      struct v4l2_async_subdev *);
			void *priv;
		} custom;
	} match;
...
}

we need a smarter rule that will be removing nested structs
from the inner to the outer ones. So, changed the parsing rule to
remove nested structs/unions from the inner ones to the outer
ones, while it matches.

 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9d3eafea58f0..443e1bcc78db 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2173,7 +2173,7 @@ sub dump_struct($$) {
 	my $members = $3;
 
 	# ignore embedded structs or unions
-	$members =~ s/({.*})//g;
+	while ($members =~ s/({[^\{\}]*})//g) {};
 	$nested = $1;
 
 	# ignore members marked private:
-- 
2.13.5
