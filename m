Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1I3KBf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 06:01:35 -0400
Message-ID: <4E859377.3000302@redhat.com>
Date: Fri, 30 Sep 2011 07:01:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Andy Walls <awalls@md.metrocast.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] ir-rc6-decoder: Support RC6-6A variable length data
References: <1317129069.1627.17.camel@gagarin>
In-Reply-To: <1317129069.1627.17.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-09-2011 10:11, Lawrence Rust escreveu:
> Hi,
> 
> This patch to the IR RC6 decoder adds support for variable length
> mode-6A frames which can range in size from 8 to 128 bits.  Please refer
> to the following link for a detailed explanation or RC6 frames:
> http://slydiman.narod.ru/scr/kb/rc6.htm
> 
> This change removes the assumption that frames are fixed length
> (currently either 24 or 32 data bits) and actually counts the number of
> bits until an end of frame marker is seen.
> 
> This change adds support for Sky/Sky+ RC's that transmit RC6-6A-24 i.e.
> 24 bit data.
> 
> The patch was made against git tag v2.6.39 and was tested with a MCE-USB
> and a Sky RC.
> 
> Comments & suggestions please.

One thing that has to be tested is if the RC6 decoder won't get RC5 keycodes.
We currently has this problem with a few remotes, but I'm afraid that using
a more relaxed code, we might be increasing this problem. I'll try to test
it later, if I can find some time for it.

> --
> Lawrence Rust
> 
>>From 44431fd36f4b766d2b26ff70fb79b9a7c9e869fe Mon Sep 17 00:00:00 2001
> From: Lawrence Rust <lvr@softsystem.co.uk>
> Date: Mon, 26 Sep 2011 15:21:13 +0200
> Subject: [PATCH] ir-rc6-decoder: Support RC6-6A variable length body
> 
> Signed-off-by: Lawrence Rust <lvr@softsystem.co.uk>
> ---
>  drivers/media/rc/ir-rc6-decoder.c |   65 ++++++++++++++++++++++---------------
>  1 files changed, 39 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
> index 755dafa..015038a 100644
> --- a/drivers/media/rc/ir-rc6-decoder.c
> +++ b/drivers/media/rc/ir-rc6-decoder.c
> @@ -17,24 +17,31 @@
>  /*
>   * This decoder currently supports:
>   * RC6-0-16	(standard toggle bit in header)
> + * RC6-6A-20	(no toggle bit)
>   * RC6-6A-24	(no toggle bit)
>   * RC6-6A-32	(MCE version with toggle bit in body)
>   */
>  
> -#define RC6_UNIT		444444	/* us */
> +#define RC6_UNIT		444444	/* nanosecs */
>  #define RC6_HEADER_NBITS	4	/* not including toggle bit */
>  #define RC6_0_NBITS		16
> -#define RC6_6A_SMALL_NBITS	24
> -#define RC6_6A_LARGE_NBITS	32
> +#define RC6_6A_32_NBITS	32
> +#define RC6_6A_NBITS		128	/* Variable 8..128 */

This won't work:

static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
{
	struct rc6_dec *data = &dev->raw->rc6;
	u32 scancode;


and also, from include/media/rc-map.h:

struct rc_map_table {
	u32	scancode;
	u32	keycode;
};


See? scancode currently has only 32 bits. For 128 bits to work, the code needs two
changes:

1) at ir-rc6-decoder: implement an "u128" data type, e. g. creating two vars: 
	u64  scan_low, scan_high;

and implement a logic to shift bits from one to the other at overflow, e . g.,
something like:

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c6ca870..b1d70692 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -60,7 +60,7 @@ struct ir_raw_event_ctrl {
 	struct rc6_dec {
 		int state;
 		u8 header;
-		u32 body;
+		u64 body_low, body_high;
 		bool toggle;
 		unsigned count;
 		unsigned wanted_bits;
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 755dafa..00f4bde 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -194,10 +194,12 @@ again:
 	case STATE_BODY_BIT_START:
 		if (!eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2))
 			break;
-
-		data->body <<= 1;
+		data->body_high <<= 1;
+		if (data->body_low & (1L << 64))
+			data->body_high |= 1;
+		data->body_low <<= 1;
 		if (ev.pulse)
-			data->body |= 1;
+			data->body_low |= 1;
 		data->count++;
 		data->state = STATE_BODY_BIT_END;
 		return 0;

2) the RC core also needs to be changed, in order to work with an arbitrary
number of bytes. My suggestion is to change it internally to work with a fixed
number of bits, by either using two 64 bits vars for scancode, or to use 
a more generic code like defining the scancode internally as:

	#define MAX_RC_BITS	128
	struct scancode_t {
		unsigned n_bytes;
		char	 *scancode;
	}

The advantage is that, if we need bigger scancodes, it will be just a matter
of increasing MAX_RC_BITS.

In any case, maybe we'll need to pass the number of the scancode bits
to the rc_keydown functions:

void rc_keydown(struct rc_dev *dev, struct scancode_t *scancode, unsigned n_bits, u8 toggle);
void rc_keydown_notimeout(struct rc_dev *dev, struct scancode_t *scancode, unsigned n_bits, u8 toggle);

The input API were already changed to accept an arbitrary number of bits
at the keycode get/set keys, but the driver currently truncates it to 32 bits,
and userspace is not prepared to use more than that. My suggestion is to use
at least 32 bits for those two ioctls.

