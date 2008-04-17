Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout04.t-online.de ([194.25.134.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JmbhK-0005qb-Go
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 23:31:15 +0200
Message-ID: <4807C1A6.8000909@t-online.de>
Date: Thu, 17 Apr 2008 23:31:18 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Stephen Dawkins <elfarto@elfarto.com>
References: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>	<200804130349.15215@orion.escape-edv.de>	<4801DED3.4020804@elfarto.com>	<4803C2FA.1010408@hot.ee>
	<48065CB6.50709@elfarto.com>	<1208422406.12385.295.camel@rommel.snap.tv>	<34260.217.8.27.117.1208427888.squirrel@webmail.elfarto.com>	<4807AFE2.40400@t-online.de>
	<4807B386.1050109@elfarto.com>
In-Reply-To: <4807B386.1050109@elfarto.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT-Budget C-1501
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

Stephen Dawkins schrieb:
> Hartmut Hackmann wrote:
> <snip>
>  > I did not follow the thread yet. Which channel demodulator are you 
> talking
>  > about?
>  >
> 
> The demod is a TDA10023HT.
> 
>  > BTW: You need to be careful to not mix up the a- and non-a versions of
>  > the tuner. They are *not* software compatible.
>  >
> 
> How do I know which one I have?
> 
>  > Best regards
>  >   Hartmut
>  >
> 
> Regards
> Stephen
> 
The driver is able to determine this automatically if it is used the way
we intended.
After attach, the first call either needs to be init or sleep. At the first
call, they probe for the chip version.

Do you have a datasheet of the tda10023? From the first glance, i have the
impression that it was only used with a conventional tuner yet. With the
silicon tuner, the chip needs to be programmed to use a different IF. We
beed to find out how this is done.

Best regards
   Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
