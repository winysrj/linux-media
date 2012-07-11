Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38573 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358Ab2GKTZn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 15:25:43 -0400
Received: from dyn3-82-128-190-162.psoas.suomi.net ([82.128.190.162] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Sp2Xd-0002jB-Mj
	for linux-media@vger.kernel.org; Wed, 11 Jul 2012 22:25:41 +0300
Message-ID: <4FFDD32E.2070705@iki.fi>
Date: Wed, 11 Jul 2012 22:25:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Q: FE set_property() and get_property callbacks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was playing with the DVB API LNA support and ended up looking common 
dvb-frontend code.

There is struct dvb_frontend_ops:
int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);

What I can see from the dvb-core comments those are used for validating 
parameters. Why? Naming is very misleading. For me those names sounds 
like setting and getting parameters is something what average coder can 
think.

For example if I wish to set LNA I would like to implement 
set_property() to my driver and expect to catch DTV_LNA	command and 
handle it.

But what now is done is to add new callback "set_lna()" to struct 
dvb_frontend_ops, add new parameter "lna" to struct 
dtv_frontend_properties, cache value here and use new callback to set 
value. Due to that selected implementation it goes complex and "struct 
dvb_frontend_ops" and "struct dtv_frontend_properties" grows all the 
time when new parameter is added.

It looks even more weird as you grep current use of set_property() and 
get_property(). There is only two drivers, stv0288 and stv6110, defining 
those callbacks. And both of those seems to have quite nonsense 
implementation. So whats happening here?

regards
Antti

-- 
http://palosaari.fi/

