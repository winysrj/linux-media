Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JO9Lz-00061n-Db
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 11:24:07 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3323560fge.25
	for <linux-dvb@linuxtv.org>; Sun, 10 Feb 2008 02:24:07 -0800 (PST)
Message-ID: <47AECFEF.3010503@gmail.com>
Date: Sun, 10 Feb 2008 11:20:31 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <47ADC81B.4050203@gmail.com> <200802092214.06946.zzam@gentoo.org>
In-Reply-To: <200802092214.06946.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Some tests on Avermedia A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0413823216=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0413823216==
Content-Type: multipart/alternative;
 boundary="------------050605070100070805050404"

This is a multi-part message in MIME format.
--------------050605070100070805050404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

En/na Matthias Schwarzott ha escrit:
> On Samstag, 9. Februar 2008, Eduard Huguet wrote:
>   
>> Hi, Matthias
>>     
> Hi Eduard!
>
>   
>>     I've been performing some tests using your patch for this card.
>> Right now neither dvbscan nor kaffeine are able to find any channel on
>> Astra (the sat. my dish points to).
>>
>> However, Kaffeine has been giving me some interesting results: with your
>> driver "as is" it's getting me a 13-14% signal level and ~52% SNR when
>> scanning. Then, thinking that the problem is related to the low signal I
>> have I've changed the gain levels used to program the tuner: you were
>> using default values of 0 for all (in zl1003x_set_gain_params()
>> function, variables "rfg", "ba" and "bg"), and I've changed them top the
>> maximum (according to the documentation: rfg=1, ba=bg=3). With that, I'm
>> getting a 18% signal level, which is higher but still too low apparently
>> to get a lock.
>>
>> I've stopped here, because I really don't have the necessary background
>> to keep tweaking the driver. I just wanted to share it with you, as
>> maybe you have some idea on how to continue or what else could be done.
>>
>>     
>
> So I can do only this guess:
> I changed demod driver to invert the Polarization voltage for a700 card.
> This is controlled by member-variable voltage_inverted.
>
> static struct mt312_config avertv_a700_mt312 = {
>         .demod_address = 0x0e,
>         .voltage_inverted = 1,
> };
>
> Can you try to comment the voltage_inverted line here (saa7134-dvb.c: line 
> 865).
>
> BUT: If this helps we need to find out how to detect which card needs this 
> enabled/disabled.
>
> Regards
> Matthias
>
>   
Hi,
  Nothing :(. Removing (or setting it to 0) the voltage_inverted member 
doesn't seem to make any difference. I'm starting to suspect that there 
is something wrong with my antennae setup, so I'll test it later using 
an standalone STB or by plugging the card into a Windows computer and 
using the supplied drivers.

Regards,
  Eduard



--------------050605070100070805050404
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
En/na Matthias Schwarzott ha escrit:
<blockquote cite="mid:200802092214.06946.zzam@gentoo.org" type="cite">
  <pre wrap="">On Samstag, 9. Februar 2008, Eduard Huguet wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi, Matthias
    </pre>
  </blockquote>
  <pre wrap=""><!---->Hi Eduard!

  </pre>
  <blockquote type="cite">
    <pre wrap="">    I've been performing some tests using your patch for this card.
Right now neither dvbscan nor kaffeine are able to find any channel on
Astra (the sat. my dish points to).

However, Kaffeine has been giving me some interesting results: with your
driver "as is" it's getting me a 13-14% signal level and ~52% SNR when
scanning. Then, thinking that the problem is related to the low signal I
have I've changed the gain levels used to program the tuner: you were
using default values of 0 for all (in zl1003x_set_gain_params()
function, variables "rfg", "ba" and "bg"), and I've changed them top the
maximum (according to the documentation: rfg=1, ba=bg=3). With that, I'm
getting a 18% signal level, which is higher but still too low apparently
to get a lock.

I've stopped here, because I really don't have the necessary background
to keep tweaking the driver. I just wanted to share it with you, as
maybe you have some idea on how to continue or what else could be done.

    </pre>
  </blockquote>
  <pre wrap=""><!---->
So I can do only this guess:
I changed demod driver to invert the Polarization voltage for a700 card.
This is controlled by member-variable voltage_inverted.

static struct mt312_config avertv_a700_mt312 = {
        .demod_address = 0x0e,
        .voltage_inverted = 1,
};

Can you try to comment the voltage_inverted line here (saa7134-dvb.c: line 
865).

BUT: If this helps we need to find out how to detect which card needs this 
enabled/disabled.

Regards
Matthias

  </pre>
</blockquote>
Hi, <br>
&nbsp; Nothing :(. Removing (or setting it to 0) the voltage_inverted member
doesn't seem to make any difference. I'm starting to suspect that there
is something wrong with my antennae setup, so I'll test it later using
an standalone STB or by plugging the card into a Windows computer and
using the supplied drivers.<br>
<br>
Regards, <br>
&nbsp; Eduard<br>
<br>
<br>
</body>
</html>

--------------050605070100070805050404--


--===============0413823216==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0413823216==--
