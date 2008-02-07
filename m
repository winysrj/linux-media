Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JNDBV-0004mb-0A
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 21:17:25 +0100
Received: by ug-out-1314.google.com with SMTP id o29so1038047ugd.20
	for <linux-dvb@linuxtv.org>; Thu, 07 Feb 2008 12:17:22 -0800 (PST)
Message-ID: <47AB668D.2090405@gmail.com>
Date: Thu, 07 Feb 2008 21:14:05 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <47AB3603.20303@gmail.com>
	<387ee2020802070901w2e3f3896n51fa97acbf01683e@mail.gmail.com>
	<200802071940.09143.zzam@gentoo.org>
In-Reply-To: <200802071940.09143.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to force adaptor order when using 2 DVB cards?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2009844282=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============2009844282==
Content-Type: multipart/alternative;
 boundary="------------000607090108080504040705"

This is a multi-part message in MIME format.
--------------000607090108080504040705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,
    Thank you. This is what I finally did (blacklisting and manually 
loading), as the udev rules have a really "ugly" syntax ;). I found the 
tip in Gentoo wiki and it's working fine now.

Thank you all anyway.
  Eduard




En/na Matthias Schwarzott ha escrit:
> On Donnerstag, 7. Februar 2008, John Drescher wrote:
>   
>> On Feb 7, 2008 11:46 AM, Eduard Huguet <eduardhc@gmail.com> wrote:
>>     
>>> Hi,
>>>     I currently have a media center computer set up using Gentoo 64 bit
>>> and a Hauppauge Nova-T 500 card (dual DVB-T receiver). Now I'm trying to
>>> add a new card (DVB-S), and here my problems begin: not mentioning the
>>> experimental state of the driver (this is a different story that doesn't
>>> matter now), my problem is that the new card porks the order in which
>>> the device nodes were created in /dev. And even worse, the actual order
>>> ing schema is different between a cold boot and rebooting:
>>>
>>> Cold boot:
>>>   · DVB:0: DVB-S tuner from Avermedia A700
>>>   · DVB:1,2: DVB-T tuners from Nova-T
>>>
>>> Reboot:
>>>   · DVB:0: 1st DVB-T tuner from Nova-T
>>>   · DVB:1: DVB-S tuner from A700
>>>   · DVB:2: 2nd DVB-T tuner from Nova-T
>>>
>>> I guess that on a cold boot the Nova-T 500 takes longer to initialize
>>> (due to the firmware being loaded), so its adaptors gets both created
>>> later.
>>>
>>> Is there any way to avoid this? My MythTV setup currently expects to
>>> find the 2 Nova-T 500 adaptors on DVB:0 and DVB:1, and In expected the
>>> new DVB-S adaptor to be created as DVB:2. However, it seems this is not
>>> the case.
>>>
>>> Is there any way to force the numbering schema or the 2 adaptors?
>>>       
>> Create a udev rule.
>>
>> http://reactivated.net/writing_udev_rules.html
>>
>>     
> More people have tried this for dvb and failed as it seems. That would require 
> something like persistent-net.
>
> I suggest you first try blacklisting the modules like described here:
> http://www.gentoo.org/doc/en/udev-guide.xml
>
> Matthias
>
>   

--------------000607090108080504040705
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Hi, <br>
&nbsp;&nbsp;&nbsp; Thank you. This is what I finally did (blacklisting and manually
loading), as the udev rules have a really "ugly" syntax ;). I found the
tip in Gentoo wiki and it's working fine now.<br>
<br>
Thank you all anyway.<br>
&nbsp; Eduard<br>
<br>
<br>
<br>
<br>
En/na Matthias Schwarzott ha escrit:
<blockquote cite="mid:200802071940.09143.zzam@gentoo.org" type="cite">
  <pre wrap="">On Donnerstag, 7. Februar 2008, John Drescher wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">On Feb 7, 2008 11:46 AM, Eduard Huguet <a class="moz-txt-link-rfc2396E" href="mailto:eduardhc@gmail.com">&lt;eduardhc@gmail.com&gt;</a> wrote:
    </pre>
    <blockquote type="cite">
      <pre wrap="">Hi,
    I currently have a media center computer set up using Gentoo 64 bit
and a Hauppauge Nova-T 500 card (dual DVB-T receiver). Now I'm trying to
add a new card (DVB-S), and here my problems begin: not mentioning the
experimental state of the driver (this is a different story that doesn't
matter now), my problem is that the new card porks the order in which
the device nodes were created in /dev. And even worse, the actual order
ing schema is different between a cold boot and rebooting:

Cold boot:
  &middot; DVB:0: DVB-S tuner from Avermedia A700
  &middot; DVB:1,2: DVB-T tuners from Nova-T

Reboot:
  &middot; DVB:0: 1st DVB-T tuner from Nova-T
  &middot; DVB:1: DVB-S tuner from A700
  &middot; DVB:2: 2nd DVB-T tuner from Nova-T

I guess that on a cold boot the Nova-T 500 takes longer to initialize
(due to the firmware being loaded), so its adaptors gets both created
later.

Is there any way to avoid this? My MythTV setup currently expects to
find the 2 Nova-T 500 adaptors on DVB:0 and DVB:1, and In expected the
new DVB-S adaptor to be created as DVB:2. However, it seems this is not
the case.

Is there any way to force the numbering schema or the 2 adaptors?
      </pre>
    </blockquote>
    <pre wrap="">Create a udev rule.

<a class="moz-txt-link-freetext" href="http://reactivated.net/writing_udev_rules.html">http://reactivated.net/writing_udev_rules.html</a>

    </pre>
  </blockquote>
  <pre wrap=""><!---->More people have tried this for dvb and failed as it seems. That would require 
something like persistent-net.

I suggest you first try blacklisting the modules like described here:
<a class="moz-txt-link-freetext" href="http://www.gentoo.org/doc/en/udev-guide.xml">http://www.gentoo.org/doc/en/udev-guide.xml</a>

Matthias

  </pre>
</blockquote>
</body>
</html>

--------------000607090108080504040705--


--===============2009844282==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2009844282==--
