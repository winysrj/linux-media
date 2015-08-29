Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49855 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbbH2PDR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 11:03:17 -0400
Subject: Re: [PATCH] stv090x: use lookup tables for carrier/noise ratio
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <5238E030.8040203@gmx.de> <20141111082838.05369439@recife.lan>
Cc: linux-media <linux-media@vger.kernel.org>
From: Joerg Riechardt <J.Riechardt@gmx.de>
Message-ID: <55E1C9A1.6040702@gmx.de>
Date: Sat, 29 Aug 2015 17:02:57 +0200
MIME-Version: 1.0
In-Reply-To: <20141111082838.05369439@recife.lan>
Content-Type: multipart/mixed;
 boundary="------------040806060509000808050105"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040806060509000808050105
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 11.11.2014 um 11:28 schrieb Mauro Carvalho Chehab:
> Em Wed, 18 Sep 2013 01:05:20 +0200
> Joerg Riechardt <J.Riechardt@gmx.de> escreveu:
>
>> The stv090x driver uses the lookup table for signal strength already,
>> with this patch we use the lookup tables for carrier/noise ratio as well.
>> This has the advantage, that values for DVB-S and DVB-S2 are now
>> corresponding, while before they were way off. The values are now
>> proportional to real carrier/noise ratio, while before they were
>> corresponding to register values. So now applications are able to give
>> the user real carrier/noise ratio.
>>
>> Because the output has to be within 0x0000...0xFFFF the three negative
>> values for DVB-S2 are omitted. This is no significant loss, because
>> reception is lost at 7.5 dB already (TT S2-1600, Cine S2), so the
>> negative values are not really important, and also for DVB-S they don´t
>> exist.
>>
>> Signed-off-by: Joerg Riechardt <j.riechardt@gmx.de>
>>
>> Regards,
>> Joerg
>>
>> --- stv090x.c.bak	2013-09-06 20:59:01.132365872 +0200
>> +++ stv090x.c	2013-09-10 03:21:48.884115191 +0200
>> @@ -173,9 +173,9 @@
>>
>>   /* DVBS2 C/N Lookup table */
>>   static const struct stv090x_tab stv090x_s2cn_tab[] = {
>> -	{ -30, 13348 }, /* -3.0dB */
>> -	{ -20, 12640 }, /* -2d.0B */
>> -	{ -10, 11883 }, /* -1.0dB */
>> +//	{ -30, 13348 }, /* -3.0dB */
>> +//	{ -20, 12640 }, /* -2d.0B */
>> +//	{ -10, 11883 }, /* -1.0dB */
>>   	{   0, 11101 }, /* -0.0dB */
>>   	{   5, 10718 }, /*  0.5dB */
>>   	{  10, 10339 }, /*  1.0dB */
>
> Instead of commenting, just truncate the value at the DVBv3 stats
> function.

Ok, done.
Changed patch attached.

>
>> @@ -3697,9 +3697,10 @@
>>   			}
>>   			val /= 16;
>>   			last = ARRAY_SIZE(stv090x_s2cn_tab) - 1;
>> -			div = stv090x_s2cn_tab[0].read -
>> -			      stv090x_s2cn_tab[last].read;
>> -			*cnr = 0xFFFF - ((val * 0xFFFF) / div);
>> +			div = stv090x_s2cn_tab[last].real -
>> +			      stv090x_s2cn_tab[0].real;
>> +			val = stv090x_table_lookup(stv090x_s2cn_tab, last, val);
>> +			*cnr = val * 0xFFFF / div;
>>   		}
>>   		break;
>>
>> @@ -3719,9 +3720,10 @@
>>   			}
>>   			val /= 16;
>>   			last = ARRAY_SIZE(stv090x_s1cn_tab) - 1;
>> -			div = stv090x_s1cn_tab[0].read -
>> -			      stv090x_s1cn_tab[last].read;
>> -			*cnr = 0xFFFF - ((val * 0xFFFF) / div);
>> +			div = stv090x_s1cn_tab[last].real -
>> +			      stv090x_s1cn_tab[0].real;
>> +			val = stv090x_table_lookup(stv090x_s1cn_tab, last, val);
>> +			*cnr = val * 0xFFFF / div;
>>   		}
>
> As, with this patch, C/N will be a properly scaled value, the best
> is to add support for DVBv5 stats. With DVBv5 stats, the scale can
> be sent to userspace.

