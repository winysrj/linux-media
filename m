Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56478 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaGATHM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jul 2014 15:07:12 -0400
Message-ID: <53B306DD.6060204@iki.fi>
Date: Tue, 01 Jul 2014 22:07:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
CC: xpert-reactos@gmx.de
Subject: Re: [PATCH 1/3] si2165: Add demod driver for DVB-T only
References: <1398543680-21374-1-git-send-email-zzam@gentoo.org> <5376C5FA.5040701@iki.fi> <53B3056D.9020102@gentoo.org>
In-Reply-To: <53B3056D.9020102@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Matthias!

On 07/01/2014 10:01 PM, Matthias Schwarzott wrote:
> On 17.05.2014 04:14, Antti Palosaari wrote:

>> That driver could be a little bit modern in a following ways:
>> 1) dynamic debugs
>> 2) I2C client driver model
>> 3) RegMap API
>> 4) I2C mux adapter for tuner I2C bus / gate
>>
>> Maybe 30% less LOC.
>>
>> regards
>> Antti
>
> I hope to reduce LOC by using register data tables instead of long
> chains of register writes. But mixing 8 bits and larger writes makes
> this complicated.
> 1) I could also write the larger registers byte by byte -> bad performance.
> 2) store them byte by byte and let the register array write function
> collect them.
> 3) store them together with a size indicator -> wasted space when always
> reserving 32bits for the value and normally using only 8bits.
>
> I will send the next version later.

Just send your current driver out and improve it later in order to go 
ahead. There is many devices waiting that driver... :D

regards
Antti

-- 
http://palosaari.fi/
