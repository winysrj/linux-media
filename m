Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38804 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1GVQq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 12:46:28 -0400
Message-ID: <4E29A960.3090401@iki.fi>
Date: Fri, 22 Jul 2011 19:46:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
References: <201106070205.08118.jareguero@telefonica.net> <201107221802.34505.jareguero@telefonica.net> <4E29A087.4090507@iki.fi> <201107221825.48246.jareguero@telefonica.net>
In-Reply-To: <201107221825.48246.jareguero@telefonica.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2011 07:25 PM, Jose Alberto Reguero wrote:
> On Viernes, 22 de Julio de 2011 18:08:39 Antti Palosaari escribió:
>> On 07/22/2011 07:02 PM, Jose Alberto Reguero wrote:
>>> On Viernes, 22 de Julio de 2011 13:32:53 Antti Palosaari escribió:
>>>> Have you had to time test these?
>>>>
>>>> And about I2C adapter, I don't see why changes are needed. As far as I
>>>> understand it is already working with TDA10023 and you have done changes
>>>> for TDA10048 support. I compared TDA10048 and TDA10023 I2C functions and
>>>> those are ~similar. Both uses most typical access, for reg write {u8
>>>> REG, u8 VAL} and for reg read {u8 REG}/{u8 VAL}.
>>>>
>>>> regards
>>>> Antti
>>>
>>> I just finish the testing. The changes to I2C are for the tuner tda827x.
>>> The MFE fork fine. I need to change the code in tda10048 and ttusb2.
>>> Attached is the patch for CT-3650 with your MFE patch.
>>
>> You still pass tda10023 fe pointer to tda10048 for I2C-gate control
>> which is wrong. Could you send USB sniff I can look what there really
>> happens. If you have raw SniffUSB2 logs I wish to check those, other
>> logs are welcome too if no raw SniffUSB2 available.
>>
>
> Youre chnage don't work. You need to change the function i2c gate of tda1048
> for the one of tda1023, but the parameter of this function must be the fe
> pointer of tda1023. If this is a problem, I can duplicate tda1023 i2c gate in
> ttusb2 code and pass it to the tda10048. It is done this way in the first patch
> of this thread.

Yes I now see why it cannot work - since FE is given as a parameter to 
i2c_gate_ctrl it does not see correct priv and used I2C addr is read 
from priv. You must implement own i2c_gate_ctrl in ttusb2 driver. 
Implement own ct3650_i2c_gate_ctrl and override tda10048 i2c_gate_ctrl 
using that. Then call tda10023 i2c_gate_ctrl but instead of tda10048 FE 
use td10023 FE. Something like

static int ct3650_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
{
	return adap->mfe[0]->ops.i2c_gate_ctrl(POINTER_TO_TDA10023_FE, enable);
}

/* tuner is behind TDA10023 I2C-gate */
adap->mfe[1]->ops.i2c_gate_ctrl = ct3650_i2c_gate_ctrl;


Could you still send USB logs? I don't see it correct behaviour you need 
to change I2C-adaper when same tuner is used for DVB-T because it was 
already working in DVB-C mode.

regards
Antti

-- 
http://palosaari.fi/
