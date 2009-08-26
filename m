Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58119 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbZHZLJM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 07:09:12 -0400
Message-ID: <4A9517D6.1070405@iki.fi>
Date: Wed, 26 Aug 2009 14:09:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and
 	mythbuntu 9.04
References: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>	 <200908041312.52878.jareguero@telefonica.net>	 <8527bc070908041423p439f2d35y2e31014a10433c80@mail.gmail.com>	 <200908042348.58148.jareguero@telefonica.net>	 <4A945CA4.6010402@iki.fi>	 <829197380908251501l7731536bg79dd8595cd7ce50d@mail.gmail.com>	 <4A94612A.2070705@iki.fi> <829197380908251524m66bc9a46i5428bdc28ecab153@mail.gmail.com> <4A9467CF.2070207@iki.fi>
In-Reply-To: <4A9467CF.2070207@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/2009 01:38 AM, Antti Palosaari wrote:
> On 08/26/2009 01:24 AM, Devin Heitmueller wrote:
>> On Tue, Aug 25, 2009 at 6:09 PM, Antti Palosaari<crope@iki.fi> wrote:
>>> If demod (and tuner) is powered off by bridge (.power_ctrl) that's not
>>> possible. Is there way to call bridge .power_ctrl to wake up demod and
>>> tuner? I added param for demdod state to track sleep/wake state and
>>> return 0
>>> in sleep case. But that does not sounds good solution...
>>
>> Michael Krufky actually put together some patches to allow the bridge
>> to intercept frontend calls, which would allow for things like power
>> management. I don't know if they've been merged yet.
>
> OK, lets see.
>
> I wonder why v4l-dvb -framework even allows IOCTLs when device is
> powered off. This sounds like wrong functionality from my sight. Why not
> to power on device before all IOCTL request. Some IOCTLs like
> SET_FRONTEND will of course power on device but most not.

Probably it is better and easier to left all parts of the device powered 
on always to fulfil all IOCTL request.

I know it is a little bit stupid to keep device always powered, keep it 
consuming power and hotter...

Antti
-- 
http://palosaari.fi/
