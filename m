Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab0BHTRi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 14:17:38 -0500
Message-ID: <4B706347.9020400@redhat.com>
Date: Mon, 08 Feb 2010 17:17:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 5/12] tm6000: update init table and sequence for tm6010
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de> <4B6FF3C9.2010804@redhat.com> <4B704A2D.5000100@arcor.de> <4B7054A0.8050001@redhat.com> <4B7060DC.5030006@arcor.de>
In-Reply-To: <4B7060DC.5030006@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 08.02.2010 19:14, schrieb Mauro Carvalho Chehab:
>> Stefan Ringel wrote:
>>   
    
>> We'll need some function to change between analog and digital modes, doing the right
>> GPIO changes. See em28xx_set_mode() for a way of implementing it.
>>
>>   
> I don't mean that. I mean it loads the init table then goes to
> tm600_cards_setup, then goes to return and loads the init table new and
> then ... reset the demodulator or can it without the reset demodulator?
> I can test it next weekend.

Tests are required. Maybe you'll need to call it again. The tm6000 chip has lot of
weird behaviours. In the case of xc3028 on analog, you need to re-load the firmware
every time the stream starts. Also, it seems that tm6000 has a timeout: if the image
is not ok for a few seconds, it cuts the tuner down. So, I ended to make it to re-load
part of the firmware (the smaller part of the firmware) every time the channel changes,
when I wrote the first version of the driver. I suspect that this behavior of tuner-xc2028
were removed on the last driver reviews, to speedup tuning with all other devices that
use those chips.

-- 

Cheers,
Mauro
