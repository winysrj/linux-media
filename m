Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44573 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab3A0J1R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 04:27:17 -0500
Message-ID: <5104F2CF.7080205@iki.fi>
Date: Sun, 27 Jan 2013 11:26:39 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add lock to af9035 driver for dual mode
References: <45300900.lplt0zG7i2@jar7.dominio> <1411603.1yOyLSGzvX@jar7.dominio> <5100F440.90302@iki.fi> <2105558.TtkZgv1BCF@jar7.dominio>
In-Reply-To: <2105558.TtkZgv1BCF@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/27/2013 02:10 AM, Jose Alberto Reguero wrote:
> On Jueves, 24 de enero de 2013 10:43:44 Antti Palosaari escribió:
>> On 01/24/2013 02:15 AM, Jose Alberto Reguero wrote:
>>> On Jueves, 24 de enero de 2013 00:36:25 Antti Palosaari escribió:
>>>> On 01/24/2013 12:34 AM, Jose Alberto Reguero wrote:
>>>>> Add lock to af9035 driver for dual mode.
>>>>
>>>> May I ask why you do that?
>>>>
>>>> regards
>>>> Antti
>>>
>>> Just to avoid interference between the two demods.
>>>
>>> Jose Alberto
>>
>> ... and how you can see that interference? What should I do that I can
>> see these problems you are trying to fix with that patch.
>>
>> regards
>> Antti
>
> It is not to fix any real problem. It is to avoid concurrent access to both
> demods to prevent bad effects.
>
> Jose Alberto

You copy & pasted it from the AF9015 driver. The reason why it is there 
is firmware, which has some problems if it was interrupted in some 
cases. Like you were asking BER from the demod and then tuner access was 
done using same I2C adapter. AF9015 firmware offers I2C adapter for 2 
demod and 2 RF-tuners. First demod is integrated and is memory mapped - 
but what I remember you could access it via I2C too. AF9015 fw also has 
internally some logic, it access to tuner and demod registers directly.

Those locks seen in AF9015 driver are mostly due to af9015 firmware 
limitations and should not be copied to the any other driver without a 
real need. AF9035 fw seems to behave a better.

regards
Antti

-- 
http://palosaari.fi/
