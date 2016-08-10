Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:43843 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbcHJSJE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:09:04 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] v4l-utils build instruction and dvbv5 format
Date: Wed, 10 Aug 2016 11:52:17 +0200
Message-Id: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Mauro,

today I send you a small patch series for the v4l-utils project.

 -- Markus --

Heiser, Markus (2):
  v4l-utils: add comments to the build instructions
  v4l-utils: fixed dvbv5 vdr format

 README                        |  8 +++++++-
 lib/libdvbv5/dvb-vdr-format.c | 45 +++++++++++++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 15 deletions(-)

-- 
2.7.4

