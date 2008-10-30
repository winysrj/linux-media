Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1Kvc0w-0002Ql-Ga
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 19:12:59 +0100
Received: by yw-out-2324.google.com with SMTP id 3so292180ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 30 Oct 2008 11:12:54 -0700 (PDT)
Message-ID: <c74595dc0810301112h3d2ccf7ar7cf5e6bfe58f90d0@mail.gmail.com>
Date: Thu, 30 Oct 2008 20:12:53 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: jean-paul@goedee.nl
In-Reply-To: <20081030094113.zlaly2uj68ssgg4o@webmail.goedee.nl>
MIME-Version: 1.0
References: <20081029164747.h5xzc1hhwo0oocww@webmail.goedee.nl>
	<c74595dc0810291211k144f4f72nbbf85b3d3b8a79aa@mail.gmail.com>
	<20081030094113.zlaly2uj68ssgg4o@webmail.goedee.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Update: S2API , scan-s2, TT 3200_CI, VDR 1.7.0,
	Streamdev (latest version)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1708096225=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1708096225==
Content-Type: multipart/alternative;
	boundary="----=_Part_13440_27855934.1225390374016"

------=_Part_13440_27855934.1225390374016
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Do you have Igor's driver in ../s2/ directory?

RTFM?

Here's the part that I wrote in README:
The driver directory was symbolically linked to "s2" directory. If you have
the driver in other directory,
you'll have to change the following line in Makefile to point to the right
place:
INCLUDE=3D-I../s2/linux/include


On Thu, Oct 30, 2008 at 10:41 AM, <jean-paul@goedee.nl> wrote:

> compiled on opensuse 11.0 default.
>
>
> gcc -I../s2/linux/include -c atsc_psip_section.c -o atsc_psip_section.o
> gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
> gcc -I../s2/linux/include -c dump-vdr.c -o dump-vdr.o
> gcc -I../s2/linux/include -c dump-zap.c -o dump-zap.o
> gcc -I../s2/linux/include -c lnb.c -o lnb.o
> gcc -I../s2/linux/include -c scan.c -o scan.o
> scan.c: In function =E2tune_to_transponder=E2:
> scan.c:1669: error: =E2SYS_DSS=E2 undeclared (first use in this function)
> scan.c:1669: error: (Each undeclared identifier is reported only once
> scan.c:1669: error: for each function it appears in.)
> scan.c: In function =E2scan_tp=E2:
> scan.c:2048: error: =E2SYS_DSS=E2 undeclared (first use in this function)
> make: *** [scan.o] Error 1
>
> Jean-Paul
>
>
>
>  Please specify what was the error in scan-s2 compilation and what
>> changeset
>> you've used?
>>
>>
>> On Wed, Oct 29, 2008 at 5:47 PM, <jean-paul@goedee.nl> wrote:
>>
>>  S2API (drivers) latest version compile without error, Compiling
>>> scan-s2 give a error on DDS or something like that. Remove it from
>>> scan.c and compile it again.
>>>
>>> Scanning booth LNB?s (astra 1  & 3) and only normal S. Try al options
>>> but no S2 channels.  Compile VDR with S2API patch and streamdev
>>> plugin. No problem so far. Copy the new channels.conf to the vdr
>>> directory and start vdr. Tuning to FTA channels is no problem but
>>> encrypt channels are not available. For so far as I can see the caids
>>> are correct (verify with the caids of mij production system  (also
>>> 2*tt 3200 incl cam/card and multiproto/vdr 1.7.0 and off Corse
>>> streamdev.
>>>
>>> No S2 channels, No encrypt channels.
>>>
>>> Regards
>>>
>>> Jean-Paul
>>>
>>>
>>>
>>>
>>>
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>
>>
>
>
>

------=_Part_13440_27855934.1225390374016
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div dir=3D"ltr">Do you have Igor&#39;s driver in ../s2/ directory?<br><br>=
RTFM?<br><br>Here&#39;s the part that I wrote in README:<br>The driver dire=
ctory was symbolically linked to &quot;s2&quot; directory. If you have the =
driver in other directory, <br>
you&#39;ll have to change the following line in Makefile to point to the ri=
ght place:<br>INCLUDE=3D-I../s2/linux/include<br><br><br><div class=3D"gmai=
l_quote">On Thu, Oct 30, 2008 at 10:41 AM,  <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jean-paul@goedee.nl">jean-paul@goedee.nl</a>&gt;</span> wrote:<b=
r>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">compiled on opens=
use 11.0 default.<br>
<br>
<br>
gcc -I../s2/linux/include -c atsc_psip_section.c -o atsc_psip_section.o<br>
gcc -I../s2/linux/include -c diseqc.c -o diseqc.o<br>
gcc -I../s2/linux/include -c dump-vdr.c -o dump-vdr.o<br>
gcc -I../s2/linux/include -c dump-zap.c -o dump-zap.o<br>
gcc -I../s2/linux/include -c lnb.c -o lnb.o<br>
gcc -I../s2/linux/include -c scan.c -o scan.o<br>
scan.c: In function =E2tune_to_transponder=E2:<br>
scan.c:1669: error: =E2SYS_DSS=E2 undeclared (first use in this function)<b=
r>
scan.c:1669: error: (Each undeclared identifier is reported only once<br>
scan.c:1669: error: for each function it appears in.)<br>
scan.c: In function =E2scan_tp=E2:<br>
scan.c:2048: error: =E2SYS_DSS=E2 undeclared (first use in this function)<b=
r>
make: *** [scan.o] Error 1<br>
<br>
Jean-Paul<div><div></div><div class=3D"Wj3C7c"><br>
<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Please specify what was the error in scan-s2 compilation and what changeset=
<br>
you&#39;ve used?<br>
<br>
<br>
On Wed, Oct 29, 2008 at 5:47 PM, &lt;<a href=3D"mailto:jean-paul@goedee.nl"=
 target=3D"_blank">jean-paul@goedee.nl</a>&gt; wrote:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
S2API (drivers) latest version compile without error, Compiling<br>
scan-s2 give a error on DDS or something like that. Remove it from<br>
scan.c and compile it again.<br>
<br>
Scanning booth LNB?s (astra 1 &nbsp;&amp; 3) and only normal S. Try al opti=
ons<br>
but no S2 channels. &nbsp;Compile VDR with S2API patch and streamdev<br>
plugin. No problem so far. Copy the new channels.conf to the vdr<br>
directory and start vdr. Tuning to FTA channels is no problem but<br>
encrypt channels are not available. For so far as I can see the caids<br>
are correct (verify with the caids of mij production system &nbsp;(also<br>
2*tt 3200 incl cam/card and multiproto/vdr 1.7.0 and off Corse<br>
streamdev.<br>
<br>
No S2 channels, No encrypt channels.<br>
<br>
Regards<br>
<br>
Jean-Paul<br>
<br>
<br>
<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-dvb@linuxt=
v.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
<br>
</blockquote>
<br>
</blockquote>
<br>
<br>
<br>
</div></div></blockquote></div><br></div>

------=_Part_13440_27855934.1225390374016--


--===============1708096225==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1708096225==--
