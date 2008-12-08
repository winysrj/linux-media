Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp03.online.nl ([194.134.41.33])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1L9ZzK-00019G-Vd
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 07:53:05 +0100
Message-ID: <493CC447.8030606@verbraak.org>
Date: Mon, 08 Dec 2008 07:52:55 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: Pavel Hofman <pavel.hofman@insite.cz>, linux-dvb@linuxtv.org
References: <49346726.7010303@insite.cz>	<4934D218.4090202@verbraak.org>		<4935B72F.1000505@insite.cz>		<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>	<49371511.1060703@insite.cz>
	<493BE666.8030007@insite.cz>
In-Reply-To: <493BE666.8030007@insite.cz>
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0713366387=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0713366387==
Content-Type: multipart/alternative;
 boundary="------------010103050604060505050505"

This is a multi-part message in MIME format.
--------------010103050604060505050505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pavel Hofman schreef:
> Pavel Hofman napsal(a):
>   
>> Alex Betis napsal(a):
>>     
>>> On Wed, Dec 3, 2008 at 9:32 AM, Alex Betis <alex.betis@gmail.com 
>>> <mailto:alex.betis@gmail.com>> wrote:
>>>
>>>
>>>     On Wed, Dec 3, 2008 at 12:31 AM, Pavel Hofman
>>>     <pavel.hofman@insite.cz <mailto:pavel.hofman@insite.cz>> wrote:
>>>
>>>         pavel@htpc:~/project/satelit2/szap-s2$
>>>         <mailto:pavel@htpc:~/project/satelit2/szap-s2$> ./szap-s2 -x
>>>         EinsFestival
>>>         reading channels from file '/home/pavel/.szap/channels.conf'
>>>         zapping to 5 'EinsFestival':
>>>         delivery DVB-S, modulation QPSK
>>>         sat 0, frequency 12110 MHz H, symbolrate 27500000, coderate auto,
>>>
>>>     I don't think there is 12110 channel on Astra 19.2, at least not
>>>     accirding to lyngsat.
>>>
>>> My bad, there is such channel... I somehow got to Astra 1G only page 
>>> instead of all Atras in that position.
>>> Try other frequencies anyway.
>>>  
>>> Maybe you have diseqc problems?
>>>
>>>       
>
>
> Hi,
>
> Partial success :)
>
> I added a few free-to-air channels I was able to tune in WinXP to 
> channels.conf:
>
> Entertainment:12012:v:0:27500:2582:2581:8037
> SkyNews:12207:v:0:27500:514:645:4707
> WineTV:11555:h:1:27500:2372:2374:50435
> AvaTest:11555:h:1:27500:2329:2330:50446
> Vegas:11515:h:1:27500:3568:3567:8035
> Faith:11515:h:1:27500:2375:2376:50455
>
>
> The first two on LNB0, the rest on LNB1.
>
> For LNB0, I can tune via szap2:
>
> pavel@htpc:~/project/satelit2/szap-s2$ ./szap-s2 -r SkyNews
> reading channels from file '/home/pavel/.szap/channels.conf'
> zapping to 2 'SkyNews':
> delivery DVB-S, modulation QPSK
> sat 0, frequency 12207 MHz V, symbolrate 27500000, coderate auto, 
> rolloff 0.35
> vpid 0x0202, apid 0x0285, sid 0x1263
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal 0136 | snr 002d | ber 00000000 | unc fffffffe | 
> FE_HAS_LOCK
> status 1f | signal 0136 | snr 0031 | ber 00000000 | unc fffffffe | 
> FE_HAS_LOCK
>
> and view the channels with
>
> mplayer - < /dev/dvb/adapter0/dvr0
>
> For LNB1, it seems I can get signal via szap2:
>
> pavel@htpc:~/project/satelit2/szap-s2$ ./szap-s2 -r Faith
> reading channels from file '/home/pavel/.szap/channels.conf'
> zapping to 6 'Faith':
> delivery DVB-S, modulation QPSK
> sat 1, frequency 11515 MHz H, symbolrate 27500000, coderate auto, 
> rolloff 0.35
> vpid 0x0947, apid 0x0948, sid 0xc517
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal 0178 | snr 0051 | ber 00000000 | unc fffffffe | 
> FE_HAS_LOCK
> status 1f | signal 0178 | snr 0051 | ber 00000000 | unc fffffffe | 
> FE_HAS_LOCK
> status 1f | signal 0178 | snr 0050 | ber 00000000 | unc fffffffe | 
> FE_HAS_LOCK
>
>
> However, /dev/dvb/adapter0/dvr0 outputs no data for any of the stations 
> on the second LNB1.
>
>
> Perhaps it is correct and the channels I checked broadcast no stream at 
> this time. Since scan2 keeps failing, please is there a place to 
> download recent channels.conf for Astra 19.2E so that I can test on many 
> more channels?
>
> Thanks a lot,
>
> Pavel.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Pavel,

