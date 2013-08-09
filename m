Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:46781 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967262Ab3HIHn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 03:43:58 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r797hsLk003492
	for <linux-media@vger.kernel.org>; Fri, 9 Aug 2013 07:43:54 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] qv4l2: add cropping and qt opimization
Date: Fri,  9 Aug 2013 09:43:47 +0200
Message-Id: <1376034229-26693-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add cropping to CaptureWin as well as optimizing the Qt renderer.
There is also other fixes and tweaks to the code itself.
Cropping allows removal of letterboxing from the video display.
Qt optimization no longer needs to copy the frame data for every
frame and scaling or cropping is only performed when required.
This was required to make cropping work efficent and should improve
general performance. A consequence is that the Qt renderer has been rewritten.

Some of the changes/improvements:
- Update, add and fix status tips
- Add cropping to CaptureWin
- Optimized Qt renderer
- Code cleanup

Cropping options:
- None
- Top and Bottom Lines
- Widescreen 14:9
- Widescreen 16:9
- Cinema 1.85:1
- Cinema 1.39:1

