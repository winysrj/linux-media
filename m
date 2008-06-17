Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <meysam.hariri@gmail.com>) id 1K8ixn-0001Uj-U3
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 23:43:51 +0200
Received: by yw-out-2324.google.com with SMTP id 3so3151268ywj.41
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 14:41:33 -0700 (PDT)
Message-ID: <1a18e9e80806171441l3e0f6fd2x7d2b7590dc13f493@mail.gmail.com>
Date: Wed, 18 Jun 2008 02:11:32 +0430
From: "Meysam Hariri" <meysam.hariri@gmail.com>
To: ajurik@quick.cz
In-Reply-To: <200806172316.22039.ajurik@quick.cz>
MIME-Version: 1.0
References: <1a18e9e80806171353x49b36059h17dcfb40f6bfe7b0@mail.gmail.com>
	<200806172316.22039.ajurik@quick.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT 3200 locking on 8PSK channels fail
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1564694932=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1564694932==
Content-Type: multipart/alternative;
	boundary="----=_Part_5074_30921272.1213738892722"

------=_Part_5074_30921272.1213738892722
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Jun 18, 2008 at 1:46 AM, Ales Jurik <ajurik@quick.cz> wrote:

> On Tuesday 17 of June 2008, Meysam Hariri wrote:
> > After successfull compilation of multiproto drivers and dvb-utils with
> > patched szap on linux kernel 2.6.25.7, locking works great on dvb-s2
> > channels with QPSK modulation but no chance on 8PSK. the patched szap and
> > the unpached version also lock on dvb-s channels but i need to run szap
> > multiple times until i get lock.on an 8PSK channel with FEC 9/10 locking
> > fails totally and i could never get lock. any suggestions?
> >
> > Regards,
>
> Hi,
>
> your problem seems to correspond with problem in this thread:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026020.html.
>
> But I'm able to get without problem lock on some channels DVB-S2, 8PSK and
> FEC2/3 (SkyItalia from 13.0E) but not on channels with higher FEC.
>
> I've tried only on FEC 3/4 - which channels with FEC 9/10 did you tested?
>
> Regards,
>
> Ales
>
>
> Hi,

I'm trying to lock on 21.5E 11449 MHz s/r 30000 , FEC 9/10 and with 8PSK
modulation (DVB-IP) .
i've increased/decreased the Freq by 4-10 MHz increments and also the S/R.
not any combination helped getting lock on the channel.
I've no problem getting lock on this frequency using factory drivers on
Windows XP, so it's a software issue.
the other S2 channels on the same position do lock without any change on
freq/symrate but they are QPSK and have lower FECs.

Regards,

------=_Part_5074_30921272.1213738892722
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Wed, Jun 18, 2008 at 1:46 AM, Ales Jurik &lt;<a href="mailto:ajurik@quick.cz">ajurik@quick.cz</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class="Wj3C7c">On Tuesday 17 of June 2008, Meysam Hariri wrote:<br>
&gt; After successfull compilation of multiproto drivers and dvb-utils with<br>
&gt; patched szap on linux kernel <a href="http://2.6.25.7" target="_blank">2.6.25.7</a>, locking works great on dvb-s2<br>
&gt; channels with QPSK modulation but no chance on 8PSK. the patched szap and<br>
&gt; the unpached version also lock on dvb-s channels but i need to run szap<br>
&gt; multiple times until i get lock.on an 8PSK channel with FEC 9/10 locking<br>
&gt; fails totally and i could never get lock. any suggestions?<br>
&gt;<br>
&gt; Regards,<br>
<br>
</div></div>Hi,<br>
<br>
your problem seems to correspond with problem in this thread:<br>
<a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026020.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026020.html</a>.<br>
<br>
But I&#39;m able to get without problem lock on some channels DVB-S2, 8PSK and<br>
FEC2/3 (SkyItalia from 13.0E) but not on channels with higher FEC.<br>
<br>
I&#39;ve tried only on FEC 3/4 - which channels with FEC 9/10 did you tested?<br>
<br>
Regards,<br>
<font color="#888888"><br>
Ales<br>
<br>
<br>
</font></blockquote></div>Hi,<br><br>I&#39;m trying to lock on 21.5E 11449 MHz s/r 30000 , FEC 9/10 and with 8PSK modulation (DVB-IP) .<br>i&#39;ve increased/decreased the Freq by 4-10 MHz increments and also the S/R.&nbsp; not any combination helped getting lock on the channel.<br>
I&#39;ve no problem getting lock on this frequency using factory drivers on Windows XP, so it&#39;s a software issue.<br>the other S2 channels on the same position do lock without any change on freq/symrate but they are QPSK and have lower FECs.<br>
<br>Regards,<br>

------=_Part_5074_30921272.1213738892722--


--===============1564694932==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1564694932==--
