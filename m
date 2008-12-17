Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1LD3fb-000338-E0
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 22:11:04 +0100
Received: by qyk9 with SMTP id 9so115028qyk.17
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 13:10:28 -0800 (PST)
Message-ID: <c74595dc0812171310n3f8862b2w18f1f15c272af231@mail.gmail.com>
Date: Wed, 17 Dec 2008 23:10:27 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "ga ver" <gavermer@gmail.com>
In-Reply-To: <468e5d620812171159g49b87f0bu484d5445c695249f@mail.gmail.com>
MIME-Version: 1.0
References: <468e5d620812171159g49b87f0bu484d5445c695249f@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Linux DVB driver API version 5.0?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1641627978=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1641627978==
Content-Type: multipart/alternative;
	boundary="----=_Part_12966_23045972.1229548227174"

------=_Part_12966_23045972.1229548227174
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Dec 17, 2008 at 9:59 PM, ga ver <gavermer@gmail.com> wrote:

> Hi
> I download the S2API driver from
> hg clone http://mercurial.intuxication.org/hg/s2-liplianin
> make and make install OK
>
> I try to install scan-s2 and got
> /usr/local/src# cd scan-s2
> root@gv3:/usr/local/src/scan-s2# make
> gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
> In file included from diseqc.c:7:
> scan.h:86: fout: expected specifier-qualifier-list before 'fe_rolloff_t'
> make: *** [diseqc.o] Fout 1
>
> Installing vdr-1.7.2 gives
> /usr/local/src/vdr-1.7.2# make
> In file included from audio.c:12:
> dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version
> 5.0!
> In file included from dvbdevice.c:10:
> dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version
> 5.0!
> In file included from dvbosd.c:15:
>
> Is this not de right driver?, or what is wrong

Hint: README


>
>
> gaver
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_12966_23045972.1229548227174
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">On Wed, Dec 17, 2008 at 9:59 PM, ga ver <span dir="ltr">&lt;<a href="mailto:gavermer@gmail.com">gavermer@gmail.com</a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi<br>
I download the S2API driver from<br>
hg clone <a href="http://mercurial.intuxication.org/hg/s2-liplianin" target="_blank">http://mercurial.intuxication.org/hg/s2-liplianin</a><br>
make and make install OK<br>
<br>
I try to install scan-s2 and got<br>
/usr/local/src# cd scan-s2<br>
root@gv3:/usr/local/src/scan-s2# make<br>
gcc -I../s2/linux/include -c diseqc.c -o diseqc.o<br>
In file included from diseqc.c:7:<br>
scan.h:86: fout: expected specifier-qualifier-list before &#39;fe_rolloff_t&#39;<br>
make: *** [diseqc.o] Fout 1<br>
<br>
Installing vdr-1.7.2 gives<br>
/usr/local/src/vdr-1.7.2# make<br>
In file included from audio.c:12:<br>
dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version 5.0!<br>
In file included from dvbdevice.c:10:<br>
dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version 5.0!<br>
In file included from dvbosd.c:15:<br>
<br>
Is this not de right driver?, or what is wrong</blockquote><div>Hint: README<br>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>
gaver<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div>

------=_Part_12966_23045972.1229548227174--


--===============1641627978==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1641627978==--
