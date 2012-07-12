Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35356 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734Ab2GLUYg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 16:24:36 -0400
Received: from dyn3-82-128-190-162.psoas.suomi.net ([82.128.190.162] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SpPwA-0007EP-6J
	for linux-media@vger.kernel.org; Thu, 12 Jul 2012 23:24:34 +0300
Message-ID: <4FFF327A.9080300@iki.fi>
Date: Thu, 12 Jul 2012 23:24:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: GPIO interface between DVB sub-drivers (bridge, demod, tuner)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am looking kinda standardized interface for setting GPIOs between the 
DVB drivers chip drivers. For most typical example there is LNA which is 
controlled by RF-tuner GPIO. That kind of LNA controlling logic belongs 
to interface driver thus I will need to call demod driver from bridge in 
order to set LNA.

Simply solution is to add own own callbacks, set_gpio() and get_gpio() 
for both tuner and demod ops but I will not like to that of there is 
existing solutions. Grepping Documentation reveals quite much documents, 
most interesting seems to be:
Documentation/gpio.txt
Documentation/devicetree/bindings/gpio/gpio.txt
Documentation/pinctrl.txt

Is there anyone who could say straight now what is best approach and 
where to look example?


regards
Antti

-- 
http://palosaari.fi/

