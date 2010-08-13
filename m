Return-path: <mchehab@pedra>
Received: from fallback1.mail.ru ([94.100.176.18]:42441 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab0HMOIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 10:08:06 -0400
Received: from mx38.mail.ru (mx38.mail.ru [94.100.176.52])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 2125B46E8BD
	for <linux-media@vger.kernel.org>; Fri, 13 Aug 2010 12:31:43 +0400 (MSD)
Received: from [92.101.158.175] (port=33452 helo=localhost.localdomain)
	by mx38.mail.ru with psmtp
	id 1OjpeA-000BmX-00
	for linux-media@vger.kernel.org; Fri, 13 Aug 2010 12:29:50 +0400
Date: Fri, 13 Aug 2010 12:37:14 +0400
From: Goga777 <goga777@list.ru>
To: <linux-media@vger.kernel.org>
Subject: Re: 2.6.35 and current v4l-dvb - error: implicit declaration of
 function 'usb_buffer_free'
Message-ID: <20100813123714.288571a4@list.ru>
In-Reply-To: <AANLkTi=m7YinFKg8pdYCuVTfQyNAvEM7dkVF8WLkOEAb@mail.gmail.com>
References: <20100812022919.7ce6dace@bk.ru>
	<AANLkTi=m7YinFKg8pdYCuVTfQyNAvEM7dkVF8WLkOEAb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> Both functions were renamed in upstream, backport created and
> commited, please try again.

yes, I don't have more such errors, but still have other one which I reported early

  CC [M]  /usr/src/v4l-dvb/v4l/dvb_net.o
/usr/src/v4l-dvb/v4l/dvb_net.c:1190: warning: 'struct dev_mc_list' declared inside parameter list
/usr/src/v4l-dvb/v4l/dvb_net.c:1190: warning: its scope is only this definition or declaration, which is
  probably not what you want /usr/src/v4l-dvb/v4l/dvb_net.c: In function 'dvb_set_mc_filter':
/usr/src/v4l-dvb/v4l/dvb_net.c:1197: error: dereferencing pointer to incomplete type
/usr/src/v4l-dvb/v4l/dvb_net.c:1197: error: dereferencing pointer to incomplete type
/usr/src/v4l-dvb/v4l/dvb_net.c: In function 'wq_set_multicast_list':
/usr/src/v4l-dvb/v4l/dvb_net.c:1247: error: 'struct net_device' has no member named 'mc_list'
/usr/src/v4l-dvb/v4l/dvb_net.c:1249: error: dereferencing pointer to incomplete type
/usr/src/v4l-dvb/v4l/dvb_net.c:1249: warning: left-hand operand of comma expression has no effect
/usr/src/v4l-dvb/v4l/dvb_net.c:1249: warning: value computed is not used
/usr/src/v4l-dvb/v4l/dvb_net.c:1250: warning: passing argument 2 of 'dvb_set_mc_filter' from incompatible
  pointer type /usr/src/v4l-dvb/v4l/dvb_net.c:1190: note: expected 'struct dev_mc_list *' but argument is
  of type 'struct dev_mc_list *' make[3]: *** [/usr/src/v4l-dvb/v4l/dvb_net.o] Ошибка 1
make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.35'
make[1]: *** [default] Ошибка 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Ошибка 2
