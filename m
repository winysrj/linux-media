Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38552 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbaCaKTM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 06:19:12 -0400
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC  scancodes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Mar 2014 12:19:10 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
In-Reply-To: <5339390B.6030709@imgtec.com>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
 <5339390B.6030709@imgtec.com>
Message-ID: <4af025b742df648556360db390351166@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-03-31 11:44, James Hogan wrote:
> On 29/03/14 16:11, David Härdeman wrote:
>> Using the full 32 bits for all kinds of NEC scancodes simplifies 
>> rc-core
>> and the nec decoder without any loss of functionality.
>> 
>> In order to maintain backwards compatibility, some heuristics are 
>> added
>> in rc-main.c to convert scancodes to NEC32 as necessary.
>> 
>> I plan to introduce a different ioctl later which makes the protocol
>> explicit (and which expects all NEC scancodes to be 32 bit, thereby
>> removing the need for guesswork).
>> 
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>> ---
>> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c 
>> b/drivers/media/rc/img-ir/img-ir-nec.c
>> index 40ee844..133ea45 100644
>> --- a/drivers/media/rc/img-ir/img-ir-nec.c
>> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
>> @@ -5,42 +5,20 @@
>>   */
>> 
>>  #include "img-ir-hw.h"
>> -#include <linux/bitrev.h>
>> 
>>  /* Convert NEC data to a scancode */
>>  static int img_ir_nec_scancode(int len, u64 raw, enum rc_type 
>> *protocol,
>>  			       u32 *scancode, u64 enabled_protocols)
>>  {
>> -	unsigned int addr, addr_inv, data, data_inv;
>>  	/* a repeat code has no data */
>>  	if (!len)
>>  		return IMG_IR_REPEATCODE;
>> +
>>  	if (len != 32)
>>  		return -EINVAL;
>> -	/* raw encoding: ddDDaaAA */
>> -	addr     = (raw >>  0) & 0xff;
>> -	addr_inv = (raw >>  8) & 0xff;
>> -	data     = (raw >> 16) & 0xff;
>> -	data_inv = (raw >> 24) & 0xff;
>> -	if ((data_inv ^ data) != 0xff) {
>> -		/* 32-bit NEC (used by Apple and TiVo remotes) */
>> -		/* scan encoding: AAaaDDdd (LSBit first) */
>> -		*scancode = bitrev8(addr)     << 24 |
>> -			    bitrev8(addr_inv) << 16 |
>> -			    bitrev8(data)     <<  8 |
>> -			    bitrev8(data_inv);
>> -	} else if ((addr_inv ^ addr) != 0xff) {
>> -		/* Extended NEC */
>> -		/* scan encoding: AAaaDD */
>> -		*scancode = addr     << 16 |
>> -			    addr_inv <<  8 |
>> -			    data;
>> -	} else {
>> -		/* Normal NEC */
>> -		/* scan encoding: AADD */
>> -		*scancode = addr << 8 |
>> -			    data;
>> -	}
>> +
>> +	/* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
>> +	*scancode = swab32((u32)raw);
> 
> What's the point of the byte swapping?
> 
> Surely the most natural NEC encoding would just treat it as a single
> 32-bit (LSBit first) field rather than 4 8-bit fields that needs 
> swapping.

Thanks for having a look at the patches, I agree with your comments on 
the other patches (and I have to respin some of them because I missed 
two drivers), but the comments to this patch confuses me a bit.

That the NEC data is transmitted as 32 bits encoded with LSB bit order 
within each byte is AFAIK just about the only thing that all 
sources/documentation of the protocal can agree on (so bitrev:ing the 
bits within each byte makes sense, unless the hardware has done it 
already).

As for the byte order, AAaaDDdd corresponds to the transmission order 
and seems to be what most drivers expect/use for their RX data.

Are you suggesting that rc-core should standardize on ddDDaaAA order?

