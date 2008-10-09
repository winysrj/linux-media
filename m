Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <klaas.de.waal@gmail.com>) id 1Ko1v5-0007VH-P2
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 22:15:36 +0200
Received: by qw-out-2122.google.com with SMTP id 9so66273qwb.17
	for <linux-dvb@linuxtv.org>; Thu, 09 Oct 2008 13:15:30 -0700 (PDT)
Message-ID: <7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
Date: Thu, 9 Oct 2008 22:15:30 +0200
From: "klaas de waal" <klaas.de.waal@gmail.com>
To: jerremy@wordtgek.nl, linux-dvb@linuxtv.org
In-Reply-To: <c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
MIME-Version: 1.0
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0690807204=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0690807204==
Content-Type: multipart/alternative;
	boundary="----=_Part_58434_26863350.1223583330428"

------=_Part_58434_26863350.1223583330428
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Jeremy,

I have the Technotrend C-1501 now locking at 388MHz.
The table tda827xa_dvbt contains the settings for each frequency segment.
The frequency values (first column) are for  the frequency plus the IF, so
for 388MHz
this is 388+5 gives 393 MHz. The table starts a new segment at 390MHz, it
then
starts to use VCO2 instead of VCO1.
I have now (hack, hack) changed the segment start from 390 to 395MHz so
that the 388MHz is still tuned with VCO1, and this works OK!!
Like this:

static const struct tda827xa_data tda827xa_dvbt[] = {
    { .lomax =  56875000, .svco = 3, .spd = 4, .scr = 0, .sbs = 0, .gc3 =
1},
    { .lomax =  67250000, .svco = 0, .spd = 3, .scr = 0, .sbs = 0, .gc3 =
1},
    { .lomax =  81250000, .svco = 1, .spd = 3, .scr = 0, .sbs = 0, .gc3 =
1},
    { .lomax =  97500000, .svco = 2, .spd = 3, .scr = 0, .sbs = 0, .gc3 =
1},
    { .lomax = 113750000, .svco = 3, .spd = 3, .scr = 0, .sbs = 1, .gc3 =
1},
    { .lomax = 134500000, .svco = 0, .spd = 2, .scr = 0, .sbs = 1, .gc3 =
1},
    { .lomax = 154000000, .svco = 1, .spd = 2, .scr = 0, .sbs = 1, .gc3 =
1},
    { .lomax = 162500000, .svco = 1, .spd = 2, .scr = 0, .sbs = 1, .gc3 =
1},
    { .lomax = 183000000, .svco = 2, .spd = 2, .scr = 0, .sbs = 1, .gc3 =
1},
    { .lomax = 195000000, .svco = 2, .spd = 2, .scr = 0, .sbs = 2, .gc3 =
1},
    { .lomax = 227500000, .svco = 3, .spd = 2, .scr = 0, .sbs = 2, .gc3 =
1},
    { .lomax = 269000000, .svco = 0, .spd = 1, .scr = 0, .sbs = 2, .gc3 =
1},
    { .lomax = 290000000, .svco = 1, .spd = 1, .scr = 0, .sbs = 2, .gc3 =
1},
    { .lomax = 325000000, .svco = 1, .spd = 1, .scr = 0, .sbs = 3, .gc3 =
1},
#ifdef ORIGINAL // KdW test
    { .lomax = 390000000, .svco = 2, .spd = 1, .scr = 0, .sbs = 3, .gc3 =
1},
#else
    { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs = 3, .gc3 =
1},
#endif
    { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs = 3, .gc3 =
1},
etc etc

I plan to do a test on the all frequencies in the near future, at
least on all the Dutch Ziggo frequencies.
Because I cannot test what will happen if the driver is used for DVB-T (what
the name of the table suggests) it might be best to make a separate
tda827xa_dvbc table.

About the timeout messages, they come from the SAA7134 and they happen
fairly random. I have looked at debug traces and everytime it happens it
does a retry and then succeeds, so I think this can be ignored for the time
being.
Maybe you can check if the fix/hack also works for you?
If there is an official maintainer of this driver, maybe he can comment?

Groetjes,
Klaas



On Tue, Sep 30, 2008 at 11:18 AM, <jerremy@wordtgek.nl> wrote:

> Hi Klaas,
>
> Perhaps its an idea to post this on the linux-dvb mailing list, if anything
> it keeps the subject alive.
>
> I've spent an hour or so playing with several of the parameters of the
> demodulator (the tda10023), mostly because this was suggest in one of the
> older posts about this issue. However none of my efforts gave any desired
> result and quickly got tired of unloading / reloading my drivers (which
> every so often required a hard reset as well).
>
> But if you find anything, that would be great ;)
>
> Gr. Jerremy
>
> On Mon, 29 Sep 2008 11:35:03 +0200, "klaas de waal"
> <klaas.de.waal@gmail.com> wrote:
> > Hallo Jeremy,
> > I have exactly the same problem with my C-1501 card: tuning problems on
> > 388
> > MHz but OK on most other frequencies.
> > It works OK with WIndowsXP on all frequencies including the 388MHz, so
> the
> > hardware is OK and it must be a software issue.
> > I have over the weekend put in a lot of printk for debugging but have not
> > found it yet.
> > I will keep you updated.
> >
> > Groetjes,
> > Klaas
> >
> >
> > On Thu, Sep 11, 2008 at 5:50 PM, <jerremy@wordtgek.nl> wrote:
> >
> >> Hi,
> >>
> >> This issue has come up at least once a bit more then a month ago and is
> >> still present in the current release of the V4L-DVB drivers. The
> >> Technotrend C-1501 drivers are unable to get a lock on 388Mhz (and a
> > couple
> >> of other frequencies, like 682Mhz and 322Mhz, but I can only test
> > 388Mhz).
> >>
> >> The dmesg will mention an I2C timeout when this occurs, I'm not sure if
> > its
> >> related (as it'll randomly give those timeouts when viewing working
> >> channels too).
> >>
> >> I have two seperate installs of Linux (Ubuntu 8.04 64-Bit with 1
> > received
> >> and Ubuntu 8.04 32-Bit with 2 receivers) which both suffer the same
> >> inability to lock onto that frequency. So its unlikely to be a hardware
> >> problem, also the Windows drivers do not seem to have any issues.
> >>
> >> Is anyone looking into this issue? If not, what would be the place to
> >> experiment?
> >>
> >> Gr,
> >>
> >> Jerremy Koot
> >>
> >>
> >>
> >> _______________________________________________
> >> linux-dvb mailing list
> >> linux-dvb@linuxtv.org
> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>
>
>
>

