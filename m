Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-1.orange.nl ([193.252.22.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1KysTl-0004sa-QE
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 19:24:14 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf6007.online.nl (SMTP Server) with ESMTP id 388F27000085
	for <linux-dvb@linuxtv.org>; Sat,  8 Nov 2008 19:23:40 +0100 (CET)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134])
	by mwinf6007.online.nl (SMTP Server) with ESMTP id E46737000083
	for <linux-dvb@linuxtv.org>; Sat,  8 Nov 2008 19:23:37 +0100 (CET)
Message-ID: <4915D927.1000806@verbraak.org>
Date: Sat, 08 Nov 2008 19:23:35 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4915C608.9000709@verbraak.org> <18991.1226167267@kewl.org>
In-Reply-To: <18991.1226167267@kewl.org>
Subject: Re: [linux-dvb] How to find which command generates error in
	FE_SET_PROPERTY
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0430533164=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0430533164==
Content-Type: multipart/alternative;
 boundary="------------070009010104070307060909"

This is a multi-part message in MIME format.
--------------070009010104070307060909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Darron Broad schreef:
> In message <4915C608.9000709@verbraak.org>, Michel Verbraak wrote:
>
> LO
>
>   
>> I'm trying to modify one of my applications to use the new S2API. With 
>> this application I control my dvb-t and dvb-s/s2 receivers.
>>
>> I'm using szap-s2 as an example but I run into a problem that the ioctl 
>> FE_SET_PROPERTY always returns -1 and variable errno is set to 14.
>>
>> My question is. How do I determine which of the commands in the command 
>> queue given to FE_SET_PROPERTY is producing this error. I did not try 
>> yet to devide my command queue up into one command queue per command.
>>     
>
> The only commands as such as CLEAR and TUNE, the rest are tuning
> parameters. The way this works is that the TUNE command informs
> the kernel to retune using the parameters specified. This occurs
> outside of the IOCTL call itself and you don't directly know
> if a paramater was wrong, it just doesn't work.
>
> The error you have:
>   
>> grep 14 /usr/include/asm-generic/errno-base.h
>>     
> #define EFAULT          14      /* Bad address */
>
> Suggests a problem in your code...
>
>   
>> Regards,
>>
>> Michel.
>>
>> Part of source code for dvb-s/s2:
>>
>> #ifdef S2API
>> int TDVBDevice::SetProperty(struct dtv_property *cmdseq)
>>     
>
> This should something like SetProperties(struct dtv_properties cmdseq[])
> and then call ioctl(fefd, FE_SET_PROPERTY, cmdseq)
> This sends of your args at the same time.
>
>   
>>      if (SetProperty(&p[0]) == 0)
>>     
>
> That needs to be more like:
> 	SetProperties(&cmdseq)
>
> I hope that helps.
>
> cya!
>
> --
>
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \ 
>
>   

Darron,

You were right. The error I had to solve was to change 
SetProperty(&p[0]) into SetProperty(&cmdseq).

I have been coding all day and missed this one.

Thanks,

Michel.

--------------070009010104070307060909
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Darron Broad schreef:
<blockquote cite="mid:18991.1226167267@kewl.org" type="cite">
  <pre wrap="">In message <a class="moz-txt-link-rfc2396E" href="mailto:4915C608.9000709@verbraak.org">&lt;4915C608.9000709@verbraak.org&gt;</a>, Michel Verbraak wrote:

LO

  </pre>
  <blockquote type="cite">
    <pre wrap="">I'm trying to modify one of my applications to use the new S2API. With 
this application I control my dvb-t and dvb-s/s2 receivers.

I'm using szap-s2 as an example but I run into a problem that the ioctl 
FE_SET_PROPERTY always returns -1 and variable errno is set to 14.

My question is. How do I determine which of the commands in the command 
queue given to FE_SET_PROPERTY is producing this error. I did not try 
yet to devide my command queue up into one command queue per command.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
The only commands as such as CLEAR and TUNE, the rest are tuning
parameters. The way this works is that the TUNE command informs
the kernel to retune using the parameters specified. This occurs
outside of the IOCTL call itself and you don't directly know
if a paramater was wrong, it just doesn't work.

The error you have:
  </pre>
  <blockquote type="cite">
    <pre wrap="">grep 14 /usr/include/asm-generic/errno-base.h
    </pre>
  </blockquote>
  <pre wrap=""><!---->#define EFAULT          14      /* Bad address */

Suggests a problem in your code...

  </pre>
  <blockquote type="cite">
    <pre wrap="">Regards,

Michel.

Part of source code for dvb-s/s2:

#ifdef S2API
int TDVBDevice::SetProperty(struct dtv_property *cmdseq)
    </pre>
  </blockquote>
  <pre wrap=""><!---->
This should something like SetProperties(struct dtv_properties cmdseq[])
and then call ioctl(fefd, FE_SET_PROPERTY, cmdseq)
This sends of your args at the same time.

  </pre>
  <blockquote type="cite">
    <pre wrap="">     if (SetProperty(&amp;p[0]) == 0)
    </pre>
  </blockquote>
  <pre wrap=""><!---->
That needs to be more like:
	SetProperties(&amp;cmdseq)

I hope that helps.

cya!

--

 // /
{:)==={ Darron Broad <a class="moz-txt-link-rfc2396E" href="mailto:darron@kewl.org">&lt;darron@kewl.org&gt;</a>
 \\ \ 

  </pre>
</blockquote>
<br>
Darron,<br>
<br>
You were right. The error I had to solve was to change
SetProperty(&amp;p[0]) into SetProperty(&amp;cmdseq).<br>
<br>
I have been coding all day and missed this one.<br>
<br>
Thanks,<br>
<br>
Michel.<br>
</body>
</html>

--------------070009010104070307060909--



--===============0430533164==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0430533164==--
