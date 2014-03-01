Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46236 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752652AbaCAQPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:15:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [yavta PATCH 0/9] Timestamp source and mem-to-mem device support
Date: Sat,  1 Mar 2014 18:18:01 +0200
Message-Id: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset enables using yavta for mem-to-mem devices, including
mem2mem_testdev (or soon vim2m). The timestamp will be set for output
buffers when the timestamp type is copy. An option is added to set the
timestamp source flags (eof/soe).

To use yavta for mem2mem devices, just open the device in the shell and pass
the file descriptor to yavta (--fd).

-- 
Kind regards,
Sakari

