Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:37527 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756854Ab2HNUPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 16:15:18 -0400
Message-ID: <502AB1D2.3070209@gmx.de>
Date: Tue, 14 Aug 2012 22:15:14 +0200
From: Reinhard Nissl <rnissl@gmx.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: STV0299: reading property DTV_FREQUENCY -- what am I expected
 to get?
References: <502A1221.8020804@gmx.de> <CAHFNz9KnwKuATLKwhH22znmWa8QP5tZN0KJHFu4fuf7RGES1Gw@mail.gmail.com>
In-Reply-To: <CAHFNz9KnwKuATLKwhH22znmWa8QP5tZN0KJHFu4fuf7RGES1Gw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020608060607040005010107"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020608060607040005010107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Am 14.08.2012 14:05, schrieb Manu Abraham:

>> My other device, a STB0899, always reports the set frequency. So it seems
>> driver dependent whether it reports the actually locked frequency found by
>> the zig-zag-algorithm or just the set frequency to tune to.
>
> The STV0299 blindly sets the value based on a software zigzag (due to simpler
> hardware), but this might not be accurate enough. On the other hand, the
> STB0899 internally does zig-zag in hardware for DVB-S2, and partly in
> software for DVB-S.
>
> In any event, the get_frontend callback should return the value that is read
> from the demodulator registers, rather than the cached original value that
> which was requested to be tuned.
>
> The stb0899 returns only the cached value IIRC. Maybe I will fix this soon,
> or maybe you can send a patch.

See the attached patch.

This is what I get after the patch:

Sat.	Pol.	Band	Freq (MHz) Set	Freq (MHz) Get	Delta (MHz)
S19,2E	H	L	10744	10748,474	4,474
S19,2E	H	L	10773	10777,944	4,944
S19,2E	H	L	10832	10836,953	4,953
S19,2E	H	L	10861	10868,774	7,774
S19,2E	H	L	10920	10924,312	4,312
S19,2E	H	L	11023	11026,827	3,827
S19,2E	H	L	11170	11175,423	5,423
S19,2E	H	L	11243	11248,452	5,452
S19,2E	H	L	11302	11307,371	5,371
S19,2E	H	L	11361	11366,427	5,427
S19,2E	H	L	11420	11425,473	5,473
S19,2E	H	L	11464	11468,876	4,876
S19,2E	H	L	11493	11498,421	5,421
S19,2E	H	L	11523	11529,080	6,080
S19,2E	H	L	11582	11586,942	4,942
S19,2E	H	L	11611	11618,785	7,785
S19,2E	H	L	11641	11645,951	4,951
S19,2E	H	L	11670	11675,450	5,450
S19,2E	H	H	11719	11724,970	5,970
S19,2E	H	H	11758	11763,975	5,975
S19,2E	H	H	11797	11802,978	5,978
S19,2E	H	H	11836	11841,972	5,972
S19,2E	H	H	11875	11880,951	5,951

I'll have to let VDR "travel" across the transponders several 
times to see whether I get similar results for the previously 
mentioned transponder on the stv0299 device.

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de

--------------020608060607040005010107
Content-Type: text/x-patch;
 name="stb0899_drv-report-internal-freq-via-get_frontend.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="stb0899_drv-report-internal-freq-via-get_frontend.diff"

--- /usr/src/linux-3.1.10-1.16/drivers/media/dvb/frontends/stb0899_drv.c	2012-08-14 21:59:59.000000000 +0200
+++ stb0899_drv.c	2012-08-14 21:29:17.000000000 +0200
@@ -1596,6 +1596,7 @@ static int stb0899_get_frontend(struct d
 
 	dprintk(state->verbose, FE_DEBUG, 1, "Get params");
 	p->u.qpsk.symbol_rate = internal->srate;
+	p->frequency = internal->freq;
 
 	return 0;
 }

--------------020608060607040005010107--
