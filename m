Return-path: <mchehab@pedra>
Received: from smtp8.mail.ru ([94.100.176.53]:52226 "EHLO smtp8.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab0HLIZ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 04:25:26 -0400
Received: from [95.53.178.138] (port=30418 helo=localhost.localdomain)
	by smtp8.mail.ru with asmtp
	id 1OjT6K-0006AO-00
	for linux-media@vger.kernel.org; Thu, 12 Aug 2010 12:25:24 +0400
Date: Thu, 12 Aug 2010 12:32:32 +0400
From: Goga777 <goga777@bk.ru>
To: linux-media@vger.kernel.org
Subject: dvb_net.c:1237: error: =?UTF-8?B?4oCYc3RydWN0IG5ldF9kZXZpY2XigJk=?=
 has no member
Message-ID: <20100812123232.6339408c@bk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

hi

with 2.6.35 kernel and current v4l-dvb I have other errors as described here is
http://www.kernellabs.com/blog/?p=1397


CC [M] /home/fabio/src/v4l-dvb-drxd/v4l/dvb_filter.o
CC [M] /home/fabio/src/v4l-dvb-drxd/v4l/dvb_ca_en50221.o
CC [M] /home/fabio/src/v4l-dvb-drxd/v4l/dvb_frontend.o
CC [M] /home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.o
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1179: warning: ‘struct dev_mc_list’ declared inside parameter list
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1179: warning: its scope is only this definition or declaration, which is probably not what you want
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c: In function ‘dvb_set_mc_filter’:
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1186: error: dereferencing pointer to incomplete type
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c: In function ‘wq_set_multicast_list’:
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1226: error: ‘struct net_device’ has no member named ‘mc_count’
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1230: error: ‘struct net_device’ has no member named ‘mc_count’
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1236: error: ‘struct net_device’ has no member named ‘mc_list’
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1237: error: ‘struct net_device’ has no member named ‘mc_count’
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1238: error: dereferencing pointer to incomplete type
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1238: warning: left-hand operand of comma expression has no effect
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1238: warning: value computed is not used
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1239: warning: passing argument 2 of ‘dvb_set_mc_filter’ from incompatible pointer type
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1179: note: expected ‘struct dev_mc_list *’ but argument is of type ‘struct dev_mc_list *’
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c: In function ‘dvb_net_setup’:
/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.c:1363: error: ‘struct net_device’ has no member named ‘mc_count’
make[3]: *** [/home/fabio/src/v4l-dvb-drxd/v4l/dvb_net.o] Error 1
make[2]: *** [_module_/home/fabio/src/v4l-dvb-drxd/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.35-kal.i686′
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/fabio/src/v4l-dvb-drxd/v4l’
make: *** [all] Error 2

hope that it will fix soon

Goga


