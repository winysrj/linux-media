Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:46367 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3LJLku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 06:40:50 -0500
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/4] Bugfixes for UVC gadget test application
Date: Tue, 10 Dec 2013 12:40:33 +0100
Message-id: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patchset fixes UVC gadget test application, created by Laurent Pinchart
(git tree available here: git://git.ideasonboard.org/uvc-gadget.git), with
applied patches created by Bhupesh Sharma (which can be found here:
http://www.spinics.net/lists/linux-usb/msg84376.html).

It improves video-capture device handling, and adds few other fixes.
More details can be found in commit messages.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Robert Baldyga (4):
  closing uvc file when init fails
  remove set_format from uvc_events_process_data
  fix v4l2 stream handling
  remove flooding debugs

 uvc-gadget.c |   68 +++++++++-------------------------------------------------
 1 file changed, 10 insertions(+), 58 deletions(-)

-- 
1.7.9.5

