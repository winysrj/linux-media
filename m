Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab0AYSIG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 13:08:06 -0500
Message-ID: <4B5DDDFB.5020907@iki.fi>
Date: Mon, 25 Jan 2010 20:07:55 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com>
In-Reply-To: <4B5D6098.7010700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/25/2010 11:12 AM, Jiri Slaby wrote:
> On 01/25/2010 12:44 AM, Antti Palosaari wrote:
>> When I now test this patch with debugs enabled I don't see
>> .probe and .disconnect be called for this HID interface (interface 1) at
>> all and thus checks not needed.
>
> What happens if you disable the HID layer? Or at least if you add an
> ignore quirk for the device in usbhid?

Looks like Fedora doesn't have usbhid compiled as module. I looked 
hid-quirks.c file and there was only one af9015 device blacklisted 
15a4:9016. I have 15a4:9015, 15a4:9016 and 13d3:3237 devices and no 
difference.

How can I disable HID layer?

> I forbid usbhid to attach to the device, as the remote kills X with HID
> driver. With dvb-usb-remote it works just fine (with remote=2 for af9015
> or the 4 patches I've sent).

In my understanding the cause of the remote problem is chipset bug which 
sets USB2.0 polling interval to 4096ms. Therefore HID remote does not 
work at all or starts repeating. It is possible to implement remote as 
polling from the driver which works very well. But HID problem still 
remains. I have some hacks in my mind to test to kill HID. One is to 
configure HID wrongly to see if it stops outputting characters. Other 
way is try to read remote codes directly from the chip memory.

But all in all, your patch does not break anything, it is safe to add. 
It could be still nice to know if there is better alternatives. And 
there is surely few other devices having HID remote - are those also 
affected.

regards
Antti
-- 
http://palosaari.fi/
