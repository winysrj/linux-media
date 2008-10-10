Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Ko65a-0003iv-Jd
	for linux-dvb@linuxtv.org; Fri, 10 Oct 2008 02:42:44 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: klaas de waal <klaas.de.waal@gmail.com>
In-Reply-To: <7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
Date: Fri, 10 Oct 2008 02:36:35 +0200
Message-Id: <1223598995.4825.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, jerremy@wordtgek.nl
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

Hi,

Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:
> Hi Jeremy,
> 
> I have the Technotrend C-1501 now locking at 388MHz.
> The table tda827xa_dvbt contains the settings for each frequency
> segment.
> The frequency values (first column) are for  the frequency plus the
> IF, so for 388MHz
> this is 388+5 gives 393 MHz. The table starts a new segment at 390MHz,
> it then
> starts to use VCO2 instead of VCO1.
> I have now (hack, hack) changed the segment start from 390 to 395MHz
> so
> that the 388MHz is still tuned with VCO1, and this works OK!!
> Like this:
> 
> static const struct tda827xa_data tda827xa_dvbt[] = {
>     { .lomax =  56875000, .svco = 3, .spd = 4, .scr = 0, .sbs =
> 0, .gc3 = 1},
>     { .lomax =  67250000, .svco = 0, .spd = 3, .scr = 0, .sbs =
> 0, .gc3 = 1},
>     { .lomax =  81250000, .svco = 1, .spd = 3, .scr = 0, .sbs =
> 0, .gc3 = 1},
>     { .lomax =  97500000, .svco = 2, .spd = 3, .scr = 0, .sbs =
> 0, .gc3 = 1},
>     { .lomax = 113750000, .svco = 3, .spd = 3, .scr = 0, .sbs =
> 1, .gc3 = 1},
>     { .lomax = 134500000, .svco = 0, .spd = 2, .scr = 0, .sbs =
> 1, .gc3 = 1},
>     { .lomax = 154000000, .svco = 1, .spd = 2, .scr = 0, .sbs =
> 1, .gc3 = 1},
>     { .lomax = 162500000, .svco = 1, .spd = 2, .scr = 0, .sbs =
> 1, .gc3 = 1},
>     { .lomax = 183000000, .svco = 2, .spd = 2, .scr = 0, .sbs =
> 1, .gc3 = 1},
>     { .lomax = 195000000, .svco = 2, .spd = 2, .scr = 0, .sbs =
> 2, .gc3 = 1},
>     { .lomax = 227500000, .svco = 3, .spd = 2, .scr = 0, .sbs =
> 2, .gc3 = 1},
>     { .lomax = 269000000, .svco = 0, .spd = 1, .scr = 0, .sbs =
> 2, .gc3 = 1},
>     { .lomax = 290000000, .svco = 1, .spd = 1, .scr = 0, .sbs =
> 2, .gc3 = 1},
>     { .lomax = 325000000, .svco = 1, .spd = 1, .scr = 0, .sbs =
> 3, .gc3 = 1},
> #ifdef ORIGINAL // KdW test
>     { .lomax = 390000000, .svco = 2, .spd = 1, .scr = 0, .sbs =
> 3, .gc3 = 1},
> #else
>     { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs =
> 3, .gc3 = 1},
> #endif
>     { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs =
> 3, .gc3 = 1},
> etc etc
> 
> I plan to do a test on the all frequencies in the near future, at
> least on all the Dutch Ziggo frequencies.
> Because I cannot test what will happen if the driver is used for DVB-T
> (what
> the name of the table suggests) it might be best to make a separate
> tda827xa_dvbc table.
> 
> About the timeout messages, they come from the SAA7134 and they happen
> fairly random. I have looked at debug traces and everytime it happens
> it
> does a retry and then succeeds, so I think this can be ignored for the
> time being.
> Maybe you can check if the fix/hack also works for you?
> If there is an official maintainer of this driver, maybe he can
> comment?
> 
> Groetjes,
> Klaas
> 

just scrolling through mails and did not look it up yet.

But you likely mean tda8274a DVB-C, tda10023 and saa7146.

Are we still here?
http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025634.html

Please don't top post, you get more readers.

Cheers,
Hermann


> 
> On Tue, Sep 30, 2008 at 11:18 AM, <jerremy@wordtgek.nl> wrote:
>         Hi Klaas,
>         
>         Perhaps its an idea to post this on the linux-dvb mailing
>         list, if anything
>         it keeps the subject alive.
>         
>         I've spent an hour or so playing with several of the
>         parameters of the
>         demodulator (the tda10023), mostly because this was suggest in
>         one of the
>         older posts about this issue. However none of my efforts gave
>         any desired
>         result and quickly got tired of unloading / reloading my
>         drivers (which
>         every so often required a hard reset as well).
>         
>         But if you find anything, that would be great ;)
>         
>         Gr. Jerremy
>         
>         
>         On Mon, 29 Sep 2008 11:35:03 +0200, "klaas de waal"
>         <klaas.de.waal@gmail.com> wrote:
>         > Hallo Jeremy,
>         > I have exactly the same problem with my C-1501 card: tuning
>         problems on
>         > 388
>         > MHz but OK on most other frequencies.
>         > It works OK with WIndowsXP on all frequencies including the
>         388MHz, so
>         the
>         > hardware is OK and it must be a software issue.
>         > I have over the weekend put in a lot of printk for debugging
>         but have not
>         > found it yet.
>         > I will keep you updated.
>         >
>         > Groetjes,
>         > Klaas
>         >
>         >
>         > On Thu, Sep 11, 2008 at 5:50 PM, <jerremy@wordtgek.nl>
>         wrote:
>         >
>         >> Hi,
>         >>
>         >> This issue has come up at least once a bit more then a
>         month ago and is
>         >> still present in the current release of the V4L-DVB
>         drivers. The
>         >> Technotrend C-1501 drivers are unable to get a lock on
>         388Mhz (and a
>         > couple
>         >> of other frequencies, like 682Mhz and 322Mhz, but I can
>         only test
>         > 388Mhz).
>         >>
>         >> The dmesg will mention an I2C timeout when this occurs, I'm
>         not sure if
>         > its
>         >> related (as it'll randomly give those timeouts when viewing
>         working
>         >> channels too).
>         >>
>         >> I have two seperate installs of Linux (Ubuntu 8.04 64-Bit
>         with 1
>         > received
>         >> and Ubuntu 8.04 32-Bit with 2 receivers) which both suffer
>         the same
>         >> inability to lock onto that frequency. So its unlikely to
>         be a hardware
>         >> problem, also the Windows drivers do not seem to have any
>         issues.
>         >>
>         >> Is anyone looking into this issue? If not, what would be
>         the place to
>         >> experiment?
>         >>
>         >> Gr,
>         >>
>         >> Jerremy Koot
>         >>
>         >>




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
