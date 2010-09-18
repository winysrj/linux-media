Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:41942 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab0IRSIl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 14:08:41 -0400
Message-ID: <4C950026.9020403@iki.fi>
Date: Sat, 18 Sep 2010 21:08:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Afatech AF9015 & MaxLinear MXL5007T dual tuner 2
References: <4C94C25B.5080702@gmail.com>
In-Reply-To: <4C94C25B.5080702@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09/18/2010 04:44 PM, poma wrote:
> Problem:
> Boot from G2 (S5) aka Soft Off
> or
> Resume from G1 - S3 aka Suspend to RAM
> tuner #2 nonfunctional


> p.p.s.
> Boot from G2 (S5) aka Soft Off
> or
> Resume from G1 - S3 aka Suspend to RAM
> tuner #1 and tuner #2 functional WITH module option:
> dvb-core dvb_powerdown_on_sleep=0
> namely dvb_powerdown_on_sleep:
> 0: do not power down,
> 1: turn LNB voltage off on sleep (default) (int)
>
> Antti, is this the same case with TerraTec Cinergy T Stick Dual RC and
> is this the only solution, to keep the tuners on with "dvb-core
> dvb_powerdown_on_sleep=0"?

I think so. Must be GPIO problem. One of the last problematic part is 
GPIOs - feel free to reimplement.


Antti
-- 
http://palosaari.fi/
