Return-path: <mchehab@gaivota>
Received: from adelie.canonical.com ([91.189.90.139]:38163 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0L0TCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 14:02:46 -0500
Message-ID: <4D18E2D2.8020400@canonical.com>
Date: Mon, 27 Dec 2010 20:02:42 +0100
From: David Henningsson <david.henningsson@canonical.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] DVB: TechnoTrend CT-3650 IR support
References: <4D170785.1070306@canonical.com> <4D1729DB.80406@infradead.org> <4D17999E.4000500@canonical.com> <4D18623C.8080006@infradead.org> <4D18B6AC.2040506@canonical.com> <4D18C413.3020300@infradead.org>
In-Reply-To: <4D18C413.3020300@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------020506000308000003090203"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------020506000308000003090203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2010-12-27 17:51, Mauro Carvalho Chehab wrote:
> Em 27-12-2010 13:54, David Henningsson escreveu:
>> On 2010-12-27 10:54, Mauro Carvalho Chehab wrote:
>>> Em 26-12-2010 17:38, David Henningsson escreveu:
>>>> On 2010-12-26 12:41, Mauro Carvalho Chehab wrote:
>
>>>> +/* command to poll IR receiver (copied from pctv452e.c) */
>>>> +#define CMD_GET_IR_CODE     0x1b
>>>> +
>>>> +/* IR */
>>>> +static int tt3650_rc_query(struct dvb_usb_device *d)
>>>> +{
>>>> +    int ret;
>>>> +    u8 rx[9]; /* A CMD_GET_IR_CODE reply is 9 bytes long */
>>>> +    ret = ttusb2_msg(d, CMD_GET_IR_CODE, NULL, 0, rx, sizeof(rx));
>>>> +    if (ret != 0)
>>>> +        return ret;
>>>> +
>>>> +    if (rx[8]&   0x01) {
>>>
>>> Maybe (rx[8]&   0x01) == 0 indicates a keyup event. If so, if you map both keydown
>>> and keyup events, the in-kernel repeat logic will work.
>>
>> Hmm. If I should fix keyup events, the most reliable version would probably be something like:
>>
>> if (rx[8]&  0x01) {
>>    int currentkey = rx[2]; // or (rx[3]<<   8) | rx[2];
>>    if (currentkey == lastkey)
>>      rc_repeat(lastkey);
>>    else {
>>      if (lastkey)
>>        rc_keyup(lastkey);
>>      lastkey = currentkey;
>>      rc_keydown(currentkey);
>>    }
>
> rc_keydown() already handles repeat events (see ir_do_keydown and rc_keydown, at
> rc-main.c), so, you don't need it.
>
>> }
>> else if (lastkey) {
>>    rc_keyup(lastkey);
>>    lastkey = 0;
>> }
>
> Yeah, this makes sense, if bit 1 of rx[8] indicates keyup/keydown or repeat.
>
> You need to double check if you are not receiving any packet with this bit unset,
> when you press and hold a key, as some devices use a bit to just indicate that
> the info there is valid or not (a "done" bit).

As far as I can understand, a value of "1" indicates that a key is 
currently pressed, and a value of "0" indicates that no key is pressed.

>
>>
>> Does this sound reasonable to you?
>>
>>>
>>>> +        /* got a "press" event */
>>>> +        deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
>>>> +        rc_keydown(d->rc_dev, rx[2], 0);
>>>> +    }
>>>
>>> As you're receiving both command+address, please use the complete code:
>>>      rc_keydown(d->rc_dev, (rx[3]<<   8) | rx[2], 0);
>>
>> I've tried this, but it stops working. evtest shows only scancode events, so my guess is that this makes it incompatible with RC_MAP_TT_1500, which lists only the lower byte.
>
> yeah, you'll need either to create another table or to fix it. The better is to fix
> the table and to use .scanmask = 0xff at the old drivers. This way, the same table
> will work for both the legacy/incomplete get_scancode function and for the new one.

Ok. I did a grep for RC_MAP_TT_1500 and found one place only, so I'm 
attaching two patches that should fix this, feel free to commit them if 
they look good to you.

>>> Also as it is receiving 8 bytes from the device, maybe the IR decoding logic is
>>> capable of decoding more than just one protocol. Such feature is nice, as it
>>> allows replacing the original keycode table by a more complete one.
>>
>> I've tried dumping all nine bytes but I can't make much out of it as I'm unfamiliar with RC protocols and decoders.
>>
>> Typical reply is (no key pressed):
>>
>> cc 35 0b 15 00 03 00 00 00
>>
>> Does this tell you anything?
>
> This means nothing to me, but the only way to double check is to test the device
> with other remote controllers. On several hardware, it is possible to use
> RC5 remote controllers as well. As there are some empty (zero) fields, maybe
> this device also supports RC6 protocols (that have more than 16 bits) and
> NEC extended (24 bits or 32 bits, on a few variants).

Ok.

>>> One of the most interesting features of the new RC code is that it offers
>>> a sysfs class and some additional logic to allow dynamically change/replace
>>> the keymaps and keycodes via userspace. The idea is to remove all in-kernel
>>> keymaps in the future, using, instead, the userspace way, via ir-keytable
>>> tool, available at:
>>>      http://git.linuxtv.org/v4l-utils.git
>>>
>>> The tool already supports auto-loading the keymap via udev.
>>>
>>> For IR's where we don't know the protocol or that we don't have the full scancode,
>>> loading the keymap via userspace will not bring any new feature. But, for those
>>> devices where we can be sure about the protocol and for those that also allow
>>> using other protocols, users can just replace the device-provided IR with a more
>>> powerful remote controller with more keys.
>>
>> Yeah, that sounds like a really nice feature.
>>
>>> So, it would be wonderful if you could identify what's the supported protocol(s)
>>> instead of using RC_TYPE_UNKNOWN. You can double check the protocol if you have
>>> with you another RC device that supports raw decoding. The rc-core internal decoders
>>> will tell you what protocol was used to decode a keycode, if you enable debug.
>>
>> I don't have any such RC receiver device. I do have a Logitech Harmony 525, so I tried pointing that one towards the CT 3650, but CMD_GET_IR_CODE didn't change for any of the devices I've currently told my Harmony to emulate.
>>
>> So I don't really see how I can help further in this case?
>
> I don't have a Logitech Harmony, so I'm not sure about it. Maybe Jarod may have some
> info about it.

Would you like me to provide a patch with RC_TYPE_UNKNOWN at this point 
(i e what I showed you earlier + your review comments), and when I or 
somebody else can provide more complete information, we make an 
additional patch with better protocol support? Does that make sense to you?

-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic

--------------020506000308000003090203
Content-Type: text/x-patch;
 name="0001-DVB-Set-scanmask-for-Budget-SAA7146-cards.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-DVB-Set-scanmask-for-Budget-SAA7146-cards.patch"

>From 7435de9c183fa2b62c03311ae8e08ddd436cb287 Mon Sep 17 00:00:00 2001
From: David Henningsson <david.henningsson@canonical.com>
Date: Mon, 27 Dec 2010 19:41:58 +0100
Subject: [PATCH 1/2] DVB: Set scanmask for Budget/SAA7146 cards

These devices do not return the full command+address, so set
scanmask accordingly.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
---
 drivers/media/dvb/ttpci/budget-ci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 8ae67c1..b82756d 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -184,6 +184,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	dev->input_phys = budget_ci->ir.phys;
 	dev->input_id.bustype = BUS_PCI;
 	dev->input_id.version = 1;
+	dev->scanmask = 0xff;
 	if (saa->pci->subsystem_vendor) {
 		dev->input_id.vendor = saa->pci->subsystem_vendor;
 		dev->input_id.product = saa->pci->subsystem_device;
-- 
1.7.1


--------------020506000308000003090203
Content-Type: text/x-patch;
 name="0002-MEDIA-RC-Provide-full-scancodes-for-TT-1500-remote-c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-MEDIA-RC-Provide-full-scancodes-for-TT-1500-remote-c.pa";
 filename*1="tch"

>From 404319567f67d5c63001239ca4f960aaf775a075 Mon Sep 17 00:00:00 2001
From: David Henningsson <david.henningsson@canonical.com>
Date: Mon, 27 Dec 2010 19:45:19 +0100
Subject: [PATCH 2/2] MEDIA: RC: Provide full scancodes for TT-1500 remote control

Add 0x15 prefix to scancodes for TT-1500 remote control.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
---
 drivers/media/rc/keymaps/rc-tt-1500.c |   78 ++++++++++++++++----------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index bb19487..295f373 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -15,45 +15,45 @@
 /* for the Technotrend 1500 bundled remotes (grey and black): */
 
 static struct rc_map_table tt_1500[] = {
-	{ 0x01, KEY_POWER },
-	{ 0x02, KEY_SHUFFLE },		/* ? double-arrow key */
-	{ 0x03, KEY_1 },
-	{ 0x04, KEY_2 },
-	{ 0x05, KEY_3 },
-	{ 0x06, KEY_4 },
-	{ 0x07, KEY_5 },
-	{ 0x08, KEY_6 },
-	{ 0x09, KEY_7 },
-	{ 0x0a, KEY_8 },
-	{ 0x0b, KEY_9 },
-	{ 0x0c, KEY_0 },
-	{ 0x0d, KEY_UP },
-	{ 0x0e, KEY_LEFT },
-	{ 0x0f, KEY_OK },
-	{ 0x10, KEY_RIGHT },
-	{ 0x11, KEY_DOWN },
-	{ 0x12, KEY_INFO },
-	{ 0x13, KEY_EXIT },
-	{ 0x14, KEY_RED },
-	{ 0x15, KEY_GREEN },
-	{ 0x16, KEY_YELLOW },
-	{ 0x17, KEY_BLUE },
-	{ 0x18, KEY_MUTE },
-	{ 0x19, KEY_TEXT },
-	{ 0x1a, KEY_MODE },		/* ? TV/Radio */
-	{ 0x21, KEY_OPTION },
-	{ 0x22, KEY_EPG },
-	{ 0x23, KEY_CHANNELUP },
-	{ 0x24, KEY_CHANNELDOWN },
-	{ 0x25, KEY_VOLUMEUP },
-	{ 0x26, KEY_VOLUMEDOWN },
-	{ 0x27, KEY_SETUP },
-	{ 0x3a, KEY_RECORD },		/* these keys are only in the black remote */
-	{ 0x3b, KEY_PLAY },
-	{ 0x3c, KEY_STOP },
-	{ 0x3d, KEY_REWIND },
-	{ 0x3e, KEY_PAUSE },
-	{ 0x3f, KEY_FORWARD },
+	{ 0x1501, KEY_POWER },
+	{ 0x1502, KEY_SHUFFLE },		/* ? double-arrow key */
+	{ 0x1503, KEY_1 },
+	{ 0x1504, KEY_2 },
+	{ 0x1505, KEY_3 },
+	{ 0x1506, KEY_4 },
+	{ 0x1507, KEY_5 },
+	{ 0x1508, KEY_6 },
+	{ 0x1509, KEY_7 },
+	{ 0x150a, KEY_8 },
+	{ 0x150b, KEY_9 },
+	{ 0x150c, KEY_0 },
+	{ 0x150d, KEY_UP },
+	{ 0x150e, KEY_LEFT },
+	{ 0x150f, KEY_OK },
+	{ 0x1510, KEY_RIGHT },
+	{ 0x1511, KEY_DOWN },
+	{ 0x1512, KEY_INFO },
+	{ 0x1513, KEY_EXIT },
+	{ 0x1514, KEY_RED },
+	{ 0x1515, KEY_GREEN },
+	{ 0x1516, KEY_YELLOW },
+	{ 0x1517, KEY_BLUE },
+	{ 0x1518, KEY_MUTE },
+	{ 0x1519, KEY_TEXT },
+	{ 0x151a, KEY_MODE },		/* ? TV/Radio */
+	{ 0x1521, KEY_OPTION },
+	{ 0x1522, KEY_EPG },
+	{ 0x1523, KEY_CHANNELUP },
+	{ 0x1524, KEY_CHANNELDOWN },
+	{ 0x1525, KEY_VOLUMEUP },
+	{ 0x1526, KEY_VOLUMEDOWN },
+	{ 0x1527, KEY_SETUP },
+	{ 0x153a, KEY_RECORD },		/* these keys are only in the black remote */
+	{ 0x153b, KEY_PLAY },
+	{ 0x153c, KEY_STOP },
+	{ 0x153d, KEY_REWIND },
+	{ 0x153e, KEY_PAUSE },
+	{ 0x153f, KEY_FORWARD },
 };
 
 static struct rc_map_list tt_1500_map = {
-- 
1.7.1


--------------020506000308000003090203--
