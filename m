Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:38162 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbeH1NF5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 09:05:57 -0400
Subject: Re: [PATCH v6 1/2] media: imx274: use regmap_bulk_write to write
 multybyte registers
To: Philippe De Muyter <phdm@macq.eu>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20180725162455.31381-1-luca@lucaceresoli.net>
 <20180725162455.31381-2-luca@lucaceresoli.net>
 <20180828090300.GA23579@frolo.macqel>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <9ed69bb8-ff2c-76bb-faef-71c06e96877b@lucaceresoli.net>
Date: Tue, 28 Aug 2018 11:14:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180828090300.GA23579@frolo.macqel>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,

thanks for you review.

On 28/08/2018 11:03, Philippe De Muyter wrote:
> On Wed, Jul 25, 2018 at 06:24:54PM +0200, Luca Ceresoli wrote:
>> Currently 2-bytes and 3-bytes registers are set by very similar
>> functions doing the needed shift & mask manipulation, followed by very
>> similar for loops setting one byte at a time over I2C.
>>
>> Replace all of this code by a unique helper function that calls
>> regmap_bulk_write(), which has two advantages:
>>  - sets all the bytes in a unique I2C transaction
>>  - removes lots of now unused code.
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
> ...
>> +/**
>> + * Write a multibyte register.
>> + *
>> + * Uses a bulk write where possible.
>> + *
>> + * @priv: Pointer to device structure
>> + * @addr: Address of the LSB register.  Other registers must be
>> + *        consecutive, least-to-most significant.
>> + * @val: Value to be written to the register (cpu endianness)
>> + * @nbytes: Number of bits to write (range: [1..3])
>> + */
>> +static int imx274_write_mbreg(struct stimx274 *priv, u16 addr, u32 val,
>> +			      size_t nbytes)
> 
> Should nbytes be called nbits, or is nbytes a 'Number of bytes' ?

This patch has already been applied, but I sent a fix:
https://patchwork.linuxtv.org/patch/51719/

-- 
Luca
