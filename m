Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60774 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbbFCPeL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 11:34:11 -0400
Message-ID: <556F1E70.7070507@iki.fi>
Date: Wed, 03 Jun 2015 18:34:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>
CC: Stephen Allan <stephena@intellectit.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>	<556EB2F7.506@iki.fi>	<556EB4B0.8050505@iki.fi> <CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
In-Reply-To: <CAAZRmGxby0r20HX6-MqmFBcJ1de3-Op0XHyO4QrErkZ0K3Om2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 12:29 PM, Olli Salonen wrote:
> I'm seeing the same issue as well. I thought that maybe some recent
> Si2168 changes did impact this, but it does not seem to be the case.
>
> I made a quick test myself. I reverted the latest si2168 patches one
> by one, but that did not remedy the situation. Anyway, the kernel log
> does not seem to indicate that the si2168_cmd_execute itself would
> fail (which is what happens after the I2C error handling patch in case
> the demod sets the error bit).
>
> olli@dl160:~/src/media_tree/drivers/media/dvb-frontends$ git log
> --oneline si2168.c
>
> d4b3830 Revert "[media] si2168: add support for gapped clock"
> eb62eb1 Revert "[media] si2168: add I2C error handling"
> 7adf99d [media] si2168: add I2C error handling
> 8117a31 [media] si2168: add support for gapped clock
> 17d4d6a [media] si2168: add support for 1.7MHz bandwidth
> 683e98b [media] si2168: return error if set_frontend is called with invalid para
> c32b281 [media] si2168: change firmware variable name and type
> 9b7839c [media] si2168: print chip version
>
> dmesg lines when it fails (this is with a card that has worked before):
>
> [66661.336898] saa7164[0]: registered device video0 [mpeg]
> [66661.567295] saa7164[0]: registered device video1 [mpeg]
> [66661.778660] saa7164[0]: registered device vbi0 [vbi]
> [66661.778817] saa7164[0]: registered device vbi1 [vbi]
> [66675.175508] si2168:si2168_init: si2168 2-0064:
> [66675.187299] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution took 6 ms
> [66675.194105] si2168:si2168_cmd_execute: si2168 2-0064: cmd execution
> took 2 ms [OLLI: The result of this I2C cmd must be bogus]
> [66675.194110] si2168 2-0064: unknown chip version Si2168-
> [66675.200244] si2168:si2168_init: si2168 2-0064: failed=-22
> [66675.213020] si2157 0-0060: found a 'Silicon Labs Si2157-A30'
> [66675.242856] si2157 0-0060: firmware version: 3.0.5

Okei, so it has been working earlier... Could you enable I2C debugs to 
see what kind of data that command returns?

What I suspect in first hand is that Windows driver has downloaded 
firmware to chip and linux driver does it again, but with incompatible 
firmware, which leads to situation it starts failing. But if that is 
issue you likely already noted it.

regards
Antti

-- 
http://palosaari.fi/
