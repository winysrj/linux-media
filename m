Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vince_m@bigpond.com>) id 1LMBgE-0005Fk-7y
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 02:33:26 +0100
Message-ID: <496A9DBA.7010602@bigpond.com>
Date: Mon, 12 Jan 2009 10:32:42 +0900
From: Vince Mari <vince_m@bigpond.com>
MIME-Version: 1.0
To: James Gemmell <james@dipalo.com>
References: <4937CAE4.8080100@bigpond.com>
	<18793.39119.727237.615925@gargle.gargle.HOWL>
In-Reply-To: <18793.39119.727237.615925@gargle.gargle.HOWL>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Leadtek DTV1000S ?
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1406028009=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1406028009==
Content-Type: multipart/alternative;
 boundary="------------050903070009040606030807"

This is a multi-part message in MIME format.
--------------050903070009040606030807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Gemmell wrote:
> ...
>> I am currently trying to get the tda18271 to lock onto a signal but with
>> no luck yet
>>     
>
> This is pretty much where I'm at right now.  I've been through the
> tda18271 code and, with the exhaustive use of debug statements, am
> satisfied that it setting up the tuner correctly.  The problem seems
> to be somewhere between the tuner and the demod or how the demod is
> interpreting the tuner data.
>
> Do you have any ideas as to what I could try next?  I've tried
> changing the settings in the tda10048_config and tda18271_config
> structures without much luck.  Where you able to get any further?
>
> Best regards
> James Gemmell
>
>   
Hi James,
The signal strength doesnt go low when the antenna is disconnected (it 
does on my other card) instead it stays high. I am currently looking for 
some kind of switch between the antenna and the tuner or a gain problem 
(too sensitive?)

Cheers,
Vince Mari


--------------050903070009040606030807
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
James Gemmell wrote:
<blockquote cite="mid:18793.39119.727237.615925@gargle.gargle.HOWL"
 type="cite">...
  <blockquote type="cite">
    <pre wrap="">I am currently trying to get the tda18271 to lock onto a signal but with
no luck yet
    </pre>
  </blockquote>
  <pre wrap=""><!---->
This is pretty much where I'm at right now.  I've been through the
tda18271 code and, with the exhaustive use of debug statements, am
satisfied that it setting up the tuner correctly.  The problem seems
to be somewhere between the tuner and the demod or how the demod is
interpreting the tuner data.

Do you have any ideas as to what I could try next?  I've tried
changing the settings in the tda10048_config and tda18271_config
structures without much luck.  Where you able to get any further?

Best regards
James Gemmell

  </pre>
</blockquote>
Hi James,<br>
The signal strength doesnt go low when the antenna is disconnected (it
does on my other card) instead it stays high. I am currently looking
for some kind of switch between the antenna and the tuner or a gain
problem (too sensitive?)<br>
<br>
Cheers,<br>
Vince Mari<br>
<br>
</body>
</html>

--------------050903070009040606030807--


--===============1406028009==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1406028009==--
