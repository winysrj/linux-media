Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40029 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897AbaAIMKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jan 2014 07:10:12 -0500
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id F36C12140C
	for <linux-media@vger.kernel.org>; Thu,  9 Jan 2014 07:10:10 -0500 (EST)
Message-ID: <52CE91A0.1010901@ladisch.de>
Date: Thu, 09 Jan 2014 13:10:08 +0100
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Takashi Iwai <tiwai@suse.de>, Hans de Goede <hdegoede@redhat.com>,
	alsa-devel@alsa-project.org, linux-usb@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [alsa-devel] Fw: Isochronous transfer error on USB3
References: <20140108164800.70ea4169@samsung.com> <52CE5B09.6070203@ladisch.de> <20140109092957.58092c3f@samsung.com>
In-Reply-To: <20140109092957.58092c3f@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Clemens Ladisch <clemens@ladisch.de> escreveu:
>> Mauro Carvalho Chehab wrote:
>>> 	.period_bytes_min = 64,		/* 12544/2, */
>>
>> This is wrong (if the driver doesn't install other constraints on the
>> period length, like the USB audio class driver does).
>
> Ok, how should it be estimated?

This value specifies how fast the driver can report period interrupts,
i.e., how often it can call snd_pcm_period_elapsed().  In other words,
if the application configures the device for this minimum period size,
but if it is possible for this amount of bytes to be transferred
_without_ triggering an interrupt (by reaching the end of the URB), then
this value was too low.

The em28xx driver uses a fixed URB size, so actual interrupts happen
every 64 frames, so this value should be at least the number of bytes
that can be transferred in 64 ms (assuming a full-speed device).

Because you do not know the exact number of samples that will be sent
per frame, it is possible that the USB interrupt happens up to 63 ms
after the point where the period interrupt should actually have
happened.  This jitter could be reduced by using shorter URBs.

In any case, this driver does not need the integer constraint on the
period count.


Regards,
Clemens
