Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway06.websitewelcome.com ([67.18.144.9])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JxfaR-0003HH-O7
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 11:53:53 +0200
Received: from [77.109.107.153] (port=38794 helo=[192.168.1.3])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1JxfaI-0005Hx-4d
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 04:53:42 -0500
Message-ID: <482FFCA9.9000200@kipdola.com>
Date: Sun, 18 May 2008 11:53:45 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <482CC0F0.30005@kipdola.com>	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>	<482D1AB7.3070101@kipdola.com>
	<20080518121250.7dc0eaac@bk.ru>
In-Reply-To: <20080518121250.7dc0eaac@bk.ru>
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0570946130=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0570946130==
Content-Type: multipart/alternative;
 boundary="------------040500060602080005020203"

This is a multi-part message in MIME format.
--------------040500060602080005020203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Igor Nikanov schreef:
>
> with the latest multiproto you have to use testing version of szap2 from test directory of dvb-apps
> http://linuxtv.org/hg/dvb-apps/file/31a6dd437b9a/test/szap2.c
>
> Igor
>   

Yes, thank you, I finally got szap2 to actually catch a signal and get a 
lock on it.

But since only szap2 works - what do I do now?
How can I watch the stream? (I tried to run "mplayer -fs 
/dev/dvb/adapter0/vdr0 but that never worked)
Or how can I get it to work in MythTV? Do I have to wait for the new 
utilities, which would seem rather strange since they're not used by 
mythtv, right?

Thank you,

Jelle De Loecker

--------------040500060602080005020203
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
Igor Nikanov schreef:
<blockquote cite="mid:20080518121250.7dc0eaac@bk.ru" type="cite">
  <pre wrap=""><!---->
with the latest multiproto you have to use testing version of szap2 from test directory of dvb-apps
<a class="moz-txt-link-freetext"
 href="http://linuxtv.org/hg/dvb-apps/file/31a6dd437b9a/test/szap2.c">http://linuxtv.org/hg/dvb-apps/file/31a6dd437b9a/test/szap2.c</a>

Igor
  </pre>
</blockquote>
<br>
Yes, thank you, I finally got szap2 to actually catch a signal and get
a lock on it.<br>
<br>
But since only szap2 works - what do I do now?<br>
How can I watch the stream? (I tried to run "mplayer -fs
/dev/dvb/adapter0/vdr0 but that never worked)<br>
Or how can I get it to work in MythTV? Do I have to wait for the new
utilities, which would seem rather strange since they're not used by
mythtv, right?<br>
<br>
Thank you,<br>
<br>
Jelle De Loecker<br>
</body>
</html>

--------------040500060602080005020203--


--===============0570946130==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0570946130==--
