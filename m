Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38314 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab0JUVFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 17:05:51 -0400
Received: by qyk10 with SMTP id 10so19382qyk.19
        for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 14:05:50 -0700 (PDT)
Subject: Re: [PATCH 4/4] [media] mceusb: Fix parser for Polaris
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4CC0A4BA.4080105@redhat.com>
Date: Thu, 21 Oct 2010 17:06:05 -0400
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0D654DD3-FC88-41F2-B8BD-04ED85FDC830@wilsonet.com>
References: <cover.1287669886.git.mchehab@redhat.com> <20101021120748.47828273@pedra> <21DE3D7F-2805-4A11-AE29-9713FA58F66D@wilsonet.com> <4CC0A4BA.4080105@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 21, 2010, at 4:38 PM, Mauro Carvalho Chehab wrote:

> Em 21-10-2010 18:06, Jarod Wilson escreveu:
>> On Oct 21, 2010, at 10:07 AM, Mauro Carvalho Chehab wrote:
>> 
>>> Add a parser for polaris mce. On this device, sometimes, a control
>>> data appears together with the IR data, causing problems at the parser.
>>> Also, it signalizes the end of a data with a 0x80 value. The normal
>>> parser would believe that this is a time with 0x1f size, but cx231xx
>>> provides just one byte for it.
>>> 
>>> I'm not sure if the new parser would work for other devices (probably, it
>>> will), but the better is to just write it as a new parser, to avoid breaking
>>> support for other supported IR devices.
>> 
>> After staring at it for a while, I think it would work okay for all 2nd and 3rd-gen mceusb devices, but it would almost certainly break 1st-gen, as it can have distinct IR data packets split across urb -- that's the whole reason for the if rem == 0 check in the existing routine.
>> 
>> Ultimately though, this routine isn't that much different, and I *think* I see a way to extend the existing routine with some of the code from this one to make it work better for the polaris device.
>> 
>> Will still go ahead with some review comments here though.
>> 
>>> diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
>>> index 609bf3d..7210760 100644
>>> --- a/drivers/media/IR/mceusb.c
>>> +++ b/drivers/media/IR/mceusb.c
>>> @@ -265,6 +265,7 @@ struct mceusb_dev {
>>> 		u32 connected:1;
>>> 		u32 tx_mask_inverted:1;
>>> 		u32 microsoft_gen1:1;
>>> +		u32 is_polaris:1;
>>> 		u32 reserved:29;
>> 
>> reserved should be decremented by 1 here if adding another flag.
> 
> Ok. By curiosity, why are you reserving space on a bit array like that?

Legacy, mostly, I guess. Its been that way going back ages. I suppose we could just convert them all to bools and/or leave them as is and drop the reserved part entirely...

>>> +			i++;
>>> +			if (i >= buf_len)
>>> +				return;
>>> +
>>> +			cmd = ir->buf_in[i];	/* sub cmd */
>>> +			i++;
>>> +			switch (cmd) {
>>> +			case 0x08:
>>> +			case 0x14:
>>> +			case 0x17:
>>> +				i += 1;
>>> +				break;
>>> +			case 0x11:
>>> +				i += 5;
>>> +				break;
>>> +			case 0x06:
>>> +			case 0x81:
>>> +			case 0x15:
>>> +			case 0x16:
>>> +				i += 2;
>>> +				break;
>> 
>> #define's for each of these hex values would be good, if we can determine what they actually are.
> 
> Maybe we can determine a few of them, as they also occur at the debug parsing loop.

Yeah, a few of them are at least reasonably well understood.



>>> +		} else if (cmd == 0x80) {
>>> +			/*
>>> +			 * Special case: timeout event on cx231xx
>>> +			 * Is it needed to check if is_polaris?
>>> +			 */
>>> +			rawir.pulse = 0;
>>> +			rawir.duration = IR_MAX_DURATION;
>>> +			dev_dbg(ir->dev, "Storing %s with duration %d\n",
>>> +				rawir.pulse ? "pulse" : "space",
>>> +				rawir.duration);
>>> +
>>> +			ir_raw_event_store(ir->idev, &rawir);
>> 
>> I think this and the prior hunk are really the only things that need to be grafted into the existing routine to make it behave with this device. Lemme see what I can come up with...
> 
> True, although the double loop at the original logic is a bit confusing. I suspect you did it to handle
> the (cmd & 0xe0) != 0x80 condition, probably at the gen1 times, and then you modified it to handle other devices.

Yeah, this sorta grew from merging the old lirc_mceusb and lirc_mceusb2 drivers into one, and believe it or not, its actually cleaner than it used to be... :)

You've got a test patch in your inbox that attempts to merge the logic in this patch into the existing loop, and I'll see if I can beat on it with all three generations of stand-alone mceusb devices tonight...

-- 
Jarod Wilson
jarod@wilsonet.com



