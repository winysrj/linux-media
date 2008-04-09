Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+5770310511132a02686d+1690+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JjiAc-0006i9-IX
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 23:49:30 +0200
Date: Wed, 9 Apr 2008 18:47:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Message-ID: <20080409184737.2d05f16d@areia>
In-Reply-To: <47FD2748.7080203@t-online.de>
References: <1206652564.6924.22.camel@ubuntu> <47EC1668.5000608@t-online.de>
	<47FA70C3.5040808@web.de> <47FA8D34.6010900@libero.it>
	<47FBD252.3090701@t-online.de> <47FD1C72.8050208@libero.it>
	<47FD2748.7080203@t-online.de>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: fixed pointer in tuner callback
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


> Does anybody else have an idea what the reason might be?
> The handling of kernel symbol versions is tricky, i have no idea
> what sioux might have done wrong.
> But the patch in question does not even touch the sound code...

There are some distros that have .gz modules. Those aren't overridden by make install.

The better procedure to generate a clean driver is to do:
	make distclean
	make rminstall
	make rmmod
	make
	make install

If make rminstall still doesn't remove the old modules, you can always do:
	rm -rf /lib/modules/`uname -r`/kernel/drivers/media

And then, reinstall again, with make install.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
