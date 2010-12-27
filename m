Return-path: <mchehab@gaivota>
Received: from adelie.canonical.com ([91.189.90.139]:46805 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0L0PyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 10:54:23 -0500
Message-ID: <4D18B6AC.2040506@canonical.com>
Date: Mon, 27 Dec 2010 16:54:20 +0100
From: David Henningsson <david.henningsson@canonical.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB: TechnoTrend CT-3650 IR support
References: <4D170785.1070306@canonical.com> <4D1729DB.80406@infradead.org> <4D17999E.4000500@canonical.com> <4D18623C.8080006@infradead.org>
In-Reply-To: <4D18623C.8080006@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 2010-12-27 10:54, Mauro Carvalho Chehab wrote:
> Em 26-12-2010 17:38, David Henningsson escreveu:
>> On 2010-12-26 12:41, Mauro Carvalho Chehab wrote:
>>> Hi David,
>>>
>>> Em 26-12-2010 07:14, David Henningsson escreveu:
>>>> Hi Linux-media,
>>>>
>>>> As a spare time project I bought myself a TT CT-3650, to see if I could get it working. Waling Dijkstra did write a IR&   CI patch for this model half a year ago, so I was hopeful. (Reference: http://www.mail-archive.com/linux-media@vger.kernel.org/msg19860.html )
>>>>
>>>> Having tested the patch, the IR is working (tested all keys via the "evtest" tool), however descrambling is NOT working.
>>>>
>>>> Waling's patch was reviewed but never merged. So I have taken the IR part of the patch, cleaned it up a little, and hopefully this part is ready for merging now. Patch is against linux-2.6.git.
>>>
>>> Could you please rebase it to work with the rc_core support? I suspect that you
>>> based it on a kernel older than .36, as the dvb_usb rc struct changed.
>>
>> Ok, I have now done this, but I'm not completely satisfied, perhaps you can help out a little? I'm new to IR/RC stuff,
>> but I feel I'm missing correct "repeat" functionality, i e, if you keep a key pressed it appears as separate key presses
>> with whatever interval set as .rc_interval. (This was probably a problem with the old patch as well.) Is there any
>> support for this is rc_core?
>
>  From your decode logic, I suspect that the IR hardware decoder has its own logic for repeat.
> In this case, there's not much you can do, as it probably uses a very high time for repeat.
>
>> I'm attaching a temporary patch (just for review) so you know what I'm talking about.
>>
>>> The better is to base it over the latest V4L/DVB/RC development git, available at:
>>>      http://git.linuxtv.org/media_tree.git
>>
>> Ok. I was probably confused with this entry: http://linuxtv.org/news.php?entry=2010-01-19.mchehab
>> telling me to base it on v4l-dvb.git, which is not updated for four months. However, http://git.linuxtv.org/ correctly lists the media_tree.git as the repository of choice.
>
> Ah... yeah, old news;)
>
>> Thanks for the review!
>>
> Em 26-12-2010 17:38, David Henningsson escreveu:
>>  From 8c42121a08c5dabbd1a943cc1e5726ed99f0d957 Mon Sep 17 00:00:00 2001
>> From: David Henningsson<david.henningsson@canonical.com>
>> Date: Sun, 26 Dec 2010 14:23:58 +0100
>> Subject: [PATCH] DVB: IR support for CT-3650
>>
>> Signed-off-by: David Henningsson<david.henningsson@canonical.com>
>> ---
>>   drivers/media/dvb/dvb-usb/ttusb2.c |   28 ++++++++++++++++++++++++++++
>>   1 files changed, 28 insertions(+), 0 deletions(-)
>>   mode change 100644 =>  100755 debian/rules
>>
>> diff --git a/debian/rules b/debian/rules
>> old mode 100644
>> new mode 100755
>> diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
>> index a6de489..ded8a4b 100644
>> --- a/drivers/media/dvb/dvb-usb/ttusb2.c
>> +++ b/drivers/media/dvb/dvb-usb/ttusb2.c
>> @@ -128,6 +128,27 @@ static struct i2c_algorithm ttusb2_i2c_algo = {
>>   	.functionality = ttusb2_i2c_func,
>>   };
>>
>> +/* command to poll IR receiver (copied from pctv452e.c) */
>> +#define CMD_GET_IR_CODE     0x1b
>> +
>> +/* IR */
>> +static int tt3650_rc_query(struct dvb_usb_device *d)
>> +{
>> +	int ret;
>> +	u8 rx[9]; /* A CMD_GET_IR_CODE reply is 9 bytes long */
>> +	ret = ttusb2_msg(d, CMD_GET_IR_CODE, NULL, 0, rx, sizeof(rx));
>> +	if (ret != 0)
>> +		return ret;
>> +
>> +	if (rx[8]&  0x01) {
>
> Maybe (rx[8]&  0x01) == 0 indicates a keyup event. If so, if you map both keydown
> and keyup events, the in-kernel repeat logic will work.

Hmm. If I should fix keyup events, the most reliable version would 
probably be something like:

if (rx[8] & 0x01) {
   int currentkey = rx[2]; // or (rx[3]<<  8) | rx[2];
   if (currentkey == lastkey)
     rc_repeat(lastkey);
   else {
     if (lastkey)
       rc_keyup(lastkey);
     lastkey = currentkey;
     rc_keydown(currentkey);
   }
}
else if (lastkey) {
   rc_keyup(lastkey);
   lastkey = 0;
}

Does this sound reasonable to you?

>
>> +		/* got a "press" event */
>> +		deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
>> +		rc_keydown(d->rc_dev, rx[2], 0);
>> +	}
>
> As you're receiving both command+address, please use the complete code:
> 	rc_keydown(d->rc_dev, (rx[3]<<  8) | rx[2], 0);

I've tried this, but it stops working. evtest shows only scancode 
events, so my guess is that this makes it incompatible with 
RC_MAP_TT_1500, which lists only the lower byte.

> Also as it is receiving 8 bytes from the device, maybe the IR decoding logic is
> capable of decoding more than just one protocol. Such feature is nice, as it
> allows replacing the original keycode table by a more complete one.

I've tried dumping all nine bytes but I can't make much out of it as I'm 
unfamiliar with RC protocols and decoders.

Typical reply is (no key pressed):

cc 35 0b 15 00 03 00 00 00

Does this tell you anything?

> One of the most interesting features of the new RC code is that it offers
> a sysfs class and some additional logic to allow dynamically change/replace
> the keymaps and keycodes via userspace. The idea is to remove all in-kernel
> keymaps in the future, using, instead, the userspace way, via ir-keytable
> tool, available at:
> 	http://git.linuxtv.org/v4l-utils.git
>
> The tool already supports auto-loading the keymap via udev.
>
> For IR's where we don't know the protocol or that we don't have the full scancode,
> loading the keymap via userspace will not bring any new feature. But, for those
> devices where we can be sure about the protocol and for those that also allow
> using other protocols, users can just replace the device-provided IR with a more
> powerful remote controller with more keys.

Yeah, that sounds like a really nice feature.

> So, it would be wonderful if you could identify what's the supported protocol(s)
> instead of using RC_TYPE_UNKNOWN. You can double check the protocol if you have
> with you another RC device that supports raw decoding. The rc-core internal decoders
> will tell you what protocol was used to decode a keycode, if you enable debug.

I don't have any such RC receiver device. I do have a Logitech Harmony 
525, so I tried pointing that one towards the CT 3650, but 
CMD_GET_IR_CODE didn't change for any of the devices I've currently told 
my Harmony to emulate.

So I don't really see how I can help further in this case?

-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic
