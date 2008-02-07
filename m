Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JND9X-0004Jq-TP
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 21:15:23 +0100
Received: by ug-out-1314.google.com with SMTP id o29so1037393ugd.20
	for <linux-dvb@linuxtv.org>; Thu, 07 Feb 2008 12:15:21 -0800 (PST)
Message-ID: <47AB6616.7010006@gmail.com>
Date: Thu, 07 Feb 2008 21:12:06 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <47AB228E.3080303@gmail.com> <200802072013.41966.zzam@gentoo.org>
In-Reply-To: <200802072013.41966.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AVerMedia DVB-S Hybrid+FM and DVB-S Pro [A700]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0789517275=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0789517275==
Content-Type: multipart/alternative;
 boundary="------------020300030008080103020801"

This is a multi-part message in MIME format.
--------------020300030008080103020801
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Hi, Matthias
   Both lspci and dmesg EEPROM dump are exactly the same as the wiki.

Anyway, let's go with some feedback:

    I've been trying the card with your patch. Apparently the adaptor 
nodes are created (I solved yet the ordering issue), but I've been 
unable to find any channel by using neither dvbscan nor Kaffeine. In 
dvbscan I get these errors:

    eduard@mediacenter ~ $ dvbscan -a 2 /usr/share/dvb/dvb-s/Astra-19.2E

    scanning /usr/share/dvb/dvb-s/Astra-19.2E
    using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
    initial transponder 12551500 V 22000000 5
     >>> tune to: 12551:v:0:22000
    DVB-S IF freq is 1951500
    WARNING: >>> tuning failed!!!
     >>> tune to: 12551:v:0:22000 (tuning failed)
    DVB-S IF freq is 1951500
    WARNING: >>> tuning failed!!!
    ERROR: initial tuning failed
    dumping lists (0 services)
    Done.


In Kaffeine I can also see (during scan) that the signal level is 
aproximately at 14% and SNR at 51-52%, but it doesn't find any channel. 
Theoretically I'm getting the DVB-S signal through my main house 
antennae cable (I double checked this with the installer), as the dishes 
are on the top of the building and pointed to Astra 19.2, but I don't 
know if maybe it's giving me a signal too slow for the card. ¿Do you 
know if there is any amplifier in the card that needs activation (Nova-T 
500 does)?

Best regards, and thank you again for your hard work.
  Eduard







En/na Matthias Schwarzott ha escrit:
> On Donnerstag, 7. Februar 2008, Eduard Huguet wrote:
>   
>> Hi,
>>     ¿Have you been able to make the DVB-S part work, so? I've been
>> trying these days using ZZam's patch only (Tino's one also mentioned in
>> the wiki doesn't apply for now), and I was completely unable to get a
>> lock on any frequency.
>>
>> I thought it was because the driver was incomplete (without Tino's
>> patch...), but if it works for you then I'll probably need to check my
>> antenna, satellite, etc...
>>
>> My card is the DVB-S Pro simple (not hybrid), but I don't think this
>> makes any difference.
>>
>> Best regards,
>>   Eduard Huguet
>>
>>
>> (PS: sorry for double posting. I forgot to change the subject  title
>> before.)
>>     
>
> Hi Eduard, Peter!
>
> @Eduard:
> Can you please compare the dmesg output (especially the eeprom dump) of your 
> card to the one listed on the wiki-page.
>
> http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)
>
> @Peter:
> 1. Maybe you want to start a page in the wiki dedicated to your card.
> Or should we check for similarity and merge both of these cards into one page?
>
> At least I am interested in the eeprom content of your card.
>
> I should request some schematics from Avermedia to maybe get gpio controlling 
> correct. (Like resetting chips, ir ...)
>
> Regards
> Matthias
>
>   

--------------020300030008080103020801
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
Hi, Matthias<br>
   Both lspci and dmesg EEPROM dump are exactly the same as the wiki.<br>
<br>
Anyway, let's go with some feedback:<br>
<br>
    I've been trying the card with your patch. Apparently the adaptor
nodes are created (I solved yet the ordering issue), but I've been
unable to find any channel by using neither dvbscan nor Kaffeine. In
dvbscan I get these errors:<br>
<br>
<blockquote><tt>eduard@mediacenter ~ $ dvbscan -a 2
/usr/share/dvb/dvb-s/Astra-19.2E<br>
  <br>
  </tt><tt>scanning /usr/share/dvb/dvb-s/Astra-19.2E</tt><br>
  <tt>using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'</tt><br>
  <tt>initial transponder 12551500 V 22000000 5</tt><br>
  <tt>&gt;&gt;&gt; tune to: 12551:v:0:22000</tt><br>
  <tt>DVB-S IF freq is 1951500</tt><br>
  <tt>WARNING: &gt;&gt;&gt; tuning failed!!!</tt><br>
  <tt>&gt;&gt;&gt; tune to: 12551:v:0:22000 (tuning failed)</tt><br>
  <tt>DVB-S IF freq is 1951500</tt><br>
  <tt>WARNING: &gt;&gt;&gt; tuning failed!!!</tt><br>
  <tt>ERROR: initial tuning failed</tt><br>
  <tt>dumping lists (0 services)</tt><br>
  <tt>Done.</tt><br>
</blockquote>
<br>
In Kaffeine I can also see (during scan) that the signal level is
aproximately at 14% and SNR at 51-52%, but it doesn't find any channel.
Theoretically I'm getting the DVB-S signal through my main house
antennae cable (I double checked this with the installer), as the
dishes are on the top of the building and pointed to Astra 19.2, but I
don't know if maybe it's giving me a signal too slow for the card. ¿Do
you know if there is any amplifier in the card that needs activation
(Nova-T 500 does)?<br>
<br>
Best regards, and thank you again for your hard work.<br>
  Eduard<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
En/na Matthias Schwarzott ha escrit:
<blockquote cite="mid:200802072013.41966.zzam@gentoo.org" type="cite">
  <pre wrap="">On Donnerstag, 7. Februar 2008, Eduard Huguet wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi,
    ¿Have you been able to make the DVB-S part work, so? I've been
trying these days using ZZam's patch only (Tino's one also mentioned in
the wiki doesn't apply for now), and I was completely unable to get a
lock on any frequency.

I thought it was because the driver was incomplete (without Tino's
patch...), but if it works for you then I'll probably need to check my
antenna, satellite, etc...

My card is the DVB-S Pro simple (not hybrid), but I don't think this
makes any difference.

Best regards,
  Eduard Huguet


(PS: sorry for double posting. I forgot to change the subject  title
before.)
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Hi Eduard, Peter!

@Eduard:
Can you please compare the dmesg output (especially the eeprom dump) of your 
card to the one listed on the wiki-page.

<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)">http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)</a>

@Peter:
1. Maybe you want to start a page in the wiki dedicated to your card.
Or should we check for similarity and merge both of these cards into one page?

At least I am interested in the eeprom content of your card.

I should request some schematics from Avermedia to maybe get gpio controlling 
correct. (Like resetting chips, ir ...)

Regards
Matthias

  </pre>
</blockquote>
</body>
</html>

--------------020300030008080103020801--


--===============0789517275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0789517275==--
