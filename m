Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43248 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbaGVUM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 16:12:29 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: crope@iki.fi, m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: [PATCH 0/8] add si2165 demod driver
Date: Tue, 22 Jul 2014 22:12:10 +0200
Message-Id: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for Si2165 demod.
The driver is DVB-T only for now.

Then it adds support for these devices:
* Hauppauge WinTV 930C-HD model 1113xx
* Hauppauge WinTV 930C-HD model 1114xx
* Hauppauge HVR-5500 (add DVB-T support)
* PCTV QuatroStick 521e
* PCTV QuatroStick 522e

Regards
Matthias

