Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp04.online.nl ([194.134.41.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1L8U5b-0003sB-I7
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 07:23:01 +0100
Received: from smtp04.online.nl (localhost [127.0.0.1])
	by smtp04.online.nl (Postfix) with ESMTP id BBE6CE056
	for <linux-dvb@linuxtv.org>; Fri,  5 Dec 2008 07:22:53 +0100 (CET)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134]) by smtp04.online.nl (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Fri,  5 Dec 2008 07:22:53 +0100 (CET)
Message-ID: <4938C8BB.5040406@verbraak.org>
Date: Fri, 05 Dec 2008 07:22:51 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49346726.7010303@insite.cz>
	<4934D218.4090202@verbraak.org>		<4935B72F.1000505@insite.cz>		<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz>
In-Reply-To: <49371511.1060703@insite.cz>
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan (possible diseqc
	problem)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0673528300=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0673528300==
Content-Type: multipart/alternative;
 boundary="------------070001050704080302080602"

This is a multi-part message in MIME format.
--------------070001050704080302080602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pavel Hofman schreef:
> Alex Betis napsal(a):
>   
>> On Wed, Dec 3, 2008 at 9:32 AM, Alex Betis <alex.betis@gmail.com 
>> <mailto:alex.betis@gmail.com>> wrote:
>>
>>
>>     On Wed, Dec 3, 2008 at 12:31 AM, Pavel Hofman
>>     <pavel.hofman@insite.cz <mailto:pavel.hofman@insite.cz>> wrote:
>>
>>         pavel@htpc:~/project/satelit2/szap-s2$
>>         <mailto:pavel@htpc:~/project/satelit2/szap-s2$> ./szap-s2 -x
>>         EinsFestival
>>         reading channels from file '/home/pavel/.szap/channels.conf'
>>         zapping to 5 'EinsFestival':
>>         delivery DVB-S, modulation QPSK
>>         sat 0, frequency 12110 MHz H, symbolrate 27500000, coderate auto,
>>
>>     I don't think there is 12110 channel on Astra 19.2, at least not
>>     accirding to lyngsat.
>>
>> My bad, there is such channel... I somehow got to Astra 1G only page 
>> instead of all Atras in that position.
>> Try other frequencies anyway.
>>  
>> Maybe you have diseqc problems?
>>
>>     
>
> Alex,
>
> Thanks a lot for your help. I tested the card on a different computer 
> with Windows and I could scan and view both Astra 19.2E and Astra 23.5E 
> free-to-air programs through A and B parts of the dual LNB. I have no 
> decoding card yet, nor any adapter.
>
> Since the computer was different, I will test my final computer/setup in 
> windows (just have to install them first here :) ). Nevertheless I think 
> it will work in windows.
>
> I will get back with result.
>
> Regards,
>
> Pavel.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Alex,

I have the following problem. I'm not able to rotate my rotor with my 
HD2 card and any of the drivers (liplianin, v4l-dvb, Manu). I tried 
GotoX diseqc commands as well as the goto position used by scan-s2.
As Pavel also has problems with diseqc (switch with A B input) I think 
it is not in the scan-s2 an szap-s2 utilities but in the driver.

I changed the subject because I do not know if Pavels problem is only 
due to diseqc problems.

I have another card (twinhan vp-1034 mantis) which should be able to 
rotate my rotor and I will try it next weekend to see if my rotor is not 
broken and I will also have a look into the driver but this will be not 
easy beacuse I do not have schematics or any documentation.

Regards,

Michel.


--------------070001050704080302080602
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Pavel Hofman schreef:
<blockquote cite="mid:49371511.1060703@insite.cz" type="cite">
  <pre wrap="">Alex Betis napsal(a):
  </pre>
  <blockquote type="cite">
    <pre wrap="">On Wed, Dec 3, 2008 at 9:32 AM, Alex Betis &lt;<a class="moz-txt-link-abbreviated" href="mailto:alex.betis@gmail.com">alex.betis@gmail.com</a> 
<a class="moz-txt-link-rfc2396E" href="mailto:alex.betis@gmail.com">&lt;mailto:alex.betis@gmail.com&gt;</a>&gt; wrote:


    On Wed, Dec 3, 2008 at 12:31 AM, Pavel Hofman
    &lt;<a class="moz-txt-link-abbreviated" href="mailto:pavel.hofman@insite.cz">pavel.hofman@insite.cz</a> <a class="moz-txt-link-rfc2396E" href="mailto:pavel.hofman@insite.cz">&lt;mailto:pavel.hofman@insite.cz&gt;</a>&gt; wrote:

        pavel@htpc:~/project/satelit2/szap-s2$
        <a class="moz-txt-link-rfc2396E" href="mailto:pavel@htpc:~/project/satelit2/szap-s2$">&lt;mailto:pavel@htpc:~/project/satelit2/szap-s2$&gt;</a> ./szap-s2 -x
        EinsFestival
        reading channels from file '/home/pavel/.szap/channels.conf'
        zapping to 5 'EinsFestival':
        delivery DVB-S, modulation QPSK
        sat 0, frequency 12110 MHz H, symbolrate 27500000, coderate auto,

    I don't think there is 12110 channel on Astra 19.2, at least not
    accirding to lyngsat.

My bad, there is such channel... I somehow got to Astra 1G only page 
instead of all Atras in that position.
Try other frequencies anyway.
 
Maybe you have diseqc problems?

    </pre>
  </blockquote>
  <pre wrap=""><!---->
Alex,

Thanks a lot for your help. I tested the card on a different computer 
with Windows and I could scan and view both Astra 19.2E and Astra 23.5E 
free-to-air programs through A and B parts of the dual LNB. I have no 
decoding card yet, nor any adapter.

Since the computer was different, I will test my final computer/setup in 
windows (just have to install them first here :) ). Nevertheless I think 
it will work in windows.

I will get back with result.

Regards,

Pavel.

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  </pre>
</blockquote>
Alex,<br>
<br>
I have the following problem. I'm not able to rotate my rotor with my
HD2 card and any of the drivers (liplianin, v4l-dvb, Manu). I tried
GotoX diseqc commands as well as the goto position used by scan-s2.<br>
As Pavel also has problems with diseqc (switch with A B input) I think
it is not in the scan-s2 an szap-s2 utilities but in the driver.<br>
<br>
I changed the subject because I do not know if Pavels problem is only
due to diseqc problems.<br>
<br>
I have another card (twinhan vp-1034 mantis) which should be able to
rotate my rotor and I will try it next weekend to see if my rotor is
not broken and I will also have a look into the driver but this will be
not easy beacuse I do not have schematics or any documentation.<br>
<br>
Regards,<br>
<br>
Michel.<br>
<br>
</body>
</html>

--------------070001050704080302080602--


--===============0673528300==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0673528300==--
