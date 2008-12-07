Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <leo.thealmighty@gmail.com>) id 1L9FaM-0007o4-Ut
	for linux-dvb@linuxtv.org; Sun, 07 Dec 2008 10:05:56 +0100
Received: by rv-out-0506.google.com with SMTP id b25so687773rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 07 Dec 2008 01:05:49 -0800 (PST)
Message-ID: <401cfcb70812070105y38d198dw37e52d34bbc45a32@mail.gmail.com>
Date: Sun, 7 Dec 2008 14:35:49 +0530
From: "leo theGreat" <leo.thealmighty@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <493AE86B.7040805@daveoxley.co.uk>
MIME-Version: 1.0
References: <493AE86B.7040805@daveoxley.co.uk>
Subject: Re: [linux-dvb] tm6010 - Compiles All Drivers,
	but not tm6010 Strange!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0238988034=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0238988034==
Content-Type: multipart/alternative;
	boundary="----=_Part_33229_13606445.1228640749351"

------=_Part_33229_13606445.1228640749351
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

HI,

I tried compiling driver with make config and after going through a series
of
'yes/no' questions i was able to compile the driver. Compilation went fine
without any errors.
I did make install and installed fine which was certified by 'dmesg'. As
expected It was looking for
the firmware. I had the sys file for my analog card 'Trident Tv Master
5600AI'. I ran peal code to extract
the firmware from sys file... but it died with a message 'hash not matched'.

I am just wondering, will it result the same after merging the 'new working
version' . Will my firmware extract properly.
I mean should I keep my finger crossed.....

Hope my little test helps you guys some way or the other !!

Keep it up boys !

- leo.t.am

On Sun, Dec 7, 2008 at 2:32 AM, Dave Oxley <dave@daveoxley.co.uk> wrote:

> > I'm currently working on the driver and I'll probably merge soon a
> version with
> > analog support working fine, including the tm6000-alsa module. The
> current
> > version has no sound, and have a serious issue on analog handling,
> causing
> > kernel hangs.
> >
> > Cheers,
> > Mauro
> >
>
> I've just been trying the latest and am getting a gpf when modprobe'ing
> tm6000. As it sounds like you know about some problems already I'll hold
> off trying again until the latest is merged. But one thing I am unsure
> about is how to make sure there isn't a conflict between code that is in
> your branch and what I have compiled into my kernel. I've made sure that
> videobuf-core and videobuf-vmalloc aren't compiled in already, but is
> there anything else I need to check to prevent possible conflicts?
>
> Also, do you have any timeframe for this driver to be merged into main?
>
> Cheers,
> Dave.
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_33229_13606445.1228640749351
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

HI, <br><br>I tried compiling driver with make config and after going through a series of <br>&#39;yes/no&#39; questions i was able to compile the driver. Compilation went fine without any errors.<br>I did make install and installed fine which was certified by &#39;dmesg&#39;. As expected It was looking for<br>
the firmware. I had the sys file for my analog card &#39;Trident Tv Master 5600AI&#39;. I ran peal code to extract<br>the firmware from sys file... but it died with a message &#39;hash not matched&#39;.<br><br>I am just wondering, will it result the same after merging the &#39;new working version&#39; . Will my firmware extract properly.<br>
I mean should I keep my finger crossed..... <br><br>Hope my little test helps you guys some way or the other !!<br><br>Keep it up boys !<br><br>- <a href="http://leo.t.am">leo.t.am</a><br><br><div class="gmail_quote">On Sun, Dec 7, 2008 at 2:32 AM, Dave Oxley <span dir="ltr">&lt;<a href="mailto:dave@daveoxley.co.uk">dave@daveoxley.co.uk</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d">&gt; I&#39;m currently working on the driver and I&#39;ll probably merge soon a version with<br>

&gt; analog support working fine, including the tm6000-alsa module. The current<br>
&gt; version has no sound, and have a serious issue on analog handling, causing<br>
&gt; kernel hangs.<br>
&gt;<br>
&gt; Cheers,<br>
&gt; Mauro<br>
&gt;<br>
<br>
</div>I&#39;ve just been trying the latest and am getting a gpf when modprobe&#39;ing<br>
tm6000. As it sounds like you know about some problems already I&#39;ll hold<br>
off trying again until the latest is merged. But one thing I am unsure<br>
about is how to make sure there isn&#39;t a conflict between code that is in<br>
your branch and what I have compiled into my kernel. I&#39;ve made sure that<br>
videobuf-core and videobuf-vmalloc aren&#39;t compiled in already, but is<br>
there anything else I need to check to prevent possible conflicts?<br>
<br>
Also, do you have any timeframe for this driver to be merged into main?<br>
<br>
Cheers,<br>
Dave.<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_33229_13606445.1228640749351--


--===============0238988034==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0238988034==--
