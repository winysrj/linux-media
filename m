Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KieeQ-0007c8-Pu
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 02:24:12 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7Q000256FBUS20@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 24 Sep 2008 20:23:35 -0400 (EDT)
Date: Wed, 24 Sep 2008 20:23:34 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
To: Tim Lucas <lucastim@gmail.com>
Message-id: <48DADA06.9000105@linuxtv.org>
MIME-version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
	<e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
	<48DA9330.6070005@linuxtv.org>
	<e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
 FusionHDTV7 Dual Express (Read this one)
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

Tim Lucas wrote:
> OK, so I'm a little dumb.  How do you want me to test those.  Should I 
> hook up some device to the S-Video input like my DVD player?  
> 
>      --Tim
> 
> On Wed, Sep 24, 2008 at 12:21 PM, Steven Toth <stoth@linuxtv.org 
> <mailto:stoth@linuxtv.org>> wrote:
> 
>     Tim Lucas wrote:
> 
>         I forgot to mention that I commented out the digital tuner at
>         .portc first.  Then I tried to tune channels, but could not.
>          Then I changed the tuner to 0xc8 >> 1, leaving .portc commented
>         out.  I still could not tune channels.
> 
>             --Tim
> 
> 
> 
>     I really need you to test composite or svideo, did you do this?
> 
>     - Steve
> 
> 
> 
> 
> -- 
> --Tim

Yes, hook up a dvd player to the svideo adapter cable, then use tvtime 
to switch the inputs to svideo.

I suspect (hope?) this should instantly work for you. If not, something 
is really wrong inside the cx25840 driver.

Let me know.... also, be sure to try the composite input also.

Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
