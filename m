Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50159 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab3FBXnH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 19:43:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/2] Keene delay
Date: Mon,  3 Jun 2013 02:41:44 +0300
Message-Id: <1370216506-2811-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, here you are!

Antti Palosaari (1):
  keene: add delay in order to settle hardware

Hans Verkuil (1):
  Keene

 drivers/media/radio/radio-keene.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
1.7.11.7

