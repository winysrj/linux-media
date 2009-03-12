Return-path: <linux-media-owner@vger.kernel.org>
Received: from rolfschumacher.eu ([195.8.233.65]:33439 "EHLO august.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZCLWvU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 18:51:20 -0400
Received: from [192.168.1.2] (HSI-KBW-078-043-156-228.hsi4.kabel-badenwuerttemberg.de [78.43.156.228])
	(Authenticated sender: rolf)
	by august.de (Postfix) with ESMTPA id 115521FE22
	for <linux-media@vger.kernel.org>; Thu, 12 Mar 2009 23:51:18 +0100 (CET)
Message-ID: <49B991E5.1040801@august.de>
Date: Thu, 12 Mar 2009 23:51:17 +0100
From: Rolf Schumacher <mailinglist@august.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [Fwd: Re: [linux-dvb] getting started]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok, adapted the value in v4l/.version

make is doing fine now

-------- Original Message --------
Subject: 	Re: [linux-dvb] getting started
Date: 	Thu, 12 Mar 2009 23:47:24 +0100
From: 	Rolf Schumacher <mailinglist@august.de>
To: 	linux-media@vger.kernel.org
References: 	<49B982A5.7010103@august.de> <49B98677.9030102@iki.fi>



thank you, Antti, Thomas

kernel-headers are installed.
Why does make try to read the wrong file?

My kernel is named 2.6.28-7.slh.4-sidux-686, not 2.6.28-7.slh.3-sidux-686

---------
rsc@rolf9:~/src/v4l-dvb$ make
make -C /home/rsc/src/v4l-dvb/v4l
make[1]: Entering directory `/home/rsc/src/v4l-dvb/v4l'
Updating/Creating .config
Preparing to compile for kernel version 2.6.28
File not found: /lib/modules/2.6.28-7.slh.3-sidux-686/build/.config at
./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** Keine Regel vorhanden, um das Target ?.myconfig?,
beno"tigt von ?config-compat.h?, zu erstellen. Schluss.
make[1]: Leaving directory `/home/rsc/src/v4l-dvb/v4l'
make: *** [all] Fehler 2
rsc@rolf9:~/src/v4l-dvb$
rsc@rolf9:~/src/v4l-dvb$ ls -la
/lib/modules/2.6.28-7.slh.3-sidux-686/build/.config
ls: Zugriff auf /lib/modules/2.6.28-7.slh.3-sidux-686/build/.config
nicht mo"glich: Datei oder Verzeichnis nicht gefunden
rsc@rolf9:~/src/v4l-dvb$ ls -la
/lib/modules/2.6.28-7.slh.4-sidux-686/build/.config
-rw-r--r-- 1 root root 95158 12. Ma"r 00:30
/lib/modules/2.6.28-7.slh.4-sidux-686/build/.config
rsc@rolf9:~/src/v4l-dvb$ hg update
0 files updated, 0 files merged, 0 files removed, 0 files unresolved
rsc@rolf9:~/src/v4l-dvb$

------------

Antti Palosaari wrote:
> Rolf Schumacher wrote:
>   
>> File not found: /lib/modules/2.6.28-7.slh.3-sidux-686/build/.config at
>> ./scripts/make_kconfig.pl line 32, <IN> line 4.
>>     
>
> kernel-devel, kernel-headers, linux-devel or linux-headers package is 
> missing. Package name varies from distribution to distribution...
>
>
>   


