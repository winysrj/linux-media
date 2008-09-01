Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway04.websitewelcome.com ([67.18.39.3])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KaBl6-0001jc-IC
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 17:56:05 +0200
Received: from [77.109.104.26] (port=51633 helo=[192.168.1.3])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1KaBky-0003zQ-QT
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 10:55:57 -0500
Message-ID: <48BC108C.1000802@kipdola.com>
Date: Mon, 01 Sep 2008 17:55:56 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48B9360D.7030303@gmail.com>
	<20080901120601.044ddc30@mchehab.chehab.org>
In-Reply-To: <20080901120601.044ddc30@mchehab.chehab.org>
Subject: Re: [linux-dvb] Merge multiproto tree
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1672715079=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1672715079==
Content-Type: multipart/alternative;
 boundary="------------090906020602080503080609"

This is a multi-part message in MIME format.
--------------090906020602080503080609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

At the risk of getting into this thing, I must admit I didn't know about 
these rivalries on the list.
I have only followed the production of multiproto for the past 6 months, 
not as a developer but as someone who just wants to get his DVB-S2 card 
going.

You say a lot of people back this new API-idea, but I honestly can't 
wait another 2 years to get proper support for my card. Am I wrong into 
thinking that, should multiproto be merged today, major applications 
will start to really support it long before this new api will get 
finalised?

I believe Manu also shot down the theory that multiproto wouldn't be 
able to support future modulations?

It might be so that designing a whole new api might be easier for these 
new standards in the future, but haven't we waited long enough? If it's 
true what Manu's saying, tweaking multiproto to handle these new 
standards wouldn't be that hard, and since there is no hardware for 
these new modulations anyway, shouldn't dvb-s2 get some priority?


/Met vriendelijke groeten,/

*Jelle De Loecker*
Kipdola Studios - Tomberg


Mauro Carvalho Chehab schreef:
> Hello, Manu,
>
> On Sat, 30 Aug 2008, Manu Abraham wrote:
>
>   
>>  Hello Mauro,
>>
>>  Please pull from http://jusst.de/hg/multiproto_api_merge/
>>  to merge the following Changesets from the multiproto tree.
>>     
>
> The need for supporting newer DTV protocols increases day by day, since when
> the first multiproto proposal started to be discussed, about two years ago.
>
> At the end of the last year, Steven send one email to the ML with a different 
> API proposal. Yet, people decided to wait for your work to be done. People then 
> pinged you, from time to time, asking about the completion of multiproto. All 
> the times, your answer were that multiproto were not ready yet for production.
>
> I'm aware that your solution seems to be more code-complete than Steven's 
> proposal.
>
> But the recent activity on the mailing list regarding his idea (and its, 
> so far, positive feedback) and the fact that I was anyway planning to 
> have a discussion about the future of the DVB-API at the Linux Plumbers 
> Conference 2008 are supporting me in my idea of post-poning such a pull to 
> a point in time shortly after this event.
>
> Cheers,
> Mauro
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

--------------090906020602080503080609
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
At the risk of getting into this thing, I must admit I didn't know
about these rivalries on the list.<br>
I have only followed the production of multiproto for the past 6
months, not as a developer but as someone who just wants to get his
DVB-S2 card going.<br>
<br>
You say a lot of people back this new API-idea, but I honestly can't
wait another 2 years to get proper support for my card. Am I wrong into
thinking that, should multiproto be merged today, major applications
will start to really support it long before this new api will get
finalised? <br>
<br>
I believe Manu also shot down the theory that multiproto wouldn't be
able to support future modulations?<br>
<br>
It might be so that designing a whole new api might be easier for these
new standards in the future, but haven't we waited long enough? If it's
true what Manu's saying, tweaking multiproto to handle these new
standards wouldn't be that hard, and since there is no hardware for
these new modulations anyway, shouldn't dvb-s2 get some priority?<br>
<br>
<div class="moz-signature"><br>
<em>Met vriendelijke groeten,</em>
<br>
<br>
<strong>Jelle De Loecker</strong>
<br>
Kipdola Studios - Tomberg <br>
</div>
<br>
<br>
Mauro Carvalho Chehab schreef:
<blockquote cite="mid:20080901120601.044ddc30@mchehab.chehab.org"
 type="cite">
  <pre wrap="">Hello, Manu,

On Sat, 30 Aug 2008, Manu Abraham wrote:

  </pre>
  <blockquote type="cite">
    <pre wrap=""> Hello Mauro,

 Please pull from <a class="moz-txt-link-freetext" href="http://jusst.de/hg/multiproto_api_merge/">http://jusst.de/hg/multiproto_api_merge/</a>
 to merge the following Changesets from the multiproto tree.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
The need for supporting newer DTV protocols increases day by day, since when
the first multiproto proposal started to be discussed, about two years ago.

At the end of the last year, Steven send one email to the ML with a different 
API proposal. Yet, people decided to wait for your work to be done. People then 
pinged you, from time to time, asking about the completion of multiproto. All 
the times, your answer were that multiproto were not ready yet for production.

I'm aware that your solution seems to be more code-complete than Steven's 
proposal.

But the recent activity on the mailing list regarding his idea (and its, 
so far, positive feedback) and the fact that I was anyway planning to 
have a discussion about the future of the DVB-API at the Linux Plumbers 
Conference 2008 are supporting me in my idea of post-poning such a pull to 
a point in time shortly after this event.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  </pre>
</blockquote>
</body>
</html>

--------------090906020602080503080609--


--===============1672715079==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1672715079==--
