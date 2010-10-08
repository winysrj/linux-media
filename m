Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914Ab0JHMii (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 08:38:38 -0400
Message-ID: <4CAF10C4.2080701@redhat.com>
Date: Fri, 08 Oct 2010 09:38:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L/DVB: dib0700: Prevent NULL pointer dereference during
 probe
References: <20100926162553.660281c6@endymion.delvare> <20101008143251.55fed758@endymion.delvare>
In-Reply-To: <20101008143251.55fed758@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-10-2010 09:32, Jean Delvare escreveu:
> On Sun, 26 Sep 2010 16:25:53 +0200, Jean Delvare wrote:
>> Commit 8dc09004978538d211ccc36b5046919489e30a55 assumes that
>> dev->rc_input_dev is always set. It is, however, NULL if dvb-usb was
>> loaded with option disable_rc_polling=1.
>>
>> Signed-off-by: Jean Delvare <khali@linux-fr.org>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/dvb/dvb-usb/dib0700_core.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> --- linux-2.6.36-rc5.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2010-09-24 17:17:16.000000000 +0200
>> +++ linux-2.6.36-rc5/drivers/media/dvb/dvb-usb/dib0700_core.c	2010-09-26 15:04:59.000000000 +0200
>> @@ -674,7 +674,8 @@ static int dib0700_probe(struct usb_inte
>>  				dev->props.rc.core.bulk_mode = false;
>>  
>>  			/* Need a higher delay, to avoid wrong repeat */
>> -			dev->rc_input_dev->rep[REP_DELAY] = 500;
>> +			if (dev->rc_input_dev)
>> +				dev->rc_input_dev->rep[REP_DELAY] = 500;
>>  
>>  			dib0700_rc_setup(dev);
>>  
> 
> The already applied commit 04cab131ce2a267b6777a98d68fbc0cae44d4ba8
> (V4L/DVB: rc-core: increase repeat time) solves the problem in a
> different way, so you can ignore my patch above, it is no longer needed.
> 
OK.

Yeah, we needed to move this to IR core, as other drivers were suffering the
same issue, due to RC core timeouts.

Cheers,
Mauro

