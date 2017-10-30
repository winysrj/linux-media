Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:48766 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752712AbdJ3WSL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 18:18:11 -0400
Received: by mail-wm0-f66.google.com with SMTP id p75so18783114wmg.3
        for <linux-media@vger.kernel.org>; Mon, 30 Oct 2017 15:18:10 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] dvb-core: dvb_frontend_handle_ioctl(): init err to -EOPNOTSUPP
Date: Mon, 30 Oct 2017 23:18:08 +0100
Message-Id: <20171030221808.4642-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes: d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic")

The mentioned commit cleaned up the ioctl handling, but caused an issue
with the DVBv3 when they're not defined in a frontend's fe_ops: When a
userspace application checks for existence and success of a fe_ops with ie.

  if (!ioctl(fd, FE_READ_BER, &val))

this will not report failure anymore since in dvb_frontend_handle_ioctl(),
err is unitialised and thus zero, and "case FE_READ_BER" (and the
following) doesn't care about the case that fe_op isn't set by the frontend
driver. So, success is always reported while the value at the passed ptr
isn't updated. This breaks userspace applications relying on v3 stats.

Fix this by initialising err to -EOPNOTSUPP like it was before the commit.
This only affects (and fixes) the DVBv3 stat ioctls, every other handled
ioctl sets err to a proper return value.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
Discovered and tested with TVHeadend (current GIT master HEAD) which does
fallback to DVBv3 stats inquiry when v5 is absent.

 drivers/media/dvb-core/dvb_frontend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index daaf969719e4..cc64fa38a1df 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2113,6 +2113,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
+	err = -EOPNOTSUPP;
+
 	switch (cmd) {
 	case FE_SET_PROPERTY: {
 		struct dtv_properties *tvps = parg;
-- 
2.13.6
