Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50465 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3AAXc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 18:32:57 -0500
Message-ID: <50E37204.9060902@iki.fi>
Date: Wed, 02 Jan 2013 01:32:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Diorser <diorser@gmx.fr>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi> <op.wp88epxu4bfdfw@quantal> <op.wp889rso4bfdfw@quantal>
In-Reply-To: <op.wp889rso4bfdfw@quantal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2013 01:09 AM, Diorser wrote:
> Thanks for your so fast reply.
> Unfortunately, scanning output is always empty with 100% signal
> strength  (external antenna)
> I also use a AverTV super_007 with the same external antenna on a
> another PC with Kaffeine =Signal = 100%.

Does it show 100% even antenna is unplugged?

> I also tried different dvb-usb-af9035-02.fw  firmware with different
> LINK/OFDM value (I don't understand but just tried.).

I don't know exactly what are differences between all those firmwares, 
but I know all firmwares are not working with all devices.

> Never got any PID or channel.
> Scanning and tuning work (or seem to with w_scan or kaffeine), but no
> data output.

You mean you see LOCK flag gained, then there is maybe error pid filter 
timeouts?

> I've noticed that videobuf_dvb and videobuf_dma_sg modules are need by
> a  saa7134 card, and not by AF9035. (no videobuf / dvb_usb_af9035
> dependency).
> Don't know if it is normal or not.

It is normal.

> A bit frustrating to be so close to the end, but also a bit pessimistic
> because really reaching the limit of my skills.
> Anyway, I will stay tuned in case some values need to be modified in
> the  source for test, or any updates I will try.

Do you have some working device (saa7134?)?
If yes, use it to generate channels.conf and when you has working 
channels.conf you could use tzap to tune.

If not, then make channels conf by hand

make file .tzap/channels.conf
then add line to that file:
TEST:634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:512:650:17

replace 634000000 (634MHz) frequency of your transmitter. I think 8Mhz 
bandwidth is used for your area too, but if not change it to 7MHz. Other 
values are not critical as those are detected automatically.

After that you could tune: tzap -r TEST

Antti

>
> Many thanks.
> Diorser.
>
> On Tue, 01 Jan 2013 23:26:32 +0100, Antti Palosaari <crope@iki.fiwrote
>
>> Patch looks correct.
>>>
>> If you are talking of that error I saw wiki you mentioned it is not
>> error. You cannot use dvbsnoop like that. You have to tune to channel
>> first and only after device is tuned successfully pidscan is possible.
>>>
>>  # dvbsnoop -s pidscan
>>  dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
>>  Transponder PID-Scan...
>>  Error(22): DMX_SET_PES_FILTER: Invalid argument
>>>
>> If you are really sure your antenna is good (not that small antenna
>> bundled) and it does not work then there is some bug. I bet some GPIO
>> is wrong. Maybe you should take some sniffs using SniffUSB2.0 and look
>> there...
>>
>> regards
>> Antti
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
