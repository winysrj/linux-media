Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49007 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2CVLAo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 07:00:44 -0400
Received: from dyn3-82-128-185-8.psoas.suomi.net ([82.128.185.8] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SAfl4-0001DR-Kr
	for linux-media@vger.kernel.org; Thu, 22 Mar 2012 13:00:42 +0200
Message-ID: <4F6B065A.2060407@iki.fi>
Date: Thu, 22 Mar 2012 13:00:42 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: current em28xx driver crashes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I am running Kernel 3.3-rc7 + around week old linux-media.

During the implementation of MaxMedia UB425-TC and PCTV QuatroStick nano 
(520e) device support I ran very many crashes likely when unloading 
modules. Here is Kernel Panic [1].

Today it crashes just during PCTV 520e stress test. It have been 
scanning DVB-C channels in loop ~3 days now and it crashed without 
reason. Here is Kernel Panic [2].

Could someone look those and guess what is reason em28xx is so unstable 
currently?


[1] http://palosaari.fi/linux/v4l-dvb/em28xx_crashes/IMG_20120318_225505.jpg
[2] http://palosaari.fi/linux/v4l-dvb/em28xx_crashes/

regards
Antti
-- 
http://palosaari.fi/
