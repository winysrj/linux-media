Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1Knw0R-00063a-RQ
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 15:56:46 +0200
Received: by qw-out-2122.google.com with SMTP id 9so9539qwb.17
	for <linux-dvb@linuxtv.org>; Thu, 09 Oct 2008 06:56:38 -0700 (PDT)
Message-ID: <c74595dc0810090656t3201f883n323a995ecc33d661@mail.gmail.com>
Date: Thu, 9 Oct 2008 15:56:38 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: ajurik@quick.cz
In-Reply-To: <200810091404.05506.ajurik@quick.cz>
MIME-Version: 1.0
References: <17614.72727.qm@web23205.mail.ird.yahoo.com>
	<200810091404.05506.ajurik@quick.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [vdr] stb0899 and tt s2-3200
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0564019063=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0564019063==
Content-Type: multipart/alternative;
	boundary="----=_Part_52665_4616953.1223560598572"

------=_Part_52665_4616953.1223560598572
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Ales,

Could you share the stb6100 documentation or point me to a place where I can
find it?

Thanks.

On Thu, Oct 9, 2008 at 2:04 PM, Ales Jurik <ajurik@quick.cz> wrote:

> On Thursday 09 of October 2008, Newsy Paper wrote:
> > Hi Igor, hi Goga777,
> >
> > it's not working with SR 30000 FEC 3/4 dvb-s2 8PSK, still the same
> problem.
> >
> > kind regards
> >
> > Newsy
> >
>
> It seems that patch from
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html is not
> applied. The internal PLL must be disabled when setting new frequency as is
> written in stb6100 documentation.
>
> Regards,
>
> Ales
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_52665_4616953.1223560598572
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi Ales,<br><br>Could you share the stb6100 documentation or point me to a place where I can find it?<br><br>Thanks.<br><br><div class="gmail_quote">On Thu, Oct 9, 2008 at 2:04 PM, Ales Jurik <span dir="ltr">&lt;<a href="mailto:ajurik@quick.cz">ajurik@quick.cz</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">On Thursday 09 of October 2008, Newsy Paper wrote:<br>
&gt; Hi Igor, hi Goga777,<br>
&gt;<br>
&gt; it&#39;s not working with SR 30000 FEC 3/4 dvb-s2 8PSK, still the same problem.<br>
&gt;<br>
&gt; kind regards<br>
&gt;<br>
&gt; Newsy<br>
&gt;<br>
<br>
It seems that patch from<br>
<a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html</a> is not<br>
applied. The internal PLL must be disabled when setting new frequency as is<br>
written in stb6100 documentation.<br>
<br>
Regards,<br>
<br>
Ales<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_52665_4616953.1223560598572--


--===============0564019063==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0564019063==--
