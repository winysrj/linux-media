Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.44.20]:41140 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751240AbeEVRAg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 13:00:36 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 83C6C400D1665
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 11:36:28 -0500 (CDT)
Subject: Re: [media] duplicate code in media drivers
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devin Heitmueller <dheitmueller@linuxtv.org>
References: <20180521193951.GA16659@embeddedor.com>
 <20180521171415.00c56487@vento.lan>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <97ad3122-08c2-6f4c-bb50-2952723b8922@embeddedor.com>
Date: Tue, 22 May 2018 11:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <20180521171415.00c56487@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I already sent some patches based on your comments.

Thanks!
--
Gustavo

On 05/21/2018 03:14 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 21 May 2018 14:39:51 -0500
> "Gustavo A. R. Silva" <gustavo@embeddedor.com> escreveu:
> 
>> Hi Mauro,
>>
>> I found some duplicate code with the help of Coccinelle and Coverity. Notice that these are not code patches, they only point out the duplicate code in some media drivers:
>>
>> diff -u -p drivers/media/pci/bt8xx/dvb-bt8xx.c /tmp/nothing/media/pci/bt8xx/dvb-bt8xx.c
>> --- drivers/media/pci/bt8xx/dvb-bt8xx.c
>> +++ /tmp/nothing/media/pci/bt8xx/dvb-bt8xx.c
>> @@ -389,9 +389,7 @@ static int advbt771_samsung_tdtc9251dh0_
>>          else if (c->frequency < 600000000)
>>                  bs = 0x08;
>>          else if (c->frequency < 730000000)
>> -               bs = 0x08;
>>          else
>> -               bs = 0x08;
>>
>>          pllbuf[0] = 0x61;
>>          pllbuf[1] = div >> 8;
> 
> 
> Hmm... I *suspect* that "bs" here controls the frequency range for the
> tuner. Analog tuners have separate frequency regions that are controlled
> via a register, into a 4 or 5 bytes I2C sequence. They're all somewhat
> a clone of an old Philips design.
> 
> It should be safe to convert the "BS" sequence on something like:
> 
> 	if (c->frequency < 173000000)
>                  bs = 0x01;
>          else if (c->frequency < 470000000)
>                  bs = 0x02;
>          else
>                  bs = 0x08;
> 
> 
> 
>> diff -u -p drivers/media/usb/dvb-usb/dib0700_devices.c /tmp/nothing/media/usb/dvb-usb/dib0700_devices.c
>> --- drivers/media/usb/dvb-usb/dib0700_devices.c
>> +++ /tmp/nothing/media/usb/dvb-usb/dib0700_devices.c
>> @@ -1741,13 +1741,6 @@ static int dib809x_tuner_attach(struct d
>>          struct dib0700_adapter_state *st = adap->priv;
>>          struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
>>
>> -       if (adap->id == 0) {
>> -               if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
>> -                       return -ENODEV;
>> -       } else {
>> -               if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
>> -                       return -ENODEV;
>> -       }
> 
> I'm almost sure that, on the second if, it should be adap->fe_adap[1].fe.
> I tried in the past to check this, but didn't got an answer from the one
> that wrote the code.
> 
> Maybe we could add a /* FIXME: check if it is fe_adap[1] */ on the
> second clause.
> 
>>
>>          st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
>>          adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib8096_set_param_override;
>> diff -u -p drivers/media/dvb-frontends/mb86a16.c /tmp/nothing/media/dvb-frontends/mb86a16.c
>> --- drivers/media/dvb-frontends/mb86a16.c
>> +++ /tmp/nothing/media/dvb-frontends/mb86a16.c
>> @@ -1466,9 +1466,7 @@ static int mb86a16_set_fe(struct mb86a16
>>                                                          wait_t = (1572864 + state->srate / 2) / state->srate;
>>                                                  if (state->srate < 5000)
>>                                                          /* FIXME ! , should be a long wait ! */
>> -                                                       msleep_interruptible(wait_t);
>>                                                  else
>> -                                                       msleep_interruptible(wait_t);
> 
> I suspect that the goal here is to point that sleeping for
> (1572864 + state->srate / 2) / state->srate when srate is low will mean
> that it will take a lot of time to converge (probably causing timeout at
> userspace).
> 
> Basically, if srate is < 5000, the sleep time will be between
> 314 and 1575364 ms. The worse case scenario - although not realistic,
> in practice - is to wait up to 26 seconds. This is a very long time!
> 
> Probably, the right fix here would be to check if wait_t is bigger than
> a certain amount of time. If so, return an error.
> 
> I'm not against removing the if, but, if so, better to add a /* FIXME */
> block explaining that.
> 
> That's said, this is an old device. I doubt anyone would fix it.
> 
> 
>>
>>                                                  if (sync_chk(state, &junk) == 0) {
>>                                                          iq_vt_set(state, 1);
>> diff -u -p drivers/media/dvb-frontends/au8522_decoder.c /tmp/nothing/media/dvb-frontends/au8522_decoder.c
>> --- drivers/media/dvb-frontends/au8522_decoder.c
>> +++ /tmp/nothing/media/dvb-frontends/au8522_decoder.c
>> @@ -280,14 +280,9 @@ static void setup_decoder_defaults(struc
>>                          AU8522_TOREGAAGC_REG0E5H_CVBS);
>>          au8522_writereg(state, AU8522_REG016H, AU8522_REG016H_CVBS);
>>
>> -       if (is_svideo) {
>>                  /* Despite what the table says, for the HVR-950q we still need
>>                     to be in CVBS mode for the S-Video input (reason unknown). */
>>                  /* filter_coef_type = 3; */
>> -               filter_coef_type = 5;
>> -       } else {
>> -               filter_coef_type = 5;
>> -       }
> 
> Better ask Devin about this (c/c).
> 
>>
>>          /* Load the Video Decoder Filter Coefficients */
>>          for (i = 0; i < NUM_FILTER_COEF; i++) {
>>
>>
>> I wonder if some of the cases above were intentionally coded that way or some code needs to be removed.
>>
>> Thanks
>> --
>> Gustavo
> 
> 
> 
> Thanks,
> Mauro
> 
