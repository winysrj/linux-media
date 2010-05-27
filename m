Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41815
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0E0Qkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:49 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH/RFC v2 0/8] dsbr100: driver cleanup and fixes
Date: Thu, 27 May 2010 12:39:08 -0400
Message-Id: <1274978356-25836-1-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series addresses several issues in the dsbr100 driver.
This series is based on the v4l-dvb master git branch and has been
compile tested only. It should be tested before applying.

This is the second version of this series. An additional patch has
been added to cleanup/clarify the return values from dsbr100_start
and dsbr100_stop.

The following patches are included in this series:
   [PATCH/RFC v2 1/8] dsbr100: implement proper locking
   [PATCH/RFC v2 2/8] dsbr100: fix potential use after free
   [PATCH/RFC v2 3/8] dsbr100: only change frequency upon success
   [PATCH/RFC v2 4/8] dsbr100: remove disconnected indicator
   [PATCH/RFC v2 5/8] dsbr100: cleanup return value of start/stop handlers
   [PATCH/RFC v2 6/8] dsbr100: properly initialize the radio
   [PATCH/RFC v2 7/8] dsbr100: cleanup usb probe routine
   [PATCH/RFC v2 8/8] dsbr100: simplify access to radio device

Regards,

David Ellingsworth

