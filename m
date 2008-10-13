Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KpPpQ-0005ju-Np
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 17:59:29 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8O00DYQPP2BHK0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 13 Oct 2008 11:58:54 -0400 (EDT)
Date: Mon, 13 Oct 2008 11:58:14 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200810131145.01604.jareguero@telefonica.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Message-id: <48F37016.6070905@linuxtv.org>
MIME-version: 1.0
References: <200810131145.01604.jareguero@telefonica.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Fix initialization in mxl5005s
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

Jose Alberto Reguero wrote:
> I think that the initialization in the mxl5005s driver is wrong.

Great, thanks. :)

I'm curious, why do you think it's wrong? It _could_ actually be wrong, 
but I'd like to understand your rationale and testing. In principle this 
patch shouldn't matter, the tuner should get reconfigured if the caller 
requests anything other than QAM.

Which board are you testing, and what configuration is the tuner 
expected to be running in?

Regards,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
