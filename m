Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57248 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792AbcAYSUd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 13:20:33 -0500
Subject: Re: [PATCH 1/2] [media] m88rs6000t: Better exception handling in five
 functions
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5680FDB3.7060305@users.sourceforge.net>
 <alpine.DEB.2.10.1512281019050.2702@hadrien>
 <56810F56.4080306@users.sourceforge.net>
 <alpine.DEB.2.10.1512281134590.2702@hadrien>
 <568148FD.7080209@users.sourceforge.net>
 <5681497E.7030702@users.sourceforge.net> <20160125150136.449f2593@recife.lan>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56A6662C.3000804@users.sourceforge.net>
Date: Mon, 25 Jan 2016 19:15:08 +0100
MIME-Version: 1.0
In-Reply-To: <20160125150136.449f2593@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> This issue was detected by using the Coccinelle software.
>>
>> Move the jump label directly before the desired log statement
>> so that the variable "ret" will not be checked once more
>> after a function call.
>> Use the identifier "report_failure" instead of "err".
>>
>> Suggested-by: Julia Lawall <julia.lawall@lip6.fr>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> ---
>>  drivers/media/tuners/m88rs6000t.c | 154 +++++++++++++++++++-------------------
>>  1 file changed, 78 insertions(+), 76 deletions(-)
>>
>> diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
>> index 504bfbc..7e59a9f 100644
>> --- a/drivers/media/tuners/m88rs6000t.c
>> +++ b/drivers/media/tuners/m88rs6000t.c
>> @@ -44,7 +44,7 @@ static int m88rs6000t_set_demod_mclk(struct dvb_frontend *fe)
>>  	/* select demod main mclk */
>>  	ret = regmap_read(dev->regmap, 0x15, &utmp);
>>  	if (ret)
>> -		goto err;
>> +		goto report_failure;
> 
> Why to be so verbose?

Does the document "CodingStyle" give an indication in the section "Chapter 7:
Centralized exiting of functions"?


> Calling it as "err" is enough,

It seems that some short identifiers are popular during software development.


> and it means less code to type if we need to add another goto.

Would you like to increase the usage of jump labels which will contain
only a single character?

Regards,
Markus
