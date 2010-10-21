Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43475 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0JUUG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 16:06:27 -0400
Received: by qwk3 with SMTP id 3so30197qwk.19
        for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 13:06:26 -0700 (PDT)
Subject: Re: [PATCH 4/4] [media] mceusb: Fix parser for Polaris
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20101021120748.47828273@pedra>
Date: Thu, 21 Oct 2010 16:06:40 -0400
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <21DE3D7F-2805-4A11-AE29-9713FA58F66D@wilsonet.com>
References: <cover.1287669886.git.mchehab@redhat.com> <20101021120748.47828273@pedra>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 21, 2010, at 10:07 AM, Mauro Carvalho Chehab wrote:

> Add a parser for polaris mce. On this device, sometimes, a control
> data appears together with the IR data, causing problems at the parser.
> Also, it signalizes the end of a data with a 0x80 value. The normal
> parser would believe that this is a time with 0x1f size, but cx231xx
> provides just one byte for it.
> 
> I'm not sure if the new parser would work for other devices (probably, it
> will), but the better is to just write it as a new parser, to avoid breaking
> support for other supported IR devices.

After staring at it for a while, I think it would work okay for all 2nd and 3rd-gen mceusb devices, but it would almost certainly break 1st-gen, as it can have distinct IR data packets split across urb -- that's the whole reason for the if rem == 0 check in the existing routine.

Ultimately though, this routine isn't that much different, and I *think* I see a way to extend the existing routine with some of the code from this one to make it work better for the polaris device.

Will still go ahead with some review comments here though.

> diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
> index 609bf3d..7210760 100644
> --- a/drivers/media/IR/mceusb.c
> +++ b/drivers/media/IR/mceusb.c
> @@ -265,6 +265,7 @@ struct mceusb_dev {
> 		u32 connected:1;
> 		u32 tx_mask_inverted:1;
> 		u32 microsoft_gen1:1;
> +		u32 is_polaris:1;
> 		u32 reserved:29;

reserved should be decremented by 1 here if adding another flag.


> 	} flags;
> 
> @@ -697,6 +698,90 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
> 	return carrier;
> }
> 
> +static void mceusb_parse_polaris(struct mceusb_dev *ir, int buf_len)
> +{
> +	struct ir_raw_event rawir;
> +	int i;
> +	u8 cmd;
> +
> +	while (i < buf_len) {

i is being used uninitialized here.


> +		cmd = ir->buf_in[i];
> +
> +		/* Discard any non-IR cmd */
> +
> +		if ((cmd & 0xe0) >> 5 != 4) {

I'd probably just stick with if ((cmd & 0xe0) != 0x80), or even != MCE_PULSE_BIT, since we have a #define for 0x80 already. (Though its not quite an accurate name in this case).


> +			i++;
> +			if (i >= buf_len)
> +				return;
> +
> +			cmd = ir->buf_in[i];	/* sub cmd */
> +			i++;
> +			switch (cmd) {
> +			case 0x08:
> +			case 0x14:
> +			case 0x17:
> +				i += 1;
> +				break;
> +			case 0x11:
> +				i += 5;
> +				break;
> +			case 0x06:
> +			case 0x81:
> +			case 0x15:
> +			case 0x16:
> +				i += 2;
> +				break;

#define's for each of these hex values would be good, if we can determine what they actually are.


> +		} else if (cmd == 0x80) {
> +			/*
> +			 * Special case: timeout event on cx231xx
> +			 * Is it needed to check if is_polaris?
> +			 */
> +			rawir.pulse = 0;
> +			rawir.duration = IR_MAX_DURATION;
> +			dev_dbg(ir->dev, "Storing %s with duration %d\n",
> +				rawir.pulse ? "pulse" : "space",
> +				rawir.duration);
> +
> +			ir_raw_event_store(ir->idev, &rawir);

I think this and the prior hunk are really the only things that need to be grafted into the existing routine to make it behave with this device. Lemme see what I can come up with...


-- 
Jarod Wilson
jarod@wilsonet.com



