Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030524Ab2AFTEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 14:04:50 -0500
Message-ID: <4F0745C0.50605@redhat.com>
Date: Fri, 06 Jan 2012 17:04:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-media@vger.kernel.org, Michael Hunold <michael@mihu.de>,
	Johannes Stezenbach <js@sig21.net>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 0/2] Re: [git:v4l-dvb/for_v3.3] [media] dvb-bt8xx: handle
 errors from dvb_net_init
References: <E1RjBAD-0006Ue-NL@www.linuxtv.org> <20120106182519.GE15740@elie.hsd1.il.comcast.net>
In-Reply-To: <20120106182519.GE15740@elie.hsd1.il.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-01-2012 16:25, Jonathan Nieder wrote:
> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
> 
>> Subject: [media] dvb-bt8xx: handle errors from dvb_net_init
> [...]
>> [mchehab.redhat.com: codingstyle fix: printk() should include KERN_ facility level]
> [...]
>> --- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
>> +++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
>> @@ -782,7 +782,12 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
>>  		goto err_remove_mem_frontend;
>>  	}
>>  
>> -	dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
>> +	result = dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
>> +	if (result < 0) {
>> +		printk(KERN_ERR,
>> +		       "dvb_bt8xx: dvb_net_init failed (errno = %d)\n", result);
> 
> I think there is an extra comma here:

Yeah, I noticed it, but only after adding it at the main repo :(
> 
> 	$ make drivers/media/dvb/bt8xx/dvb-bt8xx.o
> 	  CHK     include/linux/version.h
> 	  CHK     include/generated/utsrelease.h
> 	  CALL    scripts/checksyscalls.sh
> 	  CC [M]  drivers/media/dvb/bt8xx/dvb-bt8xx.o
> 	drivers/media/dvb/bt8xx/dvb-bt8xx.c: In function ‘dvb_bt8xx_load_card’:
> 	drivers/media/dvb/bt8xx/dvb-bt8xx.c:788:10: warning: too many arguments for format [-Wformat-extra-args]
> 
> Perhaps it would be better to add the KERN_ levels throughout the file
> with a separate patch.  Like this:
> 
> Jonathan Nieder (2):
>   [media] dvb-bt8xx: use dprintk for debug statements
>   [media] dvb-bt8xx: convert printks to pr_err()
> 
>  drivers/media/dvb/bt8xx/dvb-bt8xx.c |   41 +++++++++++++++++------------------
>  1 files changed, 20 insertions(+), 21 deletions(-)

