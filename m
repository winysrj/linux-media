Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0BIVNS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 16:13:18 -0500
Message-ID: <4B71CFEA.3000701@infradead.org>
Date: Tue, 09 Feb 2010 19:13:14 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: add Dikom DK300 hybrid USB tuner
References: <4AFE92ED.2060208@gmail.com> <4AFEAB15.9010509@gmail.com> <829197380911140634j49c05cd0s90aed57b9ae61436@mail.gmail.com> <4B71ACC8.600@gmail.com> <4B71B5BD.8090006@infradead.org> <4B71CB52.4080109@gmail.com>
In-Reply-To: <4B71CB52.4080109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrea.Amorosi76@gmail.com wrote:
> Mauro Carvalho Chehab ha scritto:
>> Andrea.Amorosi76@gmail.com wrote:
>>> This patch add the Dikom DK300 hybrid usb card.
>>>
>>> The patch adds digital and analogue tv support.
>>>
>>> Not working: remote controller
>>
>>> diff -r d6520e486ee6 linux/drivers/media/video/em28xx/em28xx-cards.c
>>> --- a/linux/drivers/media/video/em28xx/em28xx-cards.c    Sat Jan 30
>>> 01:27:34 2010 -0200
>>> +++ b/linux/drivers/media/video/em28xx/em28xx-cards.c    Sat Jan 30
>>> 18:04:13 2010 +0100
>>
>> Your patch got mangled by Thunderbird. You should or use Asalted Patches
>> plugin:
>>         https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
>>
>> or use another emailer. Without the above plugin, long lines are broken,
>> damaging your patch.
>>
>> Cheers,
>> Mauro
>>
> Is it ok now?

Yes. Patchwork got it properly:
	http://patchwork.kernel.org/patch/78193/

So, the patch is now on my queue ;)

-- 

Cheers,
Mauro
