Return-path: <mchehab@pedra>
Received: from tur.go2.pl ([193.17.41.50]:44296 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0KIPDj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 10:03:39 -0500
Received: from moh1-ve3.go2.pl (moh1-ve3.go2.pl [193.17.41.134])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id 9B48B230078
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 16:03:35 +0100 (CET)
Received: from moh1-ve3.go2.pl (unknown [10.0.0.134])
	by moh1-ve3.go2.pl (Postfix) with ESMTP id 43B3057025F
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 16:02:47 +0100 (CET)
Received: from unknown (unknown [10.0.0.42])
	by moh1-ve3.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 16:02:47 +0100 (CET)
Message-ID: <4CD96294.8010905@o2.pl>
Date: Tue, 09 Nov 2010 16:02:44 +0100
From: Maciej Szmigiero <mhej@o2.pl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [V4L][SAA7134] fix tda9887 detection on cold and eeprom read
 corruption on warm Medion 7134
References: <4CC5C568.4090809@o2.pl> <4CD9280C.40204@infradead.org>
In-Reply-To: <4CD9280C.40204@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

W dniu 09.11.2010 11:53, Mauro Carvalho Chehab pisze:
> Em 25-10-2010 15:59, Maciej Szmigiero escreveu:
>> +			printk(KERN_NOTICE "%s DVB-T demod i2c gate was left"
>> +						    " closed\n", dev->name);
>> +			printk(KERN_NOTICE "%s previous informational"
>> +					    " EEPROM read might have been"
>> +					    " corrupted\n", dev->name);
> 
> hmm... I don't think we need those debug messages on normal cases. 

I added this message because when the gate was left closed the eeprom content (printed out unconditionally in saa7134_i2c_eeprom) looks garbled in dmesg,
so it's better to inform user that he (or she) shouldn't be worried about this.
The eeprom dump is called from saa7134_i2c_register, before card-specific code has opportunity to run.

>>  	saa7134_tuner_setup(dev);
>>  
>> +	/* some cards (Medion 7134 for example) needs tuner to be setup */
>> +	/* before tda9887 shows itself on i2c bus */
>> +	if ((TUNER_ABSENT != dev->tuner_type)
>> +			&& (dev->tda9887_conf & TDA9887_PRESENT)) {
>> +		v4l2_i2c_new_subdev(&dev->v4l2_dev,
>> +			&dev->i2c_adap, "tuner", "tuner",
>> +			0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
>> +	}
>> +
>>  	switch (dev->board) {
>>  	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
>>  	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
> 
> The order change for the demod probe will likely break support for other boards.
> If the problem is specific to Medion 7134, what you should do, instead, is to
> change the order just for MD7134 (so, inside the switch(dev->board)).

It was done in that order (tuner first then tda9887) for a long time before it was changed.
For example ( http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/media/video/saa7134/saa7134-core.c;hb=7a766f9ddd74b50d6069f054a3004ece0439f5c1 ) it used to look like that:
 942         /* load i2c helpers */
 943         if (TUNER_ABSENT != dev->tuner_type)
 944                 request_module("tuner");
 945         if (dev->tda9887_conf)
 946                 request_module("tda9887");
 947         if (card_is_empress(dev)) {
 948                 request_module("saa6752hs");
 949                 request_module_depend("saa7134-empress",&need_empress);
 950         }

But then the code for tda9887 was integrated into tuner module and later split out again, this time reversing the detection order (by accident I suppose).
 
> Cheers,
> Mauro.
> 

Best regards,
Maciej Szmigiero
