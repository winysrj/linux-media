Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35625 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbbFDIHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 04:07:48 -0400
Received: by igbzc4 with SMTP id zc4so2584860igb.0
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 01:07:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556F597F.1070406@iki.fi>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
	<556EB2F7.506@iki.fi>
	<556EB4B0.8050505@iki.fi>
	<CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
	<556F1E70.7070507@iki.fi>
	<CAAZRmGx9z_-_zs54+3OdEVj=H4ddwU0hh5+FaktzYYo=EabVzQ@mail.gmail.com>
	<556F597F.1070406@iki.fi>
Date: Thu, 4 Jun 2015 10:07:47 +0200
Message-ID: <CAAZRmGxB5TE0j4gR9e72qw+dRhEQYmhRx9P3YXDX-VV3pLgR+w@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My card has been always installed in a machine that does not have
Windows, so any interference with the Windows driver should not be an
issue. I found some old console logs from February 21 when I was
trying to put together a driver for the board. It shows that the
Si2168 chip on my board was at that time correctly detected as
Si2168-B40 by the si2168 driver and the 4.0.11 firmware was loaded ok.

[   28.646668] DVB: registering new adapter (saa7164)
[   28.646671] saa7164 0000:07:00.0: DVB: registering adapter 1
frontend 0 (Silicon Labs Si2168)...
[   28.648633] i2c i2c-4: Added multiplexed i2c bus 6
[   28.648638] si2168 4-0066: Silicon Labs Si2168 successfully attached
[   28.658000] si2157 6-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[   28.658439] DVB: registering new adapter (saa7164)
[   28.658442] saa7164 0000:07:00.0: DVB: registering adapter 2
frontend 0 (Silicon Labs Si2168)...
[   28.732812] init: plymouth-splash main process (1305) terminated
with status 1
[   35.214858] random: nonblocking pool is initialized
[  582.391928] si2168 3-0064: found a 'Silicon Labs Si2168-B40'
[  582.392289] si2168 3-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
[  584.946560] si2168 3-0064: firmware version: 4.0.11
[  584.984386] si2157 5-0060: found a 'Silicon Labs Si2157-A30'
[  585.058396] si2157 5-0060: firmware version: 3.0.5

I have some w_scan logs from that day that show that the card was
indeed working.

Cheers,
-olli


On 3 June 2015 at 21:46, Antti Palosaari <crope@iki.fi> wrote:
> On 06/03/2015 10:08 PM, Olli Salonen wrote:
>>
>> I cold booted my number cruncher after a hiatus of a couple of weeks,
>> applied a couple of extra dev_dbg printouts in the si2168_cmd_execute
>> and installed the newly built module. The results:
>>
>> [  663.147757] si2168 2-0066: Silicon Labs Si2168 successfully attached
>> [  663.151735] si2157 1-0060: Silicon Labs Si2147/2148/2157/2158
>> successfully attached
>> [  663.152436] DVB: registering new adapter (saa7164)
>> [  663.152441] saa7164 0000:07:00.0: DVB: registering adapter 1
>> frontend 0 (Silicon Labs Si2168)...
>> [  678.690104] si2168:si2168_init: si2168 2-0064:
>> [  678.690111] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 13, rlen: 0
>> [  678.690115] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: c0
>> 12 00 0c 00 0d 16 00 00 00 00 00 00
>> [  678.693331] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 8, rlen: 1
>> [  678.693337] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: c0
>> 06 01 0f 00 20 20 01
>> [  678.701914] si2168:si2168_cmd_execute: si2168 2-0064: i2c read: 80
>> [  678.701920] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution
>> took 6 ms
>> [  678.701923] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 1, rlen: 13
>> [  678.701926] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: 02
>> [  678.708631] si2168:si2168_cmd_execute: si2168 2-0064: i2c read: 80
>> 00 44 34 30 02 00 00 00 00 00 00 00
>> [  678.708636] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution
>> took 2 ms
>> [  678.708639] si2168 2-0064: unknown chip version Si2168-
>> [  678.714777] si2168:si2168_init: si2168 2-0064: failed=-22
>> [  678.727424] si2157 0-0060: found a 'Silicon Labs Si2157-A30'
>> [  678.783587] si2157 0-0060: firmware version: 3.0.5
>>
>> The answer to the 02 command seems really odd. You can see it is a
>> Si2168, version 40, but I'd expect the second octet to say 42 instead
>> of 00.
>
>
> Yeah, very odd. That byte should be letter A (0x41) or B (0x42) or likely C
> (0x43) in future when current C revision chips are seen.
>
> Are you really sure it has returned (and worked) 0x42 earlier? Have you used
> Windows driver - I speculate if it could make permanent upgrade to chip to
> change it.
>
> Timing issues are also possible. Maybe you could test with some extra
> sleeps, like adding 100ms delay between command request and reply.
>
> Unfortunately value of those 3 bytes are really important as driver selects
> firmware to download according them.
>
> regards
> Antti
>
> --
> http://palosaari.fi/
