Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2DRVyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 17:54:17 -0400
Message-ID: <4F8F37E3.1040408@redhat.com>
Date: Wed, 18 Apr 2012 18:53:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH] af9035: add remote control support
References: <201204071924.44679.hfvogt@gmx.net> <4F8ED65D.5090105@iki.fi> <4F8F136E.7030800@redhat.com> <201204182242.32330.hfvogt@gmx.net> <4F8F2E58.7000603@iki.fi>
In-Reply-To: <4F8F2E58.7000603@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-04-2012 18:12, Antti Palosaari escreveu:
> On 18.04.2012 23:42, Hans-Frieder Vogt wrote:
>> Am Mittwoch, 18. April 2012 schrieb Mauro Carvalho Chehab:
>>> Em 18-04-2012 11:57, Antti Palosaari escreveu:

>>>>>> +
>>>>>> +    if (af9035_config.raw_ir) {
>>>>>> +        ret = af9035_rd_reg(d, EEPROM_IR_TYPE,&tmp);
>>>>
>>>> No space between x,y, IIRC checkpatch reports that.
>>
>> the only errors that checkpatch is reporting is ERROR: trailing whitespace,
>> but that seems to be normal for lines in the patch that are unchanged (I run
>> checkpatch.pl --no-tree --file ...patch).
> 
> I still like idea to add one space after comma always

Me too. The above, even passing on checkpatch, is not the right CodingStyle.

Regards,
Mauro
