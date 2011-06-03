Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:45803 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab1FCMWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 08:22:02 -0400
Message-ID: <4DE8D1E6.4000300@iki.fi>
Date: Fri, 03 Jun 2011 15:21:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter()
 from em28xx-dvb.c creates a hard module dependency
References: <87vcwpnavc.fsf@nemi.mork.no> <4DE60B36.9040507@iki.fi>	<87mxi1n7ql.fsf@nemi.mork.no> <87tyc9lbb1.fsf@nemi.mork.no>
In-Reply-To: <87tyc9lbb1.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/01/2011 08:18 PM, Bjørn Mork wrote:
> Bjørn Mork<bjorn@mork.no>  writes:
>
>> diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
>> index 7904ca4..d994592 100644
>> --- a/drivers/media/video/em28xx/em28xx-dvb.c
>> +++ b/drivers/media/video/em28xx/em28xx-dvb.c
>> @@ -669,7 +669,8 @@ static int dvb_init(struct em28xx *dev)
>>   			&em28xx_cxd2820r_config,&dev->i2c_adap, NULL);
>>   		if (dvb->fe[0]) {
>>   			struct i2c_adapter *i2c_tuner;
>> -			i2c_tuner = cxd2820r_get_tuner_i2c_adapter(dvb->fe[0]);
>> +			/* we don't really attach i2c_tuner.  Just reusing the symbol logic */
>> +			i2c_tuner = dvb_attach(cxd2820r_get_tuner_i2c_adapter, dvb->fe[0]);
>
> Except that this really messes up the reference count, and need to have
> a matching symbol_put...  So you should probably code it with
> symbol_request()/symbol_put() if you want to go this way instead of
> the dvb_attach shortcut .


There is some other FEs having also I2C adapter, I wonder how those 
handle this situation. I looked example from cx24123 and s5h1420 
drivers, both used by flexcop.

Did you see what is magic used those devices?


best regards,
Antti
-- 
http://palosaari.fi/
