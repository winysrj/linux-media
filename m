Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JLW2X-0006do-7w
	for linux-dvb@linuxtv.org; Sun, 03 Feb 2008 05:01:09 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 3 Feb 2008 03:14:21 +0100
References: <47A360FE.2070105@brenken.org>
In-Reply-To: <47A360FE.2070105@brenken.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802030314.22178@orion.escape-edv.de>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Subject: Re: [linux-dvb] TT-1401 budget card support broken since 2.6.24-rc6
Reply-To: linux-dvb@linuxtv.org
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dirk Brenken wrote:
> Hi,
> I'm running a "budget-only" (Technotrend S-1401) vdr system (1.5.13) 
> with xinelibouput plugin (latest cvs checkout).  It's based on debian 
> sid and it runs fine with kernel 2.6.23.14 ... up to kernel 2.6.24-rc5. 
> After that version, my budget card system stops working ... here some 
> log file stuff:
>
> ...
> 
> The problem also occurs with kernel 2.6.23.14 plus latest v4l-dvb 
> checkout. Any idea how to track down this error? Any help is appreciated!

Could you please check whether patch
    http://linuxtv.org/hg/v4l-dvb/rev/816f256c2973
broke the driver?

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
