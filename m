Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KYLhc-0003wa-6n
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 16:08:53 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K69007BLJ9QWU60@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 27 Aug 2008 10:08:17 -0400 (EDT)
Date: Wed, 27 Aug 2008 10:08:14 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200808271141.55546.oliver@neukum.org>
To: Oliver Neukum <oliver@neukum.org>
Message-id: <48B55FCE.3020907@linuxtv.org>
MIME-version: 1.0
References: <200808271141.55546.oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] question on struct dvb_frontend_ops.sleep
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Oliver Neukum wrote:
> Hi,
> 
> could somebody explain to me what the semantics of this call is?
> It seems like dvbcore uses it to tell a device that it may power down.
> But when is it to power up again? Is powering up implied in every
> other method of the API? Can these methods sleep?

Isn't init it's powerup equivalent?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
