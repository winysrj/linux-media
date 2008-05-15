Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway15.websitewelcome.com ([67.18.94.13])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1Jwd8J-00038X-NI
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 15:04:33 +0200
Received: from [77.109.107.153] (port=60909 helo=[127.0.0.1])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1Jwd8C-0004Yf-Bc
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 08:04:25 -0500
Message-ID: <482C34D7.8020608@kipdola.com>
Date: Thu, 15 May 2008 15:04:23 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
References: <482BF672.1090402@kipdola.com>	<20080515111150.392be0b9@bercot.org>	<200805151140.15939.rudy@grumpydevil.homelinux.org>	<482C111D.6000400@kipdola.com>
	<20080515143850.5dc9b190@bercot.org>
In-Reply-To: <20080515143850.5dc9b190@bercot.org>
Subject: Re: [linux-dvb] Technotrend S2-3200 (Or Technisat Skystar HD) on
 LinuxMCE 0710 (Kubuntu Feisty)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0628876654=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0628876654==
Content-Type: multipart/alternative;
 boundary="------------040608060805040401070004"

This is a multi-part message in MIME format.
--------------040608060805040401070004
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

This is my first mailing-list experience, but I'm liking it more then a 
regular forum! :-P
>> I have rebooted the computer multiple times.
>> I also unloaded the modules and reloaded them without rebooting.
>> I even added the modules to the blacklist, rebooted, loaded the
>> modules manually - they still won't go.
>>     
> Hum, I don't understand...
What I was trying to say: I tried everything I could think of to get 
them to work! (rebooting, modprobe -r && modprobe, adding the modules to 
/etc/modprobe/d/blacklist to make them not load at boot and load them 
afterwards)

>> As stated before, I'm also curious what the difference between all
>> these drivers are.
>>     
>
> I don't know. I did not have time to look at it but I hope, soon, I
> will be able to study it...
I look forward to it! :-)

If I can't get it to work on my LinuxMCE machine (which is a strange 
beast, after all!) I'll just install Mythbuntu 8.04 on another partition 
and try that out.

>> Met vriendelijke groeten,
>>     
>
> Mhummm, it looks like a strange language ;-)
Am I wrong to assume you live in France? Otherwise you're not 
recognising your neighbouring country's language! :-D
It's Dutch, by the way ;)

Greetings,

Jelle De Loecker

