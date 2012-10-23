Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:59477 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab2JWIrn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 04:47:43 -0400
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "pawel@osciak.com" <Pawel Osciak@casper.infradead.org>,
	"hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
	"s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Date: Tue, 23 Oct 2012 10:47:19 +0200
Subject: [PATCH TRIVIAL for 3.7] mem2mem: replace BUG_ON with WARN_ON
Message-ID: <50865997.7050401@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

See following thread for rationale:

	http://www.spinics.net/lists/linux-media/msg52462.html

Tested by compilation only.

Signed-off-by: Nicolas Thery <nicolas.thery@st.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 3ac8358..017fed8 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -510,12 +510,10 @@ struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops)
 {
 	struct v4l2_m2m_dev *m2m_dev;

-	if (!m2m_ops)
+	if (!m2m_ops || WARN_ON(!m2m_ops->device_run) ||
+			WARN_ON(!m2m_ops->job_abort))
 		return ERR_PTR(-EINVAL);

-	BUG_ON(!m2m_ops->device_run);
-	BUG_ON(!m2m_ops->job_abort);
-
 	m2m_dev = kzalloc(sizeof *m2m_dev, GFP_KERNEL);
 	if (!m2m_dev)
 		return ERR_PTR(-ENOMEM);
--
1.7.11.3
