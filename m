Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59259 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbbFCTqK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 15:46:10 -0400
Message-ID: <556F597F.1070406@iki.fi>
Date: Wed, 03 Jun 2015 22:46:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>
CC: Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>	<556EB2F7.506@iki.fi>	<556EB4B0.8050505@iki.fi>	<CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>	<556F1E70.7070507@iki.fi> <CAAZRmGx9z_-_zs54+3OdEVj=H4ddwU0hh5+FaktzYYo=EabVzQ@mail.gmail.com>
In-Reply-To: <CAAZRmGx9z_-_zs54+3OdEVj=H4ddwU0hh5+FaktzYYo=EabVzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 10:08 PM, Olli Salonen wrote:
> I cold booted my number cruncher after a hiatus of a couple of weeks,
> applied a couple of extra dev_dbg printouts in the si2168_cmd_execute
> and installed the newly built module. The results:
>
> [  663.147757] si2168 2-0066: Silicon Labs Si2168 successfully attached
> [  663.151735] si2157 1-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [  663.152436] DVB: registering new adapter (saa7164)
> [  663.152441] saa7164 0000:07:00.0: DVB: registering adapter 1
> frontend 0 (Silicon Labs Si2168)...
> [  678.690104] si2168:si2168_init: si2168 2-0064:
> [  678.690111] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 13, rlen: 0
> [  678.690115] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: c0
> 12 00 0c 00 0d 16 00 00 00 00 00 00
> [  678.693331] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 8, rlen: 1
> [  678.693337] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: c0
> 06 01 0f 00 20 20 01
> [  678.701914] si2168:si2168_cmd_execute: si2168 2-0064: i2c read: 80
> [  678.701920] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution took 6 ms
> [  678.701923] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 1, rlen: 13
> [  678.701926] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: 02
> [  678.708631] si2168:si2168_cmd_execute: si2168 2-0064: i2c read: 80
> 00 44 34 30 02 00 00 00 00 00 00 00
> [  678.708636] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution took 2 ms
> [  678.708639] si2168 2-0064: unknown chip version Si2168-
> [  678.714777] si2168:si2168_init: si2168 2-0064: failed=-22
> [  678.727424] si2157 0-0060: found a 'Silicon Labs Si2157-A30'
> [  678.783587] si2157 0-0060: firmware version: 3.0.5
>
> The answer to the 02 command seems really odd. You can see it is a
> Si2168, version 40, but I'd expect the second octet to say 42 instead
> of 00.

Yeah, very odd. That byte should be letter A (0x41) or B (0x42) or 
likely C (0x43) in future when current C revision chips are seen.

Are you really sure it has returned (and worked) 0x42 earlier? Have you 
used Windows driver - I speculate if it could make permanent upgrade to 
chip to change it.

Timing issues are also possible. Maybe you could test with some extra 
sleeps, like adding 100ms delay between command request and reply.

Unfortunately value of those 3 bytes are really important as driver 
selects firmware to download according them.

regards
Antti

-- 
http://palosaari.fi/
