Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JbOIR-00011b-Mo
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 23:59:12 +0100
Received: by fg-out-1718.google.com with SMTP id 22so4417313fge.25
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 15:59:08 -0700 (PDT)
Message-ID: <ea4209750803171559q2ab79b17od0f6a6bead0dfcf6@mail.gmail.com>
Date: Mon, 17 Mar 2008 23:59:07 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: insomniac <insomniac@slackware.it>
In-Reply-To: <20080317234614.7b9a4c38@slackware.it>
MIME-Version: 1.0
References: <20080316182618.2e984a46@slackware.it> <47DE5F42.8070005@iki.fi>
	<20080317213321.01b408cd@slackware.it>
	<ea4209750803171412x63a3a711t96614c03019aaf84@mail.gmail.com>
	<20080317221546.6a4dd75e@slackware.it>
	<ea4209750803171420t55f203eev3ba21b70d93bc39f@mail.gmail.com>
	<20080317222416.38cf913f@slackware.it>
	<ea4209750803171427x45224559l4b60f804401e6c87@mail.gmail.com>
	<ea4209750803171438x34e25fb5o6bbfa91b38defa2e@mail.gmail.com>
	<20080317234614.7b9a4c38@slackware.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New unsupported device
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1667231421=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1667231421==
Content-Type: multipart/alternative;
	boundary="----=_Part_17251_26924043.1205794747597"

------=_Part_17251_26924043.1205794747597
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It's not clear that the patch worked with the differences of the source (it
has a reference to the identifier matrix). I will try to add it just to
check there's no problem with that. But tomorrw...

2008/3/17, insomniac <insomniac@slackware.it>:
>
> On Mon, 17 Mar 2008 22:38:59 +0100
>
> "Albert Comerma" <albert.comerma@gmail.com> wrote:
>
>
> > It would be very useful if you could open your device and have a look
> > on what chips it has inside. Just to check that we are in the correct
> > direction.
>
>
> It looks hard to open without breaking plastics. I tried today a couple
> of times, but if someone has experience in opening pinnacle cards,
> please tell me :-)
>
> > > > > And your source?
>
> I tried both the tarball you pointed me out, and the latest sources
> from v4l-dvb hg repository. I applied the patch from Antti on both
> source trees and tried to load modules from both after make. But no one
> succeeded. If you need, I can post again the output of dmesg from the
> mainstream repository and from the tarball you gave me.
>
>
> --
>
> Andrea Barberio
>
> a.barberio@oltrelinux.com - Linux&C.
> andrea.barberio@slackware.it - Slackware Linux Project Italia
> GPG key on http://insomniac.slackware.it/gpgkey.asc
> 2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
> SIP: 5327786, Phone: 06 916503784
>

------=_Part_17251_26924043.1205794747597
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It&#39;s not clear that the patch worked with the differences of the source (it has a reference to the identifier matrix). I will try to add it just to check there&#39;s no problem with that. But tomorrw...<br><br><div><span class="gmail_quote">2008/3/17, insomniac &lt;<a href="mailto:insomniac@slackware.it">insomniac@slackware.it</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Mon, 17 Mar 2008 22:38:59 +0100<br> <br>&quot;Albert Comerma&quot; &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt; wrote:<br> <br> <br>&gt; It would be very useful if you could open your device and have a look<br>
 &gt; on what chips it has inside. Just to check that we are in the correct<br> &gt; direction.<br> <br> <br>It looks hard to open without breaking plastics. I tried today a couple<br> of times, but if someone has experience in opening pinnacle cards,<br>
 please tell me :-)<br> <br> &gt; &gt; &gt; &gt; And your source?<br> <br> I tried both the tarball you pointed me out, and the latest sources<br> from v4l-dvb hg repository. I applied the patch from Antti on both<br> source trees and tried to load modules from both after make. But no one<br>
 succeeded. If you need, I can post again the output of dmesg from the<br> mainstream repository and from the tarball you gave me.<br> <br><br> --<br> <br>Andrea Barberio<br> <br> <a href="mailto:a.barberio@oltrelinux.com">a.barberio@oltrelinux.com</a> - Linux&amp;C.<br>
 <a href="mailto:andrea.barberio@slackware.it">andrea.barberio@slackware.it</a> - Slackware Linux Project Italia<br> GPG key on <a href="http://insomniac.slackware.it/gpgkey.asc">http://insomniac.slackware.it/gpgkey.asc</a><br>
 2818 A961 D6D8 1A8C 6E84&nbsp;&nbsp;6181 5FA6 03B2 E68A 0B7D<br> SIP: 5327786, Phone: 06 916503784<br> </blockquote></div><br>

------=_Part_17251_26924043.1205794747597--


--===============1667231421==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1667231421==--
