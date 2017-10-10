Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:42696 "EHLO
        resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756588AbdJJXbu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 19:31:50 -0400
To: linux-media@vger.kernel.org
From: Ron Economos <w6rz@comcast.net>
Subject: {PATCH] media: dvb-core: Crash from uninitialized pointer
Message-ID: <d33d6a7c-9e3f-01dc-535e-e36a065658b1@comcast.net>
Date: Tue, 10 Oct 2017 16:23:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the function dvb_net_ule(), the pointer h.priv is not initialized. 
When a ULE packet is received, the kernel crashes.

diff --git a/drivers/media/dvb-core/dvb_net.c 
b/drivers/media/dvb-core/dvb_net.c
index 06b0dcc..abfa3e5 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -798,6 +798,7 @@ static void dvb_net_ule(struct net_device *dev, 
const u8 *buf, size_t buf_len)
          * For all TS cells in current buffer.
          * Appearently, we are called for every single TS cell.
          */
+       h.priv = netdev_priv(dev);
         for (h.ts = h.buf, h.ts_end = h.buf + h.buf_len;
              h.ts < h.ts_end; /* no incr. */) {
                 if (h.new_ts) {
