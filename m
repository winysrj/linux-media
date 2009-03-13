Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as-10.de ([212.112.241.2] helo=mail.as-10.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1Li7Jo-0000xL-DV
	for linux-dvb@linuxtv.org; Fri, 13 Mar 2009 14:20:57 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id 5F06E33AA43
	for <linux-dvb@linuxtv.org>; Fri, 13 Mar 2009 14:19:39 +0100 (CET)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jL-7k3RqeLxc for <linux-dvb@linuxtv.org>;
	Fri, 13 Mar 2009 14:19:39 +0100 (CET)
Received: from halim.local (pD9E3ED04.dip.t-dialin.net [217.227.237.4])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id 9022F33AA33
	for <linux-dvb@linuxtv.org>; Fri, 13 Mar 2009 14:19:38 +0100 (CET)
Date: Fri, 13 Mar 2009 14:20:22 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090313132022.GA7007@halim.local>
References: <47097191.6070301@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47097191.6070301@gmx.de>
Subject: [linux-dvb] status: Re: Wishlist: Support for Samsung SMT-7020S
	in	cx88 -Patch available
Reply-To: linux-media@vger.kernel.org
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
Whats the current status of this patch?
is this allready merged to v4l-dvb???
thanks
halim


On Mon, Oct 08, 2007 at 01:53:53AM +0200, Wilken Haase wrote:
> Hello List,
> I own a Samsung SMT-7020S DVB-S Receiver which originally runs an 
> embedded Operating System from a Software Monpolist which runs in fact 
> like crap. The Hardware is a nice little 733Mhz PC with everything 
> needed to run linux on it, which is nice. The Box has an internal dvb-s 
> receiver unit which can be driven by the cx88 drivers. I think there 
> have been some requests for driver support before, but I would like to 
> refresh the question because a working patch is available. I haven't 
> done the work so no credits for me, the original developers are some 
> forum members in a forum dedicated to the box.
> 
> Link to the Patch:
> http://home.arcor.de/egalus2/zendeb/SMT-dvb-s-kernelpatch-2.6.21.7.diff
> 
> If someone can take a look at this and maybe integrate it into the 
> driver this would make a lot of people including me very happy.
> 
> Greetings from Bremen, Nothern Germany
> Wilken Haase
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
