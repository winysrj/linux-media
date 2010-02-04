Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122Ab0BDNmY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 08:42:24 -0500
Message-ID: <4B6ACEA3.3080900@redhat.com>
Date: Thu, 04 Feb 2010 11:41:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Antti Palosaari <crope@iki.fi>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, Pekka Sarnila <sarnila@adit.fi>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6AB7E9.40607@redhat.com> <4B6AC333.6030308@gmail.com>
In-Reply-To: <4B6AC333.6030308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jiri Slaby wrote:
> On 02/04/2010 01:04 PM, Mauro Carvalho Chehab wrote:
>>> I have 2 dvb-t receivers and both of them need fullspeed quirk. Further
>>> disable_rc_polling (a dvb_usb module parameter) must be set to not get
>>> doubled characters now. And then, it works like a charm.
>> Module parameters always bothers me. They should be used as last resort alternatives
>> when there's no other possible way to make it work properly.
>>
>> If we know for sure that the RC polling should be disabled by an specific device, 
>> just add this logic at the driver.
> 
> Yes, this is planned and written below:

Ok.
> 
>>> Note that, it's just some kind of proof of concept. A migration of
>>> af9015 devices from dvb-usb-remote needs to be done first.
>>>
>>> Ideas, comments?
>> Please next time, send the patch inlined. As you're using Thunderbird, you'll likely need
>> Asalted-patches[1] to avoid thunderbird to destroy your patches.
> 
> I must disagree for two reasons: (a) it was not patch intended for merge
> and (b) it was a plain-text attachment which is fine even for
> submission. However I don't like patches as attachments so if I decide
> to submit it for a merge later, you will not see it as an attachment
> then :).

Attachments aren't good for reply, as they appear as a file. So, people need to
open the attachment on a separate application to see and to cut-and-paste
if they want to comment, like what I did.

>> +config HID_DVB
>> +	tristate "DVB remotes support" if EMBEDDED
>> +	depends on USB_HID
>> +	default !EMBEDDED
>> +	---help---
>> +	Say Y here if you have DVB remote controllers.
>> +
>>
>> I think the better would be to use a more generic name, like HID_RC (for Remote Controller).
>> I suspect we may need in the future other hacks for other similar devices.
> 
> Seconded. I would only go for some other abbreviation other than RC or
> not abbreviate that at all.

we're using irrcv at the IR remote class. So, this can be another name for it.

>> +static int dvb_event(struct hid_device *hdev, struct hid_field *field,
>> +		struct hid_usage *usage, __s32 value)
>> +{
>> +	/* we won't get a "key up" event */
>> +	if (value) {
>> +		input_event(field->hidinput->input, usage->type, usage->code, 1);
>> +		input_event(field->hidinput->input, usage->type, usage->code, 0);
>> +	}
>> +	return 1;
>> +}
>>
>> Several V4L/DVB IR's have keyup/keydown events. So I think the name here is also wrong:
>> it is better to name the function as dvb_nokeyup_event() and eventually add an specific
>> quirk to indicate devices that only have key up events.
> 
> If such appear later, it can be rewritten. I don't plan to add such
> functionality now until somebody comes with device IDs which should be
> handled that way and tests it, because I guess I will definitely do it
> wrong otherwise. 
> Do you know/have such a device?

I have several devices here with different ways to generate keyup/keydown or
keydown/repeat, but they don't export a standard usb HID interface (in a matter
of fact, I have just one PCI device that came with a separate USB HID interface,
but this device always worked fine - also - as it has physically a separate device -
it doesn't generate any conflict with the DVB hardware).

The point is that it is better to name the function right since the beginning.
 
> There are many of quirks needed for various devices. I already wrote
> about af9005 which sends key repeat aside from key down etc. But the
> same as above, I can't test it (and don't want to introduce
> regressions). So again, if somebody can test it, I'll be happy to code it.
> 
> thanks for the input,


-- 

Cheers,
Mauro
