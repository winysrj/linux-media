Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40957 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbcBHLvl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 06:51:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Russel Winder <russel@winder.org.uk>,
	Rune Petersen <rune@megahurts.dk>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] si2157 detect firmware status run-time
Date: Mon,  8 Feb 2016 13:51:15 +0200
Message-Id: <1454932276-15780-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Something similar needed for si2168. Feel free to add.

regards
Antti

Antti Palosaari (1):
  si2157: detect if firmware is running

 drivers/media/tuners/si2157.c      | 19 +++++++++++++------
 drivers/media/tuners/si2157_priv.h |  1 -
 2 files changed, 13 insertions(+), 7 deletions(-)

-- 
http://palosaari.fi/

