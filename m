Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55582 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab3LMHC1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 02:02:27 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, crope@iki.fi
Subject: [RFC PATCH 0/3] wintv hvr 930c-hd: Add limited support for DVB-C and DVB-T
Date: Fri, 13 Dec 2013 08:02:10 +0100
Message-Id: <1386918133-21628-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is the current state of my si2165 driver.
It works on some DVB-T channels and on some DVB-C channels.
Lot of stuff is missing, see patch description.

Maybe the si2165 driver also works on other si2165/si2163/si2161 based cards.
For DVB-C/DVB-T only cards it must be detected which standard is supported.

Regards
Matthias

