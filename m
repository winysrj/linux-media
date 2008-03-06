Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JXN37-0006nG-2T
	for linux-dvb@linuxtv.org; Thu, 06 Mar 2008 21:50:47 +0100
Message-ID: <47D05919.4090601@philpem.me.uk>
Date: Thu, 06 Mar 2008 20:50:33 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Henrik Beckman <henrik.list@gmail.com>, linux-dvb <linux-dvb@linuxtv.org>
References: <47CF08B2.50008@philpem.me.uk> <47CF0EEC.6080706@philpem.me.uk>
	<af2e95fa0803060409s3aa761f1q5f8fbb61b121148d@mail.gmail.com>
In-Reply-To: <af2e95fa0803060409s3aa761f1q5f8fbb61b121148d@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge Nova T-500 / Nova-TD Stick (DiBcom
 tuners/demods) - the plot thickens...
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

Henrik Beckman wrote:
> My TD stick never worked as it should in my Nforce 4, killed my USB 
> controllers.
> Worked ok on my VIA controller.

I've just tested it on an ASUS Eee PC (Intel chipset) and it seems to be fine, 
one tuner active and playing video, the other scanning for channels.

What I did find interesting was that it really doesn't like strong signals. I 
rigged it up on our test bench at work (we have a UK terrestrial feed that's 
trimmed to the same signal power around the building, +/- a few dB). I clocked 
the signal at 70.1dBuV with a Promax DVB analyser, and the Nova-TD refused to 
lock on -- the tuner locked, but no data flowed ("filter timeout pid..." from 
scandvb).

In fact, it only passed data along after I put 21dB worth of attenuators 
(three 3dBs and a pair of 6dBs) in line, bringing the signal strength down to 
48dBuV. The maximum signal strength that allowed any signal was 60.8dBuV...

Naturally, it's behaving itself with my aerial (pointed at Emley Moor) and 
doing a far better job than the Freecom USB stick I bought it to replace.

This is with Fedora 8, kernel 2.6.23.15-137.fc8. I've got a 2.6.23 kernel 
building on the Ubuntu box, and I'm digging through the Fedora patches in the 
2.6.23.15 kernel source RPM (and the kernel config) to see if there are any 
significant differences that might explain the issues with the T500 / TD.

> Not sure that stick is proved 100% stable.

Seems stable here...

Thanks,
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
