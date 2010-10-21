Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab0JUUiW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 16:38:22 -0400
Message-ID: <4CC0A4BA.4080105@redhat.com>
Date: Thu, 21 Oct 2010 18:38:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] [media] mceusb: Fix parser for Polaris
References: <cover.1287669886.git.mchehab@redhat.com> <20101021120748.47828273@pedra> <21DE3D7F-2805-4A11-AE29-9713FA58F66D@wilsonet.com>
In-Reply-To: <21DE3D7F-2805-4A11-AE29-9713FA58F66D@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-10-2010 18:06, Jarod Wilson escreveu:
> On Oct 21, 2010, at 10:07 AM, Mauro Carvalho Chehab wrote:
> 
>> Add a parser for polaris mce. On this device, sometimes, a control
>> data appears together with the IR data, causing problems at the parser.
>> Also, it signalizes the end of a data with a 0x80 value. The normal
>> parser would believe that this is a time with 0x1f size, but cx231xx
>> provides just one byte for it.
>>
>> I'm not sure if the new parser would work for other devices (probably, it
>> will), but the better is to just write it as a new parser, to avoid breaking
>> support for other supported IR devices.
> 
> After staring at it for a while, I think it would work okay for all 2nd and 3rd-gen mceusb devices, but it would almost certainly break 1st-gen, as it can have distinct IR data packets split across urb -- that's the whole reason for the if rem == 0 check in the existing routine.
> 
> Ultimately though, this routine isn't that much different, and I *think* I see a way to extend the existing routine with some of the code from this one to make it work better for the polaris device.
> 
> Will still go ahead with some review comments here though.
> 
>> diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
>> index 609bf3d..7210760 100644
>> --- a/drivers/media/IR/mceusb.c
>> +++ b/drivers/media/IR/mceusb.c
>> @@ -265,6 +265,7 @@ struct mceusb_dev {
>> 		u32 connected:1;
>> 		u32 tx_mask_inverted:1;
>> 		u32 microsoft_gen1:1;
>> +		u32 is_polaris:1;
>> 		u32 reserved:29;
> 
> reserved should be decremented by 1 here if adding another flag.

Ok. By curiosity, why are you reserving space on a bit array like that?


>> 	} flags;
>>
>> @@ -697,6 +698,90 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
>> 	return carrier;
>> }
>>
>> +static void mceusb_parse_polaris(struct mceusb_dev *ir, int buf_len)
>> +{
>> +	struct ir_raw_event rawir;
>> +	int i;
>> +	u8 cmd;
>> +
>> +	while (i < buf_len) {
> 
> i is being used uninitialized here.

Ops!

>> +		cmd = ir->buf_in[i];
>> +
>> +		/* Discard any non-IR cmd */
>> +
>> +		if ((cmd & 0xe0) >> 5 != 4) {
> 
> I'd probably just stick with if ((cmd & 0xe0) != 0x80), or even != MCE_PULSE_BIT, since we have a #define for 0x80 already. (Though its not quite an accurate name in this case).

Ok.
 
>> +			i++;
>> +			if (i >= buf_len)
>> +				return;
>> +
>> +			cmd = ir->buf_in[i];	/* sub cmd */
>> +			i++;
>> +			switch (cmd) {
>> +			case 0x08:
>> +			case 0x14:
>> +			case 0x17:
>> +				i += 1;
>> +				break;
>> +			case 0x11:
>> +				i += 5;
>> +				break;
>> +			case 0x06:
>> +			case 0x81:
>> +			case 0x15:
>> +			case 0x16:
>> +				i += 2;
>> +				break;
> 
> #define's for each of these hex values would be good, if we can determine what they actually are.

Maybe we can determine a few of them, as they also occur at the debug parsing loop.

>> +		} else if (cmd == 0x80) {
>> +			/*
>> +			 * Special case: timeout event on cx231xx
>> +			 * Is it needed to check if is_polaris?
>> +			 */
>> +			rawir.pulse = 0;
>> +			rawir.duration = IR_MAX_DURATION;
>> +			dev_dbg(ir->dev, "Storing %s with duration %d\n",
>> +				rawir.pulse ? "pulse" : "space",
>> +				rawir.duration);
>> +
>> +			ir_raw_event_store(ir->idev, &rawir);
> 
> I think this and the prior hunk are really the only things that need to be grafted into the existing routine to make it behave with this device. Lemme see what I can come up with...

True, although the double loop at the original logic is a bit confusing. I suspect you did it to handle
the (cmd & 0xe0) != 0x80 condition, probably at the gen1 times, and then you modified it to handle other
devices. 

Cheers,
Mauro

