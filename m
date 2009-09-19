Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37250 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZISKvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 06:51:12 -0400
Message-ID: <4AB4B79C.7000802@iki.fi>
Date: Sat, 19 Sep 2009 13:51:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bert Haverkamp <bert@bertenselena.net>
CC: linux-media@vger.kernel.org
Subject: Re: usb dvb-c tuner status
References: <1e68a10b0908150515l217126f7j41e15ece329176e1@mail.gmail.com> <1e68a10b0909182348v2026a57dsc877a8c5c1e9289f@mail.gmail.com>
In-Reply-To: <1e68a10b0909182348v2026a57dsc877a8c5c1e9289f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2009 09:48 AM, Bert Haverkamp wrote:
> Hello all,
>
> A while back I asked about supported USB dvb-c devices.
> Meanwhile my search continued and I have extended my list of available devices.
> Unfortunately, none of them currently are supported by linux.
>
> Does anyone have viable solution for me?
>
> - Technotrend CT 1200 which is an old device, hard to get.
> - Technotrend CT-3650 for which there is one report that dvb-c works
> with a patch,(is this already in-tree?), but dvb-t and CI not
>   - Sundtek MediaTV Pro for which a closed source driver exists. I
> don't want to go that way.
>   Terratec Cinergy Hybrid H5  which seems to be troubled with a driver
> for a drx-k or drx-j chip.
> - Pinnacle 340e, depends on the xc4000 chip, under development by Devin.
> - Hauppauge WinTV HVR-930C, also drx-j based as far as I can see

Anysee E30C Plus
Anysee E30 Combo (DVB-T/DVB-C)
Reddo DVB-C USB BOx (I just added, goes to 2.6.32)

All those are using Philips TDA10023 demod, which seems to be almost 
only solution currently for open Linux DVB-C. Anysee contains also 
smartcard reader which is not supported (it is not CAM, just reader). 
Unfortunately market situation for those devices is currently few EU 
countries or Finland only.

Antti
-- 
http://palosaari.fi/
