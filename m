Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2CWQuA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 12:50:00 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: uvc & pwc: Add support for control events
Date: Fri, 23 Mar 2012 17:51:53 +0100
Message-Id: <1332521519-552-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch series adds supports for control events to the uvc and pwc
drivers.

Note:
-This series depends on Hans Verkuil's poll work, the latest version of
-which
 can be found here:
 http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/poll_req_events
-This series has been posted before, this version is rebased on top of
 the latest media_tree.git/staging/for_v3.4 and has some remarks from 
 earlier reviews addressed

Regards,

Hans
