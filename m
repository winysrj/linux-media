Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KjYQq-0002Tf-L1
	for linux-dvb@linuxtv.org; Sat, 27 Sep 2008 13:57:53 +0200
Received: by gxk13 with SMTP id 13so9200242gxk.17
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 04:57:18 -0700 (PDT)
Message-ID: <c74595dc0809270457s3118b367u253394e5eeead0a@mail.gmail.com>
Date: Sat, 27 Sep 2008 14:57:18 +0300
From: "Alex Betis" <alex.betis@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Twinhan 1041 (SP 400) lock and scan problems - the
	solution
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1359752646=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1359752646==
Content-Type: multipart/alternative;
	boundary="----=_Part_15101_12912138.1222516638094"

------=_Part_15101_12912138.1222516638094
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all,

My first post here, hope everything will go well.

I don't know what are the procedures to insert changes into the releases, so
I'll just describe the fixes, hope someone will find it useful and explain
how should I merge the changes into releases.

I had a Twinhan 1027 card for a while using Twinhan's Linux drivers with
many of my changes inside to make it work properly. The results were not
perfect and there was no support in linuxtv community, so I've decided to
buy Twinhan 1041 card with hope that its experimental support will work
better than what I had (and to advance to DVB-S2 format ofcause).

With latest mantis drivers I had some locking and scanning problems (using
Manu's scan utility).
Following are the description of changes I did to the driver and scan
utility to solve all those problems

First of all I'd like to thank the people who maintain the mantis driver. I
found the code very well organized and easy to follow.

Th major lock problem with this card is that it behaves differently every
time it tries to lock.
Sometimes the STATUS register reports END_LOOPVIT flag on first time the
register is checked, sometimes it shows a lock after about 20-30 checks. My
guess is that the card is not reset properly every time its used.
Since I don't have any document describing the registers in that card I did
a workaround - scan the same frequency several times (I do it 3 times, I
think 2 will be enough). I've added an internal loop counter to functions
that search for timing, carrier and data. Only when that loop on the same
frequency is finished, the derotator zigzag is set to next frequency.

Another issue is the stepping of the derotator frequency. I didn't really
understood the units of those steps since it's divided by "mclk" variable
(that has 1647 value in my machine), but the stepping was too coarse. With
the limits used in the code in most of that cases it allowed one-two steps
back and forward from the base frequency. I've used derot_step calculated in
stb0899_dvbs_algo function:
internal->derot_step = internal->derot_percent * (params->srate / 1000L) /
internal->mclk; /* DerotStep/1000 * Fsymbol    */

That value was used only in carrier search function, while in timing serach
the calculation was:
derot_step = (params->srate / 2L) / internal->mclk;  --> which gives value
large by 16.666 than 30% calculation.
and in data search the calculation was:
derot_step = (params->srate / 4L) / internal->mclk;  --> which gives value
large by 8.333 than 30% calculation.

In short there is incosistency in used steps. First I've changed the 30%
value to 10%, but after that set it to 20% and had the same results, I don't
think that change is needed. All my steps calculations are based on
stb0899_dvbs_algo function step calculation based on 20%.
I've used 4x that step for timing search, 2x that step for carrier search
and 1x that step for data search.

Another change is the limit of derotator frequency in search functions. The
frequency found in timing serach is used as base frequency in carrier
search, but the limit is absolute and not related to the base frequency.
I've changed the functions to check limit around frequency found in previous
step.
For example, I had a transponder that is constantly found in timing search
with derotator frequency value around 4500, the limit is set to something
around 5200. When the limit is checked as:
        if (ABS(derot_freq) > derot_limit)
The actual limit will be 700 instead of 5200. I've changed the check in
carrier and data search functions to:
        if(derot_freq > base_freq + derot_limit || derot_freq < base_freq -
derot_limit)
In timing search function the change has no meaning since base_freq is
always zero.


Theese are the major changes that allow me to lock on all the transponders
comparing to 1027 card.

I've also added 1 mSec sleep to loop in stb0899_check_data function, open
loops are not a good idea and the card need some time to lock anyway.


After all those changes I still saw that randomly some channels are not
appearing in the results list, while the card locked on them successfuly. It
turns out that the card or the driver has a buffer that is not resetted
after tunning to another channel, so scan utility got some descriptors from
previosly locked channel.
I dindn't had time to look for a good solution since I'm not familiar with
IOCTL commands to the card so another workaround solved that problem: ignore
first 3 messages arrived to a filter set in the scan utility.

That's all. Hope it help someone here.
My next task is to find out why DVB-S2 channels are not locked. Will write
if I'll find something interesting.

I'd really like to see those changes in formal release so I won't have to
merge the changes when I upgrade the driver.


Cheers,
Alex.

------=_Part_15101_12912138.1222516638094
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hello all,<br><br>My first post here, hope everything will go well.<br><br>I don&#39;t know what are the procedures to insert changes into the releases, so I&#39;ll just describe the fixes, hope someone will find it useful and explain how should I merge the changes into releases.<br>
<br>I had a Twinhan 1027 card for a while using Twinhan&#39;s Linux drivers with many of my changes inside to make it work properly. The results were not perfect and there was no support in linuxtv community, so I&#39;ve decided to buy Twinhan 1041 card with hope that its experimental support will work better than what I had (and to advance to DVB-S2 format ofcause).<br>
<br>With latest mantis drivers I had some locking and scanning problems (using Manu&#39;s scan utility).<br>Following are the description of changes I did to the driver and scan utility to solve all those problems<br><br>
First of all I&#39;d like to thank the people who maintain the mantis driver. I found the code very well organized and easy to follow.<br><br>Th major lock problem with this card is that it behaves differently every time it tries to lock.<br>
Sometimes the STATUS register reports END_LOOPVIT flag on first time the register is checked, sometimes it shows a lock after about 20-30 checks. My guess is that the card is not reset properly every time its used.<br>Since I don&#39;t have any document describing the registers in that card I did a workaround - scan the same frequency several times (I do it 3 times, I think 2 will be enough). I&#39;ve added an internal loop counter to functions that search for timing, carrier and data. Only when that loop on the same frequency is finished, the derotator zigzag is set to next frequency.<br>
<br>Another issue is the stepping of the derotator frequency. I didn&#39;t really understood the units of those steps since it&#39;s divided by &quot;mclk&quot; variable (that has 1647 value in my machine), but the stepping was too coarse. With the limits used in the code in most of that cases it allowed one-two steps back and forward from the base frequency. I&#39;ve used derot_step calculated in stb0899_dvbs_algo function:<br>
internal-&gt;derot_step = internal-&gt;derot_percent * (params-&gt;srate / 1000L) / internal-&gt;mclk; /* DerotStep/1000 * Fsymbol&nbsp;&nbsp;&nbsp; */<br><br>That value was used only in carrier search function, while in timing serach the calculation was:<br>
derot_step = (params-&gt;srate / 2L) / internal-&gt;mclk;&nbsp; --&gt; which gives value large by 16.666 than 30% calculation.<br>and in data search the calculation was:<br>derot_step = (params-&gt;srate / 4L) / internal-&gt;mclk;&nbsp; --&gt; which gives value large by 8.333 than 30% calculation.<br>
<br>In short there is incosistency in used steps. First I&#39;ve changed the 30% value to 10%, but after that set it to 20% and had the same results, I don&#39;t think that change is needed. All my steps calculations are based on stb0899_dvbs_algo function step calculation based on 20%.<br>
I&#39;ve used 4x that step for timing search, 2x that step for carrier search and 1x that step for data search.<br><br>Another change is the limit of derotator frequency in search functions. The frequency found in timing serach is used as base frequency in carrier search, but the limit is absolute and not related to the base frequency.<br>
I&#39;ve changed the functions to check limit around frequency found in previous step.<br>For example, I had a transponder that is constantly found in timing search with derotator frequency value around 4500, the limit is set to something around 5200. When the limit is checked as:<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (ABS(derot_freq) &gt; derot_limit)<br>The actual limit will be 700 instead of 5200. I&#39;ve changed the check in carrier and data search functions to:<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if(derot_freq &gt; base_freq + derot_limit || derot_freq &lt; base_freq - derot_limit)<br>
In timing search function the change has no meaning since base_freq is always zero.<br><br><br>Theese are the major changes that allow me to lock on all the transponders comparing to 1027 card.<br><br>I&#39;ve also added 1 mSec sleep to loop in stb0899_check_data function, open loops are not a good idea and the card need some time to lock anyway.<br>
<br><br>After all those changes I still saw that randomly some channels are not appearing in the results list, while the card locked on them successfuly. It turns out that the card or the driver has a buffer that is not resetted after tunning to another channel, so scan utility got some descriptors from previosly locked channel.<br>
I dindn&#39;t had time to look for a good solution since I&#39;m not familiar with IOCTL commands to the card so another workaround solved that problem: ignore first 3 messages arrived to a filter set in the scan utility.<br>
<br>That&#39;s all. Hope it help someone here.<br>My next task is to find out why DVB-S2 channels are not locked. Will write if I&#39;ll find something interesting.<br><br>I&#39;d really like to see those changes in formal release so I won&#39;t have to merge the changes when I upgrade the driver.<br>
<br><br>Cheers,<br>Alex.<br><br><br> </div>

------=_Part_15101_12912138.1222516638094--


--===============1359752646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1359752646==--
