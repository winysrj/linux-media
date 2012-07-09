Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34039 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab2GIHIU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 03:08:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1So84v-0006k5-OE
	for linux-media@vger.kernel.org; Mon, 09 Jul 2012 09:08:17 +0200
Received: from bra55.neoplus.adsl.tpnet.pl ([83.29.94.55])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 09:08:17 +0200
Received: from acc.for.news by bra55.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 09:08:17 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Mon, 09 Jul 2012 08:24:19 +0200
Message-ID: <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi> <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl> <4FF97DF8.4080208@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FF97DF8.4080208@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08.07.2012 14:32, Antti Palosaari wrote:
> I suspect you stopped szap ?
>
> You cannot use dvbdate or dvbtraffic, nor read data from dvr0 unless
> frontend is tuned. Leave szap running backround and try again.

That way it works, and I can save stream. Hovewer it's strange because I 
shouldn't have to constatly tune channel to watch it, and on previous 
cards it was enough to tune once and then use other commands.
I base my knowledge on
http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device
There is nothing about constant tuning channel to use it. Am I missing 
something?
Marx

wuwek:/var/lib/vdr/kanaly# nohup ./szap-s2 -n 41 -r &
[1] 4888
wuwek:/var/lib/vdr/kanaly# nohup: zignorowanie wejścia i dołączenie 
wyników do `nohup.out'

wuwek:/var/lib/vdr/kanaly#
wuwek:/var/lib/vdr/kanaly# ps ax|grep szap
  4888 pts/1    S      0:00 ./szap-s2 -n 41 -r
  4891 pts/1    S+     0:00 grep szap
wuwek:/var/lib/vdr/kanaly# dvbdate
Mon Jul  9 07:12:43 2012
wuwek:/var/lib/vdr/kanaly# dvbtraffic
0000     9 p/s     1 kb/s    14 kbit
0001     9 p/s     1 kb/s    14 kbit
0011     1 p/s     0 kb/s     2 kbit
0014     0 p/s     0 kb/s     1 kbit
0104    29 p/s     5 kb/s    44 kbit
0108    58 p/s    10 kb/s    88 kbit
0109    64 p/s    11 kb/s    97 kbit
0e04   309 p/s    56 kb/s   465 kbit
0e77   228 p/s    41 kb/s   343 kbit
0e78    59 p/s    10 kb/s    90 kbit
17d5  2139 p/s   392 kb/s  3217 kbit
17df    90 p/s    16 kb/s   136 kbit
17e0    90 p/s    16 kb/s   136 kbit
1831     4 p/s     0 kb/s     7 kbit
1832     9 p/s     1 kb/s    14 kbit
1833     9 p/s     1 kb/s    14 kbit
1834     4 p/s     0 kb/s     7 kbit
1836     9 p/s     1 kb/s    14 kbit
1839  1247 p/s   228 kb/s  1876 kbit
1843    90 p/s    16 kb/s   136 kbit
1844    90 p/s    16 kb/s   136 kbit
1895     4 p/s     0 kb/s     7 kbit
1896     9 p/s     1 kb/s    14 kbit
1897     9 p/s     1 kb/s    14 kbit

