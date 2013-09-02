Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1459 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3IBHP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Sep 2013 03:15:29 -0400
Message-ID: <52243B08.80401@xs4all.nl>
Date: Mon, 02 Sep 2013 09:15:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Dinesh Ram <dinram@cisco.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Dino d <dinesh.ram@cern.ch>
Subject: Re: [PATCH 3/6] si4713 : Bug fix for si4713_tx_tune_power() method
 in the i2c driver
References: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com> <1377862104-15429-1-git-send-email-dinram@cisco.com> <637d28441ff1e63ae72385afcba990fda11e0210.1377861337.git.dinram@cisco.com> <CAC-25o_Fk3fva7xdna=-fUv53vp2DjRt99+sEGwTwvgQn=cgkg@mail.gmail.com> <52231F3C.9000208@xs4all.nl> <CAC-25o8r4xMY_LFDMpszHZqoi0h13CR1wZYVXVHOmuorTmU=rg@mail.gmail.com> <5224376B.8020003@xs4all.nl>
In-Reply-To: <5224376B.8020003@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/2013 08:59 AM, Hans Verkuil wrote:
> On 09/01/2013 04:57 PM, edubezval@gmail.com wrote:
>> Hello Hans,
>>
>> On Sun, Sep 1, 2013 at 7:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 08/31/2013 01:49 PM, edubezval@gmail.com wrote:
>>>> Hi Dinesh,
>>>>
>>>> On Fri, Aug 30, 2013 at 7:28 AM, Dinesh Ram <dinram@cisco.com> wrote:
>>>>> In the si4713_tx_tune_power() method, the args array element 'power' can take values between
>>>>> SI4713_MIN_POWER and SI4713_MAX_POWER. power = 0 is also valid.
>>>>> All the values (0 > power < SI4713_MIN_POWER) are illegal and hence
>>>>> are all mapped to SI4713_MIN_POWER.
>>>>
>>>> While do we need to assume min power in these cases?
>>
>> s/While/Why! but I guess you already got it.
>>
>>>
>>> It makes no sense to map 0 < powers < MIN_POWER to 0 (i.e. power off). I would never
>>> expect that selecting a power > 0 would actually turn off power, so just map to the
>>> lowest possible power value.
>>
>> Hmm.. Interesting. Is this what you are seen currently?
>> 0 < power < MIN_POWER == power off?
> 
> Currently trying to use a power value in that range will result in the EDOM
> error. But that's quite unexpected for a control that's defined for the range
> [0..MAX_POWER]. So rather than return an error you map it internally to the
> lowest power value.
> 
>>
>> I would expect the driver to return an error code:
>>
>>     if (((power > 0) && (power < SI4713_MIN_POWER)) ||
>>         power > SI4713_MAX_POWER || antcap > SI4713_MAX_ANTCAP)
>>         return -EDOM;
>>
>> And that is why I am asking why are we assigning a min value when we
>> see a value out of the expected range?
> 
> The hardware expects the value 0 or a value in the range [MIN_POWER..MAX_POWER].
> The control expects a value in the range [0..MAX_POWER]. In order to prevent
> the driver from returning -EDOM for values in the range [1..MIN_POWER> we
> map those values to MIN_POWER. Returning an error in this case is not allowed
> by the V4L2 specification.
> 
>>
>>>
>>>>
>>>>>
>>>>> Signed-off-by: Dinesh Ram <dinram@cisco.com>
>>>>> ---
>>>>>  drivers/media/radio/si4713/si4713.c | 16 ++++++++--------
>>>>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
>>>>> index 55c4d27..5d0be87 100644
>>>>> --- a/drivers/media/radio/si4713/si4713.c
>>>>> +++ b/drivers/media/radio/si4713/si4713.c
>>>>> @@ -550,14 +550,14 @@ static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
>>>>>  }
>>>>>
>>>>>  /*
>>>>> - * si4713_tx_tune_power - Sets the RF voltage level between 88 and 115 dBuV in
>>>>> + * si4713_tx_tune_power - Sets the RF voltage level between 88 and 120 dBuV in
>>>>>   *                     1 dB units. A value of 0x00 indicates off. The command
>>>>>   *                     also sets the antenna tuning capacitance. A value of 0
>>>>>   *                     indicates autotuning, and a value of 1 - 191 indicates
>>>>>   *                     a manual override, which results in a tuning
>>>>>   *                     capacitance of 0.25 pF x @antcap.
>>>>>   * @sdev: si4713_device structure for the device we are communicating
>>>>> - * @power: tuning power (88 - 115 dBuV, unit/step 1 dB)
>>>>> + * @power: tuning power (88 - 120 dBuV, unit/step 1 dB)
>>>>>   * @antcap: value of antenna tuning capacitor (0 - 191)
>>>>>   */
>>>>>  static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
>>>>> @@ -571,16 +571,16 @@ static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
>>>>>          *      .Third byte = power
>>>>>          *      .Fourth byte = antcap
>>>>>          */
>>>>> -       const u8 args[SI4713_TXPWR_NARGS] = {
>>>>> +       u8 args[SI4713_TXPWR_NARGS] = {
>>>>>                 0x00,
>>>>>                 0x00,
>>>>>                 power,
>>>>>                 antcap,
>>>>>         };
>>>>>
>>>>> -       if (((power > 0) && (power < SI4713_MIN_POWER)) ||
>>>>> -               power > SI4713_MAX_POWER || antcap > SI4713_MAX_ANTCAP)
>>>>> -               return -EDOM;
>>>>> +       /* Map power values 1-87 to MIN_POWER (88) */
>>>>> +       if (power > 0 && power < SI4713_MIN_POWER)
>>>>> +               args[2] = power = SI4713_MIN_POWER;
>>>>
>>>> Why are you allowing antcap > SI4713_MAX_ANTCAP? and power >
>>>> SI4713_MAX_POWER too?
>>>
>>> The control framework already checks for that so you'll never see out-of-range values
>>> here. So it was an unnecessary check.
>>>
>>
>> I see. Are you sure about that?
> 
> I wrote the control framework, so yes, I'm sure about that. One of the reasons for the
> framework was to prevent all these checks in all the drivers.
> 
>>
>> I am just a bit concerned about regulations here. One can really get
>> in trouble if it can transmit FM for longer than 10m in some
>> countries, without a license.
> 
> Well, I assume Nokia knew what they were doing when they wrote this driver.
> AFAIK these devices are all low power with low ranges, meant for the mobile
> market.

Oops, I didn't notice until now that you're Eduardo Valentin: you email has changed
since the last time and I didn't notice your name. Of course you know all
about this device :-)

Regards,

	Hans
