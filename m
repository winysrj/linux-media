Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42467 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2GJVcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 17:32:21 -0400
Message-ID: <4FFC9F5B.9000800@iki.fi>
Date: Wed, 11 Jul 2012 00:32:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: linux-media@vger.kernel.org
Subject: Re: comments for DVB LNA API
References: <4FFC5B4E.8080903@stevekerrison.com> <4FFC5B7A.5060708@stevekerrison.com>
In-Reply-To: <4FFC5B7A.5060708@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/10/2012 07:42 PM, Steve Kerrison wrote:
> On 10/07/12 17:20, Antti Palosaari wrote:
>> I am looking how to implement LNA support for the DVB API.
>>
>> What we need to be configurable at least is: OFF, ON, AUTO.
>>
>> There is LNAs that support variable gain and likely those will be
>> sooner or later. Actually I think there is already LNAs integrated to
>> the RF-tuner that offers adjustable gain. Also looking to NXP catalog
>> and you will see there is digital TV LNAs with adjustable gain.
>>
>> Coming from that requirements are:
>> adjustable gain 0-xxx dB
>> LNA OFF
>> LNA ON
>> LNA AUTO
>>
>> Setting LNA is easy but how to query capabilities of supported LNA
>> values? eg. this device has LNA which supports Gain=5dB, Gain=8dB, LNA
>> auto?
> Without having a sample of device capabilities this question may be
> irrelevant, but what if the gain is somewhat continuiously configurable
> vs. discretized? For example can some be configured just for 5,8 and 11,
> whilst some might have some 8-bit value that controls gain between 5 and
> 11?

Yes.
For example external DVB-T/C LNA NXP BGU7033. It does have 3 modes, 10 
dB, 5 dB and bypass -2 dB.

LNAs offering more adjustable gain is called VGA (variable gain 
amplifier). It could have control interface like 5-bits or some other 
bus like I2C. Those are usually integrated to the silicon RF-tuner and 
in that case configuration is possible via tuner registers. Usually it 
is not needed to configure at all on run-time.

>> LNA ON (bypass) could be replaced with Gain=0 and LNA ON with Gain>0,
>> Gain=-1 is for auto example.
>
> How should the API handle differences between the specified gain and the
> capabilities of the LNA? Round to nearest possible config if it's within
> the operating range; return error if out of range?

I think rounding is best approach.

Maybe it is not necessary to read at all. Just allow user set LNA in 
steps of one number, 0, 1, 2, 3, ..., 100 and let the driver detect 
scale. In that case simple LNA having only one static gain value has 
values: AUTO, 0, 1. LNA having 2 gain levels: AUTO, 0, 1, 2. VGA having 
3 bit control: AUTO, 0, 1, 2, 3, 4, 5, 6, 7.

regards
Antti


-- 
http://palosaari.fi/


