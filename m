Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-37.mail.demon.net ([194.217.242.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JblZY-0007tq-8q
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 00:50:25 +0100
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-37.mail.demon.net with esmtp (Exim 4.68)
	id 1JblZQ-0002gE-OA
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 23:50:16 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JblZL-00011C-DJ
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 23:50:15 +0000
Date: Tue, 18 Mar 2008 23:25:28 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4F87A6A910%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1205877331.11231.38.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com>
	<20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu> <20080314155851.52677f28@gaivota>
	<1205523274.6364.5.camel@ubuntu> <20080314172143.62390b1f@gaivota>
	<1205573636.5941.1.camel@ubuntu> <20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu> <20080318161729.6da782ee@gaivota>
	<1205873332.11231.17.camel@ubuntu> <20080318180415.5dfc4319@gaivota>
	<1205877331.11231.38.camel@ubuntu>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental
	/	Avermedia A16D please?
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

I demand that timf may or may not have written...

[snip]
> [   30.548678] Oops: 0000 [1] SMP 
> [   30.548755] CPU 1 
[snip]
> [   30.550595] Pid: 3942, comm: modprobe Tainted: P

Tainted kernel. It would be better if you can produce the oops without the
taintware^Wproprietary module; the fewer malign influences, the better :-)

[snip]
> [   30.551583]  [<ffffffff8896b803>] :tuner_xc2028:generic_set_freq+0x593/0x1830
> [   30.551637]  [<ffffffff802361fe>] printk+0x4e/0x60
> [   30.551685]  [<ffffffff88989a4e>] :tuner:set_tv_freq+0xae/0x1c0
> [   30.551730]  [<ffffffff88989bd1>] :tuner:set_freq+0x71/0x1a0
> [   30.551771]  [<ffffffff8898afe8>] :tuner:tuner_command+0x198/0x12f0
[snip]
> 3) It looks really promising with tuner-xc3028 but it won't boot. From
> bitter experience with ubuntu and gnome I find it quicker to re-install
> than search around for what module failed.

No need to reinstall. Use your live CD, mount your root partition, append
"blacklist tuner_xc2028" to etc/modprobe.d/blacklist (relative to the mount
point). You'll need to modprobe the module manually after rebooting, this
time from HD; testing should, however, be easier now. I doubt that it'll
remove any need for reboots, though; that's just a hazard of driver
development and debugging.

Incidentally, try this:

$ cd /path/to/v4l-dvb
$ gdb v4l/tuner_xc2028.ko
(gdb) list *(generic_set_freq + 0x593)
(gdb) edit *(generic_set_freq + 0x593)

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Buy less and make it last longer.         INDUSTRY CAUSES GLOBAL WARMING.

Sir Arthur C Clarke, gone to the great monolith in the sky.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
