Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway12.websitewelcome.com ([67.18.68.6])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KcneF-0004o3-Ek
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 22:47:49 +0200
Received: from [77.109.104.26] (port=53448 helo=[192.168.1.12])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1Kcne7-0005vx-Dv
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 15:47:39 -0500
Message-ID: <48C58F6B.9000609@kipdola.com>
Date: Mon, 08 Sep 2008 22:47:39 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <364203.80680.qm@web46101.mail.sp1.yahoo.com>
	<48C58D03.8040004@gmail.com>
In-Reply-To: <48C58D03.8040004@gmail.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2120225132=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============2120225132==
Content-Type: multipart/alternative;
 boundary="------------040001060403090401090101"

This is a multi-part message in MIME format.
--------------040001060403090401090101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Is there any change in the cultiproto disecq code?

For example
MythTV won't tune to channels on disecq port 2 or higher. (Disecq port 1 
always works)

However, Kaffeine works. I'm able to watch every BBC channel on Astra 
28,2 (which is on my second port)

This made me think it's MythTV.
But a friend of mine now said an older, regular DVB-S card DOES work 
with disecq.

I must point out that I'm not using the latest multiproto drivers, the 
one with the old_api support (so that I don't have to patch mythtv)

/Met vriendelijke groeten,/

*Jelle De Loecker*
Kipdola Studios - Tomberg


Manu Abraham schreef:
> barry bouwsma wrote:
>   
>> Ciao,
>>
>>     
>
> [..]
>
>   
>> What I wonder, is two things.
>>
>> Does DiSEqC 1.1 fit into the existing API, and is it more of
>> a question of hardware support (generally I've noticed 1.0 and
>> 1.2 listed), and applications being able to handle the additional
>> switching (I've found an app limit of 4 positions)?
>>     
>
> Cascading is not supported by the dvb-apps, i must say. It's more of a
> support from the application side.
>
> As far as multiproto goes, the driver used alongwith it supports DiSEqC 2.0
>
>
>   
>> I don't know enough about the internals of DiSEqC to have any idea
>> what I'm talking about; I've got a 1.1 switch on order, and I have
>> a 1.1-able 8/1+16/1 receiver, where those appear to be incompatible
>> with my existing 4/1 switch.
>>
>>
>> Second, how do non-DVB-like technologies like DAB (Eureka-147) fit
>> into the scope of either multiproto or S2API -- or must they
>> remain outside of v4l-dvb?
>>     
>
>
> There is already a kernel module called dabusb for ages.
>
>
>   
>> The Wiki sez, ``some developers already have hardware using
>> standards unsupported by multiproto, such as ISDB-T and DMB-T/H.''
>> And some of us non-developers have such hardware and want to try
>> it with non-Windows for readily-receiveable DAB.
>>     
>
> With some simple definitions ? What applications are used ? With regards
> to ISDB-T, there was an idea to integrate the ARIB extension used in the
> DVB V4 API, but then it was proven that there wasn't much use for the
> same due to:
>
> * lack of available hardware (only some mobile devices using 1 seg or
> likewise were available) Of course, there was the demodulator from
> Toshiba TCxxxx, the DVB V4 API which it was based on.
>
> * most of the stuff's completely scrambled and the scrambling schemes
> are not open like DVB stuff.
>
> But still, if there's need to add support for the same into the
> multiproto tree, it is quite trivial.
>
>   
>> Or is DAB/T-DMB too different from DVB and related technologies,
>> that a separate development path needs to be taken outside
>> linux-dvb, but probably within V4L?
>>     
>
> DMB resembles quite a bit of DAB. Well, the tables for DMB-T/H is quite
> different from standard DVB tables, but still you can use multiproto to
> handle DMB-T/H, it's quite trivial.
>
> Regards,
> Manu
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

--------------040001060403090401090101
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Is there any change in the cultiproto disecq code?<br>
<br>
For example<br>
MythTV won't tune to channels on disecq port 2 or higher. (Disecq port
1 always works)<br>
<br>
However, Kaffeine works. I'm able to watch every BBC channel on Astra
28,2 (which is on my second port)<br>
<br>
This made me think it's MythTV. <br>
But a friend of mine now said an older, regular DVB-S card DOES work
with disecq.<br>
<br>
I must point out that I'm not using the latest multiproto drivers, the
one with the old_api support (so that I don't have to patch mythtv)<br>
<div class="moz-signature"><br>
<em>Met vriendelijke groeten,</em>
<br>
<br>
<strong>Jelle De Loecker</strong>
<br>
Kipdola Studios - Tomberg <br>
<br>
</div>
<br>
Manu Abraham schreef:
<blockquote cite="mid:48C58D03.8040004@gmail.com" type="cite">
  <pre wrap="">barry bouwsma wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Ciao,

    </pre>
  </blockquote>
  <pre wrap=""><!---->
[..]

  </pre>
  <blockquote type="cite">
    <pre wrap="">What I wonder, is two things.

Does DiSEqC 1.1 fit into the existing API, and is it more of
a question of hardware support (generally I've noticed 1.0 and
1.2 listed), and applications being able to handle the additional
switching (I've found an app limit of 4 positions)?
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Cascading is not supported by the dvb-apps, i must say. It's more of a
support from the application side.

As far as multiproto goes, the driver used alongwith it supports DiSEqC 2.0


  </pre>
  <blockquote type="cite">
    <pre wrap="">I don't know enough about the internals of DiSEqC to have any idea
what I'm talking about; I've got a 1.1 switch on order, and I have
a 1.1-able 8/1+16/1 receiver, where those appear to be incompatible
with my existing 4/1 switch.


Second, how do non-DVB-like technologies like DAB (Eureka-147) fit
into the scope of either multiproto or S2API -- or must they
remain outside of v4l-dvb?
    </pre>
  </blockquote>
  <pre wrap=""><!---->

There is already a kernel module called dabusb for ages.


  </pre>
  <blockquote type="cite">
    <pre wrap="">The Wiki sez, ``some developers already have hardware using
standards unsupported by multiproto, such as ISDB-T and DMB-T/H.''
And some of us non-developers have such hardware and want to try
it with non-Windows for readily-receiveable DAB.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
With some simple definitions ? What applications are used ? With regards
to ISDB-T, there was an idea to integrate the ARIB extension used in the
DVB V4 API, but then it was proven that there wasn't much use for the
same due to:

* lack of available hardware (only some mobile devices using 1 seg or
likewise were available) Of course, there was the demodulator from
Toshiba TCxxxx, the DVB V4 API which it was based on.

* most of the stuff's completely scrambled and the scrambling schemes
are not open like DVB stuff.

But still, if there's need to add support for the same into the
multiproto tree, it is quite trivial.

  </pre>
  <blockquote type="cite">
    <pre wrap="">Or is DAB/T-DMB too different from DVB and related technologies,
that a separate development path needs to be taken outside
linux-dvb, but probably within V4L?
    </pre>
  </blockquote>
  <pre wrap=""><!---->
DMB resembles quite a bit of DAB. Well, the tables for DMB-T/H is quite
different from standard DVB tables, but still you can use multiproto to
handle DMB-T/H, it's quite trivial.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  </pre>
</blockquote>
</body>
</html>

--------------040001060403090401090101--


--===============2120225132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2120225132==--
