Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:42757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0FLDLE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 23:11:04 -0400
Received: by pxi8 with SMTP id 8so1093228pxi.19
        for <linux-media@vger.kernel.org>; Fri, 11 Jun 2010 20:11:03 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 11 Jun 2010 20:11:03 -0700
Message-ID: <AANLkTimahhDfTESneHAGNe-lCRDr4Pw8a_dJ_tp0a2F5@mail.gmail.com>
Subject: [PATCH] Fix module dependency selection for Mantis driver
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Cc: Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds missing module dependencies to the Mantis Kconfig file
so that they are selected automatically when the user enables Mantis.

Signed-off-by: Derek Kelly <user.vdr@gmail.com>
----------

--- v4l-dvb.orig/linux/drivers/media/dvb/mantis/Kconfig 2010-06-11
14:28:26.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/mantis/Kconfig      2010-06-11
14:32:44.000000000 -0700
@@ -10,6 +10,8 @@ config MANTIS_CORE
 config DVB_MANTIS
        tristate "MANTIS based cards"
        depends on MANTIS_CORE && DVB_CORE && PCI && I2C
+       select DVB_STB0899
+       select DVB_STB6100
        select DVB_MB86A16
        select DVB_ZL10353
        select DVB_STV0299
