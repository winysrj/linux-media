Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36464 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbFCJ3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 05:29:02 -0400
Received: by ieclw1 with SMTP id lw1so8873743iec.3
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2015 02:29:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556EB4B0.8050505@iki.fi>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
	<556EB2F7.506@iki.fi>
	<556EB4B0.8050505@iki.fi>
Date: Wed, 3 Jun 2015 11:29:01 +0200
Message-ID: <CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm seeing the same issue as well. I thought that maybe some recent
Si2168 changes did impact this, but it does not seem to be the case.

I made a quick test myself. I reverted the latest si2168 patches one
by one, but that did not remedy the situation. Anyway, the kernel log
does not seem to indicate that the si2168_cmd_execute itself would
fail (which is what happens after the I2C error handling patch in case
the demod sets the error bit).

olli@dl160:~/src/media_tree/drivers/media/dvb-frontends$ git log
--oneline si2168.c

d4b3830 Revert "[media] si2168: add support for gapped clock"
eb62eb1 Revert "[media] si2168: add I2C error handling"
7adf99d [media] si2168: add I2C error handling
8117a31 [media] si2168: add support for gapped clock
17d4d6a [media] si2168: add support for 1.7MHz bandwidth
683e98b [media] si2168: return error if set_frontend is called with invalid para
c32b281 [media] si2168: change firmware variable name and type
9b7839c [media] si2168: print chip version

dmesg lines when it fails (this is with a card that has worked before):

[66661.336898] saa7164[0]: registered device video0 [mpeg]
[66661.567295] saa7164[0]: registered device video1 [mpeg]
[66661.778660] saa7164[0]: registered device vbi0 [vbi]
[66661.778817] saa7164[0]: registered device vbi1 [vbi]
[66675.175508] si2168:si2168_init: si2168 2-0064:
[66675.187299] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution took 6 ms
[66675.194105] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution
took 2 ms [OLLI: The result of this I2C cmd must be bogus]
[66675.194110] si2168 2-0064: unknown chip version Si2168-
[66675.200244] si2168:si2168_init: si2168 2-0064: failed=-22
[66675.213020] si2157 0-0060: found a 'Silicon Labs Si2157-A30'
[66675.242856] si2157 0-0060: firmware version: 3.0.5

Cheers,
-olli

On 3 June 2015 at 10:02, Antti Palosaari <crope@iki.fi> wrote:
> On 06/03/2015 10:55 AM, Antti Palosaari wrote:
>>
>> On 06/03/2015 06:55 AM, Stephen Allan wrote:
>>>
>>> I am aware that there is some development going on for the saa7164
>>> driver to support the Hauppauge WinTV-HVR2205.  I thought I would post
>>> some feedback.  I have recently compiled the driver as at 2015-05-31
>>> using "media build tree".  I am unable to tune a channel.  When
>>> running the following w_scan command:
>>>
>>> w_scan -a4 -ft -cAU -t 3 -X > /tmp/tzap/channels.conf
>>>
>>> I get the following error after scanning the frequency range for
>>> Australia.
>>>
>>> ERROR: Sorry - i couldn't get any working frequency/transponder
>>>   Nothing to scan!!
>>>
>>> At the same time I get the following messages being logged to the
>>> Linux console.
>>>
>>> dmesg
>>> [165512.436662] si2168 22-0066: unknown chip version Si2168-
>>> [165512.450315] si2157 21-0060: found a 'Silicon Labs Si2157-A30'
>>> [165512.480559] si2157 21-0060: firmware version: 3.0.5
>>> [165517.981155] si2168 22-0064: unknown chip version Si2168-
>>> [165517.994620] si2157 20-0060: found a 'Silicon Labs Si2157-A30'
>>> [165518.024867] si2157 20-0060: firmware version: 3.0.5
>>> [165682.334171] si2168 22-0064: unknown chip version Si2168-
>>> [165730.579085] si2168 22-0064: unknown chip version Si2168-
>>> [165838.420693] si2168 22-0064: unknown chip version Si2168-
>>> [166337.342437] si2168 22-0064: unknown chip version Si2168-
>>> [167305.393572] si2168 22-0064: unknown chip version Si2168-
>>>
>>>
>>> Many thanks to the developers for all of your hard work.
>>
>>
>> Let me guess they have changed Si2168 chip to latest "C" version. Driver
>> supports only A and B (A20, A30 and B40). I have never seen C version.
>
>
> gah, looking the driver I think that is not issue - it will likely print
> "unknown chip version Si2168-C.." on that case already. However, I remember
> I have seen that kind of issue earlier too, but don't remember what was
> actual reason. Probably something to do with firmware, wrong firmware and
> loading has failed? Could you make cold boot, remove socket from the wallet
> and wait minute it really powers down, then boot and look what happens.
>
> regards
> Antti
>
>
>
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
