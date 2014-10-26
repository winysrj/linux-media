Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48345 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaJZOhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 10:37:21 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so3862263pab.28
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 07:37:20 -0700 (PDT)
Date: Sun, 26 Oct 2014 22:37:25 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
References: <201410131444110937756@gmail.com>,
 <201410222016467965475@gmail.com>
Subject: Re: Re: [PATCH 3/3] DVBSky V3 PCIe card: add some changes to M88DS3103forsupporting the demod of M88RS6000
Message-ID: <201410262237204212225@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello:
On 2014-10-25 07:19:15, Antti Palosaari wrote:
>Moikka!
>
>On 10/22/2014 03:16 PM, Nibble Max wrote:
>> On 2014-10-22 05:24:02, Antti Palosaari wrote:
>>>
>>>
>>> On 10/13/2014 09:44 AM, Nibble Max wrote:
>>>> M88RS6000 is the integrated chip, which includes tuner and demod.
>>>> Its internal demod is similar with M88DS3103 except some registers definition.
>>>> The main different part of this internal demod from others is its clock/pll generation IP block sitting inside the tuner die.
>>>> So clock/pll functions should be configed through its tuner i2c bus, NOT its demod i2c bus.
>>>> The demod of M88RS6000 need the firmware: dvb-demod-m88rs6000.fw
>>>> firmware download link: http://www.dvbsky.net/download/linux/dvbsky-firmware.tar.gz
>>>
>>>> @@ -250,6 +251,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>>>>    	u16 u16tmp, divide_ratio;
>>>>    	u32 tuner_frequency, target_mclk;
>>>>    	s32 s32tmp;
>>>> +	struct m88rs6000_mclk_config mclk_cfg;
>>>>
>>>>    	dev_dbg(&priv->i2c->dev,
>>>>    			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
>>>> @@ -291,6 +293,26 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>>>>    	if (ret)
>>>>    		goto err;
>>>>
>>>> +	if (priv->chip_id == M88RS6000_CHIP_ID) {
>>>> +		ret = m88ds3103_wr_reg(priv, 0x06, 0xe0);
>>>> +		if (ret)
>>>> +			goto err;
>>>> +		if (fe->ops.tuner_ops.set_config) {
>>>> +			/* select main mclk */
>>>> +			mclk_cfg.config_op = 0;
>>>> +			mclk_cfg.TunerfreqMHz = c->frequency / 1000;
>>>> +			mclk_cfg.SymRateKSs = c->symbol_rate / 1000;
>>>> +			ret = fe->ops.tuner_ops.set_config(fe, &mclk_cfg);
>>>> +			if (ret)
>>>> +				goto err;
>>>> +			priv->mclk_khz = mclk_cfg.MclkKHz;
>>>> +		}
>>>> +		ret = m88ds3103_wr_reg(priv, 0x06, 0x00);
>>>> +		if (ret)
>>>> +			goto err;
>>>> +		usleep_range(10000, 20000);
>>>> +	}
>>>
>>> That looks odd and also ugly. You pass some values from demod to tuner
>>> using set_config callback. Tuner driver can get symbol_rate and
>>> frequency just similarly from property cache than demod. Why you do it
>>> like that?
>>>
>>> Clock is provided by tuner as you mention. I see you use that to pass
>>> used clock frequency from tuner to demod. This does not look nice and I
>>> would like to see clock framework instead. Or calculate clock on both
>>> drivers. Does the demod clock even needs to be changed? I think it is
>>> only TS stream size which defines used clock frequency - smaller the TS
>>> bitstream, the smaller the clock frequency needed => optimizes power
>>> consumption a little. But TS clock is calculated on tuner driver in any
>>> case?
>>>
>> Yes, M88RS6000 looks odd. This integrated chip has two part die, tuner die and demod die.
>> Its demod's clock(PLL) block is sitting insided the tuner die. The demod has no PLL ip block that makes demod die smaller.
>> The demod's clock can be adjusted according to the transponder's frequency and symbol rate.
>> So that the demod's clock and its harmonic frequency will not overlap with the transponder's frequency range.
>> It will improve its tuner's sensitivity.
>>
>> However the tuner driver can get the values from property cache.
>> Tuner driver does not know when need adjust this demod pll
>> and return the current demod pll value to the demod driver.
>> in "struct dvb_tuner_ops", there is no call back to do this directly.
>> So I select the general "set_config" call back.
>> TS main clock of demdod also need to be controlled in the tuner die.
>>
>> These demod's PLL registers have no relationship with tuner at all.
>> Logically, These demod's PLL registers should go with demod die as usual.
>> But in this case they goes with the tuner die physically and controlled through tuner i2c bus.
>>
>> The current dvb-frontend driver requires the tuner and demod to split into the seperate drivers.
>> The demod driver will not access tuner i2c bus directly.
>> But this integrate chip has more tighter relationship of its tuner and demod die.
>> That is reason why these odd call backs happen.
>
>I understand situation pretty well.
>Let me say it shortly still to make it clear for the possible others; 
>M88RS6000 is integrated DVB-S2 receiver containing demod IP block that 
>is very near to M88DS3103 demod and tuner which is not so near any 
>existing tuner chip. Both IP blocks, demod and tuner, are connected to 
>I2C bus. However, all demodulator clocks (master clock and TS master 
>clock) are coming from tuner die. Tuner gets reference clock from 27 MHz 
>Xtal and there is PLL or multiple PLLs to derive/generate all the other 
>needed clocks.

Yes.

>
>So now we need to get demod MCLK and TS MCLK from tuner to demod. I 
>looked the tuner driver and saw following possible M88RS6000 MCLKs 
>93.000, 96.000, 99.000, 110.250 MHz. Old M88DS3103 uses only 96.000 MHz. 
>There was rather simple logic to select suitable (smallest possible) 
>demod MCLK according to symbol rate. TS master clock calculation looked 
>more harder.
>
>1) demod MCLK calculation
>Could you write down smallest possible logic to calculate needed demod 
>MCLK frequency? I looked m88rs6000t_select_mclk(), but I am not very 
>happy as that function contains both dead-code and variables that are 
>initialized multiple times. So take a pen and paper, or text editor, and 
>write down code snippet for it.

The selection of 93,96,99MHz demod MCLK is related with two variables, symbol rate and tuner frequency.
Without tuner frequency, it should work in 96MHz which is same with the old M88DS3103. 

>
>2) TS MCLK calculation
>Initial TS master clock is calculated by demod driver, which then pass 
>that clock to tuner driver, which then programs it to PLL, and finally 
>PLL multipliers/dividers are read back and actual frequency is 
>calculated. Demod driver took that MCLK and uses integer divider in 
>order to get final TS clock. As there is rounding errors in any case and 
>TS clock is not critical at all, I wonder if it is wise to read it back 
>from PLL registers at all (on m88rs6000t driver). Do you have idea how 
>much there is rounding error in real life when TS MCLK is programmed? I 
>mean if you ask 96MHz TS MCLK, what the result is after you read 
>registers back?

The rounding error is depend on the demod MCLK and required TS MCLK.
The maxium rounding error of this TS MCLK is about 2% or 3MHz.
when demod MLCK sets to 110.25MHz and required TS MCLK sets to 144MHz, the actual TS MCLK is 147MHz.
I think it is fine if do not read back the actual TS MCLK.

>
>I mean these functions:
>m88rs6000t_set_ts_mclk()
>m88rs6000_get_ts_mclk()
>
>regards
>Antti
>
>-- 
>http://palosaari.fi/

BR,
Max

