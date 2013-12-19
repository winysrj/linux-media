Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34036 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab3LSSic (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 13:38:32 -0500
Message-ID: <52B33D24.1060705@iki.fi>
Date: Thu, 19 Dec 2013 20:38:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 6/7] rtl2832_sdr: convert to SDR API
References: <1387231688-8647-1-git-send-email-crope@iki.fi>	<1387231688-8647-7-git-send-email-crope@iki.fi>	<52B2BA92.8080706@xs4all.nl>	<52B323F0.2050701@iki.fi> <CAGoCfiz1kWHXPC-b-Exw=AYrNeOzaCgSvr3+zLuf12g5gyYJxA@mail.gmail.com>
In-Reply-To: <CAGoCfiz1kWHXPC-b-Exw=AYrNeOzaCgSvr3+zLuf12g5gyYJxA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19.12.2013 18:59, Devin Heitmueller wrote:
>> I haven't
>> looked situation more carefully yet, but one thing that must be done at the
>> very first is to add some lock to prevent only DVB or V4L2 API could access
>> the hardware at time.
>
> Probably worth mentioning that we have *lots* of devices that suffer
> from this problem.  Our general tact has to been to do nothing and let
> the driver crash and burn in non-predictable ways when userland tries
> to use both APIs at the same time.
>
> So while it's pretty pathetic that we still haven't resolved this
> after all these years, if you didn't address the issue in the initial
> release then you wouldn't be much worse off than lots of other
> devices.

I think I could add some lock quite easily. I remember when I 
implemented cxd2820r DVB-T/T2/C demod driver and at the time it 
implements 2 frontends, one for DVB-T/T2 and one for DVB-C. I used 
shared lock to prevent access only for single fe at time. I think same 
solution works in that case too.

regards
Antti

-- 
http://palosaari.fi/
