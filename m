Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56984 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1KLQ7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:59:33 -0500
Message-ID: <4EBEA5F3.1050103@iki.fi>
Date: Sat, 12 Nov 2011 18:59:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/7] af9015 dual tuner and othe fixes from my builds.
References: <4ebe9767.8366b40a.1a27.4371@mx.google.com> <4EBE9AA6.8090500@iki.fi>
In-Reply-To: <4EBE9AA6.8090500@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 06:11 PM, Antti Palosaari wrote:
> On 11/12/2011 05:57 PM, Malcolm Priestley wrote:
>> Here is the lastest patches, for dual tuner and other fixes on the
>> patchwork server.
>>
>>
>> Malcolm Priestley (7):
>> af9015 Slow down download firmware
>> af9015 Remove call to get config from probe.
>> af9015/af9013 full pid filtering.
>> af9013 frontend tuner bus lock and gate changes v2
>> af9015 bus repeater
>> af9013 Stop OFSM while channel changing.
>> af9013 empty buffer overflow command.
>>
>> drivers/media/dvb/dvb-usb/af9015.c | 220
>> +++++++++++++++++++++-------------
>> drivers/media/dvb/frontends/af9013.c | 18 +++-
>> drivers/media/dvb/frontends/af9013.h | 5 +-
>> 3 files changed, 158 insertions(+), 85 deletions(-)
>
> Uhhuh, you have done rather much changes. Are you really sure those all
> are needed and OK ?
>
> I think the issues are stream corruption and I2C some write fails. As I
> did some tests earlier it looked like I2C writes happens to fail when
> you program tuner and it is interrupted by some other command (read_snr,
> read_status, etc.).

I looked those just through and I want more information about every 
patch. Mainly I want to know which resolves which problem. As far as I 
understand, there is two problems;
1. register access fails sometimes (as I suspect in case of access some 
registers when firmware is programming tuner or doing some other task 
and does not expect it is interrupted)
2. stream corruptions

Is that possible you identify which changes fix 1 and what are for 2?

regards
Antti


-- 
http://palosaari.fi/
