Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtprelay09.ispgateway.de ([80.67.29.23])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kiu@gmx.net>) id 1JqFCH-0008Fz-PC
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 00:18:14 +0200
Received: from [62.216.212.3] (helo=blacksheep.qnet)
	by smtprelay09.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <kiu@gmx.net>) id 1JqFCE-00042w-1t
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 00:18:10 +0200
Message-ID: <20080428001809.3vbl9fotckwwswss@blacksheep.qnet>
Date: Mon, 28 Apr 2008 00:18:09 +0200
From: kiu <kiu@gmx.net>
To: linux-dvb@linuxtv.org
References: <20080427212607.csw7xwh9wcsw04cw@blacksheep.qnet>
In-Reply-To: <20080427212607.csw7xwh9wcsw04cw@blacksheep.qnet>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Regression! Re: TerraTec Cinergy C -
	tuning	fails/freezes
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

I could fix it by using exactly the mantis driver version which is  
mentioned in
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C with my  
2.6.24-16-generic kernel.

w_scan works out of the box using version  
http://jusst.de/hg/mantis/archive/af18967ffcc9.tar.bz2

If you need some help in regression tests, drop me a mail.

Quoting kiu <kiu@gmx.net>:

> Hi List,
>
> i have a TerraTec Cinergy C DVB-C PCI Card in my mythbuntu 8.04 pc.
>
> After compiling the mantis driver (http://jusst.de/hg/mantis) the card
> is recognized by the kernel. perfect!
>
> If i now run
>
> w_scan -fc -x -vvvv
>
> it searches for QAM64 and QAM256 and finds some signals there. After
> it is finished, it tries to tune in the channels and freezes with this
> message (same happens with (dvb)scan):
>
> tune to:
> tuning status == 0x1f
> add_filter:1388: add filter pid 0x0000 start_filter:1334: start filter
> pid 0x0000 table_id 0x00
>
> Any hints for debugging/fixing it my issues ?
>
> Btw, i also encountered a segfault once. If it happens again i will   
> post it...
>
> TIA!
> --
> kiu
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
kiu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