David BERCOT schreef:
> Hi again,
>
> Le Thu, 15 May 2008 12:31:57 +0200,
> Jelle De Loecker <skerit@kipdola.com> a écrit :
>   
>> Ah, my apologies, I'm trying to get help from every available
>> resource, and asking the person who wrote the tutorial seemed like a
>> good idea! :)
>>     
>
> Yes, it was ;-) No problem...
>
>   
>> I have rebooted the computer multiple times.
>> I also unloaded the modules and reloaded them without rebooting.
>> I even added the modules to the blacklist, rebooted, loaded the
>> modules manually - they still won't go.
>>     
>
> Hum, I don't understand...
>  
>   
>> As stated before, I'm also curious what the difference between all
>> these drivers are.
>>     
>
> I don't know. I did not have time to look at it but I hope, soon, I
> will be able to study it...
>
>   
>> Am I correct in assuming the CI doesn't work yet?
>>     
>
> It doesn't matter. The CI doesn't work on my computer (I don't know
> why) but everything else is OK !
>
>   
>> It's not such a big deal at the moment, I just spent all my money on
>> the setup!
>> I'll get along with freesat & othe free-to-air channels untill I
>> finally get a subscription, I'm just curious.
>>     
>
> For me, I have another terminal, so, it explains why I don't take time
> to do other tests... But I'll do ;-)
>
>   
>> Met vriendelijke groeten,
>>     
>
> Mhummm, it looks like a strange language ;-)
>
> David.
>
>   
>> Jelle De Loecker
>>
>>
>> Rudy Zijlstra schreef:
>>     
>>> On Thursday 15 May 2008 11:11, David BERCOT wrote:
>>>   
>>>       
>>>> Hi Jelle,
>>>>
>>>> I've seen your mail this morning ;-)
>>>>
>>>> Le Thu, 15 May 2008 10:38:10 +0200,
>>>>
>>>> Jelle De Loecker <skerit@kipdola.com> a écrit :
>>>>     
>>>>         
>>>>> Good morning all,
>>>>>
>>>>> I'm having difficulty getting my DVB-S2 card to work on LinuxMCE
>>>>> 0710 (Kubuntu Feisty, kernel 2.6.22-14-generic) I'll start with
>>>>> some lspci info to prove the card is connected:
>>>>> lspci -v:
>>>>> 04:01.0 Multimedia controller: Philips Semiconductors SAA7146
>>>>> (rev 01) Subsystem: Technotrend Systemtechnik GmbH S2-3200
>>>>>         Flags: bus master, medium devsel, latency 64, IRQ 16
>>>>>         Memory at febffc00 (32-bit, non-prefetchable) [size=512]
>>>>>
>>>>> I can compile the drivers just fine, I followed the instructions
>>>>> from this French page:
>>>>> http://wilco.bercot.org/debian/s2-3200.html
>>>>> <http://wilco.bercot.org/debian/s2-3200.html>(I don't completely
>>>>> understand French, but we all speak code!)
>>>>>
>>>>> But after loading the drivers I don't get a /dev/dvb folder.
>>>>> My dmesg output only shows this message:
>>>>> saa7146: register extension 'budget_ci dvb'.
>>>>>       
>>>>>           
>>>> Have you reboot your computer ? May be it can solve your
>>>> problems... If not, I'll do another version with the multiproto
>>>> plus driver soon.
>>>>
>>>>     
>>>>         
>>> Remains the question, what is the difference between multiproto and
>>> multiproto plus?
>>>
>>> Its something i also would like to understand. Another question,
>>> how if progress on CI with the TT-3200?
>>>
>>> Cheers,
>>>
>>> Rudy
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>       


--------------040608060805040401070004
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=UTF-8" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
This is my first mailing-list experience, but I'm liking it more then a
regular forum! <span class="moz-smiley-s4"><span> :-P </span></span><br>
<blockquote type="cite">
  <blockquote type="cite">
    <pre wrap="">I have rebooted the computer multiple times.
I also unloaded the modules and reloaded them without rebooting.
I even added the modules to the blacklist, rebooted, loaded the
modules manually - they still won't go.
    </pre>
  </blockquote>
  <pre wrap="">
Hum, I don't understand...</pre>
</blockquote>
What I was trying to say: I tried everything I could think of to get
them to work! (rebooting, modprobe -r &amp;&amp; modprobe, adding the
modules to /etc/modprobe/d/blacklist to make them not load at boot and
load them afterwards)<br>
<br>
<blockquote type="cite">
  <blockquote type="cite">
    <pre wrap="">As stated before, I'm also curious what the difference between all
these drivers are.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
I don't know. I did not have time to look at it but I hope, soon, I
will be able to study it...</pre>
</blockquote>
I look forward to it! <span class="moz-smiley-s1"><span> :-) </span></span><br>
<br>
If I can't get it to work on my LinuxMCE machine (which is a strange
beast, after all!) I'll just install Mythbuntu 8.04 on another
partition and try that out.<br>
<br>
<blockquote type="cite">
  <blockquote type="cite">
    <pre wrap="">Met vriendelijke groeten,
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Mhummm, it looks like a strange language ;-)</pre>
</blockquote>
Am I wrong to assume you live in France? Otherwise you're not
recognising your neighbouring country's language! <span
 class="moz-smiley-s5"><span> :-D </span></span><br>
It's Dutch, by the way ;)<br>
<br>
Greetings,<br>
<br>
Jelle De Loecker<br>
<br>
David BERCOT schreef:
<blockquote cite="mid:20080515143850.5dc9b190@bercot.org" type="cite">
  <pre wrap="">Hi again,

