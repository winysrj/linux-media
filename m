Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:53142 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194Ab1ESVuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 17:50:11 -0400
Message-ID: <4DD59090.3020900@iki.fi>
Date: Fri, 20 May 2011 00:50:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: wallak@free.fr
CC: linux-media@vger.kernel.org
Subject: Re: AverMedia A306 (cx23385, xc3028, af9013) (A577 too ?)
References: <S932606Ab1ESVJJ/20110519210909Z+86@vger.kernel.org> <1305839612.4dd587fc20a03@imp.free.fr>
In-Reply-To: <1305839612.4dd587fc20a03@imp.free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/20/2011 12:13 AM, wallak@free.fr wrote:
> I've tried to use my A306 board on my system. All the main chips are fully
> supported by linux.
>
> At this stage the CX23385 and the tuner: xc3028 seem to respond properly. But
> the DVB-T chip (af9013) is silent. Nevertheless both chips are visible on the
> I2C bus.

You should get I2C connection to chip and after that load firmware.

> I've no full datasheet of theses chips. with exception of the af9013 where this
> information is available:
> http://wenku.baidu.com/view/42240f72f242336c1eb95e08.html

Those documents are rather useless. There is few versions of Linux 
AF9015 driver around the net, which are rather near sample SDK code. Try 
to find one.

> At this stage the CLK signal of the DVB-T chip may be missing or something is
> wrong elsewhere.
>
> If you have the datasheets... Any help will be appreciated.
>
>
> Best Regards,
> Wallak.
>

Antti
-- 
http://palosaari.fi/
