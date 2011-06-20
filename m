Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:39006 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1FTLPJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 07:15:09 -0400
Message-ID: <4DFF2BBA.70905@iki.fi>
Date: Mon, 20 Jun 2011 14:15:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David <reality_es@yahoo.es>
CC: linux-media@vger.kernel.org
Subject: Re: dual sveon stv22 Afatech af9015 support (kworld clone)
References: <S1753342Ab1FKJ3p/20110611092945Z+46855@vger.kernel.org>	<672951.10004.qm@web24108.mail.ird.yahoo.com>	<4DF4A292.3070409@iki.fi> <BANLkTikT9Tp6N9=Bf_cm7aYfiFdJEM-sbA@mail.gmail.com>
In-Reply-To: <BANLkTikT9Tp6N9=Bf_cm7aYfiFdJEM-sbA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/20/2011 11:51 AM, David wrote:
> Hello again:
> I ' m working with remote in sveon stv22:
>
> remote es a grid of buttons 4 buttons horizontally and 8 vertically

That's RC_MAP_MSI_DIGIVOX_III remote. It is already used by that AF9015. 
You should add USB-ID mapping for that remote to auto detect.


[...]

> If you want anything more tell my it
> .
>
> thanks for your time

You should make patch or two and send for me in order to get changes 
upstream.

1. add support for your device (USB ID + name)
2. map remote to your device.


regards
Antti

-- 
http://palosaari.fi/
