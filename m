Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:43499 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab0BDSdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 13:33:31 -0500
Message-ID: <4B6B12F2.2080102@gmail.com>
Date: Thu, 04 Feb 2010 19:33:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Antti Palosaari <crope@iki.fi>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Pekka Sarnila <sarnila@adit.fi>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <20100204181404.GC10965@core.coreip.homeip.net>
In-Reply-To: <20100204181404.GC10965@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2010 07:14 PM, Dmitry Torokhov wrote:
> On Thu, Feb 04, 2010 at 11:31:45AM +0100, Jiri Slaby wrote:
>  +
>> +static int dvb_event(struct hid_device *hdev, struct hid_field *field,
>> +		struct hid_usage *usage, __s32 value)
>> +{
>> +	/* we won't get a "key up" event */
>> +	if (value) {
>> +		input_event(field->hidinput->input, usage->type, usage->code, 1);
>> +		input_event(field->hidinput->input, usage->type, usage->code, 0);
> 
> Do not ever forget input_sync(), you need 2 of them here.
> 
> With the latest changes to evdev, if you are using SIGIO you won't get
> wioken up until EV_SYN/SYN_REPORT.

HID layer syncs on its own. So the second is not needed. Why is needed
the first?

I.e. should there be one also in dvb_usb_read_remote_control?
