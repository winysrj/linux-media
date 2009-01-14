Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bld-mail11.adl2.internode.on.net ([203.16.214.75]
	helo=mail.internode.on.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robin.perkins@internode.on.net>) id 1LMvcv-0003zE-UN
	for linux-dvb@linuxtv.org; Wed, 14 Jan 2009 03:37:07 +0100
Message-Id: <4FBB1DE4-17DA-4F3B-9FF6-9B076D4D7803@internode.on.net>
From: Robin Perkins <robin.perkins@internode.on.net>
To: td9678td@aim.com
In-Reply-To: <8CB43CAAC52A98D-680-A5D@MBLK-M28.sysops.aol.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Date: Wed, 14 Jan 2009 12:36:01 +1000
References: <8CB43CAAC52A98D-680-A5D@MBLK-M28.sysops.aol.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro T750
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


On 14/01/2009, at 5:17 AM, td9678td@aim.com wrote:

> Hello,
>
> i writing a small application, that shuts down the pc, if there isn't
> any scheduled recording. For this i would like to use the wakeup
> feature of this card, because the acpi (nvram) wakeup doesn't seem to
> work on my pc. There was alredy an attempt to support this card:
> http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017001.html
> Can someone help me, howto program the counter on this card (under
> Linux or Windows)?
>
> Regards
> Daniel

Hello Daniel,

I'm currently trying to write a driver for the Compro Videomate T220  
which I understand is in the same series as your T750 (and also  
includes the T100). I created a wiki page for my card at http://www.linuxtv.org/wiki/index.php/Compro_VideoMate_DVB-T220 
  and was just wondering if you could please do the same for your card  
just so that I can get some idea about the similarities/differences  
between our cards. At this stage my priority is just getting the card  
to tune, however my card has the power feature as well and it would be  
nice to include it at some later stage.

Thanks,

Rob


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
