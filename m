Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:48114 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966169Ab3HIMM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:12:29 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: baard.e.winther@wintherstormer.no
Subject: [PATCH FINAL 0/6] qv4l2: cropping, optimization and documentatio
Date: Fri,  9 Aug 2013 14:12:06 +0200
Message-Id: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

qv4l2:

Add cropping to the CaptureWin. In order to make the Qt renderer work with
this as well, it had to be optimized to not lose framerate.
A basic manpage is added along width fixing the input parameters.

New Features/Improvements:
- Add cropping to CaptureWin
- Qt renderer has been optimized (no longer uses memcpy!)
- Add a basic manpage
- About window shows version number and ALSA/OpenGL support
- Fix program parameters
- Fix status hints for some missing GeneralTab elements
- Code cleanup and fixes

