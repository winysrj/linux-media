Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46193 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753353Ab2FJBop (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:45 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Some tvaudio fixes
Date: Sun, 10 Jun 2012 03:43:49 +0200
Message-Id: <1339292638-12205-1-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset is made up of changes I did to the tvaudio driver
back in 2009. IIRC I started these to get automatic mono/stereo
swiching working again in mplayer. These changes have been tested
with a TDA9873H only and most of the time there was stereo. The
last patch is just a few hours old and has received no testing at
all.

  Daniel
      
 [PATCH 1/9] tvaudio: fix TDA9873 constants
 [PATCH 2/9] tvaudio: fix tda8425_setmode
 [PATCH 3/9] tvaudio: use V4L2_TUNER_MODE_SAP for TDA985x SAP
 [PATCH 4/9] tvaudio: remove watch_stereo
 [PATCH 5/9] tvaudio: don't use thread for TA8874Z
 [PATCH 6/9] tvaudio: use V4L2_TUNER_SUB_* for bitfields
 [PATCH 7/9] tvaudio: obey V4L2 tuner audio matrix
 [PATCH 8/9] tvaudio: support V4L2_TUNER_MODE_LANG1_LANG2
 [PATCH 9/9] tvaudio: don't report mono when stereo is received

 drivers/media/video/tvaudio.c |  189 +++++++++++++++++++++++------------------
 1 files changed, 107 insertions(+), 82 deletions(-)

