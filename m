Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46036 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab3LMT1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 14:27:24 -0500
Message-ID: <52AB5F99.7070405@iki.fi>
Date: Fri, 13 Dec 2013 21:27:21 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 4/4] v4l: 1 Hz resolution flag for tuners
References: <1386806043-5331-1-git-send-email-crope@iki.fi> <1386806043-5331-5-git-send-email-crope@iki.fi> <52A96C00.8060607@xs4all.nl> <52A9F0C7.2050602@iki.fi> <52AB1447.9090601@xs4all.nl> <52AB2B02.3090300@iki.fi> <52AB30E9.40209@xs4all.nl>
In-Reply-To: <52AB30E9.40209@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.12.2013 18:08, Hans Verkuil wrote:
> On 12/13/2013 04:42 PM, Antti Palosaari wrote:
>> On 13.12.2013 16:05, Hans Verkuil wrote:
>>> On 12/12/2013 06:22 PM, Antti Palosaari wrote:

>> I really appreciate that as simply has no enough knowledge from V4L2 API
>> and API changes are needed. I will try to list here shortly some SDR
>> devices in general level enough.
>>
>> ant = antenna
>> host = host computer, PC (SW modulator/demodulator)
>> ADC = analog to digital converter
>> DAC = digital to analog converter
>> amp = amplifier
>> mixer = "TX tuner"
>>
>> receiver:
>> ant <> RF tuner <> ADC <> bridge <> host
>> ant <>ADC <> bridge <> host
>> ant <> up-converter <> RF tuner <> ADC <> bridge <> host
>>
>> transmitter:
>> ant <> amp <> mixer <> DAC <> bridge <> host
>> ant <> mixer <> DAC <> bridge <> host
>> ant <> DAC <> bridge <> host
>>
>> Those are the used building blocks in some general view. ADC (DAC) is
>> most important hardware block, but RF tuner is also critical in practice.
>>
>> So what I understood, V4L2 API "tuner" is kinda logical entity that
>> represent single radio device, containing RF tuner, demodulator and so.
>> That same logical entity in DVB API side is frontend, which is mostly
>> implemented by demodulator with a help of RF tuner.
>>
>> So what is needed is to make V4L2 API entity (tuner I guess) that could
>> represent both ADC and RF tuner.
>
> Well, a V4L2 tuner represents the hardware that requires a frequency.
> Which for typical radio and TV devices means the RF tuner + demodulator
> combo. So externally you see only one tuner, but internally there are
> often two devices (tuner and modulator) that have to be controlled.
>
> For SDR you have an RF Tuner with a frequency and an ADC with a frequency,
> and the two frequencies can be set independently. So representing that
> as two tuners seems like a sensible mapping to me.

Correct. Both RF tuner and ADC are independent each others and both must 
be possible to adjust runtime.

Shortly, all-in-all, I will implement those as a tuner#0 is ADC and 
tuner#1 is RF tuner. Patches with corrections follow soon.

regards
Antti

-- 
http://palosaari.fi/
