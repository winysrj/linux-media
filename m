Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.krastelcom.ru ([88.151.248.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpr@krastelcom.ru>) id 1JXacc-0008NC-9C
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 12:20:24 +0100
Message-Id: <095B3360-51E4-4905-A4AA-1C49C2C02943@krastelcom.ru>
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: Igor <goga777@bk.ru>
In-Reply-To: <E1JXaPT-0008Gj-00.goga777-bk-ru@f62.mail.ru>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Fri, 7 Mar 2008 14:20:13 +0300
References: <E723A8FD-137B-499A-8F6A-DC19E8AF919F@krastelcom.ru>
	<E1JXaPT-0008Gj-00.goga777-bk-ru@f62.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : TT S2-3200. No lock on high symbol rate
	(45M)transponders
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1880238751=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1880238751==
Content-Type: multipart/alternative; boundary=Apple-Mail-175--1051652834


--Apple-Mail-175--1051652834
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

No, it was checked with a digital receiver. Everything is fine. I've  
tried 2 transponders.

I'm trying AM2 - 80e, 11044 H,
11606 V

Regards,
Vladimir

On Mar 7, 2008, at 2:06 PM, Igor wrote:

> may be the transponder with high SR has weak signal ?
>
> Igor
>
>
> -----Original Message-----
> From: Vladimir Prudnikov <vpr@krastelcom.ru>
> To: Manu Abraham <abraham.manu@gmail.com>
> Date: Fri, 7 Mar 2008 10:32:05 +0300
> Subject: Re: [linux-dvb] Re : TT S2-3200. No lock on high symbol  
> rate (45M)transponders
>
>>
>> Reverted registers. No difference. Low SR - fine.
>> High SR - no lock.
>>
>> Regards,
>> Vladimir
>>
>>
>> On Mar 7, 2008, at 3:23 AM, Manu Abraham wrote:
>>
>>> manu wrote:
>>>> On 03/06/2008 06:34:28 AM, Vladimir Prudnikov wrote:
>>>>> Can't get TT S2-3200 locked on high SR transponders. I have seen a
>>>>> lot
>>>>>
>>>>> of suggestions regarding changing Frequency/Symbol rate on various
>>>>> forums but no luck. Low SR are fine.
>>>>> Does anyone have a "revision" of multiproto that was tested with
>>>>> high
>>>>>
>>>>> SR?
>>>>>
>>>>> I hope Manu can comment on that as well...
>>>>>
>>>> Just a "me too", well kind of: for me certain transponders do not
>>>> lock
>>>> or lock but with corrupted streams whereas others are perfect (on  
>>>> the
>>>> same sat with the same characteristics, SR is 30M).
>>>
>>>
>>> Please try whether these register setup changes does help as
>>> applicable.
>>>
>>> http://jusst.de/hg/mantis/rev/72e81184fb9f
>>>
>>> Regards,
>>> Manu
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>


--Apple-Mail-175--1051652834
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div>No, it was checked with a =
digital receiver. Everything is fine. I've tried 2 =
transponders.</div><div><br></div><div>I'm trying AM2 - 80e,&nbsp;<span =
class=3D"Apple-style-span" style=3D"font-family: Verdana; font-size: =
13px; font-weight: bold; ">11044 H,</span></div><div><font =
class=3D"Apple-style-span" face=3D"Verdana" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 13px;"><b>11606 =
V</b></span></font></div><div><br></div><div>Regards,</div><div>Vladimir</=
div><br><div><div>On Mar 7, 2008, at 2:06 PM, Igor wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite">may be the =
transponder with high SR has weak signal =
?<br><br>Igor<br><br><br>-----Original Message-----<br>From: Vladimir =
Prudnikov &lt;<a =
href=3D"mailto:vpr@krastelcom.ru">vpr@krastelcom.ru</a>&gt;<br>To: Manu =
Abraham &lt;<a =
href=3D"mailto:abraham.manu@gmail.com">abraham.manu@gmail.com</a>&gt;<br>D=
ate: Fri, 7 Mar 2008 10:32:05 +0300<br>Subject: Re: [linux-dvb] Re : TT =
S2-3200. No lock on high symbol rate =
(45M)transponders<br><br><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Reverted =
registers. No difference. Low SR - fine.<br></blockquote><blockquote =
type=3D"cite">High SR - no lock.<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">Regards,<br></blockquote><blockquote =
type=3D"cite">Vladimir<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">On Mar 7, 2008, =
at 3:23 AM, Manu Abraham wrote:<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">manu wrote:<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite">On =
03/06/2008 06:34:28 AM, Vladimir Prudnikov =
wrote:<br></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote type=3D"cite">Can't get TT S2-3200 locked on =
high SR transponders. I have seen =
a<br></blockquote></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote =
type=3D"cite">lot<br></blockquote></blockquote></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote type=3D"cite">of suggestions regarding =
changing Frequency/Symbol rate on =
various<br></blockquote></blockquote></blockquote></blockquote><blockquote=
 type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote type=3D"cite">forums but no luck. Low SR are =
fine.<br></blockquote></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote type=3D"cite">Does anyone have a "revision" of =
multiproto that was tested with =
&nbsp;<br></blockquote></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote =
type=3D"cite">high<br></blockquote></blockquote></blockquote></blockquote>=
<blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote =
type=3D"cite">SR?<br></blockquote></blockquote></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote type=3D"cite">I hope Manu can comment on that =
as =
well...<br></blockquote></blockquote></blockquote></blockquote><blockquote=
 type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite">Just a "me too", well kind of: for me certain transponders =
do not &nbsp;<br></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite">lock<br></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite">or =
lock but with corrupted streams whereas others are perfect (on =
the<br></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite">same =
sat with the same characteristics, SR is =
30M).<br></blockquote></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">Please try whether these =
register setup changes does help as =
&nbsp;<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">applicable.<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite"><a =
href=3D"http://jusst.de/hg/mantis/rev/72e81184fb9f">http://jusst.de/hg/man=
tis/rev/72e81184fb9f</a><br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite">Regards,<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite">Manu<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite"><br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote =
type=3D"cite">_______________________________________________<br></blockqu=
ote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">linux-dvb mailing =
list<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite"><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br></block=
quote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></b=
lockquote><blockquote type=3D"cite"><br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">_______________________________________________<br></blockqu=
ote><blockquote type=3D"cite">linux-dvb mailing =
list<br></blockquote><blockquote type=3D"cite"><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br></block=
quote><blockquote type=3D"cite"><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote><bl=
ockquote =
type=3D"cite"><br></blockquote></blockquote></div><br></body></html>=

--Apple-Mail-175--1051652834--


--===============1880238751==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1880238751==--
