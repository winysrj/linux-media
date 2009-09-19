Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <david.may10@ntlworld.com>) id 1MouMs-0005on-5L
	for linux-dvb@linuxtv.org; Sat, 19 Sep 2009 09:28:26 +0200
Received: from aamtaout03-winn.ispmail.ntl.com ([81.103.221.35])
	by mtaout02-winn.ispmail.ntl.com
	(InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP id
	<20090919072750.FEJB6611.mtaout02-winn.ispmail.ntl.com@aamtaout03-winn.ispmail.ntl.com>
	for <linux-dvb@linuxtv.org>; Sat, 19 Sep 2009 08:27:50 +0100
Received: from cpc3-bagu5-0-0-cust11.bagu.cable.ntl.com ([62.254.12.12])
	by aamtaout03-winn.ispmail.ntl.com
	(InterMail vG.2.02.00.01 201-2161-120-102-20060912) with ESMTP id
	<20090919072750.OQX2093.aamtaout03-winn.ispmail.ntl.com@cpc3-bagu5-0-0-cust11.bagu.cable.ntl.com>
	for <linux-dvb@linuxtv.org>; Sat, 19 Sep 2009 08:27:50 +0100
Date: Sat, 19 Sep 2009 08:27:47 +0100
From: david may <david.may10@ntlworld.com>
Message-ID: <664465048.20090919082747@ntlworld.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <801963131.20090919082149@ntlworld.com>
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
	<200909150853.19902.hverkuil@xs4all.nl>
	<A69FA2915331DC488A831521EAE36FE40155157076@dlee06.ent.ti.com>
	<801963131.20090919082149@ntlworld.com>
MIME-Version: 1.0
Subject: [linux-dvb] Fwd: Re[2]: RFC: V4L - Support for video timings at the
	input/output interface
Reply-To: linux-media@vger.kernel.org, david may <david.may10@ntlworld.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a forwarded message
From: david may <david.may10@ntlworld.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Date: Saturday, September 19, 2009, 8:21:49 AM
Subject: RFC: V4L - Support for video timings at the input/output interface

===8<==============Original message text===============
Hello Muralidharan,

Wednesday, September 16, 2009, 10:04:42 PM, you wrote:

> Hans,

> I was busy with some of the merge work and also some other issues.
> So this delayed response...

>>
>>Thanks for your work on this!

> You are most welcome !

>>> Where preset is one of the following values:-
>>>
>>> #define        V4L2_DV_CUSTOM        0x00000000
>>> #define       V4L2_DV_480I59_94     0x00000001
>>> #define       V4L2_DV_480I60        0x00000002
>>> #define       V4L2_DV_480P23_976    0x00000003
>>> #define       V4L2_DV_480P24        0x00000004
>>> #define       V4L2_DV_480P29_97     0x00000005
>>> #define       V4L2_DV_480P30        0x00000006
>>> #define       V4L2_DV_576I50        0x00000007
>>> #define       V4L2_DV_576P25        0x00000008
>>> #define       V4L2_DV_576P50        0x00000009
>>> #define       V4L2_DV_720P23_976    0x0000000A
>>> #define       V4L2_DV_720P24        0x0000000B
>>> #define       V4L2_DV_720P25        0x0000000C
>>> #define       V4L2_DV_720P29_97     0x0000000C
> I need to correct this and below for value.
>>> #define       V4L2_DV_720P30        0x0000000D
>>> #define       V4L2_DV_720P50        0x0000000E
>>> #define       V4L2_DV_720P59_94     0x0000000F
>>> #define       V4L2_DV_720P60        0x00000010
>>> #define       V4L2_DV_1080I50       0x00000011
>>> #define       V4L2_DV_1080I59_94    0x00000012
>>> #define       V4L2_DV_1080I60       0x00000013
>>> #define       V4L2_DV_1080P23_976   0x00000014
>>> #define       V4L2_DV_1080P24       0x00000015
>>> #define       V4L2_DV_1080P25       0x00000016
>>> #define       V4L2_DV_1080P29_97    0x00000017
>>> #define       V4L2_DV_1080P30       0x00000018
>>> #define       V4L2_DV_1080P60       0x00000019

>>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

id just like to point out your missing the generic 1080P50 ,
1080P100 hertz ,1080P200 Hz

 and the new 2K and 4K that have already been beta tested in the live DVB
 broadcasting POC trials..

 as you can see adding missed defines will mess up the flow of your
 entry's, there most be a better way to allow for mistakes omissions
 and future growth!

-- 
Best regards,
 david                            mailto:david.may10@ntlworld.com
===8<===========End of original message text===========



-- 
Best regards,
 david                            mailto:david.may10@ntlworld.com


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
