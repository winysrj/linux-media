Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:38571
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbaHIAgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Aug 2014 20:36:23 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] au0828: au0828_rc_*() defines cleanup 
Date: Fri,  8 Aug 2014 18:36:17 -0600
Message-Id: <cover.1407544065.git.shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define au0828_rc_*() stubs to avoid compile errors when
VIDEO_AU0828_RC is disabled and avoid the need to enclose
au0828_rc_*() in ifdef CONFIG_VIDEO_AU0828_RC in .c files.

This patch series adds stubs and fixes places where ifdef
is used.

Shuah Khan (2):
  au0828: add au0828_rc_*() stubs for VIDEO_AU0828_RC disabled case
  au0828: remove CONFIG_VIDEO_AU0828_RC scope around au0828_rc_*()

 drivers/media/usb/au0828/au0828-core.c |    4 ----
 drivers/media/usb/au0828/au0828.h      |   15 +++++++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
1.7.10.4

