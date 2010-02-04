Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab0BDMFa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 07:05:30 -0500
Message-ID: <4B6AB7E9.40607@redhat.com>
Date: Thu, 04 Feb 2010 10:04:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Antti Palosaari <crope@iki.fi>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, Pekka Sarnila <sarnila@adit.fi>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com>
In-Reply-To: <4B6AA211.1060707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jiri Slaby wrote:
> On 01/26/2010 02:08 PM, Jiri Kosina wrote:
>>> In my understanding the cause of the remote problem is chipset bug which sets
>>> USB2.0 polling interval to 4096ms. Therefore HID remote does not work at all
>>> or starts repeating. It is possible to implement remote as polling from the
>>> driver which works very well. But HID problem still remains. I have some hacks
>>> in my mind to test to kill HID. One is to configure HID wrongly to see if it
>>> stops outputting characters. Other way is try to read remote codes directly
>>> from the chip memory.
>> Yes, Pekka Sarnila has added this workaround to the HID driver, as the 
>> device is apparently broken.
>>
>> I want to better understand why others are not hitting this with the 
>> DVB remote driver before removing the quirk from HID code completely.
> 
> I think, we should go for a better way. Thanks Pekka for hints, I ended
> up with the patch in the attachment. Could you try it whether it works
> for you?
> 
> I have 2 dvb-t receivers and both of them need fullspeed quirk. Further
> disable_rc_polling (a dvb_usb module parameter) must be set to not get
> doubled characters now. And then, it works like a charm.

Module parameters always bothers me. They should be used as last resort alternatives
when there's no other possible way to make it work properly.

If we know for sure that the RC polling should be disabled by an specific device, 
just add this logic at the driver.

> Note that, it's just some kind of proof of concept. A migration of
> af9015 devices from dvb-usb-remote needs to be done first.
> 
> Ideas, comments?

Please next time, send the patch inlined. As you're using Thunderbird, you'll likely need
Asalted-patches[1] to avoid thunderbird to destroy your patches.

[1]https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/


 +config HID_DVB
+	tristate "DVB remotes support" if EMBEDDED
+	depends on USB_HID
+	default !EMBEDDED
+	---help---
+	Say Y here if you have DVB remote controllers.
+

I think the better would be to use a more generic name, like HID_RC (for Remote Controller).
I suspect we may need in the future other hacks for other similar devices.

+static int dvb_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value)
+{
+	/* we won't get a "key up" event */
+	if (value) {
+		input_event(field->hidinput->input, usage->type, usage->code, 1);
+		input_event(field->hidinput->input, usage->type, usage->code, 0);
+	}
+	return 1;
+}

Several V4L/DVB IR's have keyup/keydown events. So I think the name here is also wrong:
it is better to name the function as dvb_nokeyup_event() and eventually add an specific
quirk to indicate devices that only have key up events.

-- 

Cheers,
Mauro
