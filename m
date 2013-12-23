Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:60407 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab3LWLbS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 06:31:18 -0500
Message-ID: <52B81EE5.201@imgtec.com>
Date: Mon, 23 Dec 2013 11:30:45 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 06/11] media: rc: img-ir: add NEC decoder module
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com> <1386947579-26703-7-git-send-email-james.hogan@imgtec.com> <20131222114901.3e5d7dae@samsung.com>
In-Reply-To: <20131222114901.3e5d7dae@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/12/13 13:49, Mauro Carvalho Chehab wrote:
> Em Fri, 13 Dec 2013 15:12:54 +0000
> James Hogan <james.hogan@imgtec.com> escreveu:
>> +/* Convert NEC data to a scancode */
>> +static int img_ir_nec_scancode(int len, u64 raw, u64 protocols)
>> +{
>> +	unsigned int addr, addr_inv, data, data_inv;
>> +	int scancode;
>> +	/* a repeat code has no data */
>> +	if (!len)
>> +		return IMG_IR_REPEATCODE;
>> +	if (len != 32)
>> +		return IMG_IR_ERR_INVALID;
>> +	addr     = (raw >>  0) & 0xff;
>> +	addr_inv = (raw >>  8) & 0xff;
>> +	data     = (raw >> 16) & 0xff;
>> +	data_inv = (raw >> 24) & 0xff;
>> +	/* Validate data */
>> +	if ((data_inv ^ data) != 0xff)
>> +		return IMG_IR_ERR_INVALID;
>> +
>> +	if ((addr_inv ^ addr) != 0xff) {
>> +		/* Extended NEC */
>> +		scancode = addr     << 16 |
>> +			   addr_inv <<  8 |
>> +			   data;
>> +	} else {
>> +		/* Normal NEC */
>> +		scancode = addr << 8 |
>> +			   data;
>> +	}
> 
> There are some types of NEC extended that uses the full 32 bits as
> scancodes. Those are used at least on Apple and TiVo remote controllers.

Ooh, I hadn't spotted that patch. I'll make the necessary changes.

I notice that the scancode produced by the raw NEC decoder is the raw
non-bit-reversed version of the bits received, whereas for normal and
extended NEC the scancode fields are bit reversed. The TiVo keymap
appears to confirm that this is essentially backwards:

NEC:0xAAaaCCcc (AA=address, aa=not A, CC=command, cc=not command)

				bitrev(CCcc):
{ 0xa10c140b, KEY_NUMERIC_1 },	d028
{ 0xa10c940b, KEY_NUMERIC_2 },	d029
{ 0xa10c540b, KEY_NUMERIC_3 },	d02a
{ 0xa10cd40b, KEY_NUMERIC_4 },	d02b
{ 0xa10c340b, KEY_NUMERIC_5 },	d02c
{ 0xa10cb40b, KEY_NUMERIC_6 },	d02d
{ 0xa10c740b, KEY_NUMERIC_7 },	d02e
{ 0xa10cf40b, KEY_NUMERIC_8 },	d02f
{ 0x0085302f, KEY_NUMERIC_8 },
{ 0xa10c0c03, KEY_NUMERIC_9 },	c030
{ 0xa10c8c03, KEY_NUMERIC_0 },	c031

Clearly CC is supposed to be the LSB of the command.

Is it possible to reverse the bits in these scancode encodings (and of
course update the keymaps) or does this constitute a stable ABI that is
now too late to change?

IMO the following encoding would make much better sense for 32bit NEC
scancodes:
bits 31:16 = bitrev(AAaa)
bits 15:0  = bitrev(CCcc)

I.e. just bit reverse each 16bit half.

This puts the LSB of the command field in the LSB of the scancode which
I think is important, and treats the address field as a continuous
16bits (even though the extended NEC scancodes have address bytes
swapped for some reason - although for address it doesn't really
matter). If we assume the high byte of the address (aa) is always
non-zero, then the scancodes can be distinguished.

Cheers
James