Btw, if we opt to just use 128 bits, there are some btree routines for 128 bits alread
defined at include/linux/btree-128.h, and currently used on fs/logfs/segment.c. 
It is already included by include/linux/btree.h. Not sure if it would fit well, but it
deserves some investigation, as it may simplify the code.

Jarod,

Do you have any RC6 remote that can produce a scancode with more than 64 bits?

Thanks,
Mauro


>  #define RC6_PREFIX_PULSE	(6 * RC6_UNIT)
>  #define RC6_PREFIX_SPACE	(2 * RC6_UNIT)
>  #define RC6_BIT_START		(1 * RC6_UNIT)
>  #define RC6_BIT_END		(1 * RC6_UNIT)
>  #define RC6_TOGGLE_START	(2 * RC6_UNIT)
>  #define RC6_TOGGLE_END		(2 * RC6_UNIT)
> +#define RC6_SUFFIX_SPACE	(6 * RC6_UNIT)
>  #define RC6_MODE_MASK		0x07	/* for the header bits */
>  #define RC6_STARTBIT_MASK	0x08	/* for the header bits */
>  #define RC6_6A_MCE_TOGGLE_MASK	0x8000	/* for the body bits */
> +#define RC6_6A_LCC_MASK	0xffff0000 /* RC6-6A-32 long customer code mask */
> +#define RC6_6A_MCE_CC		0x800f0000 /* MCE customer code */
> +#ifndef CHAR_BIT
> +#define CHAR_BIT 8	/* Normally in <limits.h> */
> +#endif
>  
>  enum rc6_mode {
>  	RC6_MODE_0,
> @@ -124,6 +131,7 @@ again:
>  			break;
>  
>  		data->state = STATE_HEADER_BIT_START;
> +		data->header = 0;
>  		return 0;
>  
>  	case STATE_HEADER_BIT_START:
> @@ -170,20 +178,14 @@ again:
>  		data->state = STATE_BODY_BIT_START;
>  		decrease_duration(&ev, RC6_TOGGLE_END);
>  		data->count = 0;
> +		data->body = 0;
>  
>  		switch (rc6_mode(data)) {
>  		case RC6_MODE_0:
>  			data->wanted_bits = RC6_0_NBITS;
>  			break;
>  		case RC6_MODE_6A:
> -			/* This might look weird, but we basically
> -			   check the value of the first body bit to
> -			   determine the number of bits in mode 6A */
> -			if ((!ev.pulse && !geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2)) ||
> -			    geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
> -				data->wanted_bits = RC6_6A_LARGE_NBITS;
> -			else
> -				data->wanted_bits = RC6_6A_SMALL_NBITS;
> +			data->wanted_bits = RC6_6A_NBITS;
>  			break;
>  		default:
>  			IR_dprintk(1, "RC6 unknown mode\n");
> @@ -192,15 +194,21 @@ again:
>  		goto again;
>  
>  	case STATE_BODY_BIT_START:
> -		if (!eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2))
> -			break;
> -
> -		data->body <<= 1;
> -		if (ev.pulse)
> -			data->body |= 1;
> -		data->count++;
> -		data->state = STATE_BODY_BIT_END;
> -		return 0;
> +		if (eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2)) {
> +			/* Discard data bits that won't fit in data->body */
> +			if (data->count++ < CHAR_BIT * sizeof data->body) {
> +				data->body <<= 1;
> +				if (ev.pulse)
> +					data->body |= 1;
> +			}
> +			data->state = STATE_BODY_BIT_END;
> +			return 0;
> +		} else if (RC6_MODE_6A == rc6_mode(data) && !ev.pulse &&
> +				geq_margin(ev.duration, RC6_SUFFIX_SPACE, RC6_UNIT / 2)) {
> +			data->state = STATE_FINISHED;
> +			goto again;
> +		}
> +		break;
>  
>  	case STATE_BODY_BIT_END:
>  		if (!is_transition(&ev, &dev->raw->prev_ev))
> @@ -220,20 +228,21 @@ again:
>  
>  		switch (rc6_mode(data)) {
>  		case RC6_MODE_0:
> -			scancode = data->body & 0xffff;
> +			scancode = data->body;
>  			toggle = data->toggle;
>  			IR_dprintk(1, "RC6(0) scancode 0x%04x (toggle: %u)\n",
>  				   scancode, toggle);
>  			break;
>  		case RC6_MODE_6A:
> -			if (data->wanted_bits == RC6_6A_LARGE_NBITS) {
> -				toggle = data->body & RC6_6A_MCE_TOGGLE_MASK ? 1 : 0;
> -				scancode = data->body & ~RC6_6A_MCE_TOGGLE_MASK;
> +			scancode = data->body;
> +			if (data->count == RC6_6A_32_NBITS &&
> +					(scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
> +				/* MCE RC */
> +				toggle = (scancode & RC6_6A_MCE_TOGGLE_MASK) ? 1 : 0;
> +				scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
>  			} else {
>  				toggle = 0;
> -				scancode = data->body & 0xffffff;
>  			}
> -
>  			IR_dprintk(1, "RC6(6A) scancode 0x%08x (toggle: %u)\n",
>  				   scancode, toggle);
>  			break;
> @@ -242,6 +251,10 @@ again:
>  			goto out;
>  		}
>  
> +		if (data->count > CHAR_BIT * sizeof data->body)
> +			IR_dprintk(1, "RC6 scancode truncated from %u bits\n",
> +				data->count);
> +
>  		rc_keydown(dev, scancode, toggle);
>  		data->state = STATE_INACTIVE;
>  		return 0;

