Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZRtV-0005Se-Sm
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 16:57:42 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6F001TH5J78MM0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 30 Aug 2008 10:57:07 -0400 (EDT)
Date: Sat, 30 Aug 2008 10:57:07 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B93A3B.6090301@chaosmedia.org>
To: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
Message-id: <48B95FC3.7050005@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org> <48B93A3B.6090301@chaosmedia.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

ChaosMedia > WebDev wrote:
> It's not my place to judge if the problem is moving in the right 
> direction or not but it's a good thing that something happens.
> I'll trust the experienced devs whom acked this proposal.

Thank you, it was time to take a position and it's good to see many 
people supporting us now.

> 
> Writting a multiproto patch for kaffeine to get dvb-s2 support, got me 
> to learn a bit about v4l-dvb api and multiproto. Again i'm no 
> experienced coder, i followed some examples to keep v4l-dvb backward 
> compatibility and it wasn't really a walk in the park nor was it really 
> necessary now that i look at it, either your use multiproto or you don't 
> and if you do, patch your app and build it again.
> But well it's working and that's what was most important to me, to get 
> it working "asap".

Agreed.

> 
> So as Christophe Thommeret wrote, who helped a lot dealing with 
> kaffeine, i'll support whichever api is going to bring dvb-s2 and new 
> dvb hardware support to the kernel.

Agreed.

> 
> In the meantime i'll keep using and maintaining my multiproto patch as 
> it's curently done with most other applications, so end users don't have 
> to wait for the whole kernel thing to get completed.

Great, please do.

> 
> And of course if or when the new api has to be tested and modifications 
> to be done on the application side, i'll join the effort.

Great, thanks.

> 
> Marc.
> 
> Acked-by: Marc Delcambre <webdev@chaosmedia.org>


Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
