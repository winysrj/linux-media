Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:40625 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0BGMsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 07:48:15 -0500
Received: from [151.82.7.88] (151.82.7.88) by cp-out10.libero.it (8.5.107)
        id 4B5B78F701325A8A for linux-media@vger.kernel.org; Sun, 7 Feb 2010 13:48:14 +0100
Subject: [PATCH] dvb-core: fix initialization of feeds list in demux filter
From: Francesco Lavra <francescolavra@interfree.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 07 Feb 2010 13:49:58 +0100
Message-Id: <1265546998.9356.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A DVB demultiplexer device can be used to set up either a PES filter or
a section filter. In the former case, the ts field of the feed union of
struct dmxdev_filter is used, in the latter case the sec field of the
same union is used.
The ts field is a struct list_head, and is currently initialized in the
open() method of the demux device. When for a given demuxer a section
filter is set up, the sec field is played with, thus if a PES filter
needs to be set up after that the ts field will be corrupted, causing a
kernel oops.
This fix moves the list head initialization to
dvb_dmxdev_pes_filter_set(), so that the ts field is properly
initialized every time a PES filter is set up.

Signed-off-by: Francesco Lavra <francescolavra@interfree.it>
Cc: stable <stable@kernel.org>
---

--- a/drivers/media/dvb/dvb-core/dmxdev.c	2010-02-07 13:19:18.000000000 +0100
+++ b/drivers/media/dvb/dvb-core/dmxdev.c	2010-02-07 13:23:39.000000000 +0100
@@ -761,7 +761,6 @@ static int dvb_demux_open(struct inode *
 	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
 	dmxdevfilter->type = DMXDEV_TYPE_NONE;
 	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_ALLOCATED);
-	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
 	init_timer(&dmxdevfilter->timer);
 
 	dvbdev->users++;
@@ -887,6 +886,7 @@ static int dvb_dmxdev_pes_filter_set(str
 	dmxdevfilter->type = DMXDEV_TYPE_PES;
 	memcpy(&dmxdevfilter->params, params,
 	       sizeof(struct dmx_pes_filter_params));
+	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
 
 	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_SET);
 


