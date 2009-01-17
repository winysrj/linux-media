Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:54244 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbZAQQNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 11:13:16 -0500
Received: by ug-out-1314.google.com with SMTP id 39so102338ugf.37
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2009 08:13:12 -0800 (PST)
Date: Sat, 17 Jan 2009 17:13:06 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: vdp <vdp@teletec.com.ua>
cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>,
	Linux Media Mailing List Thang
	<linux-media@vger.kernel.org>
Subject: Re[3]: [linux-dvb] dvb-t config for Ukraine_Kiev (ua)
In-Reply-To: <1799153746.20090116113515@teletec.com.ua>
Message-ID: <alpine.DEB.2.00.0901171603540.18169@ybpnyubfg.ybpnyqbznva>
References: <mailman.1.1230548402.10016.linux-dvb@linuxtv.org> <495A0E46.6030903@teletec.com.ua> <alpine.DEB.2.00.0812301329490.29535@ybpnyubfg.ybpnyqbznva> <495A6A08.90909@teletec.com.ua> <alpine.DEB.2.00.0812302005410.29535@ybpnyubfg.ybpnyqbznva>
 <496617B4.5090508@teletec.com.ua> <alpine.DEB.2.00.0901090924250.26988@ybpnyubfg.ybpnyqbznva> <12410322804.20090114085746@teletec.com.ua> <alpine.DEB.2.00.0901170041060.18012@ybpnyubfg.ybpnyqbznva> <1799153746.20090116113515@teletec.com.ua>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dmitry, I am pleased that I was able to help you!

But there is one thing that caught my interest, so I am again
posting this question to the -dvb mailing list, and I guess
to linux-media too:

On Fri, 16 Jan 2009, vdp wrote:

> But when I add -tm8 (THANK YOU FOR AUDIT !!!!):
> it start !!!!
> dvbstream -tm 8 -c 0 -I 2 -qam 64 -gi 32 -cr 2_3 -bw 8 -f 650000000 -net 224.12.12.12:1234 4311 4312

> tuning DVB-T (in United Kingdom) to 650000000 Hz, Bandwidth: 8

To the readers of the list, and of linux-media, the default
of `dvbstream' here is to use FFT transmission mode 2k, as
was introduced in the UK, and it's clear how UK-centric this
utility is based on the above line.  (UK not meaning UA or
Ukraine)

Now as part of DSO in the UK, the multiplexes are slowly to
convert from 2k to 8k, and most other parts of the world are
presently using 8k.

In fact, as I `grep' the latest dvb-apps scan files, only the
UK sites listed seem to be using 2k, for now.

Does anyone familiar with DVB-T know whether 2k transmission mode 
is used elsewhere in the world?

If not, would it not be reasonable to default to 8k for this
code, to make it applicable to the parts of the UK that have
switched as well as most of the rest of the world?

Reading the CVS RCS files, this doesn't seem to have been
updated for several years, and presumably distributed binary
packages are using the UK defaults, the code of which seems
unchanged from 2002, so I imagine this could use reworking.


> wonderful word !!! You, from other country help me, real-time and free !!!!

It is indeed my pleasure.  While I have not made a visit to
your country, with the closest being in Košice, SK, I prefer to
think that we are in the same part of the world, with much
in common...


> with best regards, Dmitry
> Odessa, Ukraine

Now, back to the original subject of this message, a scanfile
for Kиïв, with proper modulation values...

Can you run the following commands for me, then send me the
files in /tmp/stream-* so that I can verify the modulation?

These will record three seconds worth of the NIT data with
the modulation, into several small files in /tmp, for all
the different multiplexes.

First, the command you used above to stream 5 ĸaнaл :

dvbstream -tm 8 -c 0 -I 2 -qam 64 -gi 32 -cr 2_3 -bw 8 \
   -f 650000000  -o:/tmp/stream-650.ts -n 3  16

Now try it with the other frequencies and see if you still can 
lock:

dvbstream -tm 8 -c 0 -I 2 -qam 64 -gi 32 -cr 3_4 -bw 8 \
   -f 634000000  -o:/tmp/stream-634.ts -n 3  16

dvbstream -tm 8 -c 0 -I 2 -qam 64 -gi 32 -cr 2_3 -bw 8 \
   -f 714000000  -o:/tmp/stream-714.ts -n 3  16

dvbstream -tm 8 -c 0 -I 2 -qam 64 -gi 32 -cr 2_3 -bw 8 \
   -f 818000000  -o:/tmp/stream-818.ts -n 3  16

And last, a frequency where the services are in MPEG-4:

dvbstream -tm 8 -c 0 -I 2 -qam 64 -gi 32 -cr 2_3 -bw 8 \
   -f 682000000  -o:/tmp/stream-682.ts -n 3  16


If you have success, then you can send me all the files
in /tmp/stream-*.ts, and I will look at them, make sure
that all the data in the scanfile is correct, and confirm
it to Christoph Pfister...

thanks,
barry bouwsma
