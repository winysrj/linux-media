Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <klaas.de.waal@gmail.com>) id 1Kp7Ro-0007sn-Ue
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 22:21:54 +0200
Received: by qw-out-2122.google.com with SMTP id 9so413212qwb.17
	for <linux-dvb@linuxtv.org>; Sun, 12 Oct 2008 13:21:46 -0700 (PDT)
Message-ID: <7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
Date: Sun, 12 Oct 2008 22:21:46 +0200
From: "klaas de waal" <klaas.de.waal@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1223598995.4825.12.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_84458_25535887.1223842906679"
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
	<1223598995.4825.12.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org, jerremy@wordtgek.nl
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_84458_25535887.1223842906679
Content-Type: multipart/alternative;
	boundary="----=_Part_84459_13260289.1223842906679"

------=_Part_84459_13260289.1223842906679
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Oct 10, 2008 at 2:36 AM, hermann pitton <hermann-pitton@arcor.de>wrote:

> Hi,
>
> Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:
> > Hi Jeremy,
> >
> > I have the Technotrend C-1501 now locking at 388MHz.
> > The table tda827xa_dvbt contains the settings for each frequency
> > segment.
> > The frequency values (first column) are for  the frequency plus the
> > IF, so for 388MHz
> > this is 388+5 gives 393 MHz. The table starts a new segment at 390MHz,
> > it then
> > starts to use VCO2 instead of VCO1.
> > I have now (hack, hack) changed the segment start from 390 to 395MHz
> > so
> > that the 388MHz is still tuned with VCO1, and this works OK!!
> > Like this:
> >
> > static const struct tda827xa_data tda827xa_dvbt[] = {
> >     { .lomax =  56875000, .svco = 3, .spd = 4, .scr = 0, .sbs =
> > 0, .gc3 = 1},
> >     { .lomax =  67250000, .svco = 0, .spd = 3, .scr = 0, .sbs =
> > 0, .gc3 = 1},
> >     { .lomax =  81250000, .svco = 1, .spd = 3, .scr = 0, .sbs =
> > 0, .gc3 = 1},
> >     { .lomax =  97500000, .svco = 2, .spd = 3, .scr = 0, .sbs =
> > 0, .gc3 = 1},
> >     { .lomax = 113750000, .svco = 3, .spd = 3, .scr = 0, .sbs =
> > 1, .gc3 = 1},
> >     { .lomax = 134500000, .svco = 0, .spd = 2, .scr = 0, .sbs =
> > 1, .gc3 = 1},
> >     { .lomax = 154000000, .svco = 1, .spd = 2, .scr = 0, .sbs =
> > 1, .gc3 = 1},
> >     { .lomax = 162500000, .svco = 1, .spd = 2, .scr = 0, .sbs =
> > 1, .gc3 = 1},
> >     { .lomax = 183000000, .svco = 2, .spd = 2, .scr = 0, .sbs =
> > 1, .gc3 = 1},
> >     { .lomax = 195000000, .svco = 2, .spd = 2, .scr = 0, .sbs =
> > 2, .gc3 = 1},
> >     { .lomax = 227500000, .svco = 3, .spd = 2, .scr = 0, .sbs =
> > 2, .gc3 = 1},
> >     { .lomax = 269000000, .svco = 0, .spd = 1, .scr = 0, .sbs =
> > 2, .gc3 = 1},
> >     { .lomax = 290000000, .svco = 1, .spd = 1, .scr = 0, .sbs =
> > 2, .gc3 = 1},
> >     { .lomax = 325000000, .svco = 1, .spd = 1, .scr = 0, .sbs =
> > 3, .gc3 = 1},
> > #ifdef ORIGINAL // KdW test
> >     { .lomax = 390000000, .svco = 2, .spd = 1, .scr = 0, .sbs =
> > 3, .gc3 = 1},
> > #else
> >     { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs =
> > 3, .gc3 = 1},
> > #endif
> >     { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs =
> > 3, .gc3 = 1},
> > etc etc
> >
> > I plan to do a test on the all frequencies in the near future, at
> > least on all the Dutch Ziggo frequencies.
> > Because I cannot test what will happen if the driver is used for DVB-T
> > (what
> > the name of the table suggests) it might be best to make a separate
> > tda827xa_dvbc table.
> >
> > About the timeout messages, they come from the SAA7134 and they happen
> > fairly random. I have looked at debug traces and everytime it happens
> > it
> > does a retry and then succeeds, so I think this can be ignored for the
> > time being.
> > Maybe you can check if the fix/hack also works for you?
> > If there is an official maintainer of this driver, maybe he can
> > comment?
> >
> > Groetjes,
> > Klaas
> >
>
> just scrolling through mails and did not look it up yet.
>
> But you likely mean tda8274a DVB-C, tda10023 and saa7146.
>
> Are we still here?
> http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025634.html
>
> Please don't top post, you get more readers.
>
> Cheers,
> Hermann
>
>
> >
> > On Tue, Sep 30, 2008 at 11:18 AM, <jerremy@wordtgek.nl> wrote:
> >         Hi Klaas,
> >
> >         Perhaps its an idea to post this on the linux-dvb mailing
> >         list, if anything
> >         it keeps the subject alive.
> >
> >         I've spent an hour or so playing with several of the
> >         parameters of the
> >         demodulator (the tda10023), mostly because this was suggest in
> >         one of the
> >         older posts about this issue. However none of my efforts gave
> >         any desired
> >         result and quickly got tired of unloading / reloading my
> >         drivers (which
> >         every so often required a hard reset as well).
> >
> >         But if you find anything, that would be great ;)
> >
> >         Gr. Jerremy
> >
> >
> >         On Mon, 29 Sep 2008 11:35:03 +0200, "klaas de waal"
> >         <klaas.de.waal@gmail.com> wrote:
> >         > Hallo Jeremy,
> >         > I have exactly the same problem with my C-1501 card: tuning
> >         problems on
> >         > 388
> >         > MHz but OK on most other frequencies.
> >         > It works OK with WIndowsXP on all frequencies including the
> >         388MHz, so
> >         the
> >         > hardware is OK and it must be a software issue.
> >         > I have over the weekend put in a lot of printk for debugging
> >         but have not
> >         > found it yet.
> >         > I will keep you updated.
> >         >
> >         > Groetjes,
> >         > Klaas
> >         >
> >         >
> >         > On Thu, Sep 11, 2008 at 5:50 PM, <jerremy@wordtgek.nl>
> >         wrote:
> >         >
> >         >> Hi,
> >         >>
> >         >> This issue has come up at least once a bit more then a
> >         month ago and is
> >         >> still present in the current release of the V4L-DVB
> >         drivers. The
> >         >> Technotrend C-1501 drivers are unable to get a lock on
> >         388Mhz (and a
> >         > couple
> >         >> of other frequencies, like 682Mhz and 322Mhz, but I can
> >         only test
> >         > 388Mhz).
> >         >>
> >         >> The dmesg will mention an I2C timeout when this occurs, I'm
> >         not sure if
> >         > its
> >         >> related (as it'll randomly give those timeouts when viewing
> >         working
> >         >> channels too).
> >         >>
> >         >> I have two seperate installs of Linux (Ubuntu 8.04 64-Bit
> >         with 1
> >         > received
> >         >> and Ubuntu 8.04 32-Bit with 2 receivers) which both suffer
> >         the same
> >         >> inability to lock onto that frequency. So its unlikely to
> >         be a hardware
> >         >> problem, also the Windows drivers do not seem to have any
> >         issues.
> >         >>
> >         >> Is anyone looking into this issue? If not, what would be
> >         the place to
> >         >> experiment?
> >         >>
> >         >> Gr,
> >         >>
> >         >> Jerremy Koot
> >         >>
> >         >>
>

