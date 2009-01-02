Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <ea4209750901020735r1659e24apba5cd7182af22817@mail.gmail.com>
Date: Fri, 2 Jan 2009 16:35:38 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0901020715m15a685f6nb951030ae961e074@mail.gmail.com>
MIME-Version: 1.0
References: <495A0E02.1030307@olenepal.org>
	<412bdbff0812300702l7f6333d0qa094332fc20f163@mail.gmail.com>
	<73e59df30901020653v5ec9b923mb5c6f4b186bb18de@mail.gmail.com>
	<ea4209750901020701q11e34b42p3440c33e366fcb35@mail.gmail.com>
	<412bdbff0901020715m15a685f6nb951030ae961e074@mail.gmail.com>
Cc: pb@linuxtv.org, linux-dvb@linuxtv.org, don@syst.com.br,
	roshan karki <roshan@olenepal.org>
Subject: Re: [linux-dvb] YUAN High-Tech STK7700PH problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1243778404=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1243778404==
Content-Type: multipart/alternative;
	boundary="----=_Part_103870_12779365.1230910538745"

------=_Part_103870_12779365.1230910538745
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I would like to understand what's happening, but I don't know anything about
usbsnoop logs and next week I leave for a 2 months trip, so it would be
difficult to look at it. I'm also thinking that is should be related to some
GPIO (that's often the problem with dibcom based devices, find the correct
place of everything), and could explain why it seemed to work once (if
correctly set on windows and then just reboot without stopping the device.
Good luck!

Albert

2009/1/2 Devin Heitmueller <devin.heitmueller@gmail.com>

> On Fri, Jan 2, 2009 at 10:01 AM, Albert Comerma
> <albert.comerma@gmail.com> wrote:
> > Hi all, sorry for the delay, I didn't noticed the first mail. I added
> this
> > patch, but I don't own any of this cards; the status was quite strange.
> One
> > of the testers said that it was working perfectly while the other (there
> was
> > not much people with that model) said it didn't work. So, I'm not sure if
> > there is more than one hardware version with the same ID or something
> > similar...
> >
> > Albert
>
> Hello Albert,
>
> As the person who submitted the original patch, thank you for taking
> the time to respond.  From a debugging standpoint, it's good to know
> that the support never worked, as opposed to some breakage being
> introduced.
>
> I'll look at Roshan's usb snoop trace over the weekend (unless you
> want to).  I suspect the GPIOs are probably just not correctly for his
> device and the demod is probably still being held in reset when the
> first i2c command is sent.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

------=_Part_103870_12779365.1230910538745
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I would like to understand what&#39;s happening, but I don&#39;t know anything about usbsnoop logs and next week I leave for a 2 months trip, so it would be difficult to look at it. I&#39;m also thinking that is should be related to some GPIO (that&#39;s often the problem with dibcom based devices, find the correct place of everything), and could explain why it seemed to work once (if correctly set on windows and then just reboot without stopping the device. Good luck!<br>
<br>Albert<br><br><div class="gmail_quote">2009/1/2 Devin Heitmueller <span dir="ltr">&lt;<a href="mailto:devin.heitmueller@gmail.com">devin.heitmueller@gmail.com</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">On Fri, Jan 2, 2009 at 10:01 AM, Albert Comerma<br>
&lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt; wrote:<br>
&gt; Hi all, sorry for the delay, I didn&#39;t noticed the first mail. I added this<br>
&gt; patch, but I don&#39;t own any of this cards; the status was quite strange. One<br>
&gt; of the testers said that it was working perfectly while the other (there was<br>
&gt; not much people with that model) said it didn&#39;t work. So, I&#39;m not sure if<br>
&gt; there is more than one hardware version with the same ID or something<br>
&gt; similar...<br>
&gt;<br>
&gt; Albert<br>
<br>
</div>Hello Albert,<br>
<br>
As the person who submitted the original patch, thank you for taking<br>
the time to respond. &nbsp;From a debugging standpoint, it&#39;s good to know<br>
that the support never worked, as opposed to some breakage being<br>
introduced.<br>
<br>
I&#39;ll look at Roshan&#39;s usb snoop trace over the weekend (unless you<br>
want to). &nbsp;I suspect the GPIOs are probably just not correctly for his<br>
device and the demod is probably still being held in reset when the<br>
first i2c command is sent.<br>
<br>
Devin<br>
<font color="#888888"><br>
--<br>
</font><div><div></div><div class="Wj3C7c">Devin J. Heitmueller<br>
<a href="http://www.devinheitmueller.com" target="_blank">http://www.devinheitmueller.com</a><br>
AIM: devinheitmueller<br>
</div></div></blockquote></div><br>

------=_Part_103870_12779365.1230910538745--


--===============1243778404==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1243778404==--
