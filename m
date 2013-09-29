Return-path: <linux-media-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:49226 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3I2LOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Sep 2013 07:14:21 -0400
Message-ID: <524804B3.9090505@seznam.cz>
Date: Sun, 29 Sep 2013 12:45:07 +0200
From: =?ISO-8859-2?Q?Ji=F8=ED_Pinkava?= <j-pi@seznam.cz>
MIME-Version: 1.0
To: gennarone@gmail.com, m.chehab@samsung.com
CC: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: [PATCH 0/2] fix tunning for r820t tunner
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes range check for VCO parameters, simplifies calculation of divisor.

 drivers/media/tuners/r820t.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