The reason why you probably do not get picture on LNB1 is because you 
are still getting a stream from LNB0. Probably there is a transponder on 
LNB0 with the same frequency and symbolrate as on LNB1 (frequency 11515 
MHz H, symbolrate 27500000) but the specified PIDs (vpid 0x0947, apid 
0x0948) do not exist. Therefore you do not get a picture.

Have a look at http://nl.kingofsat.net/pos-19.2E.php. Find the 
transponder for LNB0 with the same frequency and symbolrate (frequency 
11515 MHz H, symbolrate 27500000) as tried on LNB1 but with a set of 
PIDs that exist on LNB0. Change the channels.conf file and szap again to 
LNB1 with these parameters. If you do get picture you are sure that the 
diseqc switch is not switching but stays on LNB0.

Please report your result to the list.

Regards,

Michel.

--------------010103050604060505050505
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Pavel Hofman schreef:
<blockquote cite="mid:493BE666.8030007@insite.cz" type="cite">
  <pre wrap="">Pavel Hofman napsal(a):
  </pre>
  <blockquote type="cite">
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
  </blockquote>
  <pre wrap=""><!---->

Hi,

Partial success :)

I added a few free-to-air channels I was able to tune in WinXP to 
channels.conf:

Entertainment:12012:v:0:27500:2582:2581:8037
SkyNews:12207:v:0:27500:514:645:4707
WineTV:11555:h:1:27500:2372:2374:50435
AvaTest:11555:h:1:27500:2329:2330:50446
Vegas:11515:h:1:27500:3568:3567:8035
Faith:11515:h:1:27500:2375:2376:50455


The first two on LNB0, the rest on LNB1.

For LNB0, I can tune via szap2:

pavel@htpc:~/project/satelit2/szap-s2$ ./szap-s2 -r SkyNews
reading channels from file '/home/pavel/.szap/channels.conf'
zapping to 2 'SkyNews':
delivery DVB-S, modulation QPSK
sat 0, frequency 12207 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0202, apid 0x0285, sid 0x1263
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 0136 | snr 002d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 0136 | snr 0031 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

and view the channels with

mplayer - &lt; /dev/dvb/adapter0/dvr0

For LNB1, it seems I can get signal via szap2:

pavel@htpc:~/project/satelit2/szap-s2$ ./szap-s2 -r Faith
reading channels from file '/home/pavel/.szap/channels.conf'
zapping to 6 'Faith':
delivery DVB-S, modulation QPSK
sat 1, frequency 11515 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0947, apid 0x0948, sid 0xc517
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 0178 | snr 0051 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 0178 | snr 0051 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 0178 | snr 0050 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK


However, /dev/dvb/adapter0/dvr0 outputs no data for any of the stations 
on the second LNB1.


Perhaps it is correct and the channels I checked broadcast no stream at 
this time. Since scan2 keeps failing, please is there a place to 
download recent channels.conf for Astra 19.2E so that I can test on many 
more channels?

Thanks a lot,

Pavel.

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  </pre>
</blockquote>
Pavel,<br>
<br>
The reason why you probably do not get picture on LNB1 is because you
are still getting a stream from LNB0. Probably there is a transponder
on LNB0 with the same frequency and symbolrate as on LNB1 (frequency
11515 MHz H, symbolrate 27500000) but the specified PIDs (vpid 0x0947,
apid 0x0948) do not exist. Therefore you do not get a picture.<br>
<br>
Have a look at <a class="moz-txt-link-freetext" href="http://nl.kingofsat.net/pos-19.2E.php">http://nl.kingofsat.net/pos-19.2E.php</a>. Find the
transponder for LNB0 with the same frequency and symbolrate (frequency
11515 MHz H, symbolrate 27500000) as tried on LNB1 but with a set of
PIDs that exist on LNB0. Change the channels.conf file and szap again
to LNB1 with these parameters. If you do get picture you are sure that
the diseqc switch is not switching but stays on LNB0.<br>
<br>
Please report your result to the list.<br>
<br>
Regards,<br>
<br>
Michel.<br>
</body>
</html>

--------------010103050604060505050505--


--===============0713366387==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0713366387==--
