Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:45006 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab1DWXIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 19:08:37 -0400
Message-ID: <4DB35BD0.2040405@usa.net>
Date: Sun, 24 Apr 2011 01:08:00 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <201104231940.34575@orion.escape-edv.de> <4DB320EF.3080301@usa.net> <201104232114.31998@orion.escape-edv.de>
In-Reply-To: <201104232114.31998@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23/04/11 21:14, Oliver Endriss wrote:
> Basically you should not have to hack anything.
> - Setup the CI as with any conventional device.
> - Write the encrypted stream into sec0.
> - Read the decrypted stream from sec0.
>
> This should work. (Please note that I could do some loopback tests only,
> as I am not watching paytv.)
>
> CU
> Oliver
>

Oliver,

This does not work.

I have launch gnutv like this: 'gnutv -adapter 0 -channels hb.conf -out
dvr -timeout 30 TF1'

Then on dd

tv@tv:~> dd if=188 if=/dev/dvb/adapter0/dvr0 of=/dev/dvb/adapter0/caio0
^C36071+1 records in
36071+0 records out
18468352 bytes (18 MB) copied, 76.4947 s, 241 kB/s


And another dd

tv@tv:~> dd bs=188 if=/dev/dvb/adapter0/caio0 of=test.mpeg
^Cdd: reading `/dev/dvb/adapter0/caio0': Resource temporarily unavailable
1338880+0 records in
1338880+0 records out
251709440 bytes (252 MB) copied, 34.3276 s, 7.3 MB/s
dd: closing input file `/dev/dvb/adapter0/caio0': Bad file descriptor


The first dd reports a more/less correct size for 30sec of encrypted tv
~ 18MB.
But the 2nd dd shows a big generated file out of the device. Plus it
mostly contains the following pattern : lots of FF separated by 47 1F FF 10.

I hope you can guide me to solve this - it is getting painful. Can we
review the code together ? The starting point should be the
ts_write/read methods.
--
Issa
