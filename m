Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C043DC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76ED82176F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550523509;
	bh=ibHqo/2s+Hnq3MyRB15Vlwynbg5wd+JXA0kw1PI06IM=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=wL1y15MWF49O7+MLKlHLlkQq1vi/ckwqrxBlb9W0jyzwwIJ88l4dypAMwzt+JSJuI
	 0vRnrIvWwIGbK2Gc1Ah2yZQj0YEb/fxtJyuL8Frn83ZGIZlyQ4tNk81tiDmWaOIVgQ
	 SLmPCyG89iq5pd3wEGQNsP8YKOZWDyQ3cDol/D+Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbfBRU63 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:58:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729486AbfBRU62 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 15:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VcpkaYOTtScxm1l3lzfWQnLFO0mPwwhD83mzp3SwQ4s=; b=W/1Wo2+z4LynSNbtIFMR93UEY
        eOoPaZZQI+WRY9Ppa6wzk6bsuZzOsjQM9KyWU13KeOhH5B1pVgQqsSugwoIhRVWZiOvqhmsJBjrM3
        5H8+Tg7ddXpLqvV1lE9xD//Kd3xbNcyMCj5wiRwlRpSvO5WLxexdWdWcBkd9uFJQTPOqImmgZIR3c
        jtzgVDc3RBKOjR7SiL+e1cS+6InN4fqcu5gm3FcXaj2vTkBbwZ3ETVmFQJplkTRa5Okl7eEi+c4+h
        eTtgCE8NAH691SYduDqQPvBGdSoNyPanGZLW3gqreNf8617qUFz4waHWjke5VKg3bzVYyqMJvS3py
        IyBJY/GCw==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvpzg-00029g-9A; Mon, 18 Feb 2019 20:58:28 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvpzc-0003VU-G5; Mon, 18 Feb 2019 15:58:24 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] media: imx7.rst: Fix ReST syntax
Date:   Mon, 18 Feb 2019 15:58:23 -0500
Message-Id: <3fecc49e0dd82cdec8ac18ff53c7a4d4baedb508.1550523497.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sphinx didn't like the code-blocks on this file:

	Documentation/media/v4l-drivers/imx7.rst:19: WARNING: Inline substitution_reference start-string without end-string.
	Documentation/media/v4l-drivers/imx7.rst:20: WARNING: Block quote ends without a blank line; unexpected unindent.
	Documentation/media/v4l-drivers/imx7.rst:27: WARNING: Inline substitution_reference start-string without end-string.
	Documentation/media/v4l-drivers/imx7.rst:79: WARNING: Error in "code-block" directive:
	maximum 1 argument(s) allowed, 26 supplied.

	.. code-block:: none
	   # Setup links
	<snip/>
	   media-ctl -V "'csi':0 [fmt:SBGGR10_1X10/800x600 field:none]"
	Documentation/media/v4l-drivers/imx7.rst:96: WARNING: Error in "code-block" directive:
	maximum 1 argument(s) allowed, 9 supplied.

	.. code-block:: none
	<snip/>.
	                    -> "imx7-mipi-csis.0":0 [ENABLED]

Fix them, in order to match the expected syntax for code blocks.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/v4l-drivers/imx7.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/v4l-drivers/imx7.rst b/Documentation/media/v4l-drivers/imx7.rst
index 804d900da535..fe411f65c01c 100644
--- a/Documentation/media/v4l-drivers/imx7.rst
+++ b/Documentation/media/v4l-drivers/imx7.rst
@@ -15,9 +15,10 @@ For image capture the i.MX7 has three units:
 - Video Multiplexer
 - MIPI CSI-2 Receiver
 
-::
-                                           |\
-   MIPI Camera Input ---> MIPI CSI-2 --- > | \
+.. code-block:: none
+
+   MIPI Camera Input ---> MIPI CSI-2 --- > |\
+                                           | \
                                            |  \
                                            | M |
                                            | U | ------>  CSI ---> Capture
@@ -77,6 +78,7 @@ CSI-2 receiver. The following example configures a video capture pipeline with
 an output of 800x600, and BGGR 10 bit bayer format:
 
 .. code-block:: none
+
    # Setup links
    media-ctl -l "'ov2680 1-0036':0 -> 'imx7-mipi-csis.0':0[1]"
    media-ctl -l "'imx7-mipi-csis.0':1 -> 'csi_mux':1[1]"
@@ -94,6 +96,7 @@ After this streaming can start. The v4l2-ctl tool can be used to select any of
 the resolutions supported by the sensor.
 
 .. code-block:: none
+
     root@imx7s-warp:~# media-ctl -p
     Media controller API version 4.17.0
 
-- 
2.20.1

