Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KOk0S-0001BU-OE
	for linux-dvb@linuxtv.org; Fri, 01 Aug 2008 04:04:39 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K4W00FXFGEQTYM0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 31 Jul 2008 22:04:02 -0400 (EDT)
Date: Thu, 31 Jul 2008 22:04:01 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080801012138.GA7094@kryten>
To: Anton Blanchard <anton@samba.org>
Message-id: <48926F11.7090508@linuxtv.org>
MIME-version: 1.0
References: <20080630235654.CCD891CE833@ws1-6.us4.outblaze.com>
	<20080731042433.GA21788@kryten> <4891D557.10901@linuxtv.org>
	<20080801012138.GA7094@kryten>
Cc: linux-dvb@linuxtv.org, "stev391@email.com" <stev391@email.com>,
	linuxdvb@itee.uq.edu.au
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
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

Anton Blanchard wrote:
> Hi,
> 
>> Please try to confirm to the callback cx23885_tuner_callback, we don't  
>> want/need a dvico specific callback.:
>>
>> http://linuxtv.org/hg/~stoth/v4l-dvb/rev/2d925110d38a
> 
> Good idea, a series will follow that does this. I think the tuner
> callbacks could do with some cleaning up (as you will see in the patch
> series), but I think what I have now is a step in the right direction.

Either I'm missing patch 1/4, or the patches don't build.

I have 2,3,4 so I guess I'm missing something.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