Hello Herman,


Thanks for your post. I had not seen this message
http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025634.html
before. Probably a lot of work has been done since because the card worked
quite OK, only on the 388MHz it failed on me.

As mentioned in an earlier post, first I got my tuner working by modifying
the frequency map table tda827x_dvbt to use a different setting at 388MHz. I
have now put in a frequency map table tda827x_dvbc for DVB-C tuners only.
This works OK for me and it should not modify the behaviour with other
non-DVB-C demodulators.
With the dvb-apps/util/zap utility I get a lock on all Ziggo (Dutch cable TV
provider) frequencies. With MythTV-0.21 I can receive all the channels that
I am entitled to.

Remaining (non-fatal) issues are:

Error message:
*saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer*
This message comes once in a while and it happens at random places, it
cannot be correlated to a single place in the tda827x code. It really seems
random. I have read though a lot of traces and when this error happens it
does a retry and the retry succeeds.

Error message:
*tda827x: tda827x_config not defined, cannot set LNA gain!*
This message comes on every tuning action. I think that the TT-C1501 board
does not have a separate LNA outside the tuner so this is not really an
error. It shoudl be possible to fill in a tda827x_config struct so that it
does not give this error message. I could change the code to achieve this
but I do not want to change everything at once.

Minor issue:
*Signal strength not the same across the band.*
On the frequencies I can receive (from 252MHz to 826,75MHz) there is quite a
lot of signal strength variation; on MythTV display ranging from 60+ to 80+
percent, on zap output from 90 to d0 or so. On a KNC-One DVB-C card (cu1216
with tda10023 plus saa7146) the signal strength is practically constant.

