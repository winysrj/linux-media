Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:53446 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbcAIUYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 15:24:55 -0500
From: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
To: linux-media@vger.kernel.org
Cc: Ernst Martin Witte <emw-linux-kernel@nocabal.de>
Subject: [PATCH 0/5] [media] cancel_delayed_work_sync before device removal / kfree
Date: Sat,  9 Jan 2016 21:18:42 +0100
Message-Id: <1452370727-23128-1-git-send-email-emw-linux-kernel@nocabal.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For  si2157, kernel  panics  in call_timer_fn  could  be triggered  by
simply  doing  an

   rmmod  cx23885

A bisect identified commit 2f1ea29fca781b8e6600f3ece1f2dd98ae276294 as
the one introducing  those kernel panics. It could  be identified that
si2157_remove  was  calling  kfree(dev)  with  possibly  still  active
schedule_delayed_work(dev->stat_work).

Below drivers/media/tuners and  drivers/media/dvb-frontends this issue
could also be identified in the following modules:

   ts2020
   af9013
   af9033
   rtl2830

Therefore, this  patch series  also includes the  equivalent one-liner
fixes for these modules.

BR,
  Martin

Ernst Martin Witte (5):
  [media] si2157: cancel_delayed_work_sync before device removal / kfree
  [media] ts2020: cancel_delayed_work_sync before device removal / kfree
  [media] af9013: cancel_delayed_work_sync before device removal / kfree
  [media] af9033: cancel_delayed_work_sync before device removal / kfree
  [media] rtl2830: cancel_delayed_work_sync before device removal / kfree

 drivers/media/dvb-frontends/af9013.c  | 4 ++++
 drivers/media/dvb-frontends/af9033.c  | 3 +++
 drivers/media/dvb-frontends/rtl2830.c | 3 +++
 drivers/media/dvb-frontends/ts2020.c  | 4 ++++
 drivers/media/tuners/si2157.c         | 3 +++
 5 files changed, 17 insertions(+)

-- 
2.5.0

