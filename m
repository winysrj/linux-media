Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab2GINCC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 09:02:02 -0400
Message-ID: <4FFAD666.5060402@redhat.com>
Date: Mon, 09 Jul 2012 15:02:30 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi> <4FF5515A.1030704@redhat.com> <4FF5980F.8030109@iki.fi> <4FF59995.4010604@redhat.com> <4FF5A119.6020903@iki.fi> <4FF5ADE3.5040600@redhat.com> <4FF7EC0E.7060200@redhat.com> <4FF7FAB6.7040508@iki.fi> <4FF885B2.3070509@redhat.com> <4FFAA1B9.6020306@iki.fi> <4FFAAC8F.5080100@redhat.com> <4FFAC75B.5060506@iki.fi>
In-Reply-To: <4FFAC75B.5060506@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/09/2012 01:58 PM, Antti Palosaari wrote:
> On 07/09/2012 01:03 PM, Hans de Goede wrote:
> If I tune using old radio it works. If I tune using latest radio but with option -l 0 (./console/radio -l 0) it also works. Using "arecord -D hw:2,0 -r96000 -c2 -f S16_LE | aplay -" to listen. So it seems that latest radio with alsa loopback is only having those problems.
>

Ok.
>
> These are the patches:
> radio-si470x: Don't unnecesarily read registers on G_TUNER
> radio-si470x: Lower hardware freq seek signal treshold
> radio-si470x: Always use interrupt to wait for tune/seek completion
> radio-si470x: Lower firmware version requirements
>
> And from that I can see it loads new driver as it does not warn about software version - only firmware.

Right, so what I want to do is to lower the firmware requirement to 12, so that it won't complain
for your device since that seems to be working fine. Does that sound like a good idea to you?

> Jul  9 14:28:29 localhost kernel: [13403.017920] Linux media interface: v0.10
> Jul  9 14:28:29 localhost kernel: [13403.020866] Linux video capture interface: v2.00
> Jul  9 14:28:29 localhost kernel: [13403.022744] radio-si470x 5-2:1.2: DeviceID=0x1242 ChipID=0x060c
> Jul  9 14:28:29 localhost kernel: [13403.022747] radio-si470x 5-2:1.2: This driver is known to work with firmware version 14,
> Jul  9 14:28:29 localhost kernel: [13403.022749] radio-si470x 5-2:1.2: but the device has firmware version 12.
> Jul  9 14:28:29 localhost kernel: [13403.024715] radio-si470x 5-2:1.2: software version 1, hardware version 7
> Jul  9 14:28:29 localhost kernel: [13403.024717] radio-si470x 5-2:1.2: If you have some trouble using this driver,
> Jul  9 14:28:29 localhost kernel: [13403.024719] radio-si470x 5-2:1.2: please report to V4L ML at linux-media@vger.kernel.org
> Jul  9 14:28:29 localhost kernel: [13403.114583] usbcore: registered new interface driver radio-si470x

Regards,

Hans
