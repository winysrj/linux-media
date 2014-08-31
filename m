Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45344 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaHaLf2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 07:35:28 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com, crope@iki.fi,
	zzam@gentoo.org
Subject: [PATCH 0/7] Add support for Si2161 demod and improve firmware handling
Date: Sun, 31 Aug 2014 13:35:05 +0200
Message-Id: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for Si2161 based devices.
cx231xx based WinTV-HVR-900-H works with it.
cx231xx based WinTV-HVR-901-H should also work.

Additionally it simplifies firmware structure by no longer adding a seperate header
as suggested by Antti.

Regards
Matthias


