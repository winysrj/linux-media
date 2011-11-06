Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56606 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab1KFO0W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Nov 2011 09:26:22 -0500
Received: from [82.128.187.11] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1RN3fw-0003mO-Ta
	for linux-media@vger.kernel.org; Sun, 06 Nov 2011 16:26:20 +0200
Message-ID: <4EB6990C.8000904@iki.fi>
Date: Sun, 06 Nov 2011 16:26:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: FX2 FW: conversion from Intel HEX to DVB USB "hexline"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any simple tool (or one liner script :) to convert normal Intel 
HEX firmware to format used by DVB USB Cypress firmware loader?

Or is there some other way those are created?

Loader is here:
dvb-usb-firmware.c
int usb_cypress_load_firmware()


Antti
-- 
http://palosaari.fi/
