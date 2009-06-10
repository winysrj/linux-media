Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38061 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZFJAG5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2009 20:06:57 -0400
Message-ID: <4A2EF922.5040102@iki.fi>
Date: Wed, 10 Jun 2009 03:06:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Nikitenko <jan.nikitenko@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] af9015: fix stack corruption bug
References: <c4bc83220906091531h20677733kd993ed50c0bc74ec@mail.gmail.com>
In-Reply-To: <c4bc83220906091531h20677733kd993ed50c0bc74ec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2009 01:31 AM, Jan Nikitenko wrote:
> This patch fixes stack corruption bug present in af9015_eeprom_dump():
> the buffer buf is one byte smaller than required - there is 4 chars
> for address prefix, 16*3 chars for dump of 16 eeprom bytes per line
> and 1 byte for zero ending the string required, i.e. 53 bytes, but
> only 52 are provided.
> The one byte missing in stack based buffer buf causes following oops
> on MIPS little endian platform, because i2c_adap pointer in
> af9015_af9013_frontend_attach() is corrupted by inlined function
> af9015_eeprom_dump():

> Signed-off-by: Jan Nikitenko<jan.nikitenko@gmail.com>

Acked-by: Antti Palosaari <crope@iki.fi>

regards
Antti
-- 
http://palosaari.fi/
