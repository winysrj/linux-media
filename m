Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KY5Y9-0005R7-RK
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 22:54:02 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K68000QT7D21UR0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 26 Aug 2008 16:53:27 -0400 (EDT)
Date: Tue, 26 Aug 2008 16:53:26 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B4687D.8070205@gmail.com>
To: Mijhail Moreyra <mijhail.moreyra@gmail.com>
Message-id: <48B46D46.2020800@linuxtv.org>
MIME-version: 1.0
References: <48B4687D.8070205@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
 HVR-1500
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

Mijhail Moreyra wrote:
> Hi,
> 
> This patch adds analog TV support for the HVR-1500 which has a cx23885 
> bridge and a xc3028 tuner but no MPEG encoder. It also adds support for 
> ALSA audio capture.
> 
> There isn't digital TV in my country so I didn't test if it breaks 
> digital mode.
> 
> Hope it will be useful for anyone interested.
> 
> Regards.
> Mijhail Moreyra
> 

Indeed, very nice, thank you!

I'll generate a ~stoth/cx23885-audio tree and encourage a few people to 
test.

Regards,

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
