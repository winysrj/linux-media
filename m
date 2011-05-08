Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52919 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1EHXNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:21 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 0/8] dvb_frontend cleanup, S2API regression fix
Date: Sun,  8 May 2011 23:03:33 +0000
Message-Id: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Here are some patches to clean up some dvb_frontend code
and to allow reading back detected tuning parameters
through S2API.

The patches have only been compile-tested for now. Feedback
would be appreciated, to minimize the risk of new regressions.

They apply on top of two of the DVB-T2 patches previously
submitted:

https://patchwork.kernel.org/patch/766442/
https://patchwork.kernel.org/patch/766822/

Andreas Oberritter (8):
  DVB: return meaningful error codes in dvb_frontend
  DVB: dtv_property_cache_submit shouldn't modifiy the cache
  DVB: call get_property at the end of dtv_property_process_get
  DVB: dvb_frontend: rename parameters to parameters_in
  DVB: dvb_frontend: remove unused assignments
  DVB: dvb_frontend: use shortcut to access fe->dtv_property_cache
  DVB: dvb_frontend: add parameters_out
  DVB: allow to read back of detected parameters through S2API

 drivers/media/dvb/dvb-core/dvb_frontend.c |  356 +++++++++++++++--------------
 1 files changed, 186 insertions(+), 170 deletions(-)

-- 
1.7.2.5

