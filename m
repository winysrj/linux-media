Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36674 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbbFCTIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 15:08:02 -0400
Received: by igbpi8 with SMTP id pi8so120259197igb.1
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2015 12:08:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556F1E70.7070507@iki.fi>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
	<556EB2F7.506@iki.fi>
	<556EB4B0.8050505@iki.fi>
	<CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
	<556F1E70.7070507@iki.fi>
Date: Wed, 3 Jun 2015 21:08:01 +0200
Message-ID: <CAAZRmGx9z_-_zs54+3OdEVj=H4ddwU0hh5+FaktzYYo=EabVzQ@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I cold booted my number cruncher after a hiatus of a couple of weeks,
applied a couple of extra dev_dbg printouts in the si2168_cmd_execute
and installed the newly built module. The results:

[  663.147757] si2168 2-0066: Silicon Labs Si2168 successfully attached
[  663.151735] si2157 1-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[  663.152436] DVB: registering new adapter (saa7164)
[  663.152441] saa7164 0000:07:00.0: DVB: registering adapter 1
frontend 0 (Silicon Labs Si2168)...
[  678.690104] si2168:si2168_init: si2168 2-0064:
[  678.690111] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 13, rlen: 0
[  678.690115] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: c0
12 00 0c 00 0d 16 00 00 00 00 00 00
[  678.693331] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 8, rlen: 1
[  678.693337] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: c0
06 01 0f 00 20 20 01
[  678.701914] si2168:si2168_cmd_execute: si2168 2-0064: i2c read: 80
[  678.701920] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution took 6 ms
[  678.701923] si2168:si2168_cmd_execute: si2168 2-0064: wlen: 1, rlen: 13
[  678.701926] si2168:si2168_cmd_execute: si2168 2-0064: i2c write: 02
[  678.708631] si2168:si2168_cmd_execute: si2168 2-0064: i2c read: 80
00 44 34 30 02 00 00 00 00 00 00 00
[  678.708636] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution took 2 ms
[  678.708639] si2168 2-0064: unknown chip version Si2168-
[  678.714777] si2168:si2168_init: si2168 2-0064: failed=-22
[  678.727424] si2157 0-0060: found a 'Silicon Labs Si2157-A30'
[  678.783587] si2157 0-0060: firmware version: 3.0.5

The answer to the 02 command seems really odd. You can see it is a
Si2168, version 40, but I'd expect the second octet to say 42 instead
of 00.

Cheers,
-olli

On 3 June 2015 at 17:34, Antti Palosaari <crope@iki.fi> wrote:
> On 06/03/2015 12:29 PM, Olli Salonen wrote:
>>
>> I'm seeing the same issue as well. I thought that maybe some recent
>> Si2168 changes did impact this, but it does not seem to be the case.
>>
>> I made a quick test myself. I reverted the latest si2168 patches one
>> by one, but that did not remedy the situation. Anyway, the kernel log
>> does not seem to indicate that the si2168_cmd_execute itself would
>> fail (which is what happens after the I2C error handling patch in case
>> the demod sets the error bit).
>>
>> olli@dl160:~/src/media_tree/drivers/media/dvb-frontends$ git log
>> --oneline si2168.c
>>
>> d4b3830 Revert "[media] si2168: add support for gapped clock"
>> eb62eb1 Revert "[media] si2168: add I2C error handling"
>> 7adf99d [media] si2168: add I2C error handling
>> 8117a31 [media] si2168: add support for gapped clock
>> 17d4d6a [media] si2168: add support for 1.7MHz bandwidth
>> 683e98b [media] si2168: return error if set_frontend is called with
>> invalid para
>> c32b281 [media] si2168: change firmware variable name and type
>> 9b7839c [media] si2168: print chip version
>>
>> dmesg lines when it fails (this is with a card that has worked before):
>>
>> [66661.336898] saa7164[0]: registered device video0 [mpeg]
>> [66661.567295] saa7164[0]: registered device video1 [mpeg]
>> [66661.778660] saa7164[0]: registered device vbi0 [vbi]
>> [66661.778817] saa7164[0]: registered device vbi1 [vbi]
>> [66675.175508] si2168:si2168_init: si2168 2-0064:
>> [66675.187299] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution
>> took 6 ms
>> [66675.194105] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution
>> took 2 ms [OLLI: The result of this I2C cmd must be bogus]
>> [66675.194110] si2168 2-0064: unknown chip version Si2168-
>> [66675.200244] si2168:si2168_init: si2168 2-0064: failed=-22
>> [66675.213020] si2157 0-0060: found a 'Silicon Labs Si2157-A30'
>> [66675.242856] si2157 0-0060: firmware version: 3.0.5
>
>
> Okei, so it has been working earlier... Could you enable I2C debugs to see
> what kind of data that command returns?
>
> What I suspect in first hand is that Windows driver has downloaded firmware
> to chip and linux driver does it again, but with incompatible firmware,
> which leads to situation it starts failing. But if that is issue you likely
> already noted it.
>
> regards
> Antti
>
> --
> http://palosaari.fi/
