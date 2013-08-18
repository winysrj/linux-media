Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48249 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3HRMQO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 08:16:14 -0400
Message-ID: <5210BAE2.6010007@iki.fi>
Date: Sun, 18 Aug 2013 15:15:30 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Petter Selasky <hps@bitfrost.no>
CC: Ulf <mopp@gmx.net>, linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54> <520F643C.70306@iki.fi> <5210B5F3.4040607@bitfrost.no>
In-Reply-To: <5210B5F3.4040607@bitfrost.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2013 02:54 PM, Hans Petter Selasky wrote:
> On 08/17/13 13:53, Antti Palosaari wrote:
>> On 08/17/2013 02:30 PM, Ulf wrote:
>>> Hi,
>>>
>>> I know the topic Hauppauge HVR-900 HD and HVR 930C-HD with si2165
>>> demodulator was already discussed
>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/40982
>>>
>>> and
>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/46266.
>>>
>>>
>>> Just for me as a confirmation nobody plans to work on a driver for
>>> si2165.
>>> Is there any chance how to push the development?
>>
>> comment mode
>> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/46266
>>
>>
>>
>> As far as I know there is none working with si2165 Linux driver.
>>
>> Last week I dumped out simple sniff from initial tuning to DVB-T channel
>> and parsed log - it was 1.1 MB after parsing - wow. I haven't analyzed
>> if it yet, but if it appears it is si2165 which generates that much
>> control I/O it could be big task to write driver.
>>
>> Anyone has the idea if that amount of USB I/O traffic is caused by
>> cx231xx ?
>>
>> regards
>> Antti
>>
>
> Hi,
>
> FYI: The Si2168 driver is available from "dvbsky-linux-3.9-hps-v2.diff"
> inside. Maybe the Si2165 is similar?
>
> http://www.selasky.org/hans_petter/distfiles/webcamd-3.10.0.7.tar.bz2

It is DVB-S driver. HVR-900 is DVB-T and DVB-C.

regards
Antti

-- 
http://palosaari.fi/
