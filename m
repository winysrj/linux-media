Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L7yXI-0000y8-Aa
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 21:41:29 +0100
Received: by qyk9 with SMTP id 9so4556757qyk.17
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 12:40:53 -0800 (PST)
Message-ID: <c74595dc0812031240n48b74468x982e2516cd57820@mail.gmail.com>
Date: Wed, 3 Dec 2008 22:40:53 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "ga ver" <gavermer@gmail.com>
In-Reply-To: <468e5d620812031227i18f646ebk1b098b88b2e56289@mail.gmail.com>
MIME-Version: 1.0
References: <468e5d620812031227i18f646ebk1b098b88b2e56289@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] error in make for scan-s2-51eceb97c3bd
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1987479497=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1987479497==
Content-Type: multipart/alternative;
	boundary="----=_Part_128424_18491362.1228336853152"

------=_Part_128424_18491362.1228336853152
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Dec 3, 2008 at 10:27 PM, ga ver <gavermer@gmail.com> wrote:

> Hi,
>
> I try to update my channels.conf file for vdr-1.7.0 and want tu use scan-s2
> make scan-s2..... gives
>
> :/usr/local/src/scan-s2# make
> gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
> In file included from diseqc.c:7:
> scan.h:86: fout: expected specifier-qualifier-list before 'fe_rolloff_t'
> make: *** [diseqc.o] Fout 1
>
RTFM?

As I wrote in README file:
scan-s2 requires Linux DVB driver API version 5.0.
The scan-s2 utility was tested with Igor M. Liplianin (liplianin@me.by) DVB
S2 API driver changeset 149a5c57c1e2
that can be obtained from:
http://mercurial.intuxication.org/hg/s2-liplianin
The sources could be obtained by running:
hg clone http://mercurial.intuxication.org/hg/s2-liplianin

*The driver directory was symbolically linked to "s2" directory. If you have
the driver in other directory,
you'll have to change the following line in Makefile to point to the right
place:
INCLUDE=-I../s2/linux/include
*

>
> Fout=Error
>
> I use Ubuntu 8.10
> Kernel : Linux gv3 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC
> 2008 x86_64 GNU/Linux
>
> thanks in advance
> gavermer
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_128424_18491362.1228336853152
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Wed, Dec 3, 2008 at 10:27 PM, ga ver <span dir="ltr">&lt;<a href="mailto:gavermer@gmail.com">gavermer@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
I try to update my channels.conf file for vdr-1.7.0 and want tu use scan-s2<br>
make scan-s2..... gives<br>
<br>
:/usr/local/src/scan-s2# make<br>
gcc -I../s2/linux/include -c diseqc.c -o diseqc.o<br>
In file included from diseqc.c:7:<br>
scan.h:86: fout: expected specifier-qualifier-list before &#39;fe_rolloff_t&#39;<br>
make: *** [diseqc.o] Fout 1<br>
</blockquote><div>RTFM?<br><br>As I wrote in README file:<br>scan-s2 requires Linux DVB driver API version 5.0.<br>The scan-s2 utility was tested with Igor M. Liplianin (<a href="mailto:liplianin@me.by">liplianin@me.by</a>) DVB S2 API driver changeset 149a5c57c1e2<br>
that can be obtained from: <br><a href="http://mercurial.intuxication.org/hg/s2-liplianin">http://mercurial.intuxication.org/hg/s2-liplianin</a><br>The sources could be obtained by running:<br>hg clone <a href="http://mercurial.intuxication.org/hg/s2-liplianin">http://mercurial.intuxication.org/hg/s2-liplianin</a><br>
<br><b>The driver directory was symbolically linked to &quot;s2&quot; directory. If you have the driver in other directory, <br>you&#39;ll have to change the following line in Makefile to point to the right place:<br>INCLUDE=-I../s2/linux/include<br>
</b>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
Fout=Error<br>
<br>
I use Ubuntu 8.10<br>
Kernel : Linux gv3 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC<br>
2008 x86_64 GNU/Linux<br>
<br>
thanks in advance<br>
gavermer<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_128424_18491362.1228336853152--


--===============1987479497==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1987479497==--