I have attached my version of the tda827x.c driver, both as complete source
and as a diff against the hg version of 10 october.

Groetjes,
Klaas

------=_Part_84459_13260289.1223842906679
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Fri, Oct 10, 2008 at 2:36 AM, hermann pitton <span dir="ltr">&lt;<a href="mailto:hermann-pitton@arcor.de">hermann-pitton@arcor.de</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:<br>
<div><div></div><div class="Wj3C7c">&gt; Hi Jeremy,<br>
&gt;<br>
&gt; I have the Technotrend C-1501 now locking at 388MHz.<br>
&gt; The table tda827xa_dvbt contains the settings for each frequency<br>
&gt; segment.<br>
&gt; The frequency values (first column) are for &nbsp;the frequency plus the<br>
&gt; IF, so for 388MHz<br>
&gt; this is 388+5 gives 393 MHz. The table starts a new segment at 390MHz,<br>
&gt; it then<br>
&gt; starts to use VCO2 instead of VCO1.<br>
&gt; I have now (hack, hack) changed the segment start from 390 to 395MHz<br>
&gt; so<br>
&gt; that the 388MHz is still tuned with VCO1, and this works OK!!<br>
&gt; Like this:<br>
&gt;<br>
&gt; static const struct tda827xa_data tda827xa_dvbt[] = {<br>
&gt; &nbsp; &nbsp; { .lomax = &nbsp;56875000, .svco = 3, .spd = 4, .scr = 0, .sbs =<br>
&gt; 0, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = &nbsp;67250000, .svco = 0, .spd = 3, .scr = 0, .sbs =<br>
&gt; 0, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = &nbsp;81250000, .svco = 1, .spd = 3, .scr = 0, .sbs =<br>
&gt; 0, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = &nbsp;97500000, .svco = 2, .spd = 3, .scr = 0, .sbs =<br>
&gt; 0, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 113750000, .svco = 3, .spd = 3, .scr = 0, .sbs =<br>
&gt; 1, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 134500000, .svco = 0, .spd = 2, .scr = 0, .sbs =<br>
&gt; 1, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 154000000, .svco = 1, .spd = 2, .scr = 0, .sbs =<br>
&gt; 1, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 162500000, .svco = 1, .spd = 2, .scr = 0, .sbs =<br>
&gt; 1, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 183000000, .svco = 2, .spd = 2, .scr = 0, .sbs =<br>
&gt; 1, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 195000000, .svco = 2, .spd = 2, .scr = 0, .sbs =<br>
&gt; 2, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 227500000, .svco = 3, .spd = 2, .scr = 0, .sbs =<br>
&gt; 2, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 269000000, .svco = 0, .spd = 1, .scr = 0, .sbs =<br>
&gt; 2, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 290000000, .svco = 1, .spd = 1, .scr = 0, .sbs =<br>
&gt; 2, .gc3 = 1},<br>
&gt; &nbsp; &nbsp; { .lomax = 325000000, .svco = 1, .spd = 1, .scr = 0, .sbs =<br>
&gt; 3, .gc3 = 1},<br>
&gt; #ifdef ORIGINAL // KdW test<br>
&gt; &nbsp; &nbsp; { .lomax = 390000000, .svco = 2, .spd = 1, .scr = 0, .sbs =<br>
&gt; 3, .gc3 = 1},<br>
&gt; #else<br>
&gt; &nbsp; &nbsp; { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs =<br>
&gt; 3, .gc3 = 1},<br>
&gt; #endif<br>
&gt; &nbsp; &nbsp; { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs =<br>
&gt; 3, .gc3 = 1},<br>
&gt; etc etc<br>
&gt;<br>
&gt; I plan to do a test on the all frequencies in the near future, at<br>
&gt; least on all the Dutch Ziggo frequencies.<br>
&gt; Because I cannot test what will happen if the driver is used for DVB-T<br>
&gt; (what<br>
&gt; the name of the table suggests) it might be best to make a separate<br>
&gt; tda827xa_dvbc table.<br>
&gt;<br>
&gt; About the timeout messages, they come from the SAA7134 and they happen<br>
&gt; fairly random. I have looked at debug traces and everytime it happens<br>
&gt; it<br>
&gt; does a retry and then succeeds, so I think this can be ignored for the<br>
&gt; time being.<br>
&gt; Maybe you can check if the fix/hack also works for you?<br>
&gt; If there is an official maintainer of this driver, maybe he can<br>
&gt; comment?<br>
&gt;<br>
&gt; Groetjes,<br>
&gt; Klaas<br>
&gt;<br>
<br>
</div></div>just scrolling through mails and did not look it up yet.<br>
<br>
But you likely mean tda8274a DVB-C, tda10023 and saa7146.<br>
<br>
Are we still here?<br>
<a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025634.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025634.html</a><br>
<br>
Please don&#39;t top post, you get more readers.<br>
<br>
Cheers,<br>
<font color="#888888">Hermann<br>
</font><div><div></div><div class="Wj3C7c"><br>
<br>
&gt;<br>
&gt; On Tue, Sep 30, 2008 at 11:18 AM, &lt;<a href="mailto:jerremy@wordtgek.nl">jerremy@wordtgek.nl</a>&gt; wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Hi Klaas,<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Perhaps its an idea to post this on the linux-dvb mailing<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; list, if anything<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; it keeps the subject alive.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; I&#39;ve spent an hour or so playing with several of the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; parameters of the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; demodulator (the tda10023), mostly because this was suggest in<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; one of the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; older posts about this issue. However none of my efforts gave<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; any desired<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; result and quickly got tired of unloading / reloading my<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; drivers (which<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; every so often required a hard reset as well).<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; But if you find anything, that would be great ;)<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Gr. Jerremy<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; On Mon, 29 Sep 2008 11:35:03 +0200, &quot;klaas de waal&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;<a href="mailto:klaas.de.waal@gmail.com">klaas.de.waal@gmail.com</a>&gt; wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hallo Jeremy,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I have exactly the same problem with my C-1501 card: tuning<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; problems on<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; 388<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; MHz but OK on most other frequencies.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; It works OK with WIndowsXP on all frequencies including the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 388MHz, so<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; hardware is OK and it must be a software issue.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I have over the weekend put in a lot of printk for debugging<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; but have not<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; found it yet.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I will keep you updated.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Groetjes,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Klaas<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; On Thu, Sep 11, 2008 at 5:50 PM, &lt;<a href="mailto:jerremy@wordtgek.nl">jerremy@wordtgek.nl</a>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Hi,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; This issue has come up at least once a bit more then a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; month ago and is<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; still present in the current release of the V4L-DVB<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; drivers. The<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Technotrend C-1501 drivers are unable to get a lock on<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 388Mhz (and a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; couple<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; of other frequencies, like 682Mhz and 322Mhz, but I can<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; only test<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; 388Mhz).<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; The dmesg will mention an I2C timeout when this occurs, I&#39;m<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; not sure if<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; its<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; related (as it&#39;ll randomly give those timeouts when viewing<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; working<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; channels too).<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; I have two seperate installs of Linux (Ubuntu 8.04 64-Bit<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; with 1<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; received<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; and Ubuntu 8.04 32-Bit with 2 receivers) which both suffer<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the same<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; inability to lock onto that frequency. So its unlikely to<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; be a hardware<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; problem, also the Windows drivers do not seem to have any<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; issues.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Is anyone looking into this issue? If not, what would be<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the place to<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; experiment?<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Gr,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt; Jerremy Koot<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;&gt;<br>
</div></div></blockquote><div><br>Hello Herman,<br><br></div></div><br>Thanks for your post. I had not seen this message<br><a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025634.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025634.html</a><br>

before. Probably a lot of work has been done since because the card worked quite OK, only on the 388MHz it failed on me.<br><br>As mentioned in an earlier post, first I got my tuner working by modifying the frequency map table tda827x_dvbt to use a different setting at 388MHz. I have now put in a frequency map table tda827x_dvbc for DVB-C tuners only. This works OK for me and it should not modify the behaviour with other non-DVB-C demodulators.<br>
With the dvb-apps/util/zap utility I get a lock on all Ziggo (Dutch cable TV provider) frequencies. With MythTV-0.21 I can receive all the channels that I am entitled to.<br><br>Remaining (non-fatal) issues are:<br><br>Error message:<br>
<b>saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer</b><br>This message comes once in a while and it happens at random places, it cannot be correlated to a single place in the tda827x code. It really seems random. I have read though a lot of traces and when this error happens it does a retry and the retry succeeds.<br>
<br>Error message:<br><b>tda827x: tda827x_config not defined, cannot set LNA gain!</b><br>This message comes on every tuning action. I think that the TT-C1501 board does not have a separate LNA outside the tuner so this is not really an error. It shoudl be possible to fill in a tda827x_config struct so that it does not give this error message. I could change the code to achieve this but I do not want to change everything at once.<br>
<br>Minor issue:<br><b>Signal strength not the same across the band.</b><br>On the frequencies I can receive (from 252MHz to 826,75MHz) there is quite a lot of signal strength variation; on MythTV display ranging from 60+ to 80+ percent, on zap output from 90 to d0 or so. On a KNC-One DVB-C card (cu1216 with tda10023 plus saa7146) the signal strength is practically constant.<br>
<br>I have attached my version of the tda827x.c driver, both as complete source and as a diff against the hg version of 10 october.<br><br>Groetjes,<br>Klaas<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
<br><br><br><br><br><br></div>

------=_Part_84459_13260289.1223842906679--

------=_Part_84458_25535887.1223842906679
Content-Type: application/x-gzip; name=tda827x.c.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm84ati80
Content-Disposition: attachment; filename=tda827x.c.gz

H4sICOJp8EgAA3RkYTgyN3guYwDtXXtz2ziS/1v6FFhvJSc5ssyHJEtW4l3FlhPX2LLPj5nJ7U6p
KIqSWaFILUk59uTy3a8b4AMkQYlUPJ6pm1HNOCQI/NDobgANoJvc360S/I/U9DpRJKlNPmquv1j5
8K/+eaHZNvfwgFyY+r1mWOQHdzX7/BQUJbf3pkeWrjN3tQWBy5lrGMRzZv4XzTX65MlZEV2ziWtM
Tc93zcnKN4jpE82e7jsuWThTc/ZEgSBxZU8Nl/j3BvENd+ERZ0ZvPozuyAfDNlzNIleriWXq5NzU
DdsziAZ1Y4p3b0zJhAFhkVOk4iaggpw6gKz5pmP3iWHCc5c8GK4H90QJKwkQG8RxKUpN85F4lzhL
LFgHip+Ipflx2WYeC+KWTolpU/R7ZwmNugdMaOYX07LIxCArz5itrAbFgNzkp7Pbj5d3t2Qw+kR+
GlxfD0a3n/qQ27934KnxYDAsc7G0TICGprma7T9BCyjExfD6+COUGbw/Oz+7/QQNIadnt6PhzQ05
vbwmA3I1uL49O747H1yTq7vrq8ubYZOQGwMJMyjCGkbPqLCAl1PD10zLixr/CQTsAYHWlNxrDwYI
WjfMByBPI7qzfNosQ4qiWY49p02F3DE3+8ScEdvxG+SLa4Li+E5WurR8LOEGObP1ZoN0DtrkQvM8
MngAoR5ri4lrTudweTEgkiKrvQa5uxlgM/ar1b+btm6tpgZ5a5n26nEf1HJlGc37I+6J5i32/ael
4SWSd3RnsdT85v1OBmT6MNmfuY7tG/Y0CcWeP5hTw5kaDwo+5BD9qdZVDh4Rsur50CgdtMgHxk9W
836VkTZeasCeGk1r4OMGkTqtVr1fvbg8uTsfjkHWF+OT4c1xmGfnduXaxLH3ndmMhGQx0LkJvId8
M21l+YfwvN7cAaTq3yHJtEHkSxdq+FzT3LnXbDbr5N/VytQhXyv4I/CD+woIilVVJ0H2H4bXIyDh
/d2HqE2HZIcgSr2PZb6RL/emZZCaVMeWuivdJ0HGMWA8kK/VCrbcVPSxNp26/WolyMVStCX2xt3w
Jn4cguiOPTPnZFefAeOqlZXtmXObdkqfePOz0z6XBmObS6ylZ1g0q6rgSPaflWHrT312P4Ex64s5
9e/71W/9SDQPjjmNKvQMf+z501pAB2jAOGL17sxoVAOGBc81G/R+zmRpQFs8skuvvXr1a6YxlCO7
9O87MjP2jvwVdCeaDARS8ndBOQwkHxP3jmhrILMEz1E8DHvvCCgkr8mPrXNlfHN7Mr4Y1ZHTQSHk
C5TpKf0oKcSRMQmrgOudi9FOH0VoWDA6rEF/LwCXpS4P9b4Y0oePIiilxUN9+FgM62pwPj7bDHdW
DO3kh81QJz8Uw7oZHg8uxuebAc9L4R0LABUpgXfMAW6q/PGRZq4mFYs9fccqv70bDa/H14OTs8t6
Gq3b7ZP9XSQ76mQ4cbabMGZ//JUOyZVw1NmBTuXjCBV0BJwEvCfPNxbklfdve6eBRoQB4xVQUwXQ
ve/+0fpTvQ8mFw25ggOB5Sy0RxwUutCTl9PgauKFF8vgQg8v5rrKrqbmg7xsJ8YPGKM8n4hqC298
bWIZ//oF2Ab1fyVNWj3ckQ6YZfhrkCaQASkqXE08lCxeLLHrw4UeXgAZQSZGB4r1WyOF2cnDVLfG
PMjFlItiSmnMbuu7257B7KnbYMrrMbvb8HMtpiz1NmLKZTGVdNuVTNs3YablLqu5mIXpzGC25TxM
eeu2t9O6VL7tGcxuLp3rMKX1mO2NmEpJOhX5YKOMSmO20vyUS9OZlrvSSbddLk1nGlOV0uNnhClv
23ZV+f62ZzADEa3DVEtitjI6n+VnaczM+CmVpjMto7aabrtUms4MZqbtEaa8bds70mbMVsn+3uml
580sP8tiHrRy+ZnFlIthdpXNMipLZzfT39dgFqQz/AkwpRBTMBenMHnbDdeRgZXm0LUfM4Q3Lv/i
FSCf5VnWgWBkTlazf8mtX3AdyC2XF96c4P9gRZImrqbhitnk4fIa2jmztDnjB0dqEwAhDf5CDsuw
4dozfzWcWQ2S6uRbP1ilNwijBE36Btj29CJYO4/6vEX/yjukhvt4PFvZ+nhcx6X7F9PX7+O1xKrp
zKaLZrTopusXXYO1yfvB6OSns5Pbj+PO+OLj/xzSzQdaGSoFUxtcq0xcQ/vczxQ6EBRqZwqFuyGU
C7Cq6NKFieOSwQrWH7BA4Mu3s5V+q1ZibiCrg2bF6503MYuAgYQt04MNkaTpb/4S6PBbjsNsPYer
r1RmAJbDArAWk3DxFZFVMd+8CRZuI6iyVuOIhHIKtqRO9gm9gKu3bwXEYOd5QxSUGuqa9EtAPFU8
vKmNjo66dfK/RHpshQ8UfDCClan0OJsFaSpfskVvHttKcN+mSMLKgapOHUjIPg06KmRoQwZseSWb
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
------=_Part_84458_25535887.1223842906679
Content-Type: application/x-gzip; name=tda827x.c.patch.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm84dtua1
Content-Disposition: attachment; filename=tda827x.c.patch.gz

H4sICJ5q8EgAA3RkYTgyN3guYy5wYXRjaADtV1lv20YQfmZ+xTRAAx2UuAdPX0AQtHlK0D6nBkHx
UIlIlEpSitLA/72zS4k6lqIp2zX6UMIWlnt8O/N9M8vZwWAA0XoyWuTpNM2CmbE2ZyPsMGZpttoY
UZ6u47ww5nGUBka4mM8XmVGuMtFXRoHLnM041Bgh7ogS/APGrwi54nRMdg8MCY6/GY1GcqMk3cTR
83ahQMmVya6ousvg+BHvwDnVOXdAdgBoKxdgGvJrbD+Inzc/QVEGZRpCuMiKEl/yVVjCduPAj4Iy
OHhbT8ov93ALPwTWDxjPFvNgg+9g2a5joSk6jIt1uMAuLprLCFumaIU5tuTwpNi20A5s0Qf9FMx2
mMA6ACM1GL8UzKWnYPQCMKHcjkNsj9o5/J+9Y7DGiLSRTduuIlLSKzo8u6b3cPvt0+gLad2ePNTy
DDvLE27lGZ7IQyoW9lawBnlYgxUcSTgFcyWhj2jdEcz2umjdEczl9ombTVp3BPOcUzfZk8EoIadu
toPRoyg8AaMOOSvAxWBcUXMvALsUTM1c+nQwV3GTPRkMvy7n1WwCY21g3DwvQDuYGhrMUdzcC0Av
BOMV/c0CtIOpbnJunnLWDsZbLDMJPa/mxWC2e16AdjDVTYsrnDUd0bQbmKWERhNYN8tsrrhJWy0z
28BsrwsY6wTmMHJezUstcwnrAtbNMldVkz/dMvcFwTyqZEATWDc3n1dXDEVdMQQsLTrVFQHeLBbT
ly78+EsWfvxMrWbanm465r5WMz1Pt4hV12qatmVySwHWUH6SL7IyziJ/GeTBPC7xIgMD2S76uEZy
cMyYv8Q7EM4Rv7eQxKM7ef+R3YJprZHgQZLHf63iLPzuz4MlLjwqtK+3lfpklXyh9F4WgvuNUxb6
82IK4h9lgXEQRYIcsePoToyKDuQnmQXTiqtmgjxLt6hdX69E0alVxgvrBKJ0fHRXGwtDSBM5urMp
FfjXeIvQvv2ZzmLoHd8Y0vutxDewR+4jj7hAS5PT2YhPdytuEbhf6TTJ4+CrJEVLh8PrnbEC5DPu
3+sdWD0ELgrePhggK8I+3NyAYhQGloQRDJN76QMcPIYBxWoiaIyLYjePinmf4e4O3Hotq/reAdkk
Sd3LK8TdqylfN9SWPIkeS/SoVIlwR2utPnrRMCryAoc5Dkv+NHXKpKj3sKtdzUkjmMgdxDL7tZXO
1sqw7nGrHmLXPV7Vw8xrmVEWs3XLYnVGXR5BmB9pAj2RNotlMU6zZDEuvy9jof6vv/i/v//Ur640
WoThnZVfe29/LqCIZ/FRSuHt54/srQ6+n6yy0Pf7MvO0tiQL5ZSH6ixUw/ho6aNhfDL73wpjxaj/
RBg3WbUPY3VUCWN1yrkwVmY+O4ybDkbLYbrluLuDUawyBhAu8lxE3YffYB3MVjEMjGPqN5zUVtOt
FQStVrM0zKUpR5GPx/Y0KGM/LPNZFS+NQ7hAB1q5KwbKPMiKJM57h6d/sNThHX4eqpkiU23i6jY1
d5n6XJdUxV7XpUbVXEe3PF5/zubFLI6XPV4Bo7dodPx3DO8/fqCqo5biqJl0ODhfU0LGdZt59WH7
Mv49klGv5N8/E+5xEs0WAAA=
------=_Part_84458_25535887.1223842906679
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_84458_25535887.1223842906679--