Le Thu, 15 May 2008 12:31:57 +0200,
Jelle De Loecker <a class="moz-txt-link-rfc2396E" href="mailto:skerit@kipdola.com">&lt;skerit@kipdola.com&gt;</a> a écrit :
  </pre>
  <blockquote type="cite">
    <pre wrap="">Ah, my apologies, I'm trying to get help from every available
resource, and asking the person who wrote the tutorial seemed like a
good idea! :)
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Yes, it was ;-) No problem...

  </pre>
  <blockquote type="cite">
    <pre wrap="">I have rebooted the computer multiple times.
I also unloaded the modules and reloaded them without rebooting.
I even added the modules to the blacklist, rebooted, loaded the
modules manually - they still won't go.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Hum, I don't understand...
 
  </pre>
  <blockquote type="cite">
    <pre wrap="">As stated before, I'm also curious what the difference between all
these drivers are.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
I don't know. I did not have time to look at it but I hope, soon, I
will be able to study it...

  </pre>
  <blockquote type="cite">
    <pre wrap="">Am I correct in assuming the CI doesn't work yet?
    </pre>
  </blockquote>
  <pre wrap=""><!---->
It doesn't matter. The CI doesn't work on my computer (I don't know
why) but everything else is OK !

  </pre>
  <blockquote type="cite">
    <pre wrap="">It's not such a big deal at the moment, I just spent all my money on
the setup!
I'll get along with freesat &amp; othe free-to-air channels untill I
finally get a subscription, I'm just curious.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
For me, I have another terminal, so, it explains why I don't take time
to do other tests... But I'll do ;-)

  </pre>
  <blockquote type="cite">
    <pre wrap="">Met vriendelijke groeten,
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Mhummm, it looks like a strange language ;-)

David.

  </pre>
  <blockquote type="cite">
    <pre wrap="">Jelle De Loecker


Rudy Zijlstra schreef:
    </pre>
    <blockquote type="cite">
      <pre wrap="">On Thursday 15 May 2008 11:11, David BERCOT wrote:
  
      </pre>
      <blockquote type="cite">
        <pre wrap="">Hi Jelle,

I've seen your mail this morning ;-)

Le Thu, 15 May 2008 10:38:10 +0200,

Jelle De Loecker <a class="moz-txt-link-rfc2396E" href="mailto:skerit@kipdola.com">&lt;skerit@kipdola.com&gt;</a> a écrit :
    
        </pre>
        <blockquote type="cite">
          <pre wrap="">Good morning all,

I'm having difficulty getting my DVB-S2 card to work on LinuxMCE
0710 (Kubuntu Feisty, kernel 2.6.22-14-generic) I'll start with
some lspci info to prove the card is connected:
lspci -v:
04:01.0 Multimedia controller: Philips Semiconductors SAA7146
(rev 01) Subsystem: Technotrend Systemtechnik GmbH S2-3200
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at febffc00 (32-bit, non-prefetchable) [size=512]

I can compile the drivers just fine, I followed the instructions
from this French page:
<a class="moz-txt-link-freetext" href="http://wilco.bercot.org/debian/s2-3200.html">http://wilco.bercot.org/debian/s2-3200.html</a>
<a class="moz-txt-link-rfc2396E" href="http://wilco.bercot.org/debian/s2-3200.html">&lt;http://wilco.bercot.org/debian/s2-3200.html&gt;</a>(I don't completely
understand French, but we all speak code!)

But after loading the drivers I don't get a /dev/dvb folder.
My dmesg output only shows this message:
saa7146: register extension 'budget_ci dvb'.
      
          </pre>
        </blockquote>
        <pre wrap="">Have you reboot your computer ? May be it can solve your
problems... If not, I'll do another version with the multiproto
plus driver soon.

    
        </pre>
      </blockquote>
      <pre wrap="">Remains the question, what is the difference between multiproto and
multiproto plus?

Its something i also would like to understand. Another question,
how if progress on CI with the TT-3200?

Cheers,

Rudy

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
      </pre>
    </blockquote>
  </blockquote>
</blockquote>
<br>
</body>
</html>

--------------040608060805040401070004--


--===============0628876654==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0628876654==--
