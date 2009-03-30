Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45814 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760378AbZC3UQE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 16:16:04 -0400
Message-ID: <49D1287C.5010803@iki.fi>
Date: Mon, 30 Mar 2009 23:15:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olivier MENUEL <omenuel@laposte.net>
CC: Laurent Haond <lhaond@bearstech.com>, linux-media@vger.kernel.org,
	Thomas RENARD <threnard@gmail.com>,
	Karsten Blumenau <info@blume-online.de>,
	pHilipp Zabel <philipp.zabel@gmail.com>,
	=?ISO-8859-1?Q?Martin_M=FCller?= <mueller1977@web.de>
Subject: Re: AverMedia Volar Black HD (A850)
References: <200903291334.00879.olivier.menuel@free.fr> <200903292015.49152.omenuel@laposte.net> <49D11189.1010705@iki.fi> <200903302139.09809.omenuel@laposte.net>
In-Reply-To: <200903302139.09809.omenuel@laposte.net>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Olivier MENUEL wrote:
> Sorry,
> I was at work today.
> 
> I just downloaded the latest version.
> It works a lot better than the previous one (the device_nums are correct in the af9015.c and it seems the frontend is correctly initialized now). Here is the /var/log/messages :

Looks just correct!

> I tried a scan with kaffeine : the blue light is on when scanning (which is a pretty good news), but I can't find any channels : the signal goes up to 85% but SNR stays at 0% and no channel is found ...

hmm, not AverMedia A850 issue. I should look this later...

> But I tried a scan with the scan command line and everything worked fine !!!!!!!!!
> I found all channels and it seems to work really fine with vlc !!!

:)

Now I need some more tests. I can see from logs GPIO0 and GPIO1 are set 
differently.

1) reference design GPIOs:
If that works you don't need to test more.
http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/

2) GPIO1 tuner
looks like tuner is connected to this GPIO
If that works no need to test more.
http://linuxtv.org/hg/~anttip/af9015_aver_a850_GPIO1/

3) GPIO0 tuner
last test if nothing before works
http://linuxtv.org/hg/~anttip/af9015_aver_a850_GPIO0/

regards
Antti
-- 
http://palosaari.fi/
