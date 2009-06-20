Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:38779 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZFTSaz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 14:30:55 -0400
Date: Sat, 20 Jun 2009 13:30:53 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Michael Krufky <mkrufky@linuxtv.org>
Subject: http://linuxtv.org/hg/~mcisely/pvrusb2-dev
Message-ID: <Pine.LNX.4.64.0906201328260.24362@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro:

Please pull from http://linuxtv.org/hg/~mcisely/pvrusb2-dev for a
number of pvrusb2 driver fixes.  The first two in particular are
high-priority critical fixes that clean up a nasty regression
involving analog capture on the HVR-1950 and the older 24xxx model
series.  It would be good to see those at least backported to a
2.6.30.x release.

- pvrusb2: Fix hardware scaling when used with cx25840
- pvrusb2: Re-fix hardware scaling on video standard change
- pvrusb2: Change initial default frequency setting
- pvrusb2: Improve handling of routing schemes
- pvrusb2: De-obfuscate code which handles routing schemes

 pvrusb2-audio.c       |   14 ++++++-----
 pvrusb2-cs53l32a.c    |   26 +++++++++++----------
 pvrusb2-cx2584x-v4l.c |   39 +++++++++++++++++---------------
 pvrusb2-hdw.c         |   60 ++++++++++++++++++++++++++++----------------------
 pvrusb2-video-v4l.c   |   37 +++++++++++++++++-------------
 5 files changed, 98 insertions(+), 78 deletions(-)


  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
