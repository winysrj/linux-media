Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:49592 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZBAWin (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 17:38:43 -0500
Message-ID: <498622DA.9080106@freemail.hu>
Date: Sun, 01 Feb 2009 23:31:54 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
	Trivial Patch Monkey <trivial@kernel.org>
Subject: [PATCH] DAB: fix typo
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Fix typo in "DAB adapters" section in Kconfig.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.29-rc3/drivers/media/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.29-rc3/drivers/media/Kconfig	2009-02-01 13:30:54.000000000 +0100
@@ -117,7 +117,7 @@ source "drivers/media/dvb/Kconfig"
 config DAB
 	boolean "DAB adapters"
 	---help---
-	  Allow selecting support for for Digital Audio Broadcasting (DAB)
+	  Allow selecting support for Digital Audio Broadcasting (DAB)
 	  Receiver adapters.

 if DAB