Sorry, I have no plans to add DVBv5 stats, although I agree, it would be 
nice, if someone did.

Signed-off-by: Joerg Riechardt <j.riechardt@gmx.de>

Regards,
Joerg


>
>>   		break;
>>   	default:
>
> Regards,
> Mauro
>

--------------040806060509000808050105
Content-Type: text/plain; charset=UTF-8;
 name="stv090x-use-lookup-tables-for-carrier-noise-ratio.v2.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="stv090x-use-lookup-tables-for-carrier-noise-ratio.v2.patch"

ZGlmZiAtTnJ1IEEvc3R2MDkweC5jIEIvc3R2MDkweC5jCi0tLSBBL3N0djA5MHguYwkyMDE1
LTA2LTI1IDE0OjMzOjU4LjAwMDAwMDAwMCArMDIwMAorKysgQi9zdHYwOTB4LmMJMjAxNS0w
OC0yOSAxNjowNzo0NC44ODk4NjEyMzAgKzAyMDAKQEAgLTM3MjYsOSArMzcyNiwxMiBAQAog
CQkJfQogCQkJdmFsIC89IDE2OwogCQkJbGFzdCA9IEFSUkFZX1NJWkUoc3R2MDkweF9zMmNu
X3RhYikgLSAxOwotCQkJZGl2ID0gc3R2MDkweF9zMmNuX3RhYlswXS5yZWFkIC0KLQkJCSAg
ICAgIHN0djA5MHhfczJjbl90YWJbbGFzdF0ucmVhZDsKLQkJCSpjbnIgPSAweEZGRkYgLSAo
KHZhbCAqIDB4RkZGRikgLyBkaXYpOworCQkJZGl2ID0gc3R2MDkweF9zMmNuX3RhYltsYXN0
XS5yZWFsIC0KKwkJCSAgICAgIHN0djA5MHhfczJjbl90YWJbM10ucmVhbDsKKwkJCXZhbCA9
IHN0djA5MHhfdGFibGVfbG9va3VwKHN0djA5MHhfczJjbl90YWIsIGxhc3QsIHZhbCk7CisJ
CQlpZiAodmFsIDwgMCkKKwkJCQl2YWwgPSAwOworCQkJKmNuciA9IHZhbCAqIDB4RkZGRiAv
IGRpdjsKIAkJfQogCQlicmVhazsKIApAQCAtMzc0OCw5ICszNzUxLDEwIEBACiAJCQl9CiAJ
CQl2YWwgLz0gMTY7CiAJCQlsYXN0ID0gQVJSQVlfU0laRShzdHYwOTB4X3MxY25fdGFiKSAt
IDE7Ci0JCQlkaXYgPSBzdHYwOTB4X3MxY25fdGFiWzBdLnJlYWQgLQotCQkJICAgICAgc3R2
MDkweF9zMWNuX3RhYltsYXN0XS5yZWFkOwotCQkJKmNuciA9IDB4RkZGRiAtICgodmFsICog
MHhGRkZGKSAvIGRpdik7CisJCQlkaXYgPSBzdHYwOTB4X3MxY25fdGFiW2xhc3RdLnJlYWwg
LQorCQkJICAgICAgc3R2MDkweF9zMWNuX3RhYlswXS5yZWFsOworCQkJdmFsID0gc3R2MDkw
eF90YWJsZV9sb29rdXAoc3R2MDkweF9zMWNuX3RhYiwgbGFzdCwgdmFsKTsKKwkJCSpjbnIg
PSB2YWwgKiAweEZGRkYgLyBkaXY7CiAJCX0KIAkJYnJlYWs7CiAJZGVmYXVsdDoK
--------------040806060509000808050105--