------=_Part_58434_26863350.1223583330428
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi Jeremy,<br><br>I have the Technotrend C-1501 now locking at 388MHz.<br>The table tda827xa_dvbt contains the settings for each frequency segment.<br>The frequency values (first column) are for&nbsp; the frequency plus the IF, so for 388MHz<br>
this is 388+5 gives 393 MHz. The table starts a new segment at 390MHz, it then<br>starts to use VCO2 instead of VCO1.<br>I have now (hack, hack) changed the segment start from 390 to 395MHz so<br>that the 388MHz is still tuned with VCO1, and this works OK!!<br>
Like this:<br><br>static const struct tda827xa_data tda827xa_dvbt[] = {<br>&nbsp;&nbsp;&nbsp; { .lomax =&nbsp; 56875000, .svco = 3, .spd = 4, .scr = 0, .sbs = 0, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax =&nbsp; 67250000, .svco = 0, .spd = 3, .scr = 0, .sbs = 0, .gc3 = 1},<br>
&nbsp;&nbsp;&nbsp; { .lomax =&nbsp; 81250000, .svco = 1, .spd = 3, .scr = 0, .sbs = 0, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax =&nbsp; 97500000, .svco = 2, .spd = 3, .scr = 0, .sbs = 0, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax = 113750000, .svco = 3, .spd = 3, .scr = 0, .sbs = 1, .gc3 = 1},<br>
&nbsp;&nbsp;&nbsp; { .lomax = 134500000, .svco = 0, .spd = 2, .scr = 0, .sbs = 1, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax = 154000000, .svco = 1, .spd = 2, .scr = 0, .sbs = 1, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax = 162500000, .svco = 1, .spd = 2, .scr = 0, .sbs = 1, .gc3 = 1},<br>
&nbsp;&nbsp;&nbsp; { .lomax = 183000000, .svco = 2, .spd = 2, .scr = 0, .sbs = 1, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax = 195000000, .svco = 2, .spd = 2, .scr = 0, .sbs = 2, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax = 227500000, .svco = 3, .spd = 2, .scr = 0, .sbs = 2, .gc3 = 1},<br>
&nbsp;&nbsp;&nbsp; { .lomax = 269000000, .svco = 0, .spd = 1, .scr = 0, .sbs = 2, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax = 290000000, .svco = 1, .spd = 1, .scr = 0, .sbs = 2, .gc3 = 1},<br>&nbsp;&nbsp;&nbsp; { .lomax = 325000000, .svco = 1, .spd = 1, .scr = 0, .sbs = 3, .gc3 = 1},<br>
#ifdef ORIGINAL // KdW test<br>&nbsp;&nbsp;&nbsp; { .lomax = 390000000, .svco = 2, .spd = 1, .scr = 0, .sbs = 3, .gc3 = 1},<br>#else<br>&nbsp;&nbsp;&nbsp; { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs = 3, .gc3 = 1},<br>#endif<br>&nbsp;&nbsp;&nbsp; { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs = 3, .gc3 = 1},<br>
etc etc<br><br>I plan to do a test on the all frequencies in the near future, at<br>least on all the Dutch Ziggo frequencies.<br>Because I cannot test what will happen if the driver is used for DVB-T (what<br>the name of the table suggests) it might be best to make a separate tda827xa_dvbc table.<br>
<br>About the timeout messages, they come from the SAA7134 and they happen<br>fairly random. I have looked at debug traces and everytime it happens it<br>does a retry and then succeeds, so I think this can be ignored for the time being.<br>
Maybe you can check if the fix/hack also works for you?<br>If there is an official maintainer of this driver, maybe he can comment?<br><br>Groetjes,<br>Klaas<br><br><br><br><div class="gmail_quote">On Tue, Sep 30, 2008 at 11:18 AM,  <span dir="ltr">&lt;<a href="mailto:jerremy@wordtgek.nl">jerremy@wordtgek.nl</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi Klaas,<br>
<br>
Perhaps its an idea to post this on the linux-dvb mailing list, if anything<br>
it keeps the subject alive.<br>
<br>
I&#39;ve spent an hour or so playing with several of the parameters of the<br>
demodulator (the tda10023), mostly because this was suggest in one of the<br>
older posts about this issue. However none of my efforts gave any desired<br>
result and quickly got tired of unloading / reloading my drivers (which<br>
every so often required a hard reset as well).<br>
<br>
But if you find anything, that would be great ;)<br>
<br>
Gr. Jerremy<br>
<div><div></div><div class="Wj3C7c"><br>
On Mon, 29 Sep 2008 11:35:03 +0200, &quot;klaas de waal&quot;<br>
&lt;<a href="mailto:klaas.de.waal@gmail.com">klaas.de.waal@gmail.com</a>&gt; wrote:<br>
&gt; Hallo Jeremy,<br>
&gt; I have exactly the same problem with my C-1501 card: tuning problems on<br>
&gt; 388<br>
&gt; MHz but OK on most other frequencies.<br>
&gt; It works OK with WIndowsXP on all frequencies including the 388MHz, so<br>
the<br>
&gt; hardware is OK and it must be a software issue.<br>
&gt; I have over the weekend put in a lot of printk for debugging but have not<br>
&gt; found it yet.<br>
&gt; I will keep you updated.<br>
&gt;<br>
&gt; Groetjes,<br>
&gt; Klaas<br>
&gt;<br>
&gt;<br>
&gt; On Thu, Sep 11, 2008 at 5:50 PM, &lt;<a href="mailto:jerremy@wordtgek.nl">jerremy@wordtgek.nl</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; Hi,<br>
&gt;&gt;<br>
&gt;&gt; This issue has come up at least once a bit more then a month ago and is<br>
&gt;&gt; still present in the current release of the V4L-DVB drivers. The<br>
&gt;&gt; Technotrend C-1501 drivers are unable to get a lock on 388Mhz (and a<br>
&gt; couple<br>
&gt;&gt; of other frequencies, like 682Mhz and 322Mhz, but I can only test<br>
&gt; 388Mhz).<br>
&gt;&gt;<br>
&gt;&gt; The dmesg will mention an I2C timeout when this occurs, I&#39;m not sure if<br>
&gt; its<br>
&gt;&gt; related (as it&#39;ll randomly give those timeouts when viewing working<br>
&gt;&gt; channels too).<br>
&gt;&gt;<br>
&gt;&gt; I have two seperate installs of Linux (Ubuntu 8.04 64-Bit with 1<br>
&gt; received<br>
&gt;&gt; and Ubuntu 8.04 32-Bit with 2 receivers) which both suffer the same<br>
&gt;&gt; inability to lock onto that frequency. So its unlikely to be a hardware<br>
&gt;&gt; problem, also the Windows drivers do not seem to have any issues.<br>
&gt;&gt;<br>
&gt;&gt; Is anyone looking into this issue? If not, what would be the place to<br>
&gt;&gt; experiment?<br>
&gt;&gt;<br>
&gt;&gt; Gr,<br>
&gt;&gt;<br>
&gt;&gt; Jerremy Koot<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; _______________________________________________<br>
&gt;&gt; linux-dvb mailing list<br>
&gt;&gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt;&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;&gt;<br>
<br>
<br>
</div></div></blockquote></div><br></div>

------=_Part_58434_26863350.1223583330428--


--===============0690807204==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0690807204==--
