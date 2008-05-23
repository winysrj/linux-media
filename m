Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway15.websitewelcome.com ([69.93.243.14])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JzPzn-0007wG-0K
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 07:39:16 +0200
Received: from [77.109.107.89] (port=33551 helo=[192.168.1.3])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1JzPzc-0006NN-Sz
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 00:39:05 -0500
Message-ID: <4836587B.6080904@kipdola.com>
Date: Fri, 23 May 2008 07:39:07 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4835EF00.2030306@kipdola.com>
In-Reply-To: <4835EF00.2030306@kipdola.com>
Subject: Re: [linux-dvb] Multiproto annoying compilation error
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0682027297=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0682027297==
Content-Type: multipart/alternative;
 boundary="------------080805080300000101000108"

This is a multi-part message in MIME format.
--------------080805080300000101000108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jelle De Loecker schreef:
> I've recently declared success on installing the multiproto drivers on 
> LinuxMCE 0710 (kubuntu 7.10)
> After a lot of hard work, I created a guide which did it like a charm 
> ( http://skerit.kipdola.com/?p=5&language=en )
> Now, I reinstalled linuxmce again, but I mistakenly installed the 
> newer multiproto_plus version, like previously, nothing loaded:
>
>     [   76.128799] saa7146: register extension 'budget_ci dvb'.
>     [   76.238955] Linux video capture interface: v2.00
>     [   76.671737] saa7146: register extension 'dvb'.
>
> No bad, I expected it to load nothing.
> So I remove all the modules, I delete every bit of source code, I try 
> to use my own guide and I get *absolutely nothing*!
>
>     [  192.299179] saa7146: register extension 'budget_ci dvb'.
>
> I've rebooted so many times I've lost count! I've removed all the 
> drivers again, rebooted, reinstalled, it just won't load again!
> Does anyone have *any* idea as to why it's not working? I'm really 
> getting desperate.
Very weird,

I let LinuxMCE reinstall on it's own tonight (as I don't really have a 
choice, and it goes quite fast, thank god)
and now I followed my own guide from the beginning and still nothing! I 
have NO idea where it's going wrong...

--------------080805080300000101000108
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Jelle De Loecker schreef:
<blockquote cite="mid:4835EF00.2030306@kipdola.com" type="cite">I've
recently declared success on installing the multiproto drivers on
LinuxMCE 0710 (kubuntu 7.10)<br>
After a lot of hard work, I created a guide which did it like a charm (
  <a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://skerit.kipdola.com/?p=5&amp;language=en">http://skerit.kipdola.com/?p=5&amp;language=en</a>
)<br>
Now, I reinstalled linuxmce again, but I mistakenly installed the newer
multiproto_plus version, like previously, nothing loaded:<br>
  <blockquote>[&nbsp;&nbsp; 76.128799] saa7146: register extension 'budget_ci
dvb'.<br>
[&nbsp;&nbsp; 76.238955] Linux video capture interface: v2.00<br>
[&nbsp;&nbsp; 76.671737] saa7146: register extension 'dvb'.<br>
  </blockquote>
No bad, I expected it to load nothing.<br>
So I remove all the modules, I delete every bit of source code, I try
to use my own guide and I get *absolutely nothing*! <br>
  <blockquote>[&nbsp; 192.299179] saa7146: register extension 'budget_ci
dvb'.<br>
  </blockquote>
I've rebooted so many times I've lost count! I've removed all the
drivers again, rebooted, reinstalled, it just won't load again! <br>
Does anyone have *any* idea as to why it's not working? I'm really
getting desperate.<br>
</blockquote>
Very weird,<br>
<br>
I let LinuxMCE reinstall on it's own tonight (as I don't really have a
choice, and it goes quite fast, thank god)<br>
and now I followed my own guide from the beginning and still nothing! I
have NO idea where it's going wrong...<br>
</body>
</html>

--------------080805080300000101000108--


--===============0682027297==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0682027297==--
