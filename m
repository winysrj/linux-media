Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:38735 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab2BVNZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 08:25:08 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>, mchehab@redhat.com
Subject: [RESEND][PATCH v2 0/2] fix cx18-/ivtv-driver 'radio' module parameter
Date: Wed, 22 Feb 2012 14:24:54 +0100
Message-Id: <1329917096-19438-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated patch versions to fix the 'radio' module parameter
of cx18-driver and ivtv-driver.

Please add to 3.3.

Danny Kukawka (2):
  cx18-driver: fix handling of 'radio' module parameter
  ivtv-driver: fix handling of 'radio' module parameter

 drivers/media/video/cx18/cx18-driver.c |    4 ++--
 drivers/media/video/ivtv/ivtv-driver.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.8.3

