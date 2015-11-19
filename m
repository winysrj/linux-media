Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54326 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbbKSUEm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:04:42 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de
Subject: si2165: Add simple DVB-C support
Date: Thu, 19 Nov 2015 21:03:52 +0100
Message-Id: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds simple DVB-C support to the si2165 demod driver.

It works only for HVR-4400/HVR-5500.
For WinTV-HVR-930C-HD it fails with bad/no reception
for unknown reasons.

Regards
Matthias

