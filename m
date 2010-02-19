Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0BSMXY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 07:23:24 -0500
Message-ID: <4B7E82AC.60500@redhat.com>
Date: Fri, 19 Feb 2010 10:23:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Robert Lowery <rglowery@exemail.com.au>
CC: Terry Wu <terrywu2009@gmail.com>, Andy Walls <awalls@radix.net>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Vincent McIntyre <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)  
              tuning  regression
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>    <2088.115.70.135.213.1262579258.squirrel@webmail.exetel.com.au>    <1262658469.3054.48.camel@palomino.walls.org>    <1262661512.3054.67.camel@palomino.walls.org>    <55306.115.70.135.213.1262748017.squirrel@webmail.exetel.com.au>    <1262829099.3065.61.camel@palomino.walls.org>    <1128.115.70.135.213.1262840633.squirrel@webmail.exetel.com.au>    <6ab2c27e1001070548y1a96f390uc7b7fbd18a78a564@mail.gmail.com>    <6ab2c27e1001070604m323ccb02g10a8c302c3edee79@mail.gmail.com>    <6ab2c27e1001070618ud7019b9s69180353010a1c96@mail.gmail.com>    <6ab2c27e1001070642k4d5bd81cud404fe77bc7a6bc5@mail.gmail.com>    <1197.115.70.135.213.1262917283.squirrel@webmail.exetel.com.au>    <4B7E1931.3090007@redhat.com> <52633.115.70.135.213.1266574714.squirrel@webmail.exetel.com.au>
In-Reply-To: <52633.115.70.135.213.1266574714.squirrel@webmail.exetel.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Lowery wrote:
> Mauro,
> 
> I had to make 2 changes to get the patch to work for me
> 
> see below
> 
> HTH
> 
> -Rob
> 
>> +		if (priv->firm_version >= 0x0302) {
>> +			if (priv->cur_fw.type & DTV7)
>> +				offset -= 300000;
>> +			else if (type != ATSC) /* DVB @6MHz, DTV 8 and DTV 7/8 */
>> +				offset += 200000;
>> +		} else {
>> +			if (priv->cur_fw.type & DTV7)
>> +				offset -= 500000;
> This should be offset += 500000;
> 
>>  		/*
>>  		 * The DTV7 S-code table needs a 700 kHz shift.
>>  		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
> I had to also delete the
> if (type & DTV7)
>     demod += 500
> 
> I suspect this is no longer required due to the offset += 500000 above

Both lines should be doing the same thing, but IMO, the better is to keep 
the change at the demod.

Could you please preserve the above and remove the offset +=500000 ?

Note: are you available for irc? if so, please join #linuxtv at freenode.net.

Cheers,
Mauro
