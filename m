Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34249 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1KZQO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 11:14:29 -0500
Received: by bke11 with SMTP id 11so5845441bke.19
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2011 08:14:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED0FF05.4020700@iki.fi>
References: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
	<4ED0FF05.4020700@iki.fi>
Date: Sat, 26 Nov 2011 17:14:27 +0100
Message-ID: <CAO=zWD+w+qOWoJQ2_t-b24Yc+dpG2BDAUMOwnE-FAQ8D3hrk1w@mail.gmail.com>
Subject: Re: Status of RTL283xU support?
From: Maik Zumstrull <maik@zumstrull.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 26, 2011 at 16:00, Antti Palosaari <crope@iki.fi> wrote:
> On 11/26/2011 02:47 PM, Maik Zumstrull wrote:

>> it seems I've found myself with an rtl2832u-based DVB-T USB stick. The
>> latest news on that seems to be that you were working on cleaning up
>> the code of the Realtek-provided GPL driver, with the goal of
>> eventually getting it into mainline.
>>
>> Would you mind giving a short status update?
>
> Shortly, It is error No time, -ENOTIME.

Isn't it always. :-) I won't be holding my breath for 3.3, then.

Thanks for the info and your efforts.

> And the tree I have does support only very limited set of RTL2831U devices.
> It was Maxim Levitsky working for RTL2832U but he have given up.

I hope development will be revived by someone eventually. When looking
around, it seemed to me that this chipset is becoming more and more
common with low-end devices.

I've ordered a different stick that is supposed to be fully supported
already, so I should be fine until then.
