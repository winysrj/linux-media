Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41243 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1KIWS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 17:18:56 -0500
Message-ID: <4EBAFC4C.1060608@iki.fi>
Date: Thu, 10 Nov 2011 00:18:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tvboxspy <malcolmpriestley@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC 2/2] tda18218: use generic dvb_wr_regs()
References: <4EB9C272.2010607@iki.fi> <4EBAF97F.4000105@test.com>
In-Reply-To: <4EBAF97F.4000105@test.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/10/2011 12:06 AM, tvboxspy wrote:
> The only thing I am not sure is whether devices such as af9013 are
> keeping their gate control continuously open through the write
> operations and not timing out.
>
> This applies to tda18218, mxl5005s and other tuners, which have
> multipliable writes with no gate control between the writes, only at the
> start and end of the sequence.
>
> Afatech seem to imply that full gate control is required on all I2C
> read/write operations.
>
> With other devices such as stv0288 do close their gate after a stop
> condition.

You mean AF9013 demod will close it gate automatically after the I2C 
STOP ? Answer is no.

There are some demods which closes it automatically, like RTL2830, and 
some may have configuration if close automatically or not. But most 
common is that gate needs to be opened and closed manually.

In case of automatic gate close it is easiest way to implement own 
I2C-adapter for demod. There is few such demods drivers already 
(implementing their own I2C-adapter).

regards
Antti
-- 
http://palosaari.fi/
