Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2.elion.ee ([88.196.160.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artlov@gmail.com>) id 1KoEMb-00063U-SH
	for linux-dvb@linuxtv.org; Fri, 10 Oct 2008 11:32:52 +0200
Message-ID: <48EF2120.5070101@gmail.com>
Date: Fri, 10 Oct 2008 12:32:16 +0300
From: Arthur Konovalov <artlov@gmail.com>
MIME-Version: 1.0
To: <linux-dvb@linuxtv.org>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
In-Reply-To: <7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
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

klaas de waal wrote:
> I have the Technotrend C-1501 now locking at 388MHz.
> The table tda827xa_dvbt contains the settings for each frequency segment.
> The frequency values (first column) are for  the frequency plus the IF, 
> so for 388MHz
> this is 388+5 gives 393 MHz. The table starts a new segment at 390MHz, 
> it then
> starts to use VCO2 instead of VCO1.
> I have now (hack, hack) changed the segment start from 390 to 395MHz so
> that the 388MHz is still tuned with VCO1, and this works OK!!
> Like this:
> 
> static const struct tda827xa_data tda827xa_dvbt[] = {
>     { .lomax =  56875000, .svco = 3, .spd = 4, .scr = 0, .sbs = 0, .gc3 
> = 1},
>     { .lomax =  67250000, .svco = 0, .spd = 3, .scr = 0, .sbs = 0, .gc3 
> = 1},
>     { .lomax =  81250000, .svco = 1, .spd = 3, .scr = 0, .sbs = 0, .gc3 
> = 1},
>     { .lomax =  97500000, .svco = 2, .spd = 3, .scr = 0, .sbs = 0, .gc3 
> = 1},
>     { .lomax = 113750000, .svco = 3, .spd = 3, .scr = 0, .sbs = 1, .gc3 
> = 1},
>     { .lomax = 134500000, .svco = 0, .spd = 2, .scr = 0, .sbs = 1, .gc3 
> = 1},
>     { .lomax = 154000000, .svco = 1, .spd = 2, .scr = 0, .sbs = 1, .gc3 
> = 1},
>     { .lomax = 162500000, .svco = 1, .spd = 2, .scr = 0, .sbs = 1, .gc3 
> = 1},
>     { .lomax = 183000000, .svco = 2, .spd = 2, .scr = 0, .sbs = 1, .gc3 
> = 1},
>     { .lomax = 195000000, .svco = 2, .spd = 2, .scr = 0, .sbs = 2, .gc3 
> = 1},
>     { .lomax = 227500000, .svco = 3, .spd = 2, .scr = 0, .sbs = 2, .gc3 
> = 1},
>     { .lomax = 269000000, .svco = 0, .spd = 1, .scr = 0, .sbs = 2, .gc3 
> = 1},
>     { .lomax = 290000000, .svco = 1, .spd = 1, .scr = 0, .sbs = 2, .gc3 
> = 1},
>     { .lomax = 325000000, .svco = 1, .spd = 1, .scr = 0, .sbs = 3, .gc3 
> = 1},
> #ifdef ORIGINAL // KdW test
>     { .lomax = 390000000, .svco = 2, .spd = 1, .scr = 0, .sbs = 3, .gc3 
> = 1},
> #else
>     { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs = 3, .gc3 
> = 1},
> #endif
>     { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs = 3, .gc3 
> = 1},
> etc etc

Is it patched only in this place or somewhere else?

I tried it to solve 386MHz tuning problem, but it doesn't help.
Got LOCK, but no picture.

Arthur


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
