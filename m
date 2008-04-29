Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1JqmIx-00083y-9U
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 11:39:25 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id 3B02F2FA924
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 11:39:22 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 7B37D1300236
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 11:39:15 +0200 (CEST)
Message-ID: <4816ECC0.5030406@anevia.com>
Date: Tue, 29 Apr 2008 11:39:12 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4816E6F8.1010607@anevia.com> <4816EBBB.5080205@dupondje.be>
In-Reply-To: <4816EBBB.5080205@dupondje.be>
Subject: Re: [linux-dvb] WinTV HVR 1300 Analog Tuner issue
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Jean-Louis Dupond a =E9crit :
> Define 'Does not work' ...
> =

> Frederic CAND schreef:
>> Dear all,
>>
>> I'm using kernel 2.6.22.19 and I can't make the analog tuner of my hvr =

>> 1300 work. Anything special to do more than with any other tv card ? =

>> (I'm using a KNC One TV Station DVR, based on saa7134, saa6752hs and =

>> tda9887 and it's working - almost - fine ...)
>>   =

> =


I'm having noise, just like not tuning ...
I'm doing the same ioctls as for my knc tv station dvr (set frequency, =

set norm, etc) but it's not giving any good results than noise.
I've heard at my office it might have something to do with the =

computation of the frequency which depends on the capability field of =

the struct filled by VIDIOC_G_MODULATOR ... trying right now ...

-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
