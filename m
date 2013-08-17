Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54476 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3HQXKn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 19:10:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH STAGING 0/3] more Mirics MSi3101 changes
Date: Sun, 18 Aug 2013 02:09:29 +0300
Message-Id: <1376780972-8977-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I will pull-request these soon as well those sent earlier.

br Antti

Antti Palosaari (3):
  msi3101: implement stream format 504
  msi3101: change stream format 384
  msi3101: few improvements for RF tuner

 drivers/staging/media/msi3101/sdr-msi3101.c | 172 ++++++++++++++++++++++------
 1 file changed, 139 insertions(+), 33 deletions(-)

-- 
1.7.11.7

