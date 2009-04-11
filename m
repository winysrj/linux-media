Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2.ewetel.de ([212.6.122.196])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <spieluhr@ewetel.net>) id 1Lsemh-0005dv-Hv
	for linux-dvb@linuxtv.org; Sat, 11 Apr 2009 17:06:19 +0200
Message-ID: <49E0B1C7.1080205@ewetel.net>
Date: Sat, 11 Apr 2009 17:05:43 +0200
From: Hartmut <spieluhr@ewetel.net>
MIME-Version: 1.0
To: Dave Lister <foceni@gmail.com>
References: <621110570904100418r9d7e583j5ae4982a77e9dba9@mail.gmail.com>	
	<49DF9CB7.5080802@ewetel.net>	
	<621110570904101437g5843eb21h8a0c894cc9bb48d@mail.gmail.com>	
	<49E04D12.5050108@ewetel.net>
	<621110570904110422k29a6c341s44762676fed13252@mail.gmail.com>
In-Reply-To: <621110570904110422k29a6c341s44762676fed13252@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SkyStar HD2 (TwinHan VP-1041/Mantis) S2API support
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1713903267=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1713903267==
Content-Type: multipart/alternative;
 boundary="------------010107030903070602070003"

This is a multi-part message in MIME format.
--------------010107030903070602070003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dave Lister schrieb:
> 2009/4/11 Hartmut <spieluhr@ewetel.net>:
>   
>> I tried the multiproto-driver first and had not very good results. This
>> driver is out for some month. I installed then the liplianin-driver via hg
>> clone as shown at the following page:
>>
>> http://www.linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_(VP-1041)#Drivers
>>
>> That worked at once.
>>
>> lspci:
>> 00:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
>> Bridge Controller [Ver 1.0] (rev 01)
>>         Subsystem: Device 1ae4:0003
>>         Flags: bus master, medium devsel, latency 32, IRQ 17
>>         Memory at fb000000 (32-bit, prefetchable) [size=4K]
>>         Kernel driver in use: Mantis
>>         Kernel modules: mantis
>>
>> dmesg:
>> mantis stop feed and dma
>> stb6100_set_bandwidth: Bandwidth=51610000
>> stb6100_get_bandwidth: Bandwidth=52000000
>> stb6100_get_bandwidth: Bandwidth=52000000
>> stb6100_set_frequency: Frequency=1944000
>> stb6100_get_frequency: Frequency=1944000
>> stb6100_get_bandwidth: Bandwidth=52000000
>> mantis start feed & dma
>>
>>     
>
> Well, it seems we have the same exact card (HW revision), but it did
> not work with liplianin in my setup. It works for you, that's why I
> was asking about the components in your setup. I really need to know
> your kernel version + its distrib. revision ("cat /proc/version") and
> the revision of your working liplianin copy ("cd
> your-liplianin-source; hg log | head").
>
> My setup:
> Linux version 2.6.26-1-686 (Debian 2.6.26-9) (waldi@debian.org)
> liplianin-s2: 11145:2866ecb5e66b (Sun Mar 15 18:24:26 2009)
>
> Be quite grateful if you could furnish me with this basic info. Don't
> forget to "CC: linux-dvb@linuxtv.org" when replying to me. :)
>
> Best regards,
>
>   
hartmut@Jupiter:~> cat /proc/version
Linux version 2.6.25.20-0.1-default (geeko@buildhost) (gcc version 4.3.1
20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #1
SMP 2008-12-12 20:30:38 +0100

hartmut@Jupiter:/usr/src/s2-liplianin> hg log | head
Not trusting file /usr/src/s2-liplianin/.hg/hgrc from untrusted user
root, group root
Not trusting file /usr/src/s2-liplianin/.hg/hgrc from untrusted user
root, group root
changeset:   10883:974d10d5c462
tag:         tip
parent:      10876:982623bbc9ff
parent:      10882:c770b20d15c6
user:        Igor M. Liplianin <liplianin@me.by>
date:        Sat Feb 28 05:57:40 2009 +0200
summary:     Merge with http://linuxtv.org/hg/v4l-dvb

changeset:   10882:c770b20d15c6
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
hartmut@Jupiter:/usr/src/s2-liplianin>


Hartmut


--------------010107030903070602070003
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Dave Lister schrieb:
<blockquote
 cite="mid:621110570904110422k29a6c341s44762676fed13252@mail.gmail.com"
 type="cite">
  <pre wrap="">2009/4/11 Hartmut <a class="moz-txt-link-rfc2396E" href="mailto:spieluhr@ewetel.net">&lt;spieluhr@ewetel.net&gt;</a>:
  </pre>
  <blockquote type="cite">
    <pre wrap="">I tried the multiproto-driver first and had not very good results. This
driver is out for some month. I installed then the liplianin-driver via hg
clone as shown at the following page:

<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_(VP-1041)#Drivers">http://www.linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_(VP-1041)#Drivers</a>

That worked at once.

lspci:
00:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Device 1ae4:0003
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, latency 32, IRQ 17
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Memory at fb000000 (32-bit, prefetchable) [size=4K]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Kernel driver in use: Mantis
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Kernel modules: mantis

dmesg:
mantis stop feed and dma
stb6100_set_bandwidth: Bandwidth=51610000
stb6100_get_bandwidth: Bandwidth=52000000
stb6100_get_bandwidth: Bandwidth=52000000
stb6100_set_frequency: Frequency=1944000
stb6100_get_frequency: Frequency=1944000
stb6100_get_bandwidth: Bandwidth=52000000
mantis start feed &amp; dma

    </pre>
  </blockquote>
  <pre wrap=""><!---->
Well, it seems we have the same exact card (HW revision), but it did
not work with liplianin in my setup. It works for you, that's why I
was asking about the components in your setup. I really need to know
your kernel version + its distrib. revision ("cat /proc/version") and
the revision of your working liplianin copy ("cd
your-liplianin-source; hg log | head").

My setup:
Linux version 2.6.26-1-686 (Debian 2.6.26-9) (<a class="moz-txt-link-abbreviated" href="mailto:waldi@debian.org">waldi@debian.org</a>)
liplianin-s2: 11145:2866ecb5e66b (Sun Mar 15 18:24:26 2009)

Be quite grateful if you could furnish me with this basic info. Don't
forget to "CC: <a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>" when replying to me. :)

Best regards,

  </pre>
</blockquote>
hartmut@Jupiter:~&gt; cat /proc/version<br>
Linux version 2.6.25.20-0.1-default (geeko@buildhost) (gcc version
4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE
Linux) ) #1 SMP 2008-12-12 20:30:38 +0100<br>
<br>
hartmut@Jupiter:/usr/src/s2-liplianin&gt; hg log | head<br>
Not trusting file /usr/src/s2-liplianin/.hg/hgrc from untrusted user
root, group root<br>
Not trusting file /usr/src/s2-liplianin/.hg/hgrc from untrusted user
root, group root<br>
changeset:&nbsp;&nbsp; 10883:974d10d5c462<br>
tag:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tip<br>
parent:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10876:982623bbc9ff<br>
parent:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10882:c770b20d15c6<br>
user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Igor M. Liplianin <a class="moz-txt-link-rfc2396E" href="mailto:liplianin@me.by">&lt;liplianin@me.by&gt;</a><br>
date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sat Feb 28 05:57:40 2009 +0200<br>
summary:&nbsp;&nbsp;&nbsp;&nbsp; Merge with <a class="moz-txt-link-freetext" href="http://linuxtv.org/hg/v4l-dvb">http://linuxtv.org/hg/v4l-dvb</a><br>
<br>
changeset:&nbsp;&nbsp; 10882:c770b20d15c6<br>
user:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Mauro Carvalho Chehab <a class="moz-txt-link-rfc2396E" href="mailto:mchehab@redhat.com">&lt;mchehab@redhat.com&gt;</a><br>
hartmut@Jupiter:/usr/src/s2-liplianin&gt;<br>
<br>
<br>
Hartmut<br>
<br>
</body>
</html>

--------------010107030903070602070003--


--===============1713903267==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1713903267==--
