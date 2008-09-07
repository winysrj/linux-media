Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcDhi-00008Y-5E
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 08:24:59 +0200
Message-ID: <48C373B2.6030504@gmail.com>
Date: Sun, 07 Sep 2008 10:24:50 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Gregor Fuis <gujs.lists@gmail.com>
References: <48ABB045.5050301@fra.se>
	<20080820082010.GA5582@gmail.com>	<48AD16A1.5040703@fra.se>
	<23be820f0808210144m57e65363m159c231d2084c1c5@mail.gmail.com>
In-Reply-To: <23be820f0808210144m57e65363m159c231d2084c1c5@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto, multiproto_plus & mantis
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

Gregor Fuis wrote:
> Resend again to list
> 
> Hi,
> 
> I also have problem with this repository. I have KNC ONE DVB-S2 card and it
> doesn't even get initialized with this repository. I used
> http://jusst.de/hg/multiproto tree before and it worked fine. Kernel
> automatically detected card and loaded proper modules.
> 
> Does this repository even have support for KNC ONE DVB-S2 card and I just
> have to load the right modules. If I just have to load modules, please help
> me with the names of modules and sequence how to start them.

hg clone http://jusst.de/hg/multiproto

make

and you need to load the following modules in the order, in case it is
not loaded

stb0899
stb6100
lnbp21
budget_av

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
