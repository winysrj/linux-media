Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:51822 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754557Ab2EFU4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 16:56:47 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 0/3] fc001x: updated support for tuner FC0012 and initial support for FC0013
Date: Sun, 6 May 2012 22:56:40 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205062256.40558.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set provides an updated driver for the tuner FC0012 (v0.5), which 
includes changes from Thomas Mair (thanks!) and further modifications to make 
it compatible with the newly introduced tuner driver for the FC0013, with 
which it has a lot in common.
For FC0012, I had to introduce the new parameter dual_master in the 
fc0012_attach function. This parameter needs to be set to 0 in the single 
tuner application with the RTL2832 and to 1 in the dual tuner application with 
the AF9035.

Patch 1/3 a header file which will be common to the FC0012 and FC0013 drivers
Patch 2/3 updated tuner driver for FC0012
Patch 3/3 initial tuner driver for FC0013

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
