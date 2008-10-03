Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <damien@damienandlaurel.com>) id 1Klb5c-0003Y7-BY
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 05:12:26 +0200
Received: by mu-out-0910.google.com with SMTP id g7so1105525muf.1
	for <linux-dvb@linuxtv.org>; Thu, 02 Oct 2008 20:12:20 -0700 (PDT)
Message-ID: <ee0ad0230810022012t132b7b6cwfb098a47a561ed6f@mail.gmail.com>
Date: Fri, 3 Oct 2008 13:12:19 +1000
From: "Damien Morrissey" <damien@damienandlaurel.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1222989249.3724.3.camel@pc10.localdom.local>
MIME-Version: 1.0
References: <48E35E38.9040909@gmail.com>
	<1222900908.2706.18.camel@pc10.localdom.local>
	<48E4A4A4.8030003@gmail.com> <200810021915.40147.zzam@gentoo.org>
	<1222989249.3724.3.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Leadtek DTV1000S ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0978460785=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0978460785==
Content-Type: multipart/alternative;
	boundary="----=_Part_18322_3861592.1223003539875"

------=_Part_18322_3861592.1223003539875
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Oct 3, 2008 at 9:14 AM, hermann pitton <hermann-pitton@arcor.de>wrote:

> Hi,
>
> Am Donnerstag, den 02.10.2008, 19:15 +0200 schrieb Matthias Schwarzott:
> > On Donnerstag, 2. Oktober 2008, Plantain wrote:
> > >
> > > Hey,
> > >
> > > I'm not actually able to code in C, but I've spent the last 24 hours
> > > puddling around trying to get somewhere. I believe I've added
> everything
> > > that is needed for the card to be detected, but it's not detecting it,
> > > even if I specify it with card=152 (the ID I've added). I have got the
> > > code to compile at least, which I'm pretty proud of :)
> > >
> > > I managed to get regspy to work (needed to revert 64bit vista to 32bit
> > > XP), but the viewing software that came with the card just crashes on
> > > 32bit XP. I've built a small wiki page (with highres images) detailing
> > > my progress, but I've really just hit a brick wall. Wikipage at
> > > http://www.linuxtv.org/wiki/index.php/WinFast_DTV_1000_S
> > >
> > > Short of learning C (which I am very slowly doing), I don't see anyway
> > > forwards under my direction, so I've attached my efforts in the hope
> > > someone else can take this forwards. From my limited understanding I've
> > > provided all the necessary information for someone to finish it, and if
> > > not I'll happily dig up anything else needed. I'm not familiar with any
> > > version control system/patching, so I've just hg diff > file.diff, I
> > > hope this is adequate.
> > >
> > > I'm on #linuxtv @ freenode IRC for a significant portion of the day if
> > > anyone has pointers for me/wants to ask questions about the card.
> > >
> >
> > Looking at your regspy output
> > 109.     SAA7134_GPIO_GPMODE:             82000000   (10000010 00000000
> > 00000000 00000000)
> > 110.     SAA7134_GPIO_GPSTATUS:           02132054   (00000010 00010011
> > 00100000 01010100)
> >
> > I suggest you change your gpio code like this:
> >
> >                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x82000000,
> > 0x82000000);
> >                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x02000000,
> > 0x02000000);
> >
> > So this at least sets the directions of gpios as used in windows, and
> outputs
> > the same values on the gpios configured as output. That should work
> better
> > than your copy-and-pasted numbers from another card.
> >
> > But it still can be you need to pull some pins high or low for some time
> at
> > init to get parts reset.
> >
> > You also could try adding a small wait time after writing gpio values.
> > e.g. msleep(500);
> >
> > Good luck
> > Matthias
>
> yes, that is likely the most solid start we can have from the analog
> side so far. The card should be auto detectable as well.
>
> Thanks,
> Hermann
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hi,
I have a 64 bit system and am farmiliar with C/C++/etc, but not so farmiliar
with the specific code yet. I have one of these cards and am willing to put
a bit of work into getting it going. How can I be of use?

Damien.

