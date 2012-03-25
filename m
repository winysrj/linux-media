Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2CYLyu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 07:54:50 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: uvc & pwc: Add support for control events (v2)
Date: Sun, 25 Mar 2012 13:56:40 +0200
Message-Id: <1332676610-14953-1-git-send-email-hdegoede@redhat.com>
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

Changes in v2:
- Make the last param of __uvc_ctrl_get a s32 rather then an xctrl, as only
  the value part of the xctrl was used
- Make uvc_ctrl_send_event static as it is only used in uvc_ctrls.c
- Move some functions around in uvc_ctrls.c to avoid the need for forward
  declarations for static / private helper functions
- Refactor uvc_ctrl_send_event into uvc_ctrl_send_event and
  uvc_ctrl_send_events in preparation for the next patches
- Properly report the INACTIVE flag for inactive controls
- Send ctrl change events when the inactive flag changes due to the master
  ctrl changing

Regards,

Hans
