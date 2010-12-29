Return-path: <mchehab@gaivota>
Received: from adelie.canonical.com ([91.189.90.139]:47875 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0L2ME0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 07:04:26 -0500
Message-ID: <4D1B23C6.2080302@canonical.com>
Date: Wed, 29 Dec 2010 13:04:22 +0100
From: David Henningsson <david.henningsson@canonical.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] DVB: TechnoTrend CT-3650 IR support
References: <4D170785.1070306@canonical.com> <4D1729DB.80406@infradead.org> <4D17999E.4000500@canonical.com> <4D18623C.8080006@infradead.org> <4D18B6AC.2040506@canonical.com> <4D18C413.3020300@infradead.org> <4D18E2D2.8020400@canonical.com> <4D1904EB.4020007@infradead.org>
In-Reply-To: <4D1904EB.4020007@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------080804080905060307070708"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------080804080905060307070708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2010-12-27 22:28, Mauro Carvalho Chehab wrote:
> Em 27-12-2010 17:02, David Henningsson escreveu:
>> On 2010-12-27 17:51, Mauro Carvalho Chehab wrote:
>>> Em 27-12-2010 13:54, David Henningsson escreveu:
>>>> On 2010-12-27 10:54, Mauro Carvalho Chehab wrote:
>>>>> Em 26-12-2010 17:38, David Henningsson escreveu:
>>>>>> On 2010-12-26 12:41, Mauro Carvalho Chehab wrote:
>>>
>>>>>> +/* command to poll IR receiver (copied from pctv452e.c) */
>>>>>> +#define CMD_GET_IR_CODE     0x1b
>>>>>> +
>>>>>> +/* IR */
>>>>>> +static int tt3650_rc_query(struct dvb_usb_device *d)
>>>>>> +{
>>>>>> +    int ret;
>>>>>> +    u8 rx[9]; /* A CMD_GET_IR_CODE reply is 9 bytes long */
>>>>>> +    ret = ttusb2_msg(d, CMD_GET_IR_CODE, NULL, 0, rx, sizeof(rx));
>>>>>> +    if (ret != 0)
>>>>>> +        return ret;
>>>>>> +
>>>>>> +    if (rx[8]&    0x01) {
>>>>>
>>>>> Maybe (rx[8]&    0x01) == 0 indicates a keyup event. If so, if you map both keydown
>>>>> and keyup events, the in-kernel repeat logic will work.
>>>>
>>>> Hmm. If I should fix keyup events, the most reliable version would probably be something like:
>>>>
>>>> if (rx[8]&   0x01) {
>>>>     int currentkey = rx[2]; // or (rx[3]<<    8) | rx[2];
>>>>     if (currentkey == lastkey)
>>>>       rc_repeat(lastkey);
>>>>     else {
>>>>       if (lastkey)
>>>>         rc_keyup(lastkey);
>>>>       lastkey = currentkey;
>>>>       rc_keydown(currentkey);
>>>>     }
>>>
>>> rc_keydown() already handles repeat events (see ir_do_keydown and rc_keydown, at
>>> rc-main.c), so, you don't need it.
>>>
>>>> }
>>>> else if (lastkey) {
>>>>     rc_keyup(lastkey);
>>>>     lastkey = 0;
>>>> }
>>>
>>> Yeah, this makes sense, if bit 1 of rx[8] indicates keyup/keydown or repeat.
>>>
>>> You need to double check if you are not receiving any packet with this bit unset,
>>> when you press and hold a key, as some devices use a bit to just indicate that
>>> the info there is valid or not (a "done" bit).
>>
>> As far as I can understand, a value of "1" indicates that a key is currently pressed, and a value of "0" indicates that no key is pressed.
>
> Ok.
>>
>>>
>>>>
>>>> Does this sound reasonable to you?
>>>>
>>>>>
>>>>>> +        /* got a "press" event */
>>>>>> +        deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
>>>>>> +        rc_keydown(d->rc_dev, rx[2], 0);
>>>>>> +    }
>>>>>
>>>>> As you're receiving both command+address, please use the complete code:
>>>>>       rc_keydown(d->rc_dev, (rx[3]<<    8) | rx[2], 0);
>>>>
>>>> I've tried this, but it stops working. evtest shows only scancode events, so my guess is that this makes it incompatible with RC_MAP_TT_1500, which lists only the lower byte.
>>>
>>> yeah, you'll need either to create another table or to fix it. The better is to fix
>>> the table and to use .scanmask = 0xff at the old drivers. This way, the same table
>>> will work for both the legacy/incomplete get_scancode function and for the new one.
>>
>> Ok. I did a grep for RC_MAP_TT_1500 and found one place only, so I'm attaching two patches that should fix this, feel free to commit them if they look good to you.
>
> They are good. Applied, thanks!
>
>>
>>>>> Also as it is receiving 8 bytes from the device, maybe the IR decoding logic is
>>>>> capable of decoding more than just one protocol. Such feature is nice, as it
>>>>> allows replacing the original keycode table by a more complete one.
>>>>
>>>> I've tried dumping all nine bytes but I can't make much out of it as I'm unfamiliar with RC protocols and decoders.
>>>>
>>>> Typical reply is (no key pressed):
>>>>
>>>> cc 35 0b 15 00 03 00 00 00
>>>>
>>>> Does this tell you anything?
>>>
>>> This means nothing to me, but the only way to double check is to test the device
>>> with other remote controllers. On several hardware, it is possible to use
>>> RC5 remote controllers as well. As there are some empty (zero) fields, maybe
>>> this device also supports RC6 protocols (that have more than 16 bits) and
>>> NEC extended (24 bits or 32 bits, on a few variants).
>>
>> Ok.
>>
>>>>> One of the most interesting features of the new RC code is that it offers
>>>>> a sysfs class and some additional logic to allow dynamically change/replace
>>>>> the keymaps and keycodes via userspace. The idea is to remove all in-kernel
>>>>> keymaps in the future, using, instead, the userspace way, via ir-keytable
>>>>> tool, available at:
>>>>>       http://git.linuxtv.org/v4l-utils.git
>>>>>
>>>>> The tool already supports auto-loading the keymap via udev.
>>>>>
>>>>> For IR's where we don't know the protocol or that we don't have the full scancode,
>>>>> loading the keymap via userspace will not bring any new feature. But, for those
>>>>> devices where we can be sure about the protocol and for those that also allow
>>>>> using other protocols, users can just replace the device-provided IR with a more
>>>>> powerful remote controller with more keys.
>>>>
>>>> Yeah, that sounds like a really nice feature.
>>>>
>>>>> So, it would be wonderful if you could identify what's the supported protocol(s)
>>>>> instead of using RC_TYPE_UNKNOWN. You can double check the protocol if you have
>>>>> with you another RC device that supports raw decoding. The rc-core internal decoders
>>>>> will tell you what protocol was used to decode a keycode, if you enable debug.
>>>>
>>>> I don't have any such RC receiver device. I do have a Logitech Harmony 525, so I tried pointing that one towards the CT 3650, but CMD_GET_IR_CODE didn't change for any of the devices I've currently told my Harmony to emulate.
>>>>
>>>> So I don't really see how I can help further in this case?
>>>
>>> I don't have a Logitech Harmony, so I'm not sure about it. Maybe Jarod may have some
>>> info about it.
>>
>> Would you like me to provide a patch with RC_TYPE_UNKNOWN at this point (i e what I showed you earlier + your review comments), and when I or somebody else can provide more complete information, we make an additional patch with better protocol support? Does that make sense to you?
>
> Yeah, this should be OK for me.

Ok, here comes the patch. It seems to be working sufficiently well after 
I discovered I needed a poll interval less than IR_KEYPRESS_TIMEOUT. As 
a side note, grepping for rc_interval seems to reveal a few intervals >= 
250, could we have suboptimal results from these as well?

-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic

--------------080804080905060307070708
Content-Type: text/x-patch;
 name="0001-media-DVB-IR-support-for-TechnoTrend-CT-3650.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-media-DVB-IR-support-for-TechnoTrend-CT-3650.patch"

>From 44e2a8503f2db4f5316ec739b804b6a3498111e3 Mon Sep 17 00:00:00 2001
From: David Henningsson <david.henningsson@canonical.com>
Date: Sun, 26 Dec 2010 14:23:58 +0100
Subject: [PATCH] [media] DVB: IR support for TechnoTrend CT-3650

Based on Waling Dijkstra's discovery that the IR works the same as
on the TT-1500, this patch has been rewritten to fit with the
rc_core infrastructure.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
---
 drivers/media/dvb/dvb-usb/ttusb2.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index a6de489..0d4709f 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -43,6 +43,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct ttusb2_state {
 	u8 id;
+	u16 last_rc_key;
 };
 
 static int ttusb2_msg(struct dvb_usb_device *d, u8 cmd,
@@ -128,6 +129,33 @@ static struct i2c_algorithm ttusb2_i2c_algo = {
 	.functionality = ttusb2_i2c_func,
 };
 
+/* command to poll IR receiver (copied from pctv452e.c) */
+#define CMD_GET_IR_CODE     0x1b
+
+/* IR */
+static int tt3650_rc_query(struct dvb_usb_device *d)
+{
+	int ret;
+	u8 rx[9]; /* A CMD_GET_IR_CODE reply is 9 bytes long */
+	struct ttusb2_state *st = d->priv;
+	ret = ttusb2_msg(d, CMD_GET_IR_CODE, NULL, 0, rx, sizeof(rx));
+	if (ret != 0)
+		return ret;
+
+	if (rx[8] & 0x01) {
+		/* got a "press" event */
+		st->last_rc_key = (rx[3] << 8) | rx[2];
+		deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
+		rc_keydown(d->rc_dev, st->last_rc_key, 0);
+	} else if (st->last_rc_key) {
+		rc_keyup(d->rc_dev);
+		st->last_rc_key = 0;
+	}
+
+	return 0;
+}
+
+
 /* Callbacks for DVB USB */
 static int ttusb2_identify_state (struct usb_device *udev, struct
 		dvb_usb_device_properties *props, struct dvb_usb_device_description **desc,
@@ -345,6 +373,13 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
 
 	.size_of_priv = sizeof(struct ttusb2_state),
 
+	.rc.core = {
+		.rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
+		.rc_codes         = RC_MAP_TT_1500,
+		.rc_query         = tt3650_rc_query,
+		.allowed_protos   = RC_TYPE_UNKNOWN,
+	},
+
 	.num_adapters = 1,
 	.adapter = {
 		{
-- 
1.7.1


--------------080804080905060307070708--
