Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <b.behringer@gmx.net>) id 1JXNAj-0007Wa-4i
	for linux-dvb@linuxtv.org; Thu, 06 Mar 2008 21:58:39 +0100
Message-ID: <47D05B7B.8090307@gmx.net>
Date: Thu, 06 Mar 2008 22:00:43 +0100
From: Benjamin Behringer <b.behringer@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47D03CDB.50405@gmx.net>
In-Reply-To: <47D03CDB.50405@gmx.net>
Subject: Re: [linux-dvb] Some questions concering to TT Connect S-2400
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

Hi,

I played a bit with sourcecode and kernel. the technisat skystar usb 
plus now works fine!
if there's anybody who needs help... just contact me.

This is what dmesg now shows :D

dvb-usb: found a 'TechnoTrend AG' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (TechnoTrend AG)
DVB: registering frontend 0 (Philips TDA10086 DVB-S)...
dvb-usb: TechnoTrend AG successfully initialized and connected.

Best regards
benjamin

Benjamin Behringer wrote:
> Hi,
>
> I'm very new to linux-dvb. I just bought blinded by salesman a TechniSat 
> SkyStar USB plus and would like to know how I can get this DVB-S 
> receiver working.
>
> I already figured out that it's a TechnoTrend S-2400 originally and I 
> also found a patch posted by Andre Weidemann.
>
> Here's the patch:
> http://www.spinics.net/lists/linux-dvb/msg23611.html
>
> I've downloaded from http://ilpss8.dyndns.org/DVB-driver/v4l-dvb/ the 
> latest version of v4l-dvb and patched it.
>
> But there are still some Question:
> - Where to place the firmware mentioned in his thread?
> - Which module(s) must be loaded after installing?
> - And finally how to get the device working?
>
> Please note that I'm completely new to this and I didn't used DVB-S before.
> Could please also send me some tutorials which I should read after 
> installing the hardware successfully?
>
> Many thanks in advance!!!
>
> Benjamin
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
