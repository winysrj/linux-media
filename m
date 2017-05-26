Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38386 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762336AbdEZP0q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:26:46 -0400
Subject: [PATCH 05/12] hdlcdrv: Fix division by zero when bitrate is unset
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:26:42 +0100
Message-ID: <149581238775.17406.4594436624734437821.stgit@builder>
In-Reply-To: <149581234670.17406.8086980349538517529.stgit@builder>
References: <149581234670.17406.8086980349538517529.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code attempts to check for out of range calibration. What it forgets to do
is check for the 0 bitrate case. As a result the range check itself oopses the
kernel.

Found by Andrey Konovalov using Syzkaller.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/net/hamradio/hdlcdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 8c3633c..9f34a48 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -576,7 +576,7 @@ static int hdlcdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case HDLCDRVCTL_CALIBRATE:
 		if(!capable(CAP_SYS_RAWIO))
 			return -EPERM;
-		if (bi.data.calibrate > INT_MAX / s->par.bitrate)
+		if (!s->par.bitrate || bi.data.calibrate > INT_MAX / s->par.bitrate)
 			return -EINVAL;
 		s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;
 		return 0;
