Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <storkus@storkus.com>) id 1L8OCX-0006hO-IA
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 01:05:46 +0100
Message-Id: <1228435541.13351.1288344033@webmail.messagingengine.com>
From: storkus@storkus.com
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Content-Disposition: inline
MIME-Version: 1.0
References: <1228413511.30817.1288290035@webmail.messagingengine.com>
	<412bdbff0812041104k6ec78699h18561cdae5214bf@mail.gmail.com>
In-Reply-To: <412bdbff0812041104k6ec78699h18561cdae5214bf@mail.gmail.com>
Date: Thu, 04 Dec 2008 17:05:41 -0700
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Strange problem with loading firmware on HVR-950Q
 (XC5000)
Reply-To: storkus@storkus.com
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


On Thu, 4 Dec 2008 14:04:59 -0500, "Devin Heitmueller"
<devin.heitmueller@gmail.com> said:
> 
> Are you running the latest version of the code from mercurial?  If
> not, please update to the latest version and report back the results.
> 
> http://www.linuxtv.org/repo/
> 
> Devin

Tried it and nothing.  Then I thought of something else and plugged
"xc5000-1.1", part of the firmware filename, into Google, and got this:

http://www.linuxtv.org/pipermail/linux-dvb/2008-September/028921.html

Apparently this bug was seen back in September and supposedly squashed;
not anymore.  But the same fix worked: removing "i2c-dev" from the
kernel and it's working fine, at least for ATSC stations.

I may have to return the dongle for a different one, though, since no
one seems interested in including NTSC support for this device (and my
programming skills suck right now), which is what I'm stuck with in our
in-building sat/cable system. :(  My understanding is the HVR-1950
supports all 3 formats, or I can downgrade to a HVR 8/950 (no suffix).

Anyway, hopefully this helps in squashing this bug once and for all!

Thanks again, Mike

> 
> 
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
