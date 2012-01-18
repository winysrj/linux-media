Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55324 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab2ARWFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 17:05:37 -0500
Received: from dyn3-82-128-184-189.psoas.suomi.net ([82.128.184.189] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1RnddP-00022k-Es
	for linux-media@vger.kernel.org; Thu, 19 Jan 2012 00:05:35 +0200
Message-ID: <4F17422E.1030408@iki.fi>
Date: Thu, 19 Jan 2012 00:05:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: DVBv5 test report
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tested almost all DVB-T/T2/C devices I have and all seems to be 
working, excluding Anysee models when using legacy zap.

Anysee  anysee_streaming_ctrl() will fail because 
mutex_lock_interruptible() returns -EINTR in anysee_ctrl_msg() function 
when zap is killed using ctrl+c. This will led error returned to 
DVB-USB-core and log writing "dvb-usb: error while stopping stream."

http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/anysee.c

http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/dvb-usb-urb.c

If I change mutex_lock_interruptible() => mutex_lock() it will work. I 
think it gets SIGINT (ctrl+c) from userland, but how this haven't been 
issue earlier?

Anyone have idea what's wrong/reason here?


here are tested drivers, working fine:
dvb_usb_ec168,ec100,mxl5005s
dvb_usb_au6610,zl10353,qt101
dvb_usb_af9015,af9013,tda18218
dvb_usb_af9015,af9013,tda18218
dvb_usb_af9015,af9013,qt1010
dvb_usb_af9015,af9013,mxl5005s
dvb_usb_af9015,af9013,mxl5007t
dvb_usb_gl861,zl10353,qt1010
dvb_usb_ce6230,zl10353,mxl5005s
em28xx_dvb,tda10023,tuner_simple
dvb_ttusb_budget,stv0297
dvb_usb_mxl111sf
em28xx_dvb,cxd2820r,tda18271


Antti
-- 
http://palosaari.fi/
