Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JytPV-0005WI-KJ
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 20:51:39 +0200
Received: by rv-out-0506.google.com with SMTP id b25so3163982rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 21 May 2008 11:51:33 -0700 (PDT)
Message-ID: <617be8890805211151naf6095of1c8a3c10c0c3bd@mail.gmail.com>
Date: Wed, 21 May 2008 20:51:28 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>, bvidinli@gmail.com
In-Reply-To: <d9def9db0805210954t3a36c837g6fdbe37171330acb@mail.gmail.com>
MIME-Version: 1.0
References: <mailman.67.1211375422.824.linux-dvb@linuxtv.org>
	<617be8890805210711j726bc505jde87e32078a8d4eb@mail.gmail.com>
	<d9def9db0805210954t3a36c837g6fdbe37171330acb@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 40, Issue 74
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1027439679=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1027439679==
Content-Type: multipart/alternative;
	boundary="----=_Part_5936_30414617.1211395893161"

------=_Part_5936_30414617.1211395893161
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks, Markus
I forward the message to the one who is really having the issue. I use
Gentoo abd it's working fine for me, thanks.

Best regards
  Eduard

2008/5/21, Markus Rechberger <mrechberger@gmail.com>:
>
> Hi,
>
> 2008/5/21 Eduard Huguet <eduardhc@gmail.com>:
>
> >> ---------- Missatge reenviat ----------
> >> From: bvidinli <bvidinli@gmail.com>
> >> To: stev391@email.com, linux-dvb@linuxtv.org
> >> Date: Wed, 21 May 2008 16:10:08 +0300
> >> Subject: [linux-dvb] fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,
> >> kernel 2.6.24-16-generic (bvidinli)
> >> This problem persists, continues,
> >> does anybody have suggestions ?
> >>
> >> i continue on my search of this problem...
> >>
> >> thanks.
> >
> >
> > I'm sorry :(. I'm really not an Ubuntu expert, so I really can't help you
> a
> > lot on this one. However, as the problem is clearly that you are mixing
> the
> > old modules with newest ones, you should maybe consider compiling
> yourself a
> > custrom  kernel for your machine with the DVB / V4L support removed, and
> > then compile  LinuxTV drivers as described.
> >
> > Regards
> >
> >
>
>
> Do you have any debug messages?
> You need to compile the linuxtv code against the linux ubuntu modules
> package, only problem here the linuxtv code isnt prepared to do so,
> the easiest way is to cut out the saa module and integrate it into the
> linux ubuntu modules source package and regenerate the lum package for
> installing it.
>
>
> Markus
>

------=_Part_5936_30414617.1211395893161
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks, Markus<br>I forward the message to the one who is really having the issue. I use Gentoo abd it&#39;s working fine for me, thanks.<br><br>Best regards<br>&nbsp; Eduard<br><br><div><span class="gmail_quote">2008/5/21, Markus Rechberger &lt;<a href="mailto:mrechberger@gmail.com">mrechberger@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br> <br> 2008/5/21 Eduard Huguet &lt;<a href="mailto:eduardhc@gmail.com">eduardhc@gmail.com</a>&gt;:<br> <br>&gt;&gt; ---------- Missatge reenviat ----------<br> &gt;&gt; From: bvidinli &lt;<a href="mailto:bvidinli@gmail.com">bvidinli@gmail.com</a>&gt;<br>
 &gt;&gt; To: <a href="mailto:stev391@email.com">stev391@email.com</a>, <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br> &gt;&gt; Date: Wed, 21 May 2008 16:10:08 +0300<br> &gt;&gt; Subject: [linux-dvb] fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,<br>
 &gt;&gt; kernel 2.6.24-16-generic (bvidinli)<br> &gt;&gt; This problem persists, continues,<br> &gt;&gt; does anybody have suggestions ?<br> &gt;&gt;<br> &gt;&gt; i continue on my search of this problem...<br> &gt;&gt;<br>
 &gt;&gt; thanks.<br> &gt;<br> &gt;<br> &gt; I&#39;m sorry :(. I&#39;m really not an Ubuntu expert, so I really can&#39;t help you a<br> &gt; lot on this one. However, as the problem is clearly that you are mixing the<br>
 &gt; old modules with newest ones, you should maybe consider compiling yourself a<br> &gt; custrom&nbsp;&nbsp;kernel for your machine with the DVB / V4L support removed, and<br> &gt; then compile&nbsp;&nbsp;LinuxTV drivers as described.<br>
 &gt;<br> &gt; Regards<br> &gt;<br> &gt;<br> <br> <br>Do you have any debug messages?<br> You need to compile the linuxtv code against the linux ubuntu modules<br> package, only problem here the linuxtv code isnt prepared to do so,<br>
 the easiest way is to cut out the saa module and integrate it into the<br> linux ubuntu modules source package and regenerate the lum package for<br> installing it.<br> <br><br> Markus<br> </blockquote></div><br>

------=_Part_5936_30414617.1211395893161--


--===============1027439679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1027439679==--
