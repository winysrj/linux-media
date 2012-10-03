Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33740 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab2JCIiY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 04:38:24 -0400
Message-ID: <506BF969.5080202@iki.fi>
Date: Wed, 03 Oct 2012 11:38:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] drxk: allow loading firmware synchrousnously
References: <1349204716-25971-1-git-send-email-mchehab@redhat.com> <201210030913.51397.o.endriss@gmx.de>
In-Reply-To: <201210030913.51397.o.endriss@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/2012 10:13 AM, Oliver Endriss wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> Due to udev-182, the firmware load was changed to be async, as
>> otherwise udev would give up of loading a firmware.
>>
>> Add an option to return to the previous behaviour, async firmware
>> loads cause failures with the tda18271 driver.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>   drivers/media/dvb-frontends/drxk.h      |  2 ++
>>   drivers/media/dvb-frontends/drxk_hard.c | 20 +++++++++++++++-----
>>   2 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
>> index d615d7d..94fecfb 100644
>> --- a/drivers/media/dvb-frontends/drxk.h
>> +++ b/drivers/media/dvb-frontends/drxk.h
>> @@ -28,6 +28,7 @@
>>    *				A value of 0 (default) or lower indicates that
>>    *				the correct number of parameters will be
>>    *				automatically detected.
>> + * @load_firmware_sync:		Force the firmware load to be synchronous.
>>    *
>>    * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
>>    * UIO-3.
>> @@ -39,6 +40,7 @@ struct drxk_config {
>>   	bool	parallel_ts;
>>   	bool	dynamic_clk;
>>   	bool	enable_merr_cfg;
>> +	bool	load_firmware_sync;
>>
>>   	bool	antenna_dvbt;
>>   	u16	antenna_gpio;
>> diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
>> index 1ab8154..8b4c6d5 100644
>> --- a/drivers/media/dvb-frontends/drxk_hard.c
>> +++ b/drivers/media/dvb-frontends/drxk_hard.c
>> @@ -6609,15 +6609,25 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
>>
>>   	/* Load firmware and initialize DRX-K */
>>   	if (state->microcode_name) {
>> -		status = request_firmware_nowait(THIS_MODULE, 1,
>> +		if (config->load_firmware_sync) {
>> +			const struct firmware *fw = NULL;
>> +
>> +			status = request_firmware(&fw, state->microcode_name,
>> +						  state->i2c->dev.parent);
>> +			if (status < 0)
>> +				fw = NULL;
>> +			load_firmware_cb(fw, state);
>> +		} else {
>> +			status = request_firmware_nowait(THIS_MODULE, 1,
>>   					      state->microcode_name,
>>   					      state->i2c->dev.parent,
>>   					      GFP_KERNEL,
>>   					      state, load_firmware_cb);
>> -		if (status < 0) {
>> -			printk(KERN_ERR
>> -			"drxk: failed to request a firmware\n");
>> -			return NULL;
>> +			if (status < 0) {
>> +				printk(KERN_ERR
>> +				       "drxk: failed to request a firmware\n");
>> +				return NULL;
>> +			}
>>   		}
>>   	} else if (init_drxk(state) < 0)
>>   		goto error;
>>
>
> Sorry. loading the firmware asynchronously is simply crap! Remove this!
>
> If you intend to load a firmware, firmware loading must be the first
> thing you do with the drxk. You must not access the device, before
> firmware loading has completed, or correct operation will not be
> guaranteed.
>
> If you insist to keep this option, I request that you make synchronous
> loading the default, and you enable asynchronous loading only for
> devices _you_ have tested. I will never use asynchronous loading.
> (In fact, I have already backed-out your firmware patches from my
> drivers and forked off my own version of the drxk.)

+1, indeed. Broken by design.
That was quite what I explained earlier too. You are not allowed to 
continue attach path until previous attach is done and chip is ready to 
offer interface(s) to the chips which are next in attach path. It is not 
only that, but general rule.

I don't see any reason why this code should be left here.

regards
Antti

-- 
http://palosaari.fi/
