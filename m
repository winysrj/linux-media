Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JPK8Z-0006li-DL
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 17:07:07 +0100
Received: by ug-out-1314.google.com with SMTP id o29so1661542ugd.20
	for <linux-dvb@linuxtv.org>; Wed, 13 Feb 2008 08:07:07 -0800 (PST)
Message-ID: <47B314B8.7060403@gmail.com>
Date: Wed, 13 Feb 2008 17:03:04 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <47ADC81B.4050203@gmail.com> <200802131433.09531.zzam@gentoo.org>
	<47B30EC7.2020601@gmail.com> <200802131651.17260.zzam@gentoo.org>
In-Reply-To: <200802131651.17260.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Some tests on Avermedia A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1277144736=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1277144736==
Content-Type: multipart/alternative;
 boundary="------------070102060208010203060805"

This is a multi-part message in MIME format.
--------------070102060208010203060805
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

(remove previous for clarity...)

Oops :D. Could you please elaborate a bit on this? I don't know what is
>> the LNB connector you are referring to. Plus, I don't have right now any
>> voltimeter, but if needed I'll grab one from work tomorrow.
>>
>>     
>
> So, as I started playing with my A700 card, I discovered that the 
> input-connector on the card, where one attaches the coax-cable to the 
> lnb/dish, sent out wrong voltage.
>
> 13V / 18V was swapped. So I patched mt312 driver and added the setting 
> voltage_inverted to reverse it.
> Instead of just guessing what happens it is interesting to just call the 
> dvb-apps example app set_voltage and measure what voltage the hw outputs.
>
> Regards
> Matthias

OK, I don't know exactly what you mean, but I'll try to measure the 
output voltage of the input connector. I think you mean this, don't you?

BTW, ¿where is the set_voltage app? I have media-tv/linuxtv-dvb-apps 
package installed and there is nothing with that name...

Regards,
  Eduard





--------------070102060208010203060805
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-15"
 http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
(remove previous for clarity...)<br>
<br>
Oops :D. Could you please elaborate a bit on this? I don't know what is<br>
<blockquote cite="mid:200802131651.17260.zzam@gentoo.org" type="cite">
  <blockquote type="cite">
    <pre wrap="">the LNB connector you are referring to. Plus, I don't have right now any
voltimeter, but if needed I'll grab one from work tomorrow.

    </pre>
  </blockquote>
  <pre wrap=""><!---->
So, as I started playing with my A700 card, I discovered that the 
input-connector on the card, where one attaches the coax-cable to the 
lnb/dish, sent out wrong voltage.

13V / 18V was swapped. So I patched mt312 driver and added the setting 
voltage_inverted to reverse it.
Instead of just guessing what happens it is interesting to just call the 
dvb-apps example app set_voltage and measure what voltage the hw outputs.

Regards
Matthias</pre>
</blockquote>
<br>
OK, I don't know exactly what you mean, but I'll try to measure the
output voltage of the input connector. I think you mean this, don't
you? <br>
<br>
BTW, ¿where is the set_voltage app? I have media-tv/linuxtv-dvb-apps
package installed and there is nothing with that name...<br>
<br>
Regards, <br>
  Eduard<br>
<br>
<br>
<br>
<br>
</body>
</html>

--------------070102060208010203060805--


--===============1277144736==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1277144736==--