------=_Part_18322_3861592.1223003539875
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Fri, Oct 3, 2008 at 9:14 AM, hermann pitton <span dir="ltr">&lt;<a href="mailto:hermann-pitton@arcor.de">hermann-pitton@arcor.de</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
Am Donnerstag, den 02.10.2008, 19:15 +0200 schrieb Matthias Schwarzott:<br>
<div><div></div><div class="Wj3C7c">&gt; On Donnerstag, 2. Oktober 2008, Plantain wrote:<br>
&gt; &gt;<br>
&gt; &gt; Hey,<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m not actually able to code in C, but I&#39;ve spent the last 24 hours<br>
&gt; &gt; puddling around trying to get somewhere. I believe I&#39;ve added everything<br>
&gt; &gt; that is needed for the card to be detected, but it&#39;s not detecting it,<br>
&gt; &gt; even if I specify it with card=152 (the ID I&#39;ve added). I have got the<br>
&gt; &gt; code to compile at least, which I&#39;m pretty proud of :)<br>
&gt; &gt;<br>
&gt; &gt; I managed to get regspy to work (needed to revert 64bit vista to 32bit<br>
&gt; &gt; XP), but the viewing software that came with the card just crashes on<br>
&gt; &gt; 32bit XP. I&#39;ve built a small wiki page (with highres images) detailing<br>
&gt; &gt; my progress, but I&#39;ve really just hit a brick wall. Wikipage at<br>
&gt; &gt; <a href="http://www.linuxtv.org/wiki/index.php/WinFast_DTV_1000_S" target="_blank">http://www.linuxtv.org/wiki/index.php/WinFast_DTV_1000_S</a><br>
&gt; &gt;<br>
&gt; &gt; Short of learning C (which I am very slowly doing), I don&#39;t see anyway<br>
&gt; &gt; forwards under my direction, so I&#39;ve attached my efforts in the hope<br>
&gt; &gt; someone else can take this forwards. From my limited understanding I&#39;ve<br>
&gt; &gt; provided all the necessary information for someone to finish it, and if<br>
&gt; &gt; not I&#39;ll happily dig up anything else needed. I&#39;m not familiar with any<br>
&gt; &gt; version control system/patching, so I&#39;ve just hg diff &gt; file.diff, I<br>
&gt; &gt; hope this is adequate.<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m on #linuxtv @ freenode IRC for a significant portion of the day if<br>
&gt; &gt; anyone has pointers for me/wants to ask questions about the card.<br>
&gt; &gt;<br>
&gt;<br>
&gt; Looking at your regspy output<br>
&gt; 109. &nbsp; &nbsp; SAA7134_GPIO_GPMODE: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 82000000 &nbsp; (10000010 00000000<br>
&gt; 00000000 00000000)<br>
&gt; 110. &nbsp; &nbsp; SAA7134_GPIO_GPSTATUS: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 02132054 &nbsp; (00000010 00010011<br>
&gt; 00100000 01010100)<br>
&gt;<br>
&gt; I suggest you change your gpio code like this:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;saa_andorl(SAA7134_GPIO_GPMODE0 &gt;&gt; 2, &nbsp; 0x82000000,<br>
&gt; 0x82000000);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;saa_andorl(SAA7134_GPIO_GPSTATUS0 &gt;&gt; 2, 0x02000000,<br>
&gt; 0x02000000);<br>
&gt;<br>
&gt; So this at least sets the directions of gpios as used in windows, and outputs<br>
&gt; the same values on the gpios configured as output. That should work better<br>
&gt; than your copy-and-pasted numbers from another card.<br>
&gt;<br>
&gt; But it still can be you need to pull some pins high or low for some time at<br>
&gt; init to get parts reset.<br>
&gt;<br>
&gt; You also could try adding a small wait time after writing gpio values.<br>
&gt; e.g. msleep(500);<br>
&gt;<br>
&gt; Good luck<br>
&gt; Matthias<br>
<br>
</div></div>yes, that is likely the most solid start we can have from the analog<br>
side so far. The card should be auto detectable as well.<br>
<br>
Thanks,<br>
<font color="#888888">Hermann<br>
</font><div><div></div><div class="Wj3C7c"><br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</div></div></blockquote></div><br>Hi,<br>I have a 64 bit system and am farmiliar with C/C++/etc, but not so farmiliar with the specific code yet. I have one of these cards and am willing to put a bit of work into getting it going. How can I be of use?<br>
<br>Damien.<br></div>

------=_Part_18322_3861592.1223003539875--


--===============0978460785==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0978460785==--
