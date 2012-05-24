Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39883 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab2EXO3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 10:29:33 -0400
Message-ID: <4FBE45C9.7010803@iki.fi>
Date: Thu, 24 May 2012 17:29:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: Re: [PATCH 3/3] fc001x: tuner driver for FC0013
References: <201205062257.02674.hfvogt@gmx.net> <4FB93B2E.6010109@iki.fi> <201205212319.58264.hfvogt@gmx.net>
In-Reply-To: <201205212319.58264.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.05.2012 00:19, Hans-Frieder Vogt wrote:
> Am Sonntag, 20. Mai 2012 schrieb Antti Palosaari:
>> On 06.05.2012 23:57, Hans-Frieder Vogt wrote:
>>> Support for tuner Fitipower FC0013

>>> +EXPORT_SYMBOL(fc0013_rc_cal_add);
>>
>> Could you explain what is use of that exported function?
>> I did not see any usage for it when looking dvb_usb_rtl28xxu ...
>>
> The windows driver uses this and the following function after tuning.
> Obviously it also works without, but I thought that it could be useful.
> However I can also leave it out and implement it again if there is a real need
> for it...

Maybe better to remove unused stuff and add it later if needed. 
Generally those SDKs contains tons of routines that are not needed 
normally - just only some certain case.


>>> +static int fc0013_set_vhf_track(struct fc0013_priv *priv, u32 freq)
>>> +{
>>> +	int ret;
>>> +	u8 tmp;
>>> +
>>> +	ret = fc0013_readreg(priv, 0x1d,&tmp);
>>> +	if (ret)
>>> +		goto error_out;
>>> +	tmp&= 0xe3;
>>> +	if (freq<= 177500) {		/* VHF Track: 7 */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x1c);
>>> +	} else if (freq<= 184500) {	/* VHF Track: 6 */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x18);
>>> +	} else if (freq<= 191500) {	/* VHF Track: 5 */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x14);
>>> +	} else if (freq<= 198500) {	/* VHF Track: 4 */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x10);
>>> +	} else if (freq<= 205500) {	/* VHF Track: 3 */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x0c);
>>> +	} else if (freq<= 219500) {	/* VHF Track: 2 */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x08);
>>> +	} else if (freq<   300000) {	/* VHF Track: 1 */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x04);
>>> +	} else {			/* UHF and GPS */
>>> +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x1c);
>>> +	}
>>
>> I think the generated code will be much smaller if you just resolve
>> register value and finally write it. As you can see the routine is for
>> selecting register 0x1d value based of target frequency.
>>
> OK. Will be changed.
>
>> Also using {..} for the single line is not allowed. Forget to ran
>> checkpatch.pl ?
>>
> strange enough checkpatch didn't detect that (maybe old version?).

Heh, true! I just tested and it did not recognize it. But my eyes are 
more careful to spot it :)

Reason seems to be those comments - it makes checkpatch.pl to assume it 
is multi-line block and thus braces needed. You can apply patch for 
checkpatch.pl to fix that issue ;)

>>> +	switch (priv->xtal_freq) {
>>> +	case FC_XTAL_27_MHZ:
>>> +		xtal_freq_khz_2 = 27000 / 2;
>>> +		break;
>>> +	case FC_XTAL_36_MHZ:
>>> +		xtal_freq_khz_2 = 36000 / 2;
>>> +		break;
>>> +	case FC_XTAL_28_8_MHZ:
>>> +	default:
>>> +		xtal_freq_khz_2 = 28800 / 2;
>>> +		break;
>>> +	}
>>
>> My personal opinion is that we should never use enums like that. If we
>> have some real number like a frequency it is always simple to pass it as
>> it is. In that case you have converted Xtal frequency first as a enum
>> value and then here from enum back to real Xtal. If real Xtal frequency
>> used you can just write it xtal_freq_khz_2 = config->xtal / 2;
>>
>> #define NUMBER_0 0
>> #define NUMBER_1 1
>>
>> or
>>
>> enum numbers {
>>     NUMBER_0 0,
>>     NUMBER_1 1,
>> }
>>
>> not good IMHO.
>
> I can follow your argumentation, but am not fully convinced:
> Chosing an enum for a limited number of options helps focus on the available
> options and thus reduces errors. If we had hundreds of possible crystal
> frequencies I would agree to directly use the frequency, but here we are
> talking about 3 possible values (may be more later, but certainly less than
> 10).
> Erroneously calling fc0013_attach with FC_XTAL_28_9_MHZ would be immediately
> detected at compile time, calling it with 28900000 would not.

Yes it is one point to use enums. Also you can just check correct values 
during attach() and print error.

Some devices, like AF9015, reads demod IF from the eeprom. And when 
there is enums used you will need to convert it or so. But such cases 
are not very common in anyway.

I personally like numbers when numbers can be used. But you can still 
use enums if you wish. It is choice of yours.

One related example I would like to point is RF channel bandwidth. It is 
was earlier defined as enums in our API but nowadays it is converted 
back to real frequency value (bandwidth_hz).

>> These two, FC0012 and FC0013, seems to contains a lot of same code. IIRC
>> FC0011 was also very similar. I wonder if all these tuner can be
>> supported by one driver.
>> As listed vendor page it looks like FC0011<  FC0012<  FC0013:
>> http://www.fiticomm.com/products.html
>>
> good point! I am well aware of the similarities, but felt it would be clearer
> to keep them separate. Since the registers of the fc0013 are no simple
> superset of the fc0012, we would need a lot of ifs and thens. That wouldn't be
> easy to read, and even more difficult to debug.

I haven't looked registers so carefully nor the code. Usually comparing 
registers gives good indicator if chips are same design or not. And in 
that case what I suspect was fc10013 is the full featured version and 
fc0011/fc0012 are subset of that (no GPS band).

> What would you think about an option where we have fc0012/fc0013 in one driver
> with different .._attach functions using different ..._tuner_ops diverting into
> special functions for fc0012 and fc0013?

It depends how much difference there is. Hard to say without comparing 
drivers more exactly.

> With regards to the fc0011: I don't have access to a device with that tuner,
> but I can make a try...

could be mission impossible :/

>> FC0014 seems to be rather much feature rich compared to these older ones
>> and thus I suspect it is totally different design.
>>
>> regards
>> Antti
>
> thanks very much for your comments. I really appreciate your critical view and
> your determination to create good quality code!
>
> Regards,
> Hans-Frieder
>
> Hans-Frieder Vogt                       e-mail: hfvogt<at>  gmx .dot. net

regards
Antti
-- 
http://palosaari.fi/
