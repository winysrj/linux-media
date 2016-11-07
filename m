Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:48859 "EHLO
        resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932327AbcKGPlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Nov 2016 10:41:20 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, wsa-dev@sang-engineering.com,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        akpm@linux-foundation.org, sean@mess.org,
        patrick.boettcher@posteo.de
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix uninitialized variable warning in dib0700_rc_urb_completion()
Date: Mon,  7 Nov 2016 08:41:12 -0700
Message-Id: <20161107154114.26803-2-shuahkh@osg.samsung.com>
In-Reply-To: <20161107154114.26803-1-shuahkh@osg.samsung.com>
References: <20161107154114.26803-1-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following uninitialized variable compiler warning:

drivers/media/usb/dvb-usb/dib0700_core.c: In function ‘dib0700_rc_urb_completion’:
 drivers/media/usb/dvb-usb/dib0700_core.c:763:2: warning: ‘protocol’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   rc_keydown(d->rc_dev, protocol, keycode, toggle);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index f319665..cfe28ec 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -676,7 +676,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
 	struct dib0700_rc_response *poll_reply;
-	enum rc_type protocol;
+	enum rc_type protocol = RC_TYPE_UNKNOWN;
 	u32 uninitialized_var(keycode);
 	u8 toggle;
 
-- 
2.9.3

