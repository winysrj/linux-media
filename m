Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63035 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760940Ab2EQDkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 23:40:12 -0400
Received: by wgbdr13 with SMTP id dr13so1336272wgb.1
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 20:40:11 -0700 (PDT)
Message-ID: <4FB47318.5020807@gmail.com>
Date: Thu, 17 May 2012 05:40:08 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rtl2832 ver. 0.4: removed signal statistics
References: <1> <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-2-git-send-email-thomas.mair86@googlemail.com> <4FB4722A.9070009@gmail.com>
In-Reply-To: <4FB4722A.9070009@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050402040904090402040708"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050402040904090402040708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[…]
v4-1-5-rtl2832-ver.-0.4-v2.diff


--------------050402040904090402040708
Content-Type: text/x-patch;
 name="v4-1-5-rtl2832-ver.-0.4-v2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v4-1-5-rtl2832-ver.-0.4-v2.diff"

--- v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig	2012-05-17 05:17:16.732328539 +0200
+++ v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch	2012-05-17 05:17:35.999265106 +0200
@@ -24,7 +24,7 @@
  obj-$(CONFIG_DVB_A8293) += a8293.o
  obj-$(CONFIG_DVB_TDA10071) += tda10071.o
  obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
-+obj-$(CONFIG_DVB_RTL2830) += rtl2832.o
++obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
  obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
  obj-$(CONFIG_DVB_AF9033) += af9033.o
  

--------------050402040904090402040708--
