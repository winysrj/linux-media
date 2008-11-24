Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1L4evH-0004sa-DI
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 18:08:31 +0100
Received: by gxk4 with SMTP id 4so1951481gxk.17
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 09:07:57 -0800 (PST)
Message-ID: <617be8890811240853l4979670o509b57d56d4f8f23@mail.gmail.com>
Date: Mon, 24 Nov 2008 17:53:42 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Darron Broad" <darron@kewl.org>
In-Reply-To: <21368.1227545044@kewl.org>
MIME-Version: 1.0
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
	<29500.1227284783@kewl.org>
	<617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>
	<18885.1227529079@kewl.org>
	<617be8890811240423o6b8fc2e4jc94021cb14ec271a@mail.gmail.com>
	<617be8890811240626y6452709bk34b276c21a9ea5c6@mail.gmail.com>
	<20093.1227537387@kewl.org>
	<617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com>
	<21368.1227545044@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fwd: Distorted analog sound when using an HVR-3000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1195028947=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1195028947==
Content-Type: multipart/alternative;
	boundary="----=_Part_122476_3348283.1227545622641"

------=_Part_122476_3348283.1227545622641
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'll give a try on kradio, and let you know any results.
Best regards,
  Eduard


2008/11/24 Darron Broad <darron@kewl.org>

> In message <617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com>,
> "Eduard Huguet" wrote:
> >
> >Hi,
>
> lo
>
> >    I've tested you driver compared to the offcial LinuxTV HG tree, and I
> >**think** (can be wrong, though...) that I'm getting "correct" audio when
> >using a higher input volume. I mean, both drivers delivers crackly sound
> >when given a high volume input, but yours seems to hold up a higher volume
> >level before starting to fail.
>
> just to explain what the changes actually do:
>
> the wm8775 in v4l-dvb has a fixed gain which uses a form of AGC
> circuit to center to gain someplace above 0dB. this function is
> fixed.
>
> my changes to not activate that feature and by defailt the gain
> is set to 0dB.
>
> >I hope this means anything to you... :D
>
> sort of yes. before and after I could get distortion in some
> audio passages, however, by utilising v4l2-ctl to set the gain
> to -6dB those passages become clear. this will be input
> dependant. I don't really have a lot of test cases to provide
> you with and haven't done much investigation into the optimum
> setting.
>
> you can test this more easily using the newly working FM
> radio (does it work in the hvr-3000) in kradio which has
> a radio volume control.
>
> cya
>
> --
>
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \
>
>

------=_Part_122476_3348283.1227545622641
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I&#39;ll give a try on kradio, and let you know any results.<br>Best regards, <br>&nbsp; Eduard<br><br><br><div class="gmail_quote">2008/11/24 Darron Broad <span dir="ltr">&lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;</span><br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">In message &lt;<a href="mailto:617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com">617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com</a>&gt;, &quot;Eduard Huguet&quot; wrote:<br>

&gt;<br>
&gt;Hi,<br>
<br>
lo<br>
<div class="Ih2E3d"><br>
&gt; &nbsp; &nbsp;I&#39;ve tested you driver compared to the offcial LinuxTV HG tree, and I<br>
&gt;**think** (can be wrong, though...) that I&#39;m getting &quot;correct&quot; audio when<br>
&gt;using a higher input volume. I mean, both drivers delivers crackly sound<br>
&gt;when given a high volume input, but yours seems to hold up a higher volume<br>
&gt;level before starting to fail.<br>
<br>
</div>just to explain what the changes actually do:<br>
<br>
the wm8775 in v4l-dvb has a fixed gain which uses a form of AGC<br>
circuit to center to gain someplace above 0dB. this function is<br>
fixed.<br>
<br>
my changes to not activate that feature and by defailt the gain<br>
is set to 0dB.<br>
<div class="Ih2E3d"><br>
&gt;I hope this means anything to you... :D<br>
<br>
</div>sort of yes. before and after I could get distortion in some<br>
audio passages, however, by utilising v4l2-ctl to set the gain<br>
to -6dB those passages become clear. this will be input<br>
dependant. I don&#39;t really have a lot of test cases to provide<br>
you with and haven&#39;t done much investigation into the optimum<br>
setting.<br>
<br>
you can test this more easily using the newly working FM<br>
radio (does it work in the hvr-3000) in kradio which has<br>
a radio volume control.<br>
<br>
cya<br>
<font color="#888888"><br>
--<br>
<br>
&nbsp;// /<br>
{:)==={ Darron Broad &lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;<br>
&nbsp;\\ \<br>
<br>
</font></blockquote></div><br>

------=_Part_122476_3348283.1227545622641--


--===============1195028947==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1195028947==--
